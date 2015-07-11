//
//  main.m
//  Sculpt Comfort Mission Control
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char *argv[]) {
    NSApplicationLoad(); // Just to show dock icon

    // Make Dock load the bundle
    NSString *injectBundlePath = [[NSBundle mainBundle] pathForResource:@"Sculpt Control Inject Bundle" ofType:@"bundle"];
    NSString *injectCommand = [NSString stringWithFormat:@"expr (char)[[NSBundle bundleWithPath:@\"%@\"] load]", injectBundlePath];
    NSTask *lldbTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/lldb" arguments:@[
            @"-o", @"attach Dock",
            @"-o", injectCommand,
            @"-o", @"detach",
            @"-o", @"quit",
    ]];
    // Wait for lldb for a limited amount of time
    NSTimer *killTimer = [NSTimer scheduledTimerWithTimeInterval:15
            target:[NSBlockOperation blockOperationWithBlock:^{
                [lldbTask terminate];

                NSAlert *alert = [NSAlert new];
                alert.messageText = @"Could not start";
                [alert runModal];
            }]
            selector:@selector(main)
            userInfo:nil
            repeats:NO
    ];
    [lldbTask waitUntilExit];
    [killTimer invalidate];
    return 0;

    // Now that the app is closed ApplicationDiedInterceptor is triggered
}
