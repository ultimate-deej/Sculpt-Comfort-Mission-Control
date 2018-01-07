//
//  main.m
//  Loader App
//
//  Created by Maxim Naumov on 07.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

int main(int argc, const char * argv[]) {
    NSAppleScript *triggerOsaxScript = [[NSAppleScript alloc] initWithSource:@"tell application \"Dock\" to «event SCMCinjt»"];
    NSDictionary<NSString *, id> *error = nil;
    [triggerOsaxScript executeAndReturnError:&error];
    if (error != nil) {
        // TODO: show alert
        return 1;
    } else {
        return 0;
    }
}
