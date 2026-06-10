import UIKit

// MARK: - MaxRegnerUI · HoloChatBubble · 2029

public enum HoloBubbleDirection { case incoming, outgoing }

public final class HoloChatBubble: UIView {

    // MARK: Config
    public var direction: HoloBubbleDirection = .outgoing { didSet { configure() } }
    public var messageText: String = "" { didSet { textLabel.text = messageText; setNeedsLayout() } }
    public var timestamp: String   = "" { didSet { timeLabel.text = timestamp } }
    public var isRead: Bool        = false { didSet { updateReadState() } }

    // MARK: Layers
    private let bgLayer       = CALayer()
    private let gradientLayer = HoloGradientLayer(colors: [])
    private let borderLayer   = CAShapeLayer()
    private let glowLayer     = HoloGlowLayer()
    private let shimmerLayer  = HoloShimmerLayer()

    // MARK: Subviews
    private let textLabel  = UILabel()
    private let timeLabel  = UILabel()
    private let readIcon   = UILabel()

    // MARK: Init

    public init(direction: HoloBubbleDirection = .outgoing) {
        self.direction = direction
        super.init(frame: .zero)
        setup()
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        configure()
    }

    private func setup() {
        layer.addSublayer(bgLayer)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(glowLayer)
        layer.addSublayer(shimmerLayer)
        layer.addSublayer(borderLayer)

        textLabel.font               = HoloFonts.body
        textLabel.textColor          = HoloColors.textPrimary
        textLabel.numberOfLines      = 0
        textLabel.lineBreakMode      = .byWordWrapping
        addSubview(textLabel)

        timeLabel.font      = HoloFonts.timestamp
        timeLabel.textColor = HoloColors.textSecondary
        addSubview(timeLabel)

        readIcon.font      = HoloFonts.timestamp
        readIcon.textColor = HoloColors.plasma0
        readIcon.text      = "✓✓"
        addSubview(readIcon)

        layer.cornerRadius  = 18
        clipsToBounds       = false
    }

    private func configure() {
        switch direction {
        case .outgoing:
            gradientLayer.colors    = HoloTheme.shared.bubbleOutgoing.map(\.cgColor)
            gradientLayer.opacity   = 1
            bgLayer.backgroundColor = UIColor.clear.cgColor
            borderLayer.strokeColor = HoloTheme.shared.bubbleBorderOut.cgColor
            glowLayer.glowColor     = HoloColors.plasma1
            glowLayer.opacity       = 0.3
            shimmerLayer.opacity    = 0.08
            shimmerLayer.startAnimating()

        case .incoming:
            gradientLayer.opacity   = 0
            bgLayer.backgroundColor = HoloTheme.shared.bubbleIncoming.cgColor
            borderLayer.strokeColor = HoloTheme.shared.bubbleBorderIn.cgColor
            glowLayer.opacity       = 0
            shimmerLayer.opacity    = 0
        }

        borderLayer.lineWidth = 0.75
        borderLayer.fillColor = UIColor.clear.cgColor
        setNeedsLayout()
    }

    private func updateReadState() {
        readIcon.textColor = isRead ? HoloColors.plasma0 : HoloColors.textDisabled
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let b = bounds
        bgLayer.frame       = b
        gradientLayer.frame = b
        glowLayer.frame     = b
        shimmerLayer.frame  = b

        bgLayer.cornerRadius        = layer.cornerRadius
        gradientLayer.cornerRadius  = layer.cornerRadius
        gradientLayer.masksToBounds = true

        let path = UIBezierPath(roundedRect: b.insetBy(dx: 0.5, dy: 0.5), cornerRadius: layer.cornerRadius)
        borderLayer.path = path.cgPath

        let pad: CGFloat = HoloSpacing.md
        let timeH: CGFloat = 16
        let timeW: CGFloat = 50
        let readW: CGFloat = 24

        textLabel.frame = CGRect(
            x: pad, y: pad,
            width: b.width - pad * 2,
            height: b.height - pad * 2 - timeH - 2
        )

        timeLabel.frame = CGRect(
            x: b.width - pad - timeW - readW - 4,
            y: b.height - pad - timeH,
            width: timeW, height: timeH
        )

        readIcon.frame = CGRect(
            x: b.width - pad - readW,
            y: b.height - pad - timeH,
            width: readW, height: timeH
        )

        if direction == .incoming {
            readIcon.isHidden = true
        }

        CATransaction.commit()
    }

    public func sizeThatFits(maxWidth: CGFloat) -> CGSize {
        let textW = maxWidth - HoloSpacing.md * 2
        let size  = textLabel.sizeThatFits(CGSize(width: textW, height: .greatestFiniteMagnitude))
        let h     = size.height + HoloSpacing.md * 2 + 18
        return CGSize(width: min(maxWidth, size.width + HoloSpacing.md * 2), height: h)
    }
}
