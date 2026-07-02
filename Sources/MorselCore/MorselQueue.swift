import Foundation

/// Orders morsels so only one shows at a time; the rest wait their turn.
///
/// This type is pure, synchronous logic with **no timers and no UI**, which is
/// exactly why it's easy to unit-test. The presenters in the UIKit/SwiftUI
/// modules own the timing (auto-dismiss) and drive this queue.
public final class MorselQueue {
    private var pending: [Morsel] = []

    public init() {}

    /// The morsel that should currently be visible, if any.
    public var current: Morsel? { pending.first }

    /// Number of morsels waiting (including the current one).
    public var count: Int { pending.count }

    public var isEmpty: Bool { pending.isEmpty }

    /// Adds a morsel to the back of the queue.
    /// - Returns: the morsel that should now be visible.
    @discardableResult
    public func enqueue(_ morsel: Morsel) -> Morsel? {
        pending.append(morsel)
        return current
    }

    /// Removes the current morsel and advances to the next.
    /// - Returns: the next morsel to show, or `nil` if the queue is empty.
    @discardableResult
    public func dismissCurrent() -> Morsel? {
        if !pending.isEmpty { pending.removeFirst() }
        return current
    }

    /// Removes a specific morsel wherever it sits in the queue.
    public func remove(id: String) {
        pending.removeAll { $0.id == id }
    }

    /// Clears everything.
    public func clear() {
        pending.removeAll()
    }
}
