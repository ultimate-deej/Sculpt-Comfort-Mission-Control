//
//  SCMCMouseListener.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCMouseListener.h"
#import "SCMCConfiguration.h"
#import "SCMCHidMouseListener.h"
#import "SCMCEventTapMouseListener.h"

typedef NS_ENUM(NSInteger, LongClickState) {
    IdleLongClickState,
    DownLongClickState,
    WaitingReleaseLongClickState,
};

@interface SCMCMouseListener ()

@property(nonatomic) SCMCAction clickAction;
@property(nonatomic) SCMCAction longClickAction;
@property(nonatomic) SCMCAction swipeUpAction;
@property(nonatomic) SCMCAction swipeDownAction;

@end

@implementation SCMCMouseListener

static LongClickState ClickState;
static NSTimer *LongClickTimer;
static NSTimeInterval LongClickDuration;

BOOL HandleLongClick(__weak SCMCMouseListener *listener, BOOL down) {
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

+ (instancetype)createListenerForConfiguration:(SCMCConfiguration *)configuration {
    if (configuration.listenerKind == EventTapListenerKind) {
        return [SCMCEventTapMouseListener listenerWithConfiguration:configuration];
    } else {
        return [SCMCHidMouseListener listenerWithConfiguration:configuration];
    }
}

- (instancetype)initWithConfiguration:(SCMCConfiguration *)configuration {
    if (self = [super init]) {
        self.clickAction = configuration.clickAction;
        self.longClickAction = configuration.longClickAction;
        self.swipeUpAction = configuration.swipeUpAction;
        self.swipeDownAction = configuration.swipeDownAction;

        LongClickDuration = [[NSBundle bundleForClass:self.class].infoDictionary[@"SCMCLongClickDuration"] doubleValue];
    }

    return self;
}

@end
