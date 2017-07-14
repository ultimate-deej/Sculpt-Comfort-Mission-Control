//
//  SCMCMouseListener+Subclass.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 14/07/2017.
//  Copyright © 2017 Maxim Naumov. All rights reserved.
//

#import "SCMCMouseListener.h"

@interface SCMCMouseListener (Subclass)

@property(nonatomic, readonly) SCMCAction clickAction;
@property(nonatomic, readonly) SCMCAction longClickAction;
@property(nonatomic, readonly) SCMCAction swipeUpAction;
@property(nonatomic, readonly) SCMCAction swipeDownAction;

- (instancetype)initWithConfiguration:(SCMCConfiguration *)configuration;

extern BOOL HandleLongClick(__weak SCMCMouseListener *listener, BOOL down);

@end
