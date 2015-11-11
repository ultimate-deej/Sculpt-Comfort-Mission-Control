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

@implementation SCMCConfiguration

static NSDictionary *Configuration(void) {
    return [[NSUserDefaults standardUserDefaults] valueForKey:RootKey];
}

+ (void)load {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        RootKey : @{
            VendorIdKey : @0x45E,
            ProductIdKey : @0x7A2,
        },
    }];
}

+ (instancetype)sharedInstance {
    static SCMCConfiguration *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [SCMCConfiguration new];
    });
    return singleton;
}

#pragma mark - Properties

- (NSNumber *)vendorId {
    return Configuration()[VendorIdKey];
}

- (NSNumber *)productId {
    return Configuration()[ProductIdKey];
}

@end
