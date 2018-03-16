//
//  SCMCClickHandler.h
//  Dock Plugin
//
//  Created by Maxim Naumov on 16.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

@class SCMCActionStore;

NS_ASSUME_NONNULL_BEGIN

/// @brief Does the actual click handling (including long-click logic). Performs actions.
@interface SCMCClickHandler : NSObject

- (void)handleClickWithCode:(NSNumber *)code pressed:(BOOL)pressed actionStore:(SCMCActionStore *)actionStore;

@end

NS_ASSUME_NONNULL_END
