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
        },
    }];
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

@end
