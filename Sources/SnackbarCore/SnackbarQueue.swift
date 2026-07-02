import Foundation

/// Orders snackbars so only one shows at a time; the rest wait their turn.
///
/// This type is pure, synchronous logic with **no timers and no UI**, which is
/// exactly why it's easy to unit-test. The presenters in the UIKit/SwiftUI
/// modules own the timing (auto-dismiss) and drive this queue.
public final class SnackbarQueue {
    private var pending: [Snackbar] = []

    public init() {}

    /// The snackbar that should currently be visible, if any.
    public var current: Snackbar? { pending.first }

    /// Number of snackbars waiting (including the current one).
    public var count: Int { pending.count }

    public var isEmpty: Bool { pending.isEmpty }

    /// Adds a snackbar to the back of the queue.
    /// - Returns: the snackbar that should now be visible.
    @discardableResult
    public func enqueue(_ snackbar: Snackbar) -> Snackbar? {
        pending.append(snackbar)
        return current
    }

    /// Removes the current snackbar and advances to the next.
    /// - Returns: the next snackbar to show, or `nil` if the queue is empty.
    @discardableResult
    public func dismissCurrent() -> Snackbar? {
        if !pending.isEmpty { pending.removeFirst() }
        return current
    }

    /// Removes a specific snackbar wherever it sits in the queue.
    public func remove(id: String) {
        pending.removeAll { $0.id == id }
    }

    /// Clears everything.
    public func clear() {
        pending.removeAll()
    }
}
