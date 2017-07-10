//
//  SCMCInjector.m
//  Sculpt Control Inject Bundle
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

#import "WVSpaces.h"
#import "SCMCMouseListener.h"
#import "SCMCActions.h"
#import "SCMCConfiguration.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

static SCMCMouseListener *MouseListener;

static void SpacesFinderEnumeratorBody(__unused task_t task, id<WVSpaces> *result, __unused unsigned type, vm_range_t *ranges, unsigned numberOfRanges) {
    if (*result != nil) return; // how to interrupt enumeration properly?

    Class spacesClass = objc_getClass(SPACES_CLASS_NAME);
    size_t spacesInstanceSize = class_getInstanceSize(spacesClass);

    for (unsigned i = 0; i < numberOfRanges; i++) {
        vm_range_t range = ranges[i];
        if (range.size < spacesInstanceSize) continue;

        void *maybeObject = (void *) range.address;
        if (spacesClass == object_getClass((__bridge id) maybeObject)) {
            *result = (__bridge id<WVSpaces>) maybeObject;
            return;
        }
    }
}

static id<WVSpaces> FindSpacesInstance(void) {
    id<WVSpaces> result = nil;

    vm_address_t zoneAddress = (vm_address_t) malloc_default_zone();
    vm_range_recorder_t *rangeRecorder = (vm_range_recorder_t *) &SpacesFinderEnumeratorBody;
    malloc_default_zone()->introspect->enumerator(0, &result, MALLOC_PTR_IN_USE_RANGE_TYPE, zoneAddress, 0, *rangeRecorder);

    return result;
}

static void ShowNotification(void) {
    NSUserNotification *notification = [NSUserNotification new];
    notification.title = @"Dock";
    notification.informativeText = @"SCMC bundle loaded successfully";

    [NSUserNotificationCenter.defaultUserNotificationCenter deliverNotification:notification];
}

__attribute__((constructor))
static void StartMouseListener(void) {
    id<WVSpaces> spaces = FindSpacesInstance();
    SCMCActions *actions = [[SCMCActions alloc] initWithSpaces:spaces];
    SCMCConfiguration *configuration = [[SCMCConfiguration alloc] initWithActions:actions];
    MouseListener = [SCMCMouseListener listenerWithConfiguration:configuration];
    if (configuration.showInjectNotification) ShowNotification();
}
