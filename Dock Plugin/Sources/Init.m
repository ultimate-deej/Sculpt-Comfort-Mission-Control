//
//  Init.m
//  Dock Plugin
//
//  Created by Maxim Naumov on 15.03.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Darwin.malloc;
@import ObjectiveC.runtime;

#import "Dock.h"
#import "SCMCActions.h"
#import "SCMCConfiguration.h"

// MARK: - Searching for Required Objects

// MARK: Search Context

typedef struct SearchContext {
    const Class spacesClass;
    const size_t spacesInstanceSize;
    const Class exposeClass;
    const size_t exposeInstanceSize;

    __unsafe_unretained id<SCMCDockSpaces> outSpaces;
    __unsafe_unretained id<SCMCDockExpose> outExpose;
} SearchContext;

static SearchContext MakeSearchContext(void) {
    Class spacesClass = objc_getClass("Dock.Spaces");
    Class exposeClass = objc_getClass("Dock.WVExpose");

    return (SearchContext) {
        .spacesClass = spacesClass,
        .spacesInstanceSize = class_getInstanceSize(spacesClass),
        .exposeClass = exposeClass,
        .exposeInstanceSize = class_getInstanceSize(exposeClass),
    };
}

// MARK: Search routines

static void EnumeratorBody(__unused task_t task, SearchContext *const context, __unused unsigned type, vm_range_t *ranges, unsigned numberOfRanges) {
    if (context->outSpaces && context->outExpose) return; // It is impossible to interrupt enumeration as per source code

    for (unsigned i = 0; i < numberOfRanges; i++) {
        vm_range_t range = ranges[i];
        // Don't bother checking class if `range` is too small for the searched object
        if (nil == context->outSpaces && range.size >= context->spacesInstanceSize) {
            __unsafe_unretained id maybeObject = (__bridge id)(void *)range.address;
            if (object_getClass(maybeObject) == context->spacesClass) {
                context->outSpaces = maybeObject;
            }
        }
        if (nil == context->outExpose && range.size >= context->exposeInstanceSize) {
            __unsafe_unretained id maybeObject = (__bridge id)(void *)range.address;
            if (object_getClass(maybeObject) == context->exposeClass) {
                context->outExpose = maybeObject;
            }
        }
    }
}

static void FindRequiredInstances(SearchContext *const context) {
    vm_address_t zoneAddress = (vm_address_t)malloc_default_zone();
    vm_range_recorder_t *rangeRecorder = (vm_range_recorder_t *)&EnumeratorBody;
    malloc_default_zone()->introspect->enumerator(0, context, MALLOC_PTR_IN_USE_RANGE_TYPE, zoneAddress, NULL, *rangeRecorder);
}

// MARK: - Initializing

__attribute__((constructor))
static void StartCore(void) {
    SearchContext context = MakeSearchContext();
    FindRequiredInstances(&context);
    SCMCActions *actions = [[SCMCActions alloc] initWithSpaces:context.outSpaces expose:context.outExpose];
    SCMCConfiguration *configuration = [SCMCConfiguration configuration];
    // TODO: pull everything together
}
