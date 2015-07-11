//
//  SCMCMouseListener.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMCMouseListener : NSObject

+ (instancetype)listenerWithClickAction:(void (^)())clickAction longClickAction:(void (^)())longClickAction swipeUpAction:(void (^)())swipeUpAction swipeDownAction:(void (^)())swipeDownAction;

@end
