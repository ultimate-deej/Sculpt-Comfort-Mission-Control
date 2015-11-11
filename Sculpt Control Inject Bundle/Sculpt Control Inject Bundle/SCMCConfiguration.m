//
//  SCMCConfiguration.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCConfiguration.h"

static NSString *const RootKey = @"scmc";

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
static NSString *const NextSpaceActionName = @"next-space";
static NSString *const PreviousSpaceActionName = @"previous-space";

@interface SCMCConfiguration ()

@property(nonatomic, readonly) NSDictionary *actionsByName;

@end

@implementation SCMCConfiguration

static NSDictionary *Configuration(void) {
    return [[NSUserDefaults standardUserDefaults] valueForKey:RootKey];
}

+ (void)load {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        RootKey : @{
            VendorIdKey : @0x45E,
            ProductIdKey : @0x7A2,

            ClickCodeKey : @64817,
            SwipeUpCodeKey : @64809,
            SwipeDownCodeKey : @64816,

            ClickActionKey : MissionControlActionName,
            LongClickActionKey : ApplicationWindowsActionName,
            SwipeUpActionKey : NextSpaceActionName,
            SwipeDownActionKey : PreviousSpaceActionName,
        },
    }];
}

- (instancetype)initWithActions:(SCMCActions *)actions {
    if (nil == (self = [super init])) return nil;

    _actionsByName = @{
        MissionControlActionName : actions.missionControl,
        ApplicationWindowsActionName : actions.applicationWindows,
        NextSpaceActionName : actions.nextSpace,
        PreviousSpaceActionName : actions.previousSpace,
    };

    return self;
}

#pragma mark - Properties

- (NSNumber *)vendorId {
    return Configuration()[VendorIdKey];
}

- (NSNumber *)productId {
    return Configuration()[ProductIdKey];
}

- (NSInteger)clickCode {
    return [Configuration()[ClickCodeKey] integerValue];
}

- (NSInteger)swipeUpCode {
    return [Configuration()[SwipeUpCodeKey] integerValue];
}

- (NSInteger)swipeDownCode {
    return [Configuration()[SwipeDownCodeKey] integerValue];
}

- (SCMCAction)clickAction {
    NSString *actionName = Configuration()[ClickActionKey];
    return self.actionsByName[actionName];
}

- (SCMCAction)longClickAction {
    NSString *actionName = Configuration()[LongClickActionKey];
    return self.actionsByName[actionName];
}

- (SCMCAction)swipeUpAction {
    NSString *actionName = Configuration()[SwipeUpActionKey];
    return self.actionsByName[actionName];
}

- (SCMCAction)swipeDownAction {
    NSString *actionName = Configuration()[SwipeDownActionKey];
    return self.actionsByName[actionName];
}

@end
