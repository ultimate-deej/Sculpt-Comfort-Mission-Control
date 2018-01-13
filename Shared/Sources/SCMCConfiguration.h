//
//  SCMCConfiguration.h
//  Shared
//
//  Created by Maxim Naumov on 09.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "PrefixedNames.h"

@import Foundation;
#import "SCMCEventSpec.h"

NS_ASSUME_NONNULL_BEGIN

/// Having a strongly typed object instead of a NSDictionary or NSUserDefaults is the sole purpose of this class
@interface SCMCConfiguration : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)configuration;

@property(nonatomic, readonly, nullable) NSNumber *vendorId;
@property(nonatomic, readonly, nullable) NSNumber *productId;

@property(nonatomic, readonly, nullable) SCMCEventSpec *missionControl;
@property(nonatomic, readonly, nullable) SCMCEventSpec *applicationWindows;
@property(nonatomic, readonly, nullable) SCMCEventSpec *showDesktop;
@property(nonatomic, readonly, nullable) SCMCEventSpec *launchpad;
@property(nonatomic, readonly, nullable) SCMCEventSpec *nextSpace;
@property(nonatomic, readonly, nullable) SCMCEventSpec *previousSpace;

@end

NS_ASSUME_NONNULL_END
