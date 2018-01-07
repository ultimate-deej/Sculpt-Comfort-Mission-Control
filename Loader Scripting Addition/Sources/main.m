//
//  main.m
//  SCMS Loader
//
//  Created by Maxim Naumov on 07.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

@import Foundation;

OSErr SCMCLoadDockPlugin(const AppleEvent *event, AppleEvent *reply, long refcon) {
    NSURL *applicationsUrl = [NSFileManager.defaultManager URLForDirectory:NSApplicationDirectory inDomain:NSLocalDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL *pluginUrl = [applicationsUrl URLByAppendingPathComponent:@"Sculpt Comfort Mission Control.app/Contents/Dock Plugin/Dock Plugin.bundle"];
    [[NSBundle bundleWithURL:pluginUrl] load];

    return noErr;
}
