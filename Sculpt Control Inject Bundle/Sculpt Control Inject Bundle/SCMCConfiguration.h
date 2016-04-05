//
//  SCMCConfiguration.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMCActions.h"
#import "SCMCMouseListener.h"

@interface SCMCConfiguration : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithActions:(SCMCActions *)actions;

@property(nonatomic, readonly) ListenerKind listenerKind;

@property(nonatomic, readonly) NSNumber *vendorId;
@property(nonatomic, readonly) NSNumber *productId;

@property(nonatomic, readonly) NSInteger clickCode;
@property(nonatomic, readonly) NSInteger swipeUpCode;
@property(nonatomic, readonly) NSInteger swipeDownCode;

@property(nonatomic, readonly) SCMCAction clickAction;
@property(nonatomic, readonly) SCMCAction longClickAction;
@property(nonatomic, readonly) SCMCAction swipeUpAction;
@property(nonatomic, readonly) SCMCAction swipeDownAction;

@end
