//
//  PrefixedNames.h
//  SharedPrefixedNames
//
//  Created by Maxim Naumov on 09.01.2018.
//  Copyright © 2018 deej. All rights reserved.
//

#ifdef PREFIX_NAMES_FOR_PREFERENCE_PANE

#define PREFIX(name) DeejScmcPreference ## name

#define SCMCConfiguration PREFIX(Configuration)
#define SCMCEventSpec PREFIX(EventSpec)
#define SCMCHidListener PREFIX(HidListener)

#endif
