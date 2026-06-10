import UIKit

// MARK: - MaxRegnerUI · HoloButton · 2029

public enum HoloButtonStyle {
    case primary            // filled cyan gradient + glow
    case secondary          // glass panel + cyan border
    case ghost              // transparent + faint border
    case destructive        // crimson gradient
    case neon               // electric green gradient
    case aurora             // violet gradient
    case pill               // fully rounded primary
    case icon               // square icon button, no label
}

public final class HoloButton: UIButton {

    // MARK: Config
    public var buttonStyle: HoloButtonStyle = .primary {
        didSet { configureAppearance() }
    }

    public var holoTitle: String = "" {
        didSet { updateTitle() }
    }

    public var isLoading: Bool = false {
        didSet { updateLoadingState() }
    }

    // MARK: Private layers
    private let gradientLayer    = HoloGradientLayer(colors: [], style: .linear(start: .init(x: 0, y: 0), end: .init(x: 1, y: 1)))
    private let glassLayer       = GlassPanelLayer()
    private let glowLayer        = HoloGlowLayer()
    private let shimmerLayer     = HoloShimmerLayer()
    private let borderLayer      = CALayer()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: Init

    public init(style: HoloButtonStyle = .primary, title: String = "") {
        self.buttonStyle = style
        self.holoTitle   = title
        super.init(frame: .zero)
        setupBase()
        configureAppearance()
        updateTitle()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBase()
        configureAppearance()
    }

    // MARK: Setup

    private func setupBase() {
        clipsToBounds = false
        layer.masksToBounds = false

        layer.insertSublayer(glowLayer, at: 0)
        layer.insertSublayer(glassLayer, at: 1)
        layer.insertSublayer(gradientLayer, at: 2)
        layer.insertSublayer(shimmerLayer, at: 3)

        borderLayer.borderWidth = 1.0
        layer.addSublayer(borderLayer)

        titleLabel?.font = HoloFonts.buttonLabel
        titleLabel?.adjustsFontSizeToFitWidth = true

        activityIndicator.color = HoloColors.textPrimary
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)

        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp),   for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private func configureAppearance() {
        switch buttonStyle {
        case .primary:
            gradientLayer.colors  = HoloColors.gradientCyan.map(\.cgColor)
            gradientLayer.opacity = 1
            glassLayer.opacity    = 0
            borderLayer.borderColor = UIColor.clear.cgColor
            setTitleColor(HoloColors.textInverse, for: .normal)
            layer.cornerRadius    = HoloRadius.card
            glowLayer.glowColor   = HoloColors.plasma0
            glowLayer.pulse()
            shimmerLayer.startAnimating()

        case .secondary:
            gradientLayer.colors  = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            gradientLayer.opacity = 0
            glassLayer.opacity    = 1
            glassLayer.cornerStyle = HoloRadius.card
            borderLayer.borderColor = HoloColors.plasma0.withAlphaComponent(0.6).cgColor
            setTitleColor(HoloColors.plasma0, for: .normal)
            layer.cornerRadius    = HoloRadius.card
            glowLayer.glowColor   = HoloColors.plasma0

        case .ghost:
            gradientLayer.opacity = 0
            glassLayer.opacity    = 0
            borderLayer.borderColor = HoloColors.ghost20.cgColor
            setTitleColor(HoloColors.textPrimary, for: .normal)
            layer.cornerRadius    = HoloRadius.card

        case .destructive:
            gradientLayer.colors  = HoloColors.gradientNeon.map(\.cgColor)
            gradientLayer.colors  = [HoloColors.crimson0.cgColor, HoloColors.crimson1.cgColor]
            gradientLayer.opacity = 1
            glassLayer.opacity    = 0
            borderLayer.borderColor = UIColor.clear.cgColor
            setTitleColor(HoloColors.textPrimary, for: .normal)
            layer.cornerRadius    = HoloRadius.card
            glowLayer.glowColor   = HoloColors.crimson0

        case .neon:
            gradientLayer.colors  = HoloColors.gradientNeon.map(\.cgColor)
            gradientLayer.opacity = 1
            glassLayer.opacity    = 0
            borderLayer.borderColor = UIColor.clear.cgColor
            setTitleColor(HoloColors.textInverse, for: .normal)
            layer.cornerRadius    = HoloRadius.card
            glowLayer.glowColor   = HoloColors.neon0
            glowLayer.pulse()

        case .aurora:
            gradientLayer.colors  = HoloColors.gradientAurora.map(\.cgColor)
            gradientLayer.opacity = 1
            glassLayer.opacity    = 0
            borderLayer.borderColor = UIColor.clear.cgColor
            setTitleColor(HoloColors.textPrimary, for: .normal)
            layer.cornerRadius    = HoloRadius.card
            glowLayer.glowColor   = HoloColors.aurora0
            glowLayer.pulse()

        case .pill:
            gradientLayer.colors  = HoloColors.gradientCyan.map(\.cgColor)
            gradientLayer.opacity = 1
            glassLayer.opacity    = 0
            borderLayer.borderColor = UIColor.clear.cgColor
            setTitleColor(HoloColors.textInverse, for: .normal)
            layer.cornerRadius    = HoloRadius.pill
            glowLayer.glowColor   = HoloColors.plasma0

        case .icon:
            gradientLayer.opacity = 0
            glassLayer.opacity    = 1
            glassLayer.cornerStyle = HoloRadius.chip
            borderLayer.borderColor = HoloColors.ghost20.cgColor
            setTitleColor(.clear, for: .normal)
            layer.cornerRadius    = HoloRadius.chip
        }

        setNeedsLayout()
    }

    private func updateTitle() {
        var config = configuration ?? UIButton.Configuration.plain()
        config.title = holoTitle
        configuration = nil
        setTitle(holoTitle, for: .normal)
    }

    private func updateLoadingState() {
        if isLoading {
            activityIndicator.startAnimating()
            setTitle(nil, for: .normal)
            isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            updateTitle()
            isUserInteractionEnabled = true
        }
    }

    // MARK: Touch feedback

    @objc private func handleTouchDown() {
        UIView.animate(withDuration: 0.10, delay: 0, options: .curveEaseIn) {
            self.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            self.glowLayer.opacity = 0.3
        }
    }

    @objc private func handleTouchUp() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8) {
            self.transform = .identity
            self.glowLayer.opacity = 1
        }
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let b = bounds
        gradientLayer.frame = b
        glassLayer.frame    = b
        glowLayer.frame     = b
        shimmerLayer.frame  = b
        borderLayer.frame   = b

        gradientLayer.cornerRadius = layer.cornerRadius
        borderLayer.cornerRadius   = layer.cornerRadius
        gradientLayer.masksToBounds = true

        activityIndicator.center = CGPoint(x: b.midX, y: b.midY)
        CATransaction.commit()
    }

    public override var intrinsicContentSize: CGSize {
        switch buttonStyle {
        case .icon:
            return CGSize(width: 44, height: 44)
        case .pill:
            let base = super.intrinsicContentSize
            return CGSize(width: base.width + HoloSpacing.xl * 2, height: 44)
        default:
            let base = super.intrinsicContentSize
            return CGSize(width: max(120, base.width + HoloSpacing.xl * 2), height: 52)
        }
    }
}
