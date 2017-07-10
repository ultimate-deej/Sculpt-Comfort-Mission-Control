//
//  SCMCActions.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

@import AppKit;

#import "SCMCActions.h"
#import "WVSpaces.h"

@interface SCMCActions ()

@property(weak, nonatomic, readonly) id<WVSpaces> spaces;

@end

@implementation SCMCActions

- (instancetype)initWithSpaces:(__weak id<WVSpaces>)spaces {
    if (self = [super init]) {
        _spaces = spaces;
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

- (SCMCAction)nextSpace {
    id<WVSpaces> spaces = self.spaces;
    return ^{
        [spaces switchToNextSpace:YES];
    };
}

- (SCMCAction)previousSpace {
    id<WVSpaces> spaces = self.spaces;
    return ^{
        [spaces switchToPreviousSpace:YES];
    };
}

@end
