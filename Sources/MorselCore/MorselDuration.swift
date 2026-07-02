import Foundation

/// How long a morsel stays on screen before it auto-dismisses.
public enum MorselDuration: Equatable, Sendable {
    /// A brief message — 2 seconds.
    case short
    /// A longer message — 3.5 seconds.
    case long
    /// A custom number of seconds.
    case seconds(TimeInterval)
    /// Stays until the user (or code) dismisses it. Use with an action button.
    case indefinite

    /// The time on screen, or `nil` when the morsel should not auto-dismiss.
    public var timeInterval: TimeInterval? {
        switch self {
        case .short:            return 2.0
        case .long:             return 3.5
        case .seconds(let s):   return s
        case .indefinite:       return nil
        }
    }
}
