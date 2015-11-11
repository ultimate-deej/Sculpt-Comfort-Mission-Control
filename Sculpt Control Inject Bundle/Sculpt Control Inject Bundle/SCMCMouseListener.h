//
//  SCMCMouseListener.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCMCConfiguration;

typedef void(^SCMCAction)(void);

@interface SCMCMouseListener : NSObject

+ (instancetype)listenerWithConfiguration:(SCMCConfiguration *)configuration clickAction:(SCMCAction)clickAction longClickAction:(SCMCAction)longClickAction swipeUpAction:(SCMCAction)swipeUpAction swipeDownAction:(SCMCAction)swipeDownAction;

@end
