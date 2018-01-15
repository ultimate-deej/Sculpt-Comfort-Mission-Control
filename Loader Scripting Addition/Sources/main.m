//
//  main.m
//  SCMS Loader
//
//  Created by Maxim Naumov on 07.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

#pragma mark Cleanup Helper

static void ReleaseRef(void *variableRef) {
    CFTypeRef cfObject = *((CFTypeRef *)variableRef);
    if (cfObject) CFRelease(cfObject);
}
#define CFRELEASE_CLEANUP __attribute__((__cleanup__(ReleaseRef)))

#pragma mark -

static BOOL IsPluginSignatureValid(NSURL *bundlePath) {
    CFRELEASE_CLEANUP SecStaticCodeRef bundleCode = NULL;
    CFRELEASE_CLEANUP SecRequirementRef requirement = NULL;

    if (SecStaticCodeCreateWithPath((__bridge CFURLRef)bundlePath, kSecCSDefaultFlags, &bundleCode) != noErr) {
        return NO;
    }

    CFStringRef pluginRequirementString = CFSTR("identifier \"deej.SCMC.Dock-Plugin\" and certificate root = H\"3bbea1421ecbfb0d14919835fe9a9ba78ad3ab80\"");
    SecRequirementCreateWithString(pluginRequirementString, kSecCSDefaultFlags, &requirement);

    return (SecStaticCodeCheckValidity(bundleCode, kSecCSDefaultFlags, requirement) == noErr);
}


OSErr SCMCLoadDockPlugin(const AppleEvent *event, AppleEvent *reply, long refcon) {
    AEDesc pluginPathDesc;
    if (AEGetParamDesc(event, keyDirectObject, typeWildCard, &pluginPathDesc) != noErr) {
        return fnfErr;
    }
    NSURL *pluginUrl = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&pluginPathDesc].fileURLValue;

    NSError *error = nil;
    if (![pluginUrl checkResourceIsReachableAndReturnError:&error]) {
        const char *errorText = error.localizedDescription.UTF8String;
        AEPutParamPtr(reply, keyErrorString, typeUTF8Text, errorText, strlen(errorText));
        return fnfErr;
    }

    if (!IsPluginSignatureValid(pluginUrl)) {
        const char errorText[] = "Invalid bundle signature";
        AEPutParamPtr(reply, keyErrorString, typeUTF8Text, errorText, sizeof(errorText));
        return pathNotVerifiedErr;
    }

    [[NSBundle bundleWithURL:pluginUrl] load];

    return noErr;
}
