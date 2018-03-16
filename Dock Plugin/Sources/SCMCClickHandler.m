//
//  SCMCClickHandler.m
//  Dock Plugin
//
//  Created by Maxim Naumov on 16.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "SCMCClickHandler.h"
#import "SCMCActionStore.h"

static const NSTimeInterval LONG_CLICK_DELAY = 0.2;

@interface SCMCClickHandler ()

@property(nonatomic) NSTimer *timer;

// Code and action store together allow to distinguish a button from others
@property(nonatomic) NSNumber *pressedButtonCode;
@property(nonatomic) SCMCActionStore *pressedButtonActionStore;

@property(nonatomic) SCMCAction longClickAction;
@property(nonatomic, nullable) SCMCAction releaseAction;

@end

@implementation SCMCClickHandler

- (void)handleClickWithCode:(NSNumber *)code pressed:(BOOL)pressed actionStore:(SCMCActionStore *)actionStore {
    if (pressed) {
        SCMCAction longClickAction = actionStore.longClickActions[code];
        SCMCAction regularAction = actionStore.regularActions[code];

        if (longClickAction) {
            [self startWithCode:code actionStore:actionStore longClickAction:longClickAction releaseAction:regularAction];
        } else if (regularAction) {
            regularAction();
        }
    } else {
        [self cancelWithCode:code actionStore:actionStore];
    }
}

- (void)startWithCode:(NSNumber *)code actionStore:(SCMCActionStore *)actionStore longClickAction:(SCMCAction)longClickAction releaseAction:(SCMCAction)releaseAction {
    if (self.timer != nil) return; // Ignore if already started

    self.pressedButtonCode = code;
    self.pressedButtonActionStore = actionStore;

    self.longClickAction = longClickAction;
    self.releaseAction = releaseAction;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:LONG_CLICK_DELAY target:self selector:@selector(executeLongClickAction:) userInfo:nil repeats:NO];
}

/// @note @c code and @c actionStore are needed to check if we are releasing the same button that was pressed initially.
- (void)cancelWithCode:(NSNumber *)code actionStore:(SCMCActionStore *)actionStore {
    if (self.timer == nil) return; // Nothing to cancel

    BOOL releasingPressedButton = [self.pressedButtonCode isEqualToNumber:code] && (self.pressedButtonActionStore == actionStore);
    if (self.releaseAction != nil && releasingPressedButton) {
        self.releaseAction();
    }

    [self reset];
}

- (void)executeLongClickAction:(__unused NSTimer *)timer {
    self.longClickAction();
    [self reset];
}

- (void)reset {
    [self.timer invalidate];
    self.timer = nil;

    self.pressedButtonCode = nil;
    self.pressedButtonActionStore = nil;

    self.longClickAction = nil;
    self.releaseAction = nil;
}

@end
