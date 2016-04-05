//
//  SCMCMouseListener.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCMouseListener.h"
#import "SCMCConfiguration.h"
#import "SCMCHidMouseListener.h"

@implementation SCMCMouseListener

+ (instancetype)listenerWithConfiguration:(SCMCConfiguration *)configuration {
    return [SCMCHidMouseListener listenerWithConfiguration:configuration];
}

@end
