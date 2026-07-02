#if canImport(SwiftUI)
import SwiftUI

/// Overlays the presenter's current snackbar at the bottom of a view, with a
/// slide-up transition.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct SnackbarHostModifier: ViewModifier {
    @ObservedObject private var presenter: SnackbarPresenter

    public init(presenter: SnackbarPresenter) {
        self.presenter = presenter
    }

    public func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if let snackbar = presenter.current {
                SnackbarView(snackbar: snackbar) {
                    presenter.dismiss()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .id(snackbar.id)
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public extension View {
    /// Attach once (typically on your root view) to display snackbars from the
    /// given presenter.
    ///
    /// ```swift
    /// @StateObject private var snackbar = SnackbarPresenter()
    ///
    /// var body: some View {
    ///     ContentView()
    ///         .snackbarHost(snackbar)
    /// }
    /// ```
    func snackbarHost(_ presenter: SnackbarPresenter) -> some View {
        modifier(SnackbarHostModifier(presenter: presenter))
    }
}
#endif
