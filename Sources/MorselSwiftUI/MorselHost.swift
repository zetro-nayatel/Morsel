#if canImport(SwiftUI)
import SwiftUI

/// Overlays the presenter's current morsel at the bottom of a view, with a
/// slide-up transition.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct MorselHostModifier: ViewModifier {
    @ObservedObject private var presenter: MorselPresenter

    public init(presenter: MorselPresenter) {
        self.presenter = presenter
    }

    public func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if let morsel = presenter.current {
                MorselView(morsel: morsel) {
                    presenter.dismiss()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .id(morsel.id)
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public extension View {
    /// Attach once (typically on your root view) to display morsels from the
    /// given presenter.
    ///
    /// ```swift
    /// @StateObject private var morsel = MorselPresenter()
    ///
    /// var body: some View {
    ///     ContentView()
    ///         .morselHost(morsel)
    /// }
    /// ```
    func morselHost(_ presenter: MorselPresenter) -> some View {
        modifier(MorselHostModifier(presenter: presenter))
    }
}
#endif
