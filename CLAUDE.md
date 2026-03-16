# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GeneralNotification is a Swift Package for displaying custom floating notifications on macOS, derived from [NotchNotification](https://github.com/Lakr233/NotchNotification). It shows animated toast-style notifications at the top of the screen with material background, supporting any SwiftUI content.

## Build & Test Commands

```bash
# Build the library
swift build

# Build the Example app (requires xcbeautify)
./Scripts/test.build.sh

# Build Example manually via xcodebuild
xcodebuild -workspace ./Example/App.xcworkspace -scheme App -destination "generic/platform=macOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_ALLOWED=NO
```

There are no unit tests in this project. CI runs `test.build.sh` on push/PR to main.

## Architecture

The library exposes a single public entry point: `GeneralNotification.present(bodyView:interval:onTap:)`.

Internal flow when `present()` is called:

1. **`GeneralNotification`** (enum) — Public API. Wraps the user's SwiftUI view and creates a `NotificationContext`.
2. **`NotificationContext`** — Determines which screen to display on (mouse location → built-in display fallback), creates the window stack, and triggers the open animation.
3. **`NotificationWindowController`** / **`NotificationWindow`** — AppKit window layer. Creates a borderless, transparent, always-on-top (`statusBar + 8`) window that spans the top of the target screen. The window joins all spaces and ignores the window cycle.
4. **`NotificationViewModel`** — `ObservableObject` managing open/closed state and auto-dismiss timer. Calculates notification size by measuring the body view via `NSHostingView.fittingSize`. Holds a strong reference to the window controller to keep it alive, then nils it out on destroy.
5. **`NotificationView`** — SwiftUI view that renders the notification content with material background, rounded corners, shadow, and scale+opacity+offset transition animation. Wraps content in a `Button` if `onTap` is provided.
6. **`NotificationViewController`** — `NSHostingController` subclass using `ClickableHostingView` to accept first-mouse clicks.
7. **`Ext+NSScreen`** — Extension providing notch size detection and built-in display lookup.

## Key Constraints

- **macOS 12.0+**, Swift 5.7+, Swift tools version 5.7
- No external dependencies
- Max notification body width: 320pt
- Notification auto-dismisses after `interval` seconds (default 2s); pass `0` for persistent notification
- Author attribution: okooo5km(十里)
