//
//  SCMCActions.m
//  Dock Plugin
//
//  Created by Maxim Naumov on 15.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import AppKit;

#import "SCMCActions.h"
#import "Dock.h"

@interface SCMCActions ()

@property(weak, nonatomic, readonly) id<SCMCDockSpaces> spaces;
@property(weak, nonatomic, readonly) id<SCMCDockExpose> expose;

@end

@implementation SCMCActions

- (instancetype)initWithSpaces:(__weak id<SCMCDockSpaces>)spaces expose:(__weak id<SCMCDockExpose>)expose {
    if (self = [super init]) {
        _spaces = spaces;
        _expose = expose;
    }

    return self;
}

- (SCMCAction)missionControl {
    return ^{
        [NSWorkspace.sharedWorkspace launchApplication:@"Mission Control"];
    };
}

- (SCMCAction)applicationWindows {
    return ^{
        NSString *missionControlPath = [NSWorkspace.sharedWorkspace fullPathForApplication:@"Mission Control"];
        NSURL *missionControlUrl = [NSURL fileURLWithPath:missionControlPath];
        [NSWorkspace.sharedWorkspace launchApplicationAtURL:missionControlUrl options:NSWorkspaceLaunchDefault configuration:@{NSWorkspaceLaunchConfigurationArguments : @[@"2"]} error:nil];
    };
}

- (SCMCAction)showDesktop {
    return ^{
        NSString *missionControlPath = [NSWorkspace.sharedWorkspace fullPathForApplication:@"Mission Control"];
        NSURL *missionControlUrl = [NSURL fileURLWithPath:missionControlPath];
        [NSWorkspace.sharedWorkspace launchApplicationAtURL:missionControlUrl options:NSWorkspaceLaunchDefault configuration:@{NSWorkspaceLaunchConfigurationArguments : @[@"1"]} error:nil];
    };
}

- (SCMCAction)launchpad {
    return ^{
        [NSWorkspace.sharedWorkspace launchApplication:@"Launchpad"];
    };
}

// Unlike Spaces, Expose requires a display ID as an argument
static CGDirectDisplayID CurrentDisplayId() {
    CGEventRef dummyEvent = CGEventCreate(NULL);
    CGPoint mouseLocation = CGEventGetLocation(dummyEvent);
    CFRelease(dummyEvent);

    CGDirectDisplayID currentDisplay;
    if (CGGetDisplaysWithPoint(mouseLocation, 1, &currentDisplay, NULL) != kCGErrorSuccess) {
        return kCGNullDirectDisplay;
    }

    return currentDisplay;
}

- (SCMCAction)nextSpace {
    id<SCMCDockSpaces> spaces = self.spaces;
    id<SCMCDockExpose> expose = self.expose;
    return ^{
        if (expose.mode == 0) {
            [spaces switchToNextSpace:YES];
        } else {
            [expose MissionControlSwitchToNextSpace:CurrentDisplayId()];
        }
    };
}

- (SCMCAction)previousSpace {
    id<SCMCDockSpaces> spaces = self.spaces;
    id<SCMCDockExpose> expose = self.expose;
    return ^{
        if (expose.mode == 0) {
            [spaces switchToPreviousSpace:YES];
        } else {
            [expose MissionControlSwitchToPreviousSpace:CurrentDisplayId()];
        }
    };
}

@end
