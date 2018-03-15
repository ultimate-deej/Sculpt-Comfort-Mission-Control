//
//  SCMCActions.h
//  Dock Plugin
//
//  Created by Maxim Naumov on 15.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

@protocol SCMCDockSpaces;
@protocol SCMCDockExpose;

typedef void(^SCMCAction)(void);

NS_ASSUME_NONNULL_BEGIN

/// @brief A collection of actions available to user.
@interface SCMCActions : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSpaces:(__weak id<SCMCDockSpaces>)spaces expose:(__weak id<SCMCDockExpose>)expose;

@property(nonatomic, readonly) SCMCAction missionControl;
@property(nonatomic, readonly) SCMCAction applicationWindows;
@property(nonatomic, readonly) SCMCAction showDesktop;
@property(nonatomic, readonly) SCMCAction launchpad;
@property(nonatomic, readonly) SCMCAction nextSpace;
@property(nonatomic, readonly) SCMCAction previousSpace;

@end

NS_ASSUME_NONNULL_END
