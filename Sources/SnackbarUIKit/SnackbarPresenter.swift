#if canImport(UIKit) && !os(watchOS)
import UIKit
import SnackbarCore

/// Shows snackbars in the active window for UIKit apps.
///
/// Use the shared instance from anywhere:
/// ```swift
/// SnackbarPresenter.shared.show("Saved!", style: .success)
/// SnackbarPresenter.shared.schedule(
///     Snackbar(message: "Reminder", style: .warning), after: 3
/// )
/// ```
@MainActor
public final class SnackbarPresenter {

    public static let shared = SnackbarPresenter()

    private let queue = SnackbarQueue()
    private var currentView: SnackbarView?
    private var dismissTask: Task<Void, Never>?

    public init() {}

    /// Shows a snackbar now, or queues it behind one already visible.
    public func show(_ snackbar: Snackbar) {
        let wasIdle = (currentView == nil)
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
        animateOut(currentView) { [weak self] in
            self?.currentView = nil
            self?.queue.dismissCurrent()
            self?.presentNext()
        }
    }

    // MARK: - Presentation

    private func presentNext() {
        guard let snackbar = queue.current, let window = activeWindow else { return }

        let view = SnackbarView(snackbar: snackbar)
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

        guard let interval = snackbar.duration.timeInterval else { return }
        dismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            if !Task.isCancelled { self.dismiss() }
        }
    }

    private func animateOut(_ view: SnackbarView?, completion: @escaping () -> Void) {
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
