#if canImport(UIKit) && !os(watchOS)
import UIKit
import MorselCore

/// The UIKit morsel bar. Usually created for you by ``MorselPresenter``.
@MainActor
public final class MorselView: UIView {

    /// Called when the action button is tapped.
    public var onAction: (() -> Void)?

    public init(morsel: Morsel) {
        super.init(frame: .zero)
        configure(with: morsel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    private func configure(with morsel: Morsel) {
        backgroundColor = Self.backgroundColor(for: morsel.style)
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        let icon = UIImageView(image: UIImage(systemName: morsel.style.systemImageName))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let label = UILabel()
        label.text = morsel.message
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center

        if let action = morsel.action {
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

    static func backgroundColor(for style: MorselStyle) -> UIColor {
        switch style {
        case .info:    return .systemBlue
        case .success: return .systemGreen
        case .warning: return .systemOrange
        case .error:   return .systemRed
        }
    }
}
#endif
