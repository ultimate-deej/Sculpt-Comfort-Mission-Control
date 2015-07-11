//
//  SCMCInjector.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "SCMCInjector.h"
#import "WVSpaces.h"
#import "SCMCMouseListener.h"
#import <objc/runtime.h>

static SCMCMouseListener *MouseListener;

static void (*ApplicationDied_orig)(id self, SEL _cmd, int arg);

static void ApplicationDiedInterceptor(id self, SEL _cmd, int arg) {
    ApplicationDied_orig(self, _cmd, arg);

    // self is the desired instance of WVSpaces
    // Use it to create a mouse listener
    __weak id spaces = self;
    MouseListener = [SCMCMouseListener listenerWithClickAction:^{
        [[NSWorkspace sharedWorkspace] launchApplication:@"Mission Control"];
    } longClickAction:^{
        NSString *missionControlPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:@"Mission Control"];
        NSURL *missionControlUrl = [NSURL fileURLWithPath:missionControlPath];
        [[NSWorkspace sharedWorkspace] launchApplicationAtURL:missionControlUrl options:NSWorkspaceLaunchDefault configuration:@{NSWorkspaceLaunchConfigurationArguments : @[@"2"]} error:nil];
    } swipeUpAction:^{
        [spaces switchToNextSpace:YES];
    } swipeDownAction:^{
        [spaces switchToPreviousSpace:YES];
    }];

    // Restore applicationDied: method
    Class spacesClass = objc_getClass("WVSpaces");
    Method applicationDiedMethod = class_getInstanceMethod(spacesClass, @selector(applicationDied:));
    method_setImplementation(applicationDiedMethod, (IMP) ApplicationDied_orig);
    ApplicationDied_orig = NULL;
}

@implementation SCMCInjector

// Install ApplicationDiedInterceptor
+ (void)load {
    Class spacesClass = objc_getClass("WVSpaces");
    Method applicationDiedMethod = class_getInstanceMethod(spacesClass, @selector(applicationDied:));
    ApplicationDied_orig = (void *) method_getImplementation(applicationDiedMethod);
    method_setImplementation(applicationDiedMethod, (IMP) ApplicationDiedInterceptor);
}

@end
