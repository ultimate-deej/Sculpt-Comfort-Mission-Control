//
//  SCMCActions.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

@import Foundation;

#import "SCMCMouseListener.h"

@protocol WVSpaces;

@interface SCMCActions : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSpaces:(__weak id<WVSpaces>)spaces;

@property(nonatomic, readonly) SCMCAction missionControl;
@property(nonatomic, readonly) SCMCAction applicationWindows;
@property(nonatomic, readonly) SCMCAction showDesktop;
@property(nonatomic, readonly) SCMCAction nextSpace;
@property(nonatomic, readonly) SCMCAction previousSpace;

@end
