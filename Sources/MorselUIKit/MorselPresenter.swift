#if canImport(UIKit) && !os(watchOS)
import UIKit
#if !COCOAPODS
import MorselCore  // Separate module under SPM; same module under CocoaPods.
#endif

/// Shows morsels in the active window for UIKit apps.
///
/// Use the shared instance from anywhere:
/// ```swift
/// MorselPresenter.shared.show("Saved!", style: .success)
/// MorselPresenter.shared.schedule(
///     Morsel(message: "Reminder", style: .warning), after: 3
/// )
/// ```
@MainActor
public final class MorselPresenter {

    public static let shared = MorselPresenter()

    private let queue = MorselQueue()
    private var currentView: MorselView?
    private var dismissTask: Task<Void, Never>?

    public init() {}

    /// Shows a morsel now, or queues it behind one already visible.
    public func show(_ morsel: Morsel) {
        let wasIdle = (currentView == nil)
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
        animateOut(currentView) { [weak self] in
            self?.currentView = nil
            self?.queue.dismissCurrent()
            self?.presentNext()
        }
    }

    // MARK: - Presentation

    private func presentNext() {
        guard let morsel = queue.current, let window = activeWindow else { return }

        let view = MorselView(morsel: morsel)
        view.onAction = { [weak self] in self?.dismiss() }
        view.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        currentView = view

        // Slide up from below.
        window.layoutIfNeeded()
        view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height + 32)
        view.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            view.transform = .identity
            view.alpha = 1
        }

        guard let interval = morsel.duration.timeInterval else { return }
        dismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            if !Task.isCancelled { self.dismiss() }
        }
    }

    private func animateOut(_ view: MorselView?, completion: @escaping () -> Void) {
        guard let view else { completion(); return }
        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height + 32)
            view.alpha = 0
        }, completion: { _ in
            view.removeFromSuperview()
            completion()
        })
    }

    private var activeWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
#endif
