// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Morsel",
    // The Core module is pure model + queue logic and builds everywhere, so
    // `swift test` runs on macOS from the command line. UIKit is iOS/tvOS only.
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
    ],
    products: [
        // Consumers take Core plus whichever UI layer matches their app.
        .library(name: "MorselCore", targets: ["MorselCore"]),
        .library(name: "MorselUIKit", targets: ["MorselUIKit"]),
        .library(name: "MorselSwiftUI", targets: ["MorselSwiftUI"]),
        // Umbrella convenience.
        .library(name: "Morsel", targets: ["MorselCore", "MorselUIKit", "MorselSwiftUI"]),
    ],
    targets: [
        // The engine: the Morsel model, styles, durations, and the queue
        // that orders multiple snackbars. No UIKit / SwiftUI here.
        .target(name: "MorselCore"),

        // UIKit presenter — drops a snackbar view into the active window.
        .target(
            name: "MorselUIKit",
            dependencies: ["MorselCore"]
        ),

        // SwiftUI presenter — a `.morselHost()` modifier + observable presenter.
        .target(
            name: "MorselSwiftUI",
            dependencies: ["MorselCore"]
        ),

        // Tests exercise the pure Core queue/model logic.
        .testTarget(
            name: "MorselCoreTests",
            dependencies: ["MorselCore"]
        ),
    ]
)
