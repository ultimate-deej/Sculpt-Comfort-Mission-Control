//
//  SCMCHidListener.m
//  Shared
//
//  Created by Maxim Naumov on 14.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import IOKit.hid;
#import "SCMCHidListener.h"

@implementation SCMCHidListener {
    SCMCHidListenerCallback _callback;
    /// A zero-terminated array of the codes that are allowed to be passed to the callback.
    // It will be accessed at an extremely high rate
    // so the idea is to avoid ObjC overheads by using a raw array
    uint32_t *_acceptedCodes;
    uint32_t _currentlyPressedButton;
    IOHIDManagerRef _hidManager;
}

- (instancetype)initWithCallback:(SCMCHidListenerCallback)callback acceptedCodes:(NSArray<NSNumber *> *)acceptedCodes
{
    if (self = [super init]) {
        _callback = callback;
        [self initializeAcceptedCodes:acceptedCodes];
    }
    return self;
}

- (void)initializeAcceptedCodes:(NSArray<NSNumber *> *)acceptedCodes {
    _acceptedCodes = calloc(acceptedCodes.count + 1, sizeof(*_acceptedCodes));
    for (NSUInteger i = 0; i < acceptedCodes.count; i++) {
        _acceptedCodes[i] = acceptedCodes[i].unsignedIntValue;
    }
}

- (void)dealloc {
    IOHIDManagerClose(_hidManager, kIOHIDOptionsTypeNone);
    free(_acceptedCodes);
}

// MARK: - IOHIDManager

static BOOL PrefilterElement(const IOHIDElementRef element) {
    IOHIDElementType type = IOHIDElementGetType(element);
    // We only want to handle buttons
    if (type != kIOHIDElementTypeInput_Button) return YES;

    // Probably not a regular button. Sent by some Sculpt Comfort mice
    if (IOHIDElementGetLogicalMax(element) != 1) return YES;

    return NO;
}

static BOOL PrefilterUsage(const uint32_t usage, const uint32_t *const acceptedCodes) {
    // Ignore left & right buttons
    if (usage == 1 || usage == 2) return YES;

    // Check whether `acceptedCodes` contains `usage`
    uint32_t code;
    for (NSUInteger i = 0; (code = acceptedCodes[i]) != 0; i++) {
        if (usage == code) return NO;
    }

    return YES;
}

static BOOL IsDiscardedByCurrentlyPressedButton(const uint32_t usage, const BOOL pressed, const uint32_t currentlyPressedButton) {
    // Sculpt Comfort tends to send many values at once. We only want the first one
    if (currentlyPressedButton != 0 && pressed && currentlyPressedButton != usage) return YES;
    // Ignore button release events corresponding to the press events filtered out by the line above
    if (currentlyPressedButton == 0 && !pressed) return YES;

    return NO;
}

static void MouseCallback(SCMCHidListener *listener, IOReturn result, void *sender, IOHIDValueRef value) {
    if (result != kIOReturnSuccess) return;

    IOHIDElementRef element = IOHIDValueGetElement(value);
    if (PrefilterElement(element)) return;

    const uint32_t usage = IOHIDElementGetUsage(element);
    if (PrefilterUsage(usage, listener->_acceptedCodes)) return;

    // After calling `PrefilterElement` we are pretty sure that the value is either 0 or 1
    BOOL pressed = IOHIDValueGetIntegerValue(value) == 1;

    /// While a button is pressed, ignore all the other buttons until it is released
    if (IsDiscardedByCurrentlyPressedButton(usage, pressed, listener->_currentlyPressedButton)) return;
    listener->_currentlyPressedButton = pressed ? usage : 0;

    listener->_callback(usage, pressed);
}

- (void)startForDeviceMatching:(NSDictionary<NSString *,NSNumber *> *)match {
    _hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    IOHIDManagerSetDeviceMatching(_hidManager, (__bridge CFDictionaryRef)match);
    IOHIDManagerRegisterInputValueCallback(_hidManager, (IOHIDValueCallback)MouseCallback, (__bridge void *)self);
    IOHIDManagerScheduleWithRunLoop(_hidManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    IOHIDManagerOpen(_hidManager, kIOHIDOptionsTypeNone);
}

@end
