//
//  SCMCEventSpec.h
//  Shared
//
//  Created by Maxim Naumov on 09.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "PrefixedNames.h"

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCMCEventType) {
    SCMCEventTypeEventTap = 0,
    SCMCEventTypeHid = 1,
};

/// @brief Describes an event which will trigger an action
@interface SCMCEventSpec : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// @brief Constructs a @c SCMCEventSpec object described by a dictionary
/// @param specDictionary Dictionary representation of the spec
/// @return @c SCMCEventSpec or @c nil, if dictionary is in an invalid format
+ (nullable instancetype)eventSpecWithDictionary:(NSDictionary<NSString *, NSNumber *> *)specDictionary;

@property(nonatomic, readonly) SCMCEventType type;
@property(nonatomic, readonly) NSNumber *code;
@property(nonatomic, readonly) BOOL longClick;

@end

NS_ASSUME_NONNULL_END
