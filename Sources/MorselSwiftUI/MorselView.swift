#if canImport(SwiftUI)
import SwiftUI
import MorselCore

/// The visual morsel bar for SwiftUI. You rarely use this directly —
/// `.morselHost(_:)` renders it for you.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct MorselView: View {
    private let morsel: Morsel
    private let onAction: () -> Void

    public init(morsel: Morsel, onAction: @escaping () -> Void = {}) {
        self.morsel = morsel
        self.onAction = onAction
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: morsel.style.systemImageName)
                .imageScale(.large)

            Text(morsel.message)
                .font(.subheadline.weight(.medium))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 8)

            if let action = morsel.action {
                Button(action.title) {
                    action.handler()
                    onAction()
                }
                .font(.subheadline.weight(.bold))
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
    }

    private var backgroundColor: Color {
        switch morsel.style {
        case .info:    return .blue
        case .success: return .green
        case .warning: return .orange
        case .error:   return .red
        }
    }
}
#endif
