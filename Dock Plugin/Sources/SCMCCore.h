//
//  SCMCCore.h
//  Dock Plugin
//
//  Created by Maxim Naumov on 14.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

@class SCMCConfiguration;
@class SCMCActions;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Main application logic.
 @discussion Ties everything together.
    Reads configuration, listens to mouse events, and performs actions.
 */
@interface SCMCCore : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)startWithConfiguration:(SCMCConfiguration *)configuration actions:(SCMCActions *)actions;

@end

NS_ASSUME_NONNULL_END
