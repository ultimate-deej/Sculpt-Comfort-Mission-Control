//
//  SCMCConfiguration.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCConfiguration.h"

static NSString *const RootKey = @"scmc";

static NSString *const ListenerKindKey = @"method";

static NSString *const HidListenerKindName = @"hid";
static NSString *const EventTapListenerKindName = @"event-tap";

static NSString *const VendorIdKey = @"vendor-id";
static NSString *const ProductIdKey = @"product-id";

static NSString *const ClickCodeKey = @"click-code";
static NSString *const SwipeUpCodeKey = @"swipe-up-code";
static NSString *const SwipeDownCodeKey = @"swipe-down-code";

static NSString *const ClickActionKey = @"click-action";
static NSString *const LongClickActionKey = @"long-click-action";
static NSString *const SwipeUpActionKey = @"swipe-up-action";
static NSString *const SwipeDownActionKey = @"swipe-down-action";

static NSString *const MissionControlActionName = @"mission-control";
static NSString *const ApplicationWindowsActionName = @"application-windows";
static NSString *const ShowDesktopActionName = @"show-desktop";
static NSString *const LaunchpadActionName = @"launchpad";
static NSString *const NextSpaceActionName = @"next-space";
static NSString *const PreviousSpaceActionName = @"previous-space";

static NSString *const ShowInjectNotificationKey = @"show-inject-notification";

@interface SCMCConfiguration ()

@property(nonatomic, readonly) NSDictionary<NSString *, id> *rawConfiguration;
@property(nonatomic, readonly) NSDictionary<NSString *, SCMCAction> *actionsByName;

@end

@implementation SCMCConfiguration

+ (void)load {
    [NSUserDefaults.standardUserDefaults registerDefaults:@{
        RootKey : @{
            ListenerKindKey : EventTapListenerKindName,

            ClickCodeKey : @2,
            SwipeUpCodeKey : @3,
            SwipeDownCodeKey : @4,

            ClickActionKey : MissionControlActionName,
            LongClickActionKey : ApplicationWindowsActionName,
            SwipeUpActionKey : PreviousSpaceActionName,
            SwipeDownActionKey : NextSpaceActionName,

            ShowInjectNotificationKey : @YES,
        },
    }];
}

- (instancetype)initWithActions:(SCMCActions *)actions {
    if (self = [super init]) {
        _rawConfiguration = [NSUserDefaults.standardUserDefaults valueForKey:RootKey];
        _actionsByName = @{
            MissionControlActionName : actions.missionControl,
            ApplicationWindowsActionName : actions.applicationWindows,
            ShowDesktopActionName : actions.showDesktop,
            LaunchpadActionName : actions.launchpad,
            NextSpaceActionName : actions.nextSpace,
            PreviousSpaceActionName : actions.previousSpace,
        };
    }

    return self;
}

#pragma mark - Properties

- (ListenerKind)listenerKind {
    NSString *name = self.rawConfiguration[ListenerKindKey];
    if ([name isEqualToString:EventTapListenerKindName]) {
        return EventTapListenerKind;
    }
    return HidListenerKind;
}

- (NSNumber *)vendorId {
    return self.rawConfiguration[VendorIdKey];
}

- (NSNumber *)productId {
    return self.rawConfiguration[ProductIdKey];
}

- (NSInteger)clickCode {
    return [self.rawConfiguration[ClickCodeKey] integerValue];
}

- (NSInteger)swipeUpCode {
    return [self.rawConfiguration[SwipeUpCodeKey] integerValue];
}

- (NSInteger)swipeDownCode {
    return [self.rawConfiguration[SwipeDownCodeKey] integerValue];
}

- (SCMCAction)clickAction {
    NSString *actionName = self.rawConfiguration[ClickActionKey];
    return self.actionsByName[actionName];
}

- (SCMCAction)longClickAction {
    NSString *actionName = self.rawConfiguration[LongClickActionKey];
    return self.actionsByName[actionName];
}

- (SCMCAction)swipeUpAction {
    NSString *actionName = self.rawConfiguration[SwipeUpActionKey];
    return self.actionsByName[actionName];
}

- (SCMCAction)swipeDownAction {
    NSString *actionName = self.rawConfiguration[SwipeDownActionKey];
    return self.actionsByName[actionName];
}

- (BOOL)showInjectNotification {
    NSNumber *configValue = self.rawConfiguration[ShowInjectNotificationKey];
    if (configValue) {
        return configValue.boolValue;
    }
    return YES;
}

@end
