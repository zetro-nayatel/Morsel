#if canImport(SwiftUI)
import SwiftUI
#if !COCOAPODS
import MorselCore  // Separate module under SPM; same module under CocoaPods.
#endif

/// Drives morsel presentation for SwiftUI.
///
/// Create one, put it in the environment (or hold it in your root view), attach
/// `.morselHost(presenter)`, then call `show(...)` / `schedule(...)` from
/// anywhere. It owns the queue and the auto-dismiss timing.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
@MainActor
public final class MorselPresenter: ObservableObject {

    /// The morsel currently on screen (drives the view). `nil` when none.
    @Published public private(set) var current: Morsel?

    private let queue = MorselQueue()
    private var dismissTask: Task<Void, Never>?

    public init() {}

    /// Shows a morsel now, or queues it behind one already visible.
    public func show(_ morsel: Morsel) {
        let wasIdle = (current == nil)
        queue.enqueue(morsel)
        if wasIdle { presentNext() }
    }

    /// Convenience overload that builds the `Morsel` for you.
    public func show(
        _ message: String,
        style: MorselStyle = .info,
        duration: MorselDuration = .short,
        action: MorselAction? = nil
    ) {
        show(Morsel(message: message, style: style, duration: duration, action: action))
    }

    /// Shows a morsel after `delay` seconds. See SCHEDULING.md.
    public func schedule(_ morsel: Morsel, after delay: TimeInterval) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            self.show(morsel)
        }
    }

    /// Dismisses the current morsel and advances to the next queued one.
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
