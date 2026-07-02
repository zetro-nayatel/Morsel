# Scheduling Guide

Morsel can show a message **right now** or **after a delay**. Both work the
same way in UIKit and SwiftUI — you call `show(...)` for immediate, or
`schedule(_:after:)` for delayed.

> Scheduling here means an in-app timer (`Task.sleep`). It only fires while your
> app is running. If you need something to appear when the app is closed, that's
> a *system local notification*, which is a different API — not this package.

## Immediate

```swift
// SwiftUI
morsel.show("Saved!", style: .success)

// UIKit
MorselPresenter.shared.show("Saved!", style: .success)
```

## After a delay

Pass a `Morsel` and the number of seconds to wait:

```swift
let reminder = Morsel(
    message: "Don't forget to finish your profile",
    style: .warning,
    duration: .long
)

// SwiftUI
morsel.schedule(reminder, after: 5)      // shows 5s from now

// UIKit
MorselPresenter.shared.schedule(reminder, after: 5)
```

## How duration differs from delay

Two separate timers, don't mix them up:

| Concept | Controlled by | Meaning |
|---|---|---|
| **delay** | `schedule(_:after:)` | how long *until* the morsel appears |
| **duration** | `Morsel.duration` | how long it *stays* once visible |

```swift
// Appears in 3s, then stays on screen for 10s.
let m = Morsel(message: "Heads up", duration: .seconds(10))
morsel.schedule(m, after: 3)
```

Durations:

| Case | On screen |
|---|---|
| `.short` | 2 seconds |
| `.long` | 3.5 seconds |
| `.seconds(n)` | `n` seconds |
| `.indefinite` | until dismissed (pair with an action button) |

## Queueing

If you schedule or show several at once, they **don't overlap** — the
`MorselQueue` shows them one after another, each for its own duration.

```swift
morsel.show("First")
morsel.show("Second")   // waits until "First" finishes
morsel.schedule(Morsel(message: "Third"), after: 1)
```

## Sticky morsel with an action

Use `.indefinite` plus a `MorselAction` so it stays until the user responds:

```swift
let undo = Morsel(
    message: "Message deleted",
    style: .info,
    duration: .indefinite,
    action: MorselAction(title: "Undo") {
        restoreDeletedMessage()
    }
)
morsel.show(undo)
```

Tapping the action runs your handler and dismisses the morsel.
