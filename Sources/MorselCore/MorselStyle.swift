import Foundation

/// The semantic kind of a morsel, which drives its color and icon.
///
/// Core stays UI-free: it only names an SF Symbol (which both UIKit and SwiftUI
/// understand). Each UI layer maps the style to its own color.
public enum MorselStyle: String, CaseIterable, Sendable {
    case info
    case success
    case warning
    case error

    /// SF Symbol name shown alongside the message.
    public var systemImageName: String {
        switch self {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.octagon.fill"
        }
    }
}
