//
//  SCMCEventSpec.m
//  Shared
//
//  Created by Maxim Naumov on 09.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#import "SCMCEventSpec.h"

@implementation SCMCEventSpec

- (instancetype)initWithType:(SCMCEventType)type code:(NSNumber *)code longClick:(BOOL)longClick {
    if (self = [super init]) {
        _type = type;
        _code = code;
        _longClick = longClick;
    }
    return self;
}

+ (nullable instancetype)eventSpecWithDictionary:(NSDictionary<NSString *, NSNumber *> *)specDictionary {
    if (specDictionary.count == 0) {
        return nil;
    }

    SCMCEventType type = specDictionary[@"type"].integerValue;
    if (type != SCMCEventTypeEventTap && type != SCMCEventTypeHid) {
        return nil;
    }

    NSNumber *code = specDictionary[@"code"];
    if (code == nil) {
        return nil;
    }

    BOOL longClick = specDictionary[@"long"].boolValue;

    return [[self alloc] initWithType:type code:code longClick:longClick];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld:%@%@", (NSInteger)self.type, self.code, self.longClick ? @"[long]" : @""];
}

@end
