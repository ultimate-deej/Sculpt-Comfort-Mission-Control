//
//  SCMCActionStore.m
//  Dock Plugin
//
//  Created by Maxim Naumov on 16.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "SCMCActionStore.h"
#import "SCMCEventSpec.h"

@interface SCMCActionStore ()

@property(nonatomic) NSMutableDictionary<NSNumber *, SCMCAction> *regularActions;
@property(nonatomic) NSMutableDictionary<NSNumber *, SCMCAction> *longClickActions;

@end

@implementation SCMCActionStore

- (instancetype)init {
    if (self = [super init]) {
        _regularActions = [[NSMutableDictionary alloc] init];
        _longClickActions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)empty {
    return (self.regularActions.count + self.longClickActions.count) == 0;
}

- (NSArray<NSNumber *> *)addedEventCodes {
    NSSet<NSNumber *> *codes = [NSSet setWithArray:self.regularActions.allKeys];
    codes = [codes setByAddingObjectsFromArray:self.longClickActions.allKeys];
    return codes.allObjects;
}

- (void)addAction:(SCMCAction)action forEvent:(SCMCEventSpec *)eventSpec {
    if (eventSpec.longClick) {
        _longClickActions[eventSpec.code] = action;
    } else {
        _regularActions[eventSpec.code] = action;
    }
}

@end
