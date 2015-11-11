//
//  SCMCConfiguration.h
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMCConfiguration : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, readonly) NSNumber *vendorId;
@property(nonatomic, readonly) NSNumber *productId;

@property(nonatomic, readonly) NSInteger clickCode;
@property(nonatomic, readonly) NSInteger swipeUpCode;
@property(nonatomic, readonly) NSInteger swipeDownCode;

@end
