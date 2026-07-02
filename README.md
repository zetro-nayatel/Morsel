# Snackbar

A tiny, in-app **snackbar / toast** for iOS — a bar that slides up from the
bottom of *your app's* screen, shows a short message, and auto-dismisses.

No permissions, no notifications, no backend. It's pure in-app UI you can show
(or schedule) from anywhere, and it works in both **UIKit** and **SwiftUI**.

```
┌─────────────────────────┐
│      Your App Screen    │
│                         │
│  ┌───────────────────┐  │
│  │ ✓ Saved!    UNDO  │  │  ← the snackbar
│  └───────────────────┘  │
└─────────────────────────┘
```

## Modules

| Module | Depends on | Contains |
|---|---|---|
| `SnackbarCore` | — (pure Swift) | `Snackbar`, `SnackbarStyle`, `SnackbarDuration`, `SnackbarQueue` |
| `SnackbarUIKit` | Core | `SnackbarPresenter`, `SnackbarView` (UIView) |
| `SnackbarSwiftUI` | Core | `SnackbarPresenter`, `.snackbarHost()` modifier |
| `Snackbar` | all three | Umbrella convenience |

The model + queue live in **Core** with no UI dependency; each UI layer only
renders and animates. That's how one package serves both UIKit and SwiftUI.

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/your-org/Snackbar.git", from: "0.1.0")
]
```

Add `SnackbarUIKit` **or** `SnackbarSwiftUI` (each pulls in Core).

### CocoaPods

```ruby
pod 'Snackbar/UIKit'      # UIKit apps
pod 'Snackbar/SwiftUI'    # SwiftUI apps
```

## Usage — SwiftUI

```swift
import SwiftUI
import SnackbarSwiftUI

struct RootView: View {
    @StateObject private var snackbar = SnackbarPresenter()

    var body: some View {
        ContentView()
            .environmentObject(snackbar)   // so child views can reach it
            .snackbarHost(snackbar)        // attach once, at the top
    }
}

// Anywhere with access to the presenter:
snackbar.show("Saved!", style: .success)
```

## Usage — UIKit

```swift
import SnackbarUIKit

SnackbarPresenter.shared.show("Saved!", style: .success)

// With an action button that stays until tapped:
SnackbarPresenter.shared.show(Snackbar(
    message: "Message deleted",
    duration: .indefinite,
    action: SnackbarAction(title: "Undo") { restore() }
))
```

## Styles

`.info` (blue) · `.success` (green) · `.warning` (orange) · `.error` (red) —
each with a matching SF Symbol.

## Scheduling

Show a snackbar after a delay with `schedule(_:after:)`. See **[SCHEDULING.md](SCHEDULING.md)**
for delay vs. duration, queueing, and sticky snackbars.

```swift
snackbar.schedule(Snackbar(message: "Reminder", style: .warning), after: 5)
```

## Developing

```bash
swift build      # Core + UIKit + SwiftUI
swift test       # 11 tests over the pure Core logic
```
