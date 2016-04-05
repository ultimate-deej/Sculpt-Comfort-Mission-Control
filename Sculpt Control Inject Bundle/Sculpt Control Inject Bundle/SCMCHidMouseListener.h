//
//  SCMCHidMouseListener.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 05.04.16.
//  Copyright © 2016 Maxim Naumov. All rights reserved.
//

#import "SCMCMouseListener.h"

@class SCMCConfiguration;

@interface SCMCHidMouseListener : SCMCMouseListener

+ (instancetype)listenerWithConfiguration:(SCMCConfiguration *)configuration;

@end
