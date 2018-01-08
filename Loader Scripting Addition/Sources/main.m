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

    CFStringRef pluginRequirementString = CFSTR("identifier \"deej.SCMC.Dock-Plugin\" and anchor apple generic and cert leaf[subject.CN] = \"Mac Developer: ultimate.deej@gmail.com (6SLQ78239J)\" and certificate leaf[subject.OU] = X58FT7637Z and certificate 1[field.1.2.840.113635.100.6.2.1]");
    SecRequirementCreateWithString(pluginRequirementString, kSecCSDefaultFlags, &requirement);

    return (SecStaticCodeCheckValidity(bundleCode, kSecCSDefaultFlags, requirement) == noErr);
}


OSErr SCMCLoadDockPlugin(const AppleEvent *event, AppleEvent *reply, long refcon) {
    NSURL *applicationsUrl = [NSFileManager.defaultManager URLForDirectory:NSApplicationDirectory inDomain:NSLocalDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL *pluginUrl = [applicationsUrl URLByAppendingPathComponent:@"Sculpt Comfort Mission Control.app/Contents/Dock Plugin/Dock Plugin.bundle"];

    if (!IsPluginSignatureValid(pluginUrl)) {
        const char errorText[] = "Invalid bundle signature";
        AEPutParamPtr(reply, keyErrorString, typeUTF8Text, errorText, sizeof(errorText));
        return pathNotVerifiedErr;
    }

    [[NSBundle bundleWithURL:pluginUrl] load];

    return noErr;
}
