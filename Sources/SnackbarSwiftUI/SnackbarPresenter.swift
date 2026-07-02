#if canImport(SwiftUI)
import SwiftUI
import SnackbarCore

/// Drives snackbar presentation for SwiftUI.
///
/// Create one, put it in the environment (or hold it in your root view), attach
/// `.snackbarHost(presenter)`, then call `show(...)` / `schedule(...)` from
/// anywhere. It owns the queue and the auto-dismiss timing.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
@MainActor
public final class SnackbarPresenter: ObservableObject {

    /// The snackbar currently on screen (drives the view). `nil` when none.
    @Published public private(set) var current: Snackbar?

    private let queue = SnackbarQueue()
    private var dismissTask: Task<Void, Never>?

    public init() {}

    /// Shows a snackbar now, or queues it behind one already visible.
    public func show(_ snackbar: Snackbar) {
        let wasIdle = (current == nil)
        queue.enqueue(snackbar)
        if wasIdle { presentNext() }
    }

    /// Convenience overload that builds the `Snackbar` for you.
    public func show(
        _ message: String,
        style: SnackbarStyle = .info,
        duration: SnackbarDuration = .short,
        action: SnackbarAction? = nil
    ) {
        show(Snackbar(message: message, style: style, duration: duration, action: action))
    }

    /// Shows a snackbar after `delay` seconds. See SCHEDULING.md.
    public func schedule(_ snackbar: Snackbar, after delay: TimeInterval) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            self.show(snackbar)
        }
    }

    /// Dismisses the current snackbar and advances to the next queued one.
    public func dismiss() {
        dismissTask?.cancel()
        queue.dismissCurrent()
        presentNext()
    }

    private func presentNext() {
        dismissTask?.cancel()
        let next = queue.current
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            current = next
        }
        guard let next, let interval = next.duration.timeInterval else { return }
        dismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            if !Task.isCancelled { self.dismiss() }
        }
    }
}
#endif
