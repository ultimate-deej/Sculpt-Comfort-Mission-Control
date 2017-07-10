//
//  SCMCEventTapMouseListener.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 05.04.16.
//  Copyright © 2016 Maxim Naumov. All rights reserved.
//

#import "SCMCEventTapMouseListener.h"
#import "SCMCConfiguration.h"

typedef int64_t ButtonCode;

typedef NS_ENUM(NSInteger, LongClickState) {
    IdleLongClickState,
    DownLongClickState,
    WaitingReleaseLongClickState,
};

@interface SCMCEventTapMouseListener ()

@property(nonatomic, readonly) ButtonCode clickCode;
@property(nonatomic, readonly) ButtonCode swipeUpCode;
@property(nonatomic, readonly) ButtonCode swipeDownCode;

@property(nonatomic, copy) SCMCAction clickAction;
@property(nonatomic, copy) SCMCAction longClickAction;
@property(nonatomic, copy) SCMCAction swipeUpAction;
@property(nonatomic, copy) SCMCAction swipeDownAction;

@end

@implementation SCMCEventTapMouseListener

static LongClickState ClickState;
static NSTimer *LongClickTimer;
static NSTimeInterval LongClickDuration;

static BOOL HandleLongClick(__weak SCMCEventTapMouseListener *listener, BOOL down) {
    BOOL handled = NO;

    if (!down) { // button released
        [LongClickTimer invalidate];
        LongClickTimer = nil;

        if (ClickState == DownLongClickState) {
            if (listener.clickAction) {
                listener.clickAction();
                handled = YES;
            }
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
        if (listener.longClickAction) handled = YES;
    }

    return handled;
}

static CGEventRef MouseCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (type != kCGEventOtherMouseDown && type != kCGEventOtherMouseUp) return event;

    SCMCEventTapMouseListener *listener = (__bridge SCMCEventTapMouseListener *) (refcon);
    const ButtonCode code = CGEventGetIntegerValueField(event, kCGMouseEventButtonNumber);

    if (code == listener->_clickCode) {
        BOOL handled = HandleLongClick(listener, type == kCGEventOtherMouseDown);
        return handled ? NULL : event;
    }

    if (code == listener->_swipeUpCode && listener.swipeUpAction != nil) {
        if (type == kCGEventOtherMouseDown) listener.swipeUpAction();
        return NULL;
    } else if (code == listener->_swipeDownCode && listener.swipeDownAction != nil) {
        if (type == kCGEventOtherMouseDown) listener.swipeDownAction();
        return NULL;
    }

    return event;
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
        
        LongClickDuration = [[NSBundle bundleForClass:self.class].infoDictionary[@"SCMCLongClickDuration"] doubleValue];
        [self startListener];
    }

    return self;
}

+ (instancetype)listenerWithConfiguration:(SCMCConfiguration *)configuration {
    return [[self alloc] initWithConfiguration:configuration];
}

- (void)startListener {
    CGEventMask eventMask = CGEventMaskBit(kCGEventOtherMouseDown) | CGEventMaskBit(kCGEventOtherMouseUp);
    CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap, 0, kCGEventTapOptionDefault, eventMask, MouseCallback, (__bridge void *) (self));
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(NULL, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, kCFRunLoopDefaultMode);
}

@end
