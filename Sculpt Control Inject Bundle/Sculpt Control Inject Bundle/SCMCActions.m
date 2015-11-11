//
//  SCMCActions.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.11.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCActions.h"
#import "WVSpaces.h"

@interface SCMCActions ()

@property(weak, nonatomic, readonly) WVSpaces *spaces;

@end

@implementation SCMCActions

- (instancetype)initWithSpaces:(__weak WVSpaces *)spaces {
    if (nil == (self = [super init])) return nil;

    _spaces = spaces;

    return self;
}

- (SCMCAction)missionControl {
    return ^{
        [[NSWorkspace sharedWorkspace] launchApplication:@"Mission Control"];
    };
}

- (SCMCAction)applicationWindows {
    return ^{
        NSString *missionControlPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:@"Mission Control"];
        NSURL *missionControlUrl = [NSURL fileURLWithPath:missionControlPath];
        [[NSWorkspace sharedWorkspace] launchApplicationAtURL:missionControlUrl options:NSWorkspaceLaunchDefault configuration:@{NSWorkspaceLaunchConfigurationArguments : @[@"2"]} error:nil];
    };
}

- (SCMCAction)nextSpace {
    return ^{
        [self.spaces switchToNextSpace:YES];
    };
}

- (SCMCAction)previousSpace {
    return ^{
        [self.spaces switchToPreviousSpace:YES];
    };
}

@end
