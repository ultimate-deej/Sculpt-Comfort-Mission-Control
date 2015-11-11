//
//  SCMCConfiguration.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCConfiguration.h"

static NSString *const RootKey = @"scmc";

@implementation SCMCConfiguration

static NSDictionary *Configuration(void) {
    return [[NSUserDefaults standardUserDefaults] valueForKey:RootKey];
}

+ (void)load {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        RootKey : @{
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

@end
