//
//  SCMCEventTapListener.h
//  Shared
//
//  Created by Maxim Naumov on 14.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SCMCEventTapListenerCallback)(int64_t code, BOOL pressed);

/**
 Low-level Event Tap listener.
 Does all the dirty work like calling C APIs and discarding unwanted events.
 */
@interface SCMCEventTapListener : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// @param acceptedCodes Codes that are allowed to be passed to the callback.
/// @param callback Invoked whenever an appropriate event occurs.
- (instancetype)initWithAcceptedCodes:(NSArray<NSNumber *> *)acceptedCodes callback:(SCMCEventTapListenerCallback)callback;

- (void)start;

@end

NS_ASSUME_NONNULL_END
