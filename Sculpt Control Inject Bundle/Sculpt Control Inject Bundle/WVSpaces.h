//
//  WVSpaces.h
//  Sculpt Comfort Mission Control
//
//  Created by Maxim Naumov on 11.07.15.
//  Copyright (c) 2015 Maxim Naumov. All rights reserved.
//

@import Foundation;

#define SPACES_CLASS_NAME (NSProcessInfo.processInfo.operatingSystemVersion.minorVersion < 12 \
    ? "WVSpaces" \
    : "_TtC4Dock6Spaces")

@protocol WVSpaces

- (BOOL)switchToNextSpace:(BOOL)arg;
- (BOOL)switchToPreviousSpace:(BOOL)arg;

@end
