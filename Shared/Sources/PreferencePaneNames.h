//
//  PreferencePaneNames.h
//  SharedPrefixedNames
//
//  Created by Maxim Naumov on 09.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#define PREF_PANE_NAME(name) DeejScmcPreference ## name

#define SCMCConfiguration PREF_PANE_NAME(Configuration)
#define SCMCEventSpec PREF_PANE_NAME(EventSpec)
#define SCMCHidListener PREF_PANE_NAME(HidListener)
#define SCMCEventTapListener PREF_PANE_NAME(EventTapListener)
