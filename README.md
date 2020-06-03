# What is it?
It's an app that lets you switch between virtual desktops on your Mac. With a mouse! And not only with Sculpt Comfort, any mouse will do. But you really want a mouse with at least two additional buttons.

# Note for Catalina users
Since SCMC doesn't support Catalina at the moment, you might want to use a solution by [@ephemient](//github.com/ephemient). See [this](//github.com/ultimate-deej/Sculpt-Comfort-Mission-Control/issues/20#issuecomment-638209672) comment.

# Important 10.14 Mojave information
Due to security enhancements in Mojave, it's not currently possible to use SCMC with SIP enabled. You must keep it disabled to continue using this app.

# Installation
1. Install Loader. This is probably a one-time setup as this component is unlikely to change soon.
	1. Disable SIP
	2. Copy `SCMC Loader.osax` to `/System/Library/ScriptingAdditions`
	3. *[pre-10.14 only]* Enable SIP
2. Install a config (see [Configuration folder](/Configuration))
3. Run `Sculpt Comfort Mission Control.app`

# Contributing
**Contributions are highly welcomed.** You can help the project by:
- Adding more details to readme
- Fixing typos, grammar and spelling mistakes etc.
- Code contributions. Take a thorough approach here. The best way to make a code contribution is to discuss the idea before actually starting to code.
- **Tell me if it works with your mouse**. Just:
  1. Either create a pull request. It should contain a config and an update to the readme.
  2. Or create an issue. I will then add a config to the repo, and the model name to the readme.

While the above are direct contributions, there are other ways to help the project:
- Star this repo ⭐. It really motivates me to continue improving the app!
- Tell a friend

# Which macOS versions are supported?
10.12+. Support for earlier versions is dropped.

# Which mice are supported?
As stated earlier, the app should be able to work with any mouse, there are no artificial restrictions to this. However, here's the list of tested models:
- Microsoft Sculpt Comfort Mouse (of course)
- Microsoft Sculpt Ergonomic Mouse (a config is missing though, contact me and we'll make one)
- A 5-button No Name mouse

# What happened here, an update?
This is version 2, a complete rewrite of the app.

Although it's a minimal working release which lacks some important features, it can already do everything v1 can but better! To be specific, you will benefit from moving to v2 because:

- You don't need `lldb` and developer tools
- Because of the above, it starts much faster. You won't even notice
- You only need to disable SIP for an initial installation
- If the app handles a mouse event, other apps don't receive it anymore (with a proper config). With the previous version, it happened for some button configurations. No more unwanted navigation in browsers or wherever else.

# Have questions?
Read the issues. Or submit one.
