import UIKit
import QuartzCore

// MARK: - Core holographic rendering helpers used by all MaxRegnerUI components

// MARK: Gradient Layer factory

public final class HoloGradientLayer: CAGradientLayer {

    public enum Style {
        case linear(start: CGPoint = CGPoint(x: 0, y: 0), end: CGPoint = CGPoint(x: 1, y: 1))
        case radial
        case conic
    }

    public convenience init(colors: [UIColor], style: Style = .linear()) {
        self.init()
        self.colors = colors.map(\.cgColor)

        switch style {
        case .linear(let s, let e):
            self.type = .axial
            self.startPoint = s
            self.endPoint = e
        case .radial:
            self.type = .radial
            self.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.endPoint   = CGPoint(x: 1.0, y: 1.0)
        case .conic:
            self.type = .conic
            self.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.endPoint   = CGPoint(x: 1.0, y: 0.5)
        }
    }
}

// MARK: Glass / Frosted panel layer

public final class GlassPanelLayer: CALayer {

    private let gradientLayer = HoloGradientLayer(
        colors: [HoloColors.ghost14, HoloColors.ghost6],
        style: .linear(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 1))
    )
    private let borderLayer = CALayer()

    public var cornerStyle: CGFloat = HoloRadius.card {
        didSet { updateShape() }
    }

    public override init() {
        super.init()
        setupLayers()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        masksToBounds = true
        cornerRadius = cornerStyle
        addSublayer(gradientLayer)

        borderLayer.borderColor = HoloColors.ghost20.cgColor
        borderLayer.borderWidth = 0.5
        borderLayer.cornerRadius = cornerStyle
        addSublayer(borderLayer)
    }

    private func updateShape() {
        cornerRadius = cornerStyle
        borderLayer.cornerRadius = cornerStyle
    }

    public override func layoutSublayers() {
        super.layoutSublayers()
        gradientLayer.frame = bounds
        borderLayer.frame   = bounds
    }
}

// MARK: Shimmer / scan-line animation layer

public final class HoloShimmerLayer: CAGradientLayer {

    public override init() {
        super.init()
        type = .axial
        startPoint = CGPoint(x: -1, y: 0.5)
        endPoint   = CGPoint(x: 2, y: 0.5)
        colors = [
            UIColor.clear.cgColor,
            HoloColors.ghost14.cgColor,
            HoloColors.ghost30.cgColor,
            HoloColors.ghost14.cgColor,
            UIColor.clear.cgColor,
        ]
        locations = [0, 0.25, 0.5, 0.75, 1]
    }

    public required init?(coder: NSCoder) { super.init(coder: coder) }

    public func startAnimating() {
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = [-1.0, -0.75, -0.5, -0.25, 0.0]
        anim.toValue   = [ 1.0,  1.25,  1.5,  1.75, 2.0]
        anim.duration  = 2.2
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        add(anim, forKey: "shimmer")
    }
}

// MARK: Glow ring layer

public final class HoloGlowLayer: CALayer {

    public var glowColor: UIColor = HoloColors.plasma0 {
        didSet {
            shadowColor = glowColor.cgColor
            gradient.colors = [
                glowColor.withAlphaComponent(0.0).cgColor,
                glowColor.withAlphaComponent(0.5).cgColor,
                glowColor.withAlphaComponent(0.0).cgColor,
            ]
        }
    }

    private let gradient = HoloGradientLayer(
        colors: [HoloColors.plasma0.withAlphaComponent(0), HoloColors.plasma0.withAlphaComponent(0.5), HoloColors.plasma0.withAlphaComponent(0)],
        style: .radial
    )

    public override init() {
        super.init()
        shadowOffset = .zero
        shadowRadius = 18
        shadowOpacity = 0.7
        shadowColor = HoloColors.plasma0.cgColor
        addSublayer(gradient)
    }

    public required init?(coder: NSCoder) { super.init(coder: coder) }

    public override func layoutSublayers() {
        super.layoutSublayers()
        gradient.frame = bounds
    }

    public func pulse() {
        let anim = CAKeyframeAnimation(keyPath: "shadowOpacity")
        anim.values    = [0.3, 0.9, 0.3]
        anim.keyTimes  = [0, 0.5, 1]
        anim.duration  = 2.4
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        add(anim, forKey: "pulse")
    }
}

// MARK: CALayer convenience

public extension CALayer {
    func applyHoloShadow(_ config: HoloShadow.Config) {
        shadowColor   = config.color
        shadowOpacity = config.opacity
        shadowRadius  = config.radius
        shadowOffset  = config.offset
        masksToBounds = false
    }
}
