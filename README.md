# Morsel

A tiny, in-app **snackbar / toast** for iOS — a bar that slides up from the
bottom of *your app's* screen, shows a short message, and auto-dismisses.

No permissions, no notifications, no backend. It's pure in-app UI you can show
(or schedule) from anywhere, and it works in both **UIKit** and **SwiftUI**.

```
┌─────────────────────────┐
│      Your App Screen    │
│                         │
│  ┌───────────────────┐  │
│  │ ✓ Saved!    UNDO  │  │  ← the morsel
│  └───────────────────┘  │
└─────────────────────────┘
```

## Modules

| Module | Depends on | Contains |
|---|---|---|
| `MorselCore` | — (pure Swift) | `Morsel`, `MorselStyle`, `MorselDuration`, `MorselQueue` |
| `MorselUIKit` | Core | `MorselPresenter`, `MorselView` (UIView) |
| `MorselSwiftUI` | Core | `MorselPresenter`, `.morselHost()` modifier |
| `Morsel` | all three | Umbrella convenience |

The model + queue live in **Core** with no UI dependency; each UI layer only
renders and animates. That's how one package serves both UIKit and SwiftUI.

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/zetro-nayatel/Morsel.git", from: "0.1.0")
]
```

Add `MorselUIKit` **or** `MorselSwiftUI` (each pulls in Core).

### CocoaPods

```ruby
pod 'Morsel/UIKit'      # UIKit apps
pod 'Morsel/SwiftUI'    # SwiftUI apps
```

## Usage — SwiftUI

```swift
import SwiftUI
import MorselSwiftUI

struct RootView: View {
    @StateObject private var morsel = MorselPresenter()

    var body: some View {
        ContentView()
            .environmentObject(morsel)   // so child views can reach it
            .morselHost(morsel)          // attach once, at the top
    }
}

// Anywhere with access to the presenter:
morsel.show("Saved!", style: .success)
```

## Usage — UIKit

```swift
import MorselUIKit

MorselPresenter.shared.show("Saved!", style: .success)

// With an action button that stays until tapped:
MorselPresenter.shared.show(Morsel(
    message: "Message deleted",
    duration: .indefinite,
    action: MorselAction(title: "Undo") { restore() }
))
```

## Styles

`.info` (blue) · `.success` (green) · `.warning` (orange) · `.error` (red) —
each with a matching SF Symbol.

## Scheduling

Show a morsel after a delay with `schedule(_:after:)`. See **[SCHEDULING.md](SCHEDULING.md)**
for delay vs. duration, queueing, and sticky morsels.

```swift
morsel.schedule(Morsel(message: "Reminder", style: .warning), after: 5)
```

## Developing

```bash
swift build      # Core + UIKit + SwiftUI
swift test       # 11 tests over the pure Core logic
```
