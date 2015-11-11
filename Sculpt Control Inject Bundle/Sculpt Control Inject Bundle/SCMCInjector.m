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
#import "SCMCActions.h"
#import <objc/runtime.h>

static SCMCMouseListener *MouseListener;

static void (*ApplicationDied_orig)(WVSpaces *self, SEL _cmd, int arg);

static void ApplicationDiedInterceptor(WVSpaces *self, SEL _cmd, int arg) {
    ApplicationDied_orig(self, _cmd, arg);

    // self is the desired instance of WVSpaces
    // Use it to create a mouse listener
    SCMCActions *actions = [[SCMCActions alloc] initWithSpaces:self];
    MouseListener = [SCMCMouseListener listenerWithClickAction:actions.missionControl
                                               longClickAction:actions.applicationWindows
                                                 swipeUpAction:actions.nextSpace
                                               swipeDownAction:actions.previousSpace];

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
    ApplicationDied_orig = (typeof(ApplicationDied_orig)) method_getImplementation(applicationDiedMethod);
    ApplicationDied_orig = (typeof(ApplicationDied_orig)) method_setImplementation(applicationDiedMethod, (IMP) ApplicationDiedInterceptor);
}

@end
