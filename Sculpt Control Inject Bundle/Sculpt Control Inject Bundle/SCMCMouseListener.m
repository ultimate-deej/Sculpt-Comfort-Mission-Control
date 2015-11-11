//
//  SCMCMouseListener.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCMouseListener.h"
#import "SCMCConfiguration.h"

@import IOKit.hid;

typedef uint32_t ButtonCode;

typedef NS_ENUM(NSInteger, LongClickState) {
    IdleLongClickState,
    DownLongClickState,
    WaitingReleaseLongClickState,
};

@interface SCMCMouseListener ()

@property(nonatomic, readonly) ButtonCode clickCode;
@property(nonatomic, readonly) ButtonCode swipeUpCode;
@property(nonatomic, readonly) ButtonCode swipeDownCode;

@property(nonatomic, copy) SCMCAction clickAction;
@property(nonatomic, copy) SCMCAction longClickAction;
@property(nonatomic, copy) SCMCAction swipeUpAction;
@property(nonatomic, copy) SCMCAction swipeDownAction;

@end

@implementation SCMCMouseListener

static LongClickState ClickState;
static NSTimer *LongClickTimer;
static NSTimeInterval LongClickDuration;

static void HandleLongClick(__weak SCMCMouseListener *listener, BOOL down) {
    if (!down) { // button released
        [LongClickTimer invalidate];
        LongClickTimer = nil;

        if (ClickState == DownLongClickState) {
            listener.clickAction();
        }

        ClickState = IdleLongClickState;
    } else if (ClickState == IdleLongClickState) {
        LongClickTimer = [NSTimer scheduledTimerWithTimeInterval:LongClickDuration
                target:[NSBlockOperation blockOperationWithBlock:^{
                    listener.longClickAction();
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
    SCMCMouseListener *listener = (__bridge SCMCMouseListener *) (context);
    long pressed = IOHIDValueGetIntegerValue(value);
    IOHIDElementRef elem = IOHIDValueGetElement(value);
    const ButtonCode code = IOHIDElementGetUsage(elem);

    if (code == listener->_clickCode) {
        HandleLongClick(listener, pressed == 1);
        return;
    }

    if (pressed != 1) return;

    if (code == listener->_swipeUpCode) {
        listener.swipeUpAction();
    } else if (code == listener->_swipeDownCode) {
        listener.swipeDownAction();
    }
}

- (instancetype)initWithConfiguration:(SCMCConfiguration *)configuration clickAction:(SCMCAction)clickAction longClickAction:(SCMCAction)longClickAction swipeUpAction:(SCMCAction)swipeUpAction swipeDownAction:(SCMCAction)swipeDownAction {
    self = [super init];
    if (self) {
        _clickCode = (ButtonCode) configuration.clickCode;
        _swipeUpCode = (ButtonCode) configuration.swipeUpCode;
        _swipeDownCode = (ButtonCode) configuration.swipeDownCode;

        self.clickAction = clickAction;
        self.longClickAction = longClickAction;
        self.swipeUpAction = swipeUpAction;
        self.swipeDownAction = swipeDownAction;
        [self setupListenerWithConfiguration:configuration];
        LongClickDuration = [[NSBundle bundleForClass:[self class]].infoDictionary[@"SCMCLongClickDuration"] doubleValue];
    }

    return self;
}

+ (instancetype)listenerWithConfiguration:(SCMCConfiguration *)configuration clickAction:(SCMCAction)clickAction longClickAction:(SCMCAction)longClickAction swipeUpAction:(SCMCAction)swipeUpAction swipeDownAction:(SCMCAction)swipeDownAction {
    return [[self alloc] initWithConfiguration:configuration clickAction:clickAction longClickAction:longClickAction swipeUpAction:swipeUpAction swipeDownAction:swipeDownAction];
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
