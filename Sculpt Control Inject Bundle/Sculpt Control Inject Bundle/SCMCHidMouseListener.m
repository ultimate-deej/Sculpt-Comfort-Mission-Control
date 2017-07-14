//
//  SCMCHidMouseListener.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 05.04.16.
//  Copyright © 2016 Maxim Naumov. All rights reserved.
//

@import IOKit.hid;

#import "SCMCHidMouseListener.h"
#import "SCMCMouseListener+Subclass.h"
#import "SCMCConfiguration.h"

typedef uint32_t ButtonCode;

@interface SCMCHidMouseListener ()

@property(nonatomic, readonly) ButtonCode clickCode;
@property(nonatomic, readonly) ButtonCode swipeUpCode;
@property(nonatomic, readonly) ButtonCode swipeDownCode;

@end

@implementation SCMCHidMouseListener

static void MouseCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value) {
    SCMCHidMouseListener *listener = (__bridge SCMCHidMouseListener *) (context);
    long pressed = IOHIDValueGetIntegerValue(value);
    IOHIDElementRef elem = IOHIDValueGetElement(value);
    const ButtonCode code = IOHIDElementGetUsage(elem);

    if (code == listener->_clickCode) {
        HandleLongClick(listener, pressed == 1);
        return;
    }

    if (pressed != 1) return;

    if (code == listener->_swipeUpCode) {
        if (listener.swipeUpAction) listener.swipeUpAction();
    } else if (code == listener->_swipeDownCode) {
        if (listener.swipeDownAction) listener.swipeDownAction();
    }
}

- (instancetype)initWithConfiguration:(SCMCConfiguration *)configuration {
    if (self = [super initWithConfiguration:configuration]) {
        _clickCode = (ButtonCode) configuration.clickCode;
        _swipeUpCode = (ButtonCode) configuration.swipeUpCode;
        _swipeDownCode = (ButtonCode) configuration.swipeDownCode;

        [self setupListenerWithConfiguration:configuration];
    }

    return self;
}

+ (instancetype)listenerWithConfiguration:(SCMCConfiguration *)configuration {
    return [[self alloc] initWithConfiguration:configuration];
}

- (void)setupListenerWithConfiguration:(SCMCConfiguration *)configuration {
    IOHIDManagerRef hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    NSDictionary *sculptComfortMatch = @{
            @kIOHIDVendorIDKey : configuration.vendorId,
            @kIOHIDProductIDKey : configuration.productId,
    };

    IOHIDManagerSetDeviceMatching(hidManager, (__bridge CFDictionaryRef) sculptComfortMatch);
    IOHIDManagerRegisterInputValueCallback(hidManager, MouseCallback, (__bridge void *) (self));
    IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
}

@end
