import UIKit

// MARK: - MaxRegnerUI · HoloPill · Badge / Tag / Filter chip · 2029

public enum HoloPillStyle {
    case solid(UIColor)      // filled
    case ghost               // transparent with border
    case gradient([UIColor]) // gradient fill
    case badge               // notification badge
}

public final class HoloPill: UIView {

    public var text: String = "" {
        didSet { label.text = text }
    }

    public var pillStyle: HoloPillStyle = .solid(HoloColors.plasma0) {
        didSet { applyStyle() }
    }

    private let label         = UILabel()
    private let gradientLayer = HoloGradientLayer(colors: [])
    private let bgLayer       = CALayer()

    public init(text: String = "", style: HoloPillStyle = .solid(HoloColors.plasma0)) {
        self.text = text
        self.pillStyle = style
        super.init(frame: .zero)
        setup()
        applyStyle()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        applyStyle()
    }

    private func setup() {
        layer.addSublayer(bgLayer)
        layer.addSublayer(gradientLayer)

        label.font          = HoloFonts.pillLabel
        label.textAlignment = .center
        label.text          = text
        addSubview(label)

        layer.cornerRadius  = HoloRadius.pill
        clipsToBounds       = true
    }

    private func applyStyle() {
        switch pillStyle {
        case .solid(let color):
            bgLayer.backgroundColor = color.withAlphaComponent(0.18).cgColor
            layer.borderColor       = color.withAlphaComponent(0.55).cgColor
            layer.borderWidth       = 0.75
            label.textColor         = color
            gradientLayer.opacity   = 0

        case .ghost:
            bgLayer.backgroundColor = UIColor.clear.cgColor
            layer.borderColor       = HoloColors.ghost30.cgColor
            layer.borderWidth       = 0.75
            label.textColor         = HoloColors.textSecondary
            gradientLayer.opacity   = 0

        case .gradient(let colors):
            bgLayer.backgroundColor = UIColor.clear.cgColor
            layer.borderWidth       = 0
            label.textColor         = HoloColors.textPrimary
            gradientLayer.colors    = colors.map(\.cgColor)
            gradientLayer.opacity   = 1

        case .badge:
            bgLayer.backgroundColor = HoloColors.crimson0.cgColor
            layer.borderWidth       = 1.5
            layer.borderColor       = HoloColors.void1.cgColor
            label.textColor         = HoloColors.textPrimary
            label.font              = HoloFonts.badge
            gradientLayer.opacity   = 0
        }
        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        bgLayer.frame      = bounds
        gradientLayer.frame = bounds
        bgLayer.cornerRadius = layer.cornerRadius
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true

        let hPad: CGFloat = HoloSpacing.sm
        label.frame = bounds.insetBy(dx: hPad, dy: 0)
        CATransaction.commit()
    }

    public override var intrinsicContentSize: CGSize {
        let s = label.intrinsicContentSize
        return CGSize(width: s.width + HoloSpacing.base * 2, height: 24)
    }
}
