import UIKit

// MARK: - MaxRegnerUI · HoloCard · 2029
// A glassmorphic panel with optional edge-glow, shimmer, and accent border.

public enum HoloCardVariant {
    case glass          // frosted glass with subtle border
    case solidDark      // deep dark fill, sharp edge glow
    case gradient       // full-bleed gradient fill
    case dataPanel      // mono data readout panel with scan line
    case widget         // compact stat/widget panel
}

public final class HoloCard: UIView {

    // MARK: Config
    public var variant: HoloCardVariant = .glass {
        didSet { configureAppearance() }
    }
    public var accentColor: UIColor = HoloColors.plasma0 {
        didSet { applyAccent() }
    }

    // MARK: Layers
    private let bgLayer      = CALayer()
    private let gradLayer    = HoloGradientLayer(colors: [])
    private let borderLayer  = CAShapeLayer()
    private let glowLayer    = HoloGlowLayer()
    private let shimmerLayer = HoloShimmerLayer()

    // MARK: Public content area
    public let contentView = UIView()

    // MARK: Init

    public init(variant: HoloCardVariant = .glass) {
        self.variant = variant
        super.init(frame: .zero)
        setup()
        configureAppearance()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        configureAppearance()
    }

    private func setup() {
        layer.addSublayer(bgLayer)
        layer.addSublayer(gradLayer)
        layer.addSublayer(glowLayer)
        layer.addSublayer(shimmerLayer)
        layer.addSublayer(borderLayer)

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor,   constant: HoloSpacing.base),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -HoloSpacing.base),
            contentView.topAnchor.constraint(equalTo: topAnchor,           constant: HoloSpacing.base),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor,     constant: -HoloSpacing.base),
        ])

        layer.cornerRadius  = HoloRadius.card
        layer.masksToBounds = false
        clipsToBounds       = false
    }

    private func configureAppearance() {
        switch variant {
        case .glass:
            bgLayer.backgroundColor = HoloColors.ghost10.cgColor
            gradLayer.opacity       = 0
            shimmerLayer.opacity    = 0
            borderLayer.lineWidth   = 0.75
            applyAccent()

        case .solidDark:
            bgLayer.backgroundColor = HoloTheme.shared.surfaceCard.cgColor
            gradLayer.opacity       = 0
            shimmerLayer.opacity    = 0
            borderLayer.lineWidth   = 1.0
            layer.applyHoloShadow(HoloShadow.cardElevation)
            applyAccent()

        case .gradient:
            bgLayer.backgroundColor = UIColor.clear.cgColor
            gradLayer.colors        = HoloColors.gradientHoloPrimary.map(\.cgColor)
            gradLayer.opacity       = 1
            shimmerLayer.opacity    = 0.6
            shimmerLayer.startAnimating()
            borderLayer.lineWidth   = 0
            applyAccent()

        case .dataPanel:
            bgLayer.backgroundColor = UIColor(hex: 0x020810, alpha: 0.95).cgColor
            gradLayer.opacity       = 0
            shimmerLayer.opacity    = 0.35
            shimmerLayer.startAnimating()
            borderLayer.lineWidth   = 0.5
            layer.applyHoloShadow(HoloShadow.glowCyan)
            applyAccent()

        case .widget:
            bgLayer.backgroundColor = UIColor(hex: 0x08111F, alpha: 0.92).cgColor
            gradLayer.opacity       = 0
            shimmerLayer.opacity    = 0
            borderLayer.lineWidth   = 0.75
            applyAccent()
        }

        setNeedsLayout()
    }

    private func applyAccent() {
        borderLayer.strokeColor = accentColor.withAlphaComponent(0.4).cgColor
        borderLayer.fillColor   = UIColor.clear.cgColor
        glowLayer.glowColor     = accentColor
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let b = bounds
        bgLayer.frame      = b
        gradLayer.frame    = b
        glowLayer.frame    = b
        shimmerLayer.frame = b

        bgLayer.cornerRadius   = HoloRadius.card
        gradLayer.cornerRadius = HoloRadius.card
        gradLayer.masksToBounds = true

        let path = UIBezierPath(roundedRect: b.insetBy(dx: 0.5, dy: 0.5), cornerRadius: HoloRadius.card)
        borderLayer.path = path.cgPath

        CATransaction.commit()
    }
}

// MARK: HoloStatWidget — compact data widget inside HoloCard

public final class HoloStatWidget: UIView {

    private let valueLabel  = UILabel()
    private let titleLabel  = UILabel()
    private let trendIcon   = UILabel()
    private let card        = HoloCard(variant: .widget)

    public var value: String = "—" { didSet { valueLabel.text = value } }
    public var title: String = ""  { didSet { titleLabel.text = title } }
    public var trend: String = ""  { didSet { trendIcon.text  = trend } }
    public var accentColor: UIColor = HoloColors.plasma0 {
        didSet {
            valueLabel.textColor = accentColor
            card.accentColor = accentColor
        }
    }

    public init(title: String, value: String, accent: UIColor = HoloColors.plasma0) {
        super.init(frame: .zero)
        self.title = title
        self.value = value
        self.accentColor = accent
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: leadingAnchor),
            card.trailingAnchor.constraint(equalTo: trailingAnchor),
            card.topAnchor.constraint(equalTo: topAnchor),
            card.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        valueLabel.font      = HoloFonts.dataReadout
        valueLabel.textColor = accentColor
        valueLabel.text      = value

        titleLabel.font      = HoloFonts.caption(11, weight: .medium)
        titleLabel.textColor = HoloColors.textSecondary
        titleLabel.text      = title

        trendIcon.font       = HoloFonts.label(13, weight: .bold)
        trendIcon.textColor  = HoloColors.neon0
        trendIcon.text       = trend

        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel, trendIcon])
        stack.axis      = .vertical
        stack.spacing   = HoloSpacing.xs
        stack.alignment = .leading

        card.contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: card.contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.contentView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: card.contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: card.contentView.bottomAnchor),
        ])

        card.accentColor = accentColor
    }
}
