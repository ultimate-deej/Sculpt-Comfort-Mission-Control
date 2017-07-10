//
//  SCMCHidMouseListener.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 05.04.16.
//  Copyright © 2016 Maxim Naumov. All rights reserved.
//

@import IOKit.hid;

#import "SCMCHidMouseListener.h"
#import "SCMCConfiguration.h"

typedef uint32_t ButtonCode;

typedef NS_ENUM(NSInteger, LongClickState) {
    IdleLongClickState,
    DownLongClickState,
    WaitingReleaseLongClickState,
};

@interface SCMCHidMouseListener ()

@property(nonatomic, readonly) ButtonCode clickCode;
@property(nonatomic, readonly) ButtonCode swipeUpCode;
@property(nonatomic, readonly) ButtonCode swipeDownCode;

@property(nonatomic, copy) SCMCAction clickAction;
@property(nonatomic, copy) SCMCAction longClickAction;
@property(nonatomic, copy) SCMCAction swipeUpAction;
@property(nonatomic, copy) SCMCAction swipeDownAction;

@end

@implementation SCMCHidMouseListener

static LongClickState ClickState;
static NSTimer *LongClickTimer;
static NSTimeInterval LongClickDuration;

static void HandleLongClick(__weak SCMCHidMouseListener *listener, BOOL down) {
    if (!down) { // button released
        [LongClickTimer invalidate];
        LongClickTimer = nil;

        if (ClickState == DownLongClickState) {
            if (listener.clickAction) listener.clickAction();
        }

        ClickState = IdleLongClickState;
    } else if (ClickState == IdleLongClickState) {
        LongClickTimer = [NSTimer scheduledTimerWithTimeInterval:LongClickDuration
                target:[NSBlockOperation blockOperationWithBlock:^{
                    if (listener.longClickAction) listener.longClickAction();
                    ClickState = WaitingReleaseLongClickState;
                }]
                selector:@selector(main)
                userInfo:nil
                repeats:NO
        ];
        ClickState = DownLongClickState;
    }
}

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
    if (self = [super init]) {
        _clickCode = (ButtonCode) configuration.clickCode;
        _swipeUpCode = (ButtonCode) configuration.swipeUpCode;
        _swipeDownCode = (ButtonCode) configuration.swipeDownCode;

        self.clickAction = configuration.clickAction;
        self.longClickAction = configuration.longClickAction;
        self.swipeUpAction = configuration.swipeUpAction;
        self.swipeDownAction = configuration.swipeDownAction;
        
        [self setupListenerWithConfiguration:configuration];
        LongClickDuration = [[NSBundle bundleForClass:self.class].infoDictionary[@"SCMCLongClickDuration"] doubleValue];
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
