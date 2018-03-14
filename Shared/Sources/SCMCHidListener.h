//
//  SCMCHidListener.h
//  Shared
//
//  Created by Maxim Naumov on 14.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "PrefixedNames.h"

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SCMCHidListenerCallback)(uint32_t code, BOOL pressed);

/**
 Low-level HID listener.
 Does all the dirty work like calling C APIs and discarding unwanted events.

 @note Only one button can be pressed at a time. While pressed, other buttons are ignored.
 */
@interface SCMCHidListener : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// @param callback Invoked whenever an appropriate event occurs.
/// @param acceptedCodes Codes that are allowed to be passed to the callback.
- (instancetype)initWithCallback:(SCMCHidListenerCallback)callback acceptedCodes:(NSArray<NSNumber *> *)acceptedCodes;

/// @param match `NSDictionary` containing device matching criteria.
- (void)startForDeviceMatching:(NSDictionary<NSString *, NSNumber *> *)match;

@end

NS_ASSUME_NONNULL_END
