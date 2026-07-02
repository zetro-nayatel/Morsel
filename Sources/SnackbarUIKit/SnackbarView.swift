#if canImport(UIKit) && !os(watchOS)
import UIKit
import SnackbarCore

/// The UIKit snackbar bar. Usually created for you by ``SnackbarPresenter``.
@MainActor
public final class SnackbarView: UIView {

    /// Called when the action button is tapped.
    public var onAction: (() -> Void)?

    public init(snackbar: Snackbar) {
        super.init(frame: .zero)
        configure(with: snackbar)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    private func configure(with snackbar: Snackbar) {
        backgroundColor = Self.backgroundColor(for: snackbar.style)
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        let icon = UIImageView(image: UIImage(systemName: snackbar.style.systemImageName))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let label = UILabel()
        label.text = snackbar.message
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center

        if let action = snackbar.action {
            let button = UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.addAction(UIAction { [weak self] _ in
                action.handler()
                self?.onAction?()
            }, for: .touchUpInside)
            stack.addArrangedSubview(button)
        }

        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    static func backgroundColor(for style: SnackbarStyle) -> UIColor {
        switch style {
        case .info:    return .systemBlue
        case .success: return .systemGreen
        case .warning: return .systemOrange
        case .error:   return .systemRed
        }
    }
}
#endif
