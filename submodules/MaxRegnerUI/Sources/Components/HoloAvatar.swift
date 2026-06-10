import UIKit

// MARK: - MaxRegnerUI · HoloAvatar · 2029

public enum HoloAvatarSize {
    case micro  // 28
    case small  // 40
    case medium // 52
    case large  // 72
    case hero   // 96

    public var diameter: CGFloat {
        switch self {
        case .micro:  return 28
        case .small:  return 40
        case .medium: return 52
        case .large:  return 72
        case .hero:   return 96
        }
    }
}

public final class HoloAvatar: UIView {

    // MARK: Config
    public var size: HoloAvatarSize = .medium { didSet { updateLayout() } }
    public var image: UIImage? { didSet { imageView.image = image } }
    public var initials: String = "" { didSet { initialsLabel.text = initials.prefix(2).uppercased() } }
    public var accentColor: UIColor = HoloColors.plasma0 { didSet { applyAccent() } }
    public var showOnline: Bool = false { didSet { onlineDot.isHidden = !showOnline } }
    public var showGlowRing: Bool = false { didSet { glowRing.isHidden = !showGlowRing } }

    // MARK: Subviews
    private let imageView      = UIImageView()
    private let initialsLabel  = UILabel()
    private let gradientBg     = HoloGradientLayer(colors: HoloColors.gradientHoloPrimary)
    private let glowRing       = HoloGlowLayer()
    private let ringLayer      = CAShapeLayer()
    private let onlineDot      = UIView()

    public init(size: HoloAvatarSize = .medium, accent: UIColor = HoloColors.plasma0) {
        self.size = size
        self.accentColor = accent
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.addSublayer(glowRing)
        layer.addSublayer(ringLayer)
        layer.addSublayer(gradientBg)

        imageView.contentMode   = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        initialsLabel.font          = HoloFonts.display(20, weight: .bold)
        initialsLabel.textColor     = HoloColors.textPrimary
        initialsLabel.textAlignment = .center
        addSubview(initialsLabel)

        onlineDot.backgroundColor = HoloColors.neon0
        onlineDot.layer.borderColor = HoloColors.void1.cgColor
        onlineDot.layer.borderWidth = 2
        onlineDot.isHidden = !showOnline
        addSubview(onlineDot)

        ringLayer.fillColor   = UIColor.clear.cgColor
        ringLayer.lineWidth   = 1.5
        ringLayer.strokeColor = accentColor.withAlphaComponent(0.6).cgColor

        glowRing.isHidden = !showGlowRing

        updateLayout()
    }

    private func applyAccent() {
        ringLayer.strokeColor = accentColor.withAlphaComponent(0.6).cgColor
        glowRing.glowColor    = accentColor
    }

    private func updateLayout() {
        let d = size.diameter
        let b = CGRect(x: 0, y: 0, width: d, height: d)

        layer.cornerRadius      = d / 2
        imageView.frame         = b
        imageView.layer.cornerRadius = d / 2
        initialsLabel.frame     = b
        gradientBg.frame        = b
        gradientBg.cornerRadius = d / 2
        gradientBg.masksToBounds = true
        glowRing.frame          = b.insetBy(dx: -6, dy: -6)

        let ringPath = UIBezierPath(ovalIn: b.insetBy(dx: 1, dy: 1))
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = b

        let dotD: CGFloat = 12
        onlineDot.frame = CGRect(x: d - dotD, y: d - dotD, width: dotD, height: dotD)
        onlineDot.layer.cornerRadius = dotD / 2

        invalidateIntrinsicContentSize()
    }

    public override var intrinsicContentSize: CGSize {
        let d = size.diameter
        return CGSize(width: d, height: d)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
}
