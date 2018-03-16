//
//  SCMCConfiguration.m
//  Shared
//
//  Created by Maxim Naumov on 09.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "SCMCConfiguration.h"

static NSString *const VendorIdKey = @"vendor-id";
static NSString *const ProductIdKey = @"product-id";

static NSString *const MissionControlKey = @"mission-control";
static NSString *const ApplicationWindowsKey = @"application-windows";
static NSString *const ShowDesktopKey = @"show-desktop";
static NSString *const LaunchpadKey = @"launchpad";
static NSString *const NextSpaceKey = @"next-space";
static NSString *const PreviousSpaceKey = @"previous-space";

@interface SCMCConfiguration ()

@property(nonatomic, readonly) NSUserDefaults *userDefaults;

@end

@implementation SCMCConfiguration

- (instancetype)initPrivate {
    if (self = [super init]) {
        [self forceInvalidateUserDefaults];
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"deej.SCMC"];
    }
    return self;
}

- (void)forceInvalidateUserDefaults {
    // If you replace the config file, the app will keep reading previous data
    // This is a workaround for that
    system("defaults read deej.SCMC");
}

+ (instancetype)configuration {
    return [[self alloc] initPrivate];
}

// MARK: - Optional values needed for HID listener

- (NSNumber *)vendorId {
    return [self.userDefaults objectForKey:VendorIdKey];
}

- (NSNumber *)productId {
    return [self.userDefaults objectForKey:ProductIdKey];
}

// MARK: - Actions

- (SCMCEventSpec *)missionControl {
    return [self specForKey:MissionControlKey];
}

- (SCMCEventSpec *)applicationWindows {
    return [self specForKey:ApplicationWindowsKey];
}

- (SCMCEventSpec *)showDesktop {
    return [self specForKey:ShowDesktopKey];
}

- (SCMCEventSpec *)launchpad {
    return [self specForKey:LaunchpadKey];
}

- (SCMCEventSpec *)nextSpace {
    return [self specForKey:NextSpaceKey];
}

- (SCMCEventSpec *)previousSpace {
    return [self specForKey:PreviousSpaceKey];
}

// MARK: Parsing Spec

- (SCMCEventSpec *)specForKey:(NSString *)key {
    NSDictionary<NSString *, NSNumber *> *specDictionary = [self.userDefaults dictionaryForKey:key];
    return [SCMCEventSpec eventSpecWithDictionary:specDictionary];
}

@end
