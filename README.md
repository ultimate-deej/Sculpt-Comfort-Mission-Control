# What is it?
It's an app that lets you switch between virtual desktops on your Mac. With a mouse! And not only with Sculpt Comfort, any mouse will do.

# Installation
1. Install Loader. This is probably a one-time setup as this component is unlikely to change soon.
	1. Disable SIP
	2. Copy `SCMC Loader.osax` to `/System/Library/ScriptingAdditions`
	3. Enable SIP
2. Install a config (see [Configuration folder](/Configuration))
3. Run `Sculpt Comfort Mission Control.app`

# Contributing
**Contributions are highly welcomed.** This is how you can help the project:
- Adding more details to readme
- Fixing typos, grammar and spelling mistakes etc.
- Code contributions. Take a thorough approach here. The best way to make a code contribution is to discuss the idea before actually starting to code.

While the above are direct contributions, there are other ways to help the project:
- Star this repo ⭐. It really motivates me to continue improving the app!
- Tell a friend

# Which macOS versions are supported?
10.12+. Support for earlier versions is dropped.

# What happened here?
This is version 2, a complete rewrite of the app.

Although it's a minimal working release which lacks some important features, it can already do everything v1 can but better! That said, you can already benefit from moving to v2 because:

- You don't need `lldb` and developer tools
- Because of the above, it starts much faster. You won't even notice
- You only need to disable SIP for an initial installation
- If the app handles a mouse event, other apps don't receive it anymore (with a proper config). With the previous version, it happened for some button configurations. No more unwanted navigation in browsers or wherever else.

# I need help
Submit an issue.
