//
//  SCMCCore.m
//  Dock Plugin
//
//  Created by Maxim Naumov on 14.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import IOKit.hid;

#import "SCMCCore.h"
#import "SCMCConfiguration.h"
#import "SCMCActions.h"
#import "SCMCHidListener.h"
#import "SCMCEventTapListener.h"
#import "SCMCActionStore.h"
#import "SCMCClickHandler.h"

@interface SCMCCore ()

@property(nonatomic, readonly) SCMCClickHandler *clickHandler;

@property(nonatomic, readonly) SCMCHidListener *hidListener;
@property(nonatomic, readonly) SCMCEventTapListener *eventTapListener;

@end

@implementation SCMCCore

+ (instancetype)startWithConfiguration:(SCMCConfiguration *)configuration actions:(SCMCActions *)actions {
    SCMCCore *core = [[SCMCCore alloc] initPrivate];
    [core startWithConfiguration:configuration actions:actions];
    return core;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        _clickHandler = [[SCMCClickHandler alloc] init];
    }
    return self;
}

- (void)startWithConfiguration:(SCMCConfiguration *)configuration actions:(SCMCActions *)actions {
    SCMCActionStore *hidActions = [[SCMCActionStore alloc] init];
    SCMCActionStore *eventTapActions = [[SCMCActionStore alloc] init];

    void (^putAction)(SCMCAction, SCMCEventSpec *) = ^(SCMCAction action, SCMCEventSpec *eventSpec) {
        [self putAction:action forEvent:eventSpec toHidActions:hidActions orEventTapActions:eventTapActions];
    };

    putAction(actions.missionControl, configuration.missionControl);
    putAction(actions.applicationWindows, configuration.applicationWindows);
    putAction(actions.showDesktop, configuration.showDesktop);
    putAction(actions.launchpad, configuration.launchpad);
    putAction(actions.nextSpace, configuration.nextSpace);
    putAction(actions.previousSpace, configuration.previousSpace);

    SCMCClickHandler *clickHandler = self.clickHandler;

    if (!hidActions.empty) {
        _hidListener = [[SCMCHidListener alloc] initWithAcceptedCodes:hidActions.addedEventCodes callback:^(uint32_t code, BOOL pressed) {
            [clickHandler handleClickWithCode:@(code) pressed:pressed actionStore:hidActions];
        }];
        [_hidListener startForDeviceMatching:@{
            @kIOHIDVendorIDKey : configuration.vendorId,
            @kIOHIDProductIDKey : configuration.productId,
        }];
    }

    if (!eventTapActions.empty) {
        _eventTapListener = [[SCMCEventTapListener alloc] initWithAcceptedCodes:eventTapActions.addedEventCodes callback:^(int64_t code, BOOL pressed) {
            [clickHandler handleClickWithCode:@(code) pressed:pressed actionStore:eventTapActions];
        }];
        [_eventTapListener start];
    }
}

- (void)putAction:(SCMCAction)action forEvent:(SCMCEventSpec *)eventSpec toHidActions:(SCMCActionStore *)hidActions orEventTapActions:(SCMCActionStore *)eventTapActions {
    if (nil == eventSpec) return;

    if (eventSpec.type == SCMCEventTypeHid) {
        [hidActions addAction:action forEvent:eventSpec];
    } else if (eventSpec.type == SCMCEventTypeEventTap) {
        [eventTapActions addAction:action forEvent:eventSpec];
    }
}

@end
