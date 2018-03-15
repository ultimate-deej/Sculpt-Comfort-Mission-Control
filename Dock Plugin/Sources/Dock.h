//
//  Dock.h
//  Dock Plugin
//
//  Created by Maxim Naumov on 15.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

// Due to dynamic nature of Objective-C real classes can be casted
// to the protocols below, which is convenient.
// There's no classes that conform to these protocols.

@protocol SCMCDockSpaces

- (BOOL)switchToNextSpace:(BOOL)arg;
- (BOOL)switchToPreviousSpace:(BOOL)arg;

@end

@protocol SCMCDockExpose

- (void)MissionControlSwitchToNextSpace:(CGDirectDisplayID)display;
- (void)MissionControlSwitchToPreviousSpace:(CGDirectDisplayID)display;

@property(nonatomic) unsigned char mode;

@end
