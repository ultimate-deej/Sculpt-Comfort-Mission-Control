//
//  main.m
//  Sculpt Comfort Mission Control
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static BOOL InjectWithTimeout(NSTimeInterval timeout) {
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
    NSTimer *killTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
            target:[NSBlockOperation blockOperationWithBlock:^{
                [lldbTask terminate];
            }]
            selector:@selector(main)
            userInfo:nil
            repeats:NO
    ];
    [lldbTask waitUntilExit];
    BOOL result = killTimer.isValid;
    [killTimer invalidate];
    return result;
}

int main(int argc, const char *argv[]) {
    int retryCount = 4;
    NSTimeInterval retryInterval = 10;
    NSTimeInterval retryIntervalIncrement = 15;
    for (int i = 0; i < retryCount; ++i, retryInterval += retryIntervalIncrement) {
        if (InjectWithTimeout(retryInterval)) {
            return 0;
        }
    }

    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Could not start";
    [alert runModal];
    return 1;
}
