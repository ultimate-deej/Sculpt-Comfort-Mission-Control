//
//  SCMCEventTapListener.m
//  Shared
//
//  Created by Maxim Naumov on 14.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "SCMCEventTapListener.h"

@implementation SCMCEventTapListener {
    SCMCEventTapListenerCallback _callback;
    /// A zero-terminated array of the codes that are allowed to be passed to the callback.
    // It will be accessed at a much lower rate than a similar array of HID listener.
    // Anyway, I'll stick to this implementation to keep it fast.
    int64_t *_acceptedCodes;
    CFMachPortRef _eventTap;
    CFRunLoopSourceRef _source;
}

- (instancetype)initWithCallback:(SCMCEventTapListenerCallback)callback acceptedCodes:(NSArray<NSNumber *> *)acceptedCodes {
    if (self = [super init]) {
        _callback = callback;
        [self initializeAcceptedCodes:acceptedCodes];
    }
    return self;
}

- (void)initializeAcceptedCodes:(NSArray<NSNumber *> *)acceptedCodes {
    _acceptedCodes = calloc(acceptedCodes.count + 1, sizeof(*_acceptedCodes));
    for (NSUInteger i = 0; i < acceptedCodes.count; i++) {
        _acceptedCodes[i] = acceptedCodes[i].longLongValue;
    }
}

- (void)dealloc {
    CFRunLoopRemoveSource(CFRunLoopGetMain(), _source, kCFRunLoopDefaultMode);
    CFRelease(_eventTap);
    free(_acceptedCodes);
}

// MARK: - CGEventTap

static BOOL Contains(const int64_t *const acceptedCodes, const int64_t buttonNumber) {
    int64_t code;
    for (NSUInteger i = 0; (code = acceptedCodes[i]) != 0; i++) {
        if (buttonNumber == code) return YES;
    }

    return NO;
}

static CGEventRef MouseCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, SCMCEventTapListener *listener) {
    const int64_t buttonNumber = CGEventGetIntegerValueField(event, kCGMouseEventButtonNumber);
    if (!Contains(listener->_acceptedCodes, buttonNumber)) return event;

    BOOL pressed = (type == kCGEventOtherMouseDown);
    listener->_callback(buttonNumber, pressed);
    return NULL;
}

- (void)start {
    CGEventMask eventMask = CGEventMaskBit(kCGEventOtherMouseDown) | CGEventMaskBit(kCGEventOtherMouseUp);
    _eventTap = CGEventTapCreate(kCGSessionEventTap, 0, kCGEventTapOptionDefault, eventMask, (CGEventTapCallBack)MouseCallback, (__bridge void *)self);
    _source = CFMachPortCreateRunLoopSource(NULL, _eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), _source, kCFRunLoopDefaultMode);
}

@end
