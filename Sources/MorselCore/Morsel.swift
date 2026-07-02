import Foundation

/// An optional tappable action shown on the trailing edge of a morsel,
/// e.g. an "Undo" button.
public struct MorselAction {
    public let title: String
    public let handler: () -> Void

    public init(title: String, handler: @escaping () -> Void) {
        self.title = title
        self.handler = handler
    }
}

/// A single morsel to display: what it says, how it looks, how long it
/// stays, and an optional action button.
///
/// This is a plain value describing *what* to show. It knows nothing about
/// UIKit or SwiftUI — the presenters in those modules render it.
public struct Morsel: Identifiable {
    /// Stable identity, used by the queue and by SwiftUI's diffing.
    public let id: String
    public var message: String
    public var style: MorselStyle
    public var duration: MorselDuration
    public var action: MorselAction?

    public init(
        id: String = UUID().uuidString,
        message: String,
        style: MorselStyle = .info,
        duration: MorselDuration = .short,
        action: MorselAction? = nil
    ) {
        self.id = id
        self.message = message
        self.style = style
        self.duration = duration
        self.action = action
    }

    /// The current package version.
    public static let packageVersion = "0.1.0"
}

extension Morsel: Equatable {
    /// Morsels are compared by identity (the action closure isn't comparable).
    public static func == (lhs: Morsel, rhs: Morsel) -> Bool {
        lhs.id == rhs.id
    }
}
