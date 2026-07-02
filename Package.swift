// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Snackbar",
    // The Core module is pure model + queue logic and builds everywhere, so
    // `swift test` runs on macOS from the command line. UIKit is iOS/tvOS only.
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
    ],
    products: [
        // Consumers take Core plus whichever UI layer matches their app.
        .library(name: "SnackbarCore", targets: ["SnackbarCore"]),
        .library(name: "SnackbarUIKit", targets: ["SnackbarUIKit"]),
        .library(name: "SnackbarSwiftUI", targets: ["SnackbarSwiftUI"]),
        // Umbrella convenience.
        .library(name: "Snackbar", targets: ["SnackbarCore", "SnackbarUIKit", "SnackbarSwiftUI"]),
    ],
    targets: [
        // The engine: the Snackbar model, styles, durations, and the queue
        // that orders multiple snackbars. No UIKit / SwiftUI here.
        .target(name: "SnackbarCore"),

        // UIKit presenter — drops a snackbar view into the active window.
        .target(
            name: "SnackbarUIKit",
            dependencies: ["SnackbarCore"]
        ),

        // SwiftUI presenter — a `.snackbarHost()` modifier + observable presenter.
        .target(
            name: "SnackbarSwiftUI",
            dependencies: ["SnackbarCore"]
        ),

        // Tests exercise the pure Core queue/model logic.
        .testTarget(
            name: "SnackbarCoreTests",
            dependencies: ["SnackbarCore"]
        ),
    ]
)
