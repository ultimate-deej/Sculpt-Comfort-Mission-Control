# Usage

* Pick a .plist
* Put the file into `~/Library/Preferences`
* Restart Dock: `killall Dock`
* Launch the app

# Editing

## File Format

A config is a regular .plist file.
Its root element is a dictionary which may contain the following keys:

* product-id: `integer`
* vendor-id: `integer`
* mission-control: `dict`
* application-windows: `dict`
* show-desktop: `dict`
* launchpad: `dict`
* next-space: `dict`
* previous-space: `dict`

All of them are optional.

`product-id` and `vendor-id` are only needed if you use HID for any of the events.

The rest of the keys describe events on which the corresponding action will run. For example, `mission-control` key describes which button should toggle Mission Control and so on.
Here's the event description format:
```plist
<dict>
  <key>type</key>
  <integer>0|1</integer>
  <key>code</key>
  <integer>0..MAX</integer>
  <key>long</key>
  <true|false/>
</dict>
```
See also the [template](Template/deej.SCMC.plist) config.
