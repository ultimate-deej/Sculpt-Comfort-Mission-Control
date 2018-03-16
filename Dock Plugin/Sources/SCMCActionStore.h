//
//  SCMCActionStore.h
//  Dock Plugin
//
//  Created by Maxim Naumov on 16.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

#import "SCMCAction.h"

@class SCMCEventSpec;

NS_ASSUME_NONNULL_BEGIN

/// Stores actions. Provides @c empty and @c addedEventCodes convenience properties.
@interface SCMCActionStore : NSObject

@property(nonatomic, readonly) BOOL empty;
@property(nonatomic, readonly) NSArray<NSNumber *> *addedEventCodes;

@property(nonatomic, readonly) NSDictionary<NSNumber *, SCMCAction> *regularActions;
@property(nonatomic, readonly) NSDictionary<NSNumber *, SCMCAction> *longClickActions;

- (void)addAction:(SCMCAction)action forEvent:(SCMCEventSpec *)eventSpec;

@end

NS_ASSUME_NONNULL_END
