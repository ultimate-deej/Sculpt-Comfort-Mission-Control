//
//  main.m
//  Loader App
//
//  Created by Maxim Naumov on 07.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import AppKit;

static NSString *FormatError(NSDictionary<NSString *, id> *error) {
    return error[NSAppleScriptErrorBriefMessage];
}

static void ErrorAlert(NSDictionary<NSString *, id> *error) {
    // TODO: provide the user with instructions on what to do
    NSAlert *alert = [NSAlert new];
    // Make it wider
    alert.accessoryView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 0)];
    alert.alertStyle = NSAlertStyleCritical;
    alert.messageText = @"Sculpt Comfort Mission Control";
    alert.informativeText = FormatError(error);
    [alert runModal];
}

int main(int argc, const char * argv[]) {
    NSAppleScript *triggerOsaxScript = [[NSAppleScript alloc] initWithSource:@"tell application \"Dock\" to «event SCMCinjt»"];
    NSDictionary<NSString *, id> *error = nil;
    [triggerOsaxScript executeAndReturnError:&error];
    if (error != nil) {
        ErrorAlert(error);
        return 1;
    } else {
        return 0;
    }
}
