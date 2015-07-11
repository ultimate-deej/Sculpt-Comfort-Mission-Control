//
//  WVSpaces.h
//  Sculpt Comfort Mission Control
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "InterfaceHasNoImplementation"

@interface WVSpaces : NSObject

- (BOOL)switchToNextSpace:(BOOL)arg;

- (BOOL)switchToPreviousSpace:(BOOL)arg;

- (void)applicationDied:(int)arg;

@end

#pragma clang diagnostic pop
