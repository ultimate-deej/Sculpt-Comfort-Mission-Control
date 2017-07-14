Usage
-----
* Pick a sample .plist
* Edit it with any editor
* Import the config:
`defaults import com.apple.dock my-config.plist`
* Restart Dock:
`killall Dock`
* Launch the app

Available Actions
-----------------
* mission-control
* application-windows
* show-desktop
* next-space
* previous-space

Choosing click detection method
-------------------------------
Choose a method via the `method` config key. There are two valid values:

* `hid`
  Use this method if button clicks are not detected by the `event-tap` method.
  Clicks are not consumed. This is the default.
*  `event-tap`
  Use this method if button clicks can be detected by regular software (wheel click etc.)
  Clicks are consumed and are not detected by the system.
  Valid buttons codes for this method are 2-31. Vendor/product IDs are ignored.

How to disable app start notification?
--------------------------------------
Add the following to your config along the other configuration parameters:
```
<key>show-inject-notification</key>
<false/>
```

Alternatively, if you have imported a config before, run the following command:
`defaults write com.apple.dock scmc -dict-add show-inject-notification -bool false`
