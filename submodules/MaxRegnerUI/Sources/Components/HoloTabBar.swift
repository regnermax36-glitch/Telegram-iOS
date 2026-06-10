import UIKit

// MARK: - MaxRegnerUI · HoloTabBar · 2029

public struct HoloTabBarItem {
    public let icon: UIImage?
    public let label: String
    public let accentColor: UIColor

    public init(icon: UIImage?, label: String, accent: UIColor = HoloColors.plasma0) {
        self.icon = icon
        self.label = label
        self.accentColor = accent
    }
}

public protocol HoloTabBarDelegate: AnyObject {
    func holoTabBar(_ bar: HoloTabBar, didSelect index: Int)
}

public final class HoloTabBar: UIView {

    // MARK: Public
    public weak var delegate: HoloTabBarDelegate?
    public private(set) var selectedIndex: Int = 0

    // MARK: Private
    private var items: [HoloTabBarItem] = []
    private var itemViews: [HoloTabBarItemView] = []

    private let bgLayer      = CALayer()
    private let blurView     = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let topBorder    = CALayer()
    private let selIndicator = HoloGradientLayer(
        colors: HoloColors.gradientCyan,
        style: .linear(start: .init(x: 0, y: 0), end: .init(x: 1, y: 0))
    )

    // MARK: Init

    public init(items: [HoloTabBarItem]) {
        self.items = items
        super.init(frame: .zero)
        setup()
        buildItems()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)

        bgLayer.backgroundColor = HoloTheme.shared.tabBarBackground.cgColor
        layer.insertSublayer(bgLayer, at: 0)

        topBorder.backgroundColor = HoloColors.plasma0.withAlphaComponent(0.20).cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0.5)
        layer.addSublayer(topBorder)

        selIndicator.cornerRadius = 1.5
        layer.addSublayer(selIndicator)
    }

    private func buildItems() {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews = items.enumerated().map { idx, item in
            let v = HoloTabBarItemView(item: item, index: idx)
            v.onTap = { [weak self] i in self?.select(index: i) }
            addSubview(v)
            return v
        }
        select(index: 0)
    }

    public func select(index: Int) {
        guard index < itemViews.count else { return }
        let prev = selectedIndex
        selectedIndex = index

        itemViews[prev].setSelected(false)
        itemViews[index].setSelected(true)

        UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.layoutIndicator()
        }

        delegate?.holoTabBar(self, didSelect: index)
    }

    private func layoutIndicator() {
        guard itemViews.count > selectedIndex else { return }
        let iv = itemViews[selectedIndex]
        let w: CGFloat = 28
        let x = iv.frame.midX - w / 2
        selIndicator.frame = CGRect(x: x, y: 0, width: w, height: 2)
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        bgLayer.frame   = bounds
        topBorder.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0.5)

        guard !itemViews.isEmpty else { return }
        let itemW = bounds.width / CGFloat(itemViews.count)
        for (i, iv) in itemViews.enumerated() {
            iv.frame = CGRect(x: CGFloat(i) * itemW, y: 0, width: itemW, height: bounds.height)
        }
        layoutIndicator()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 83)
    }
}

// MARK: - HoloTabBarItemView

private final class HoloTabBarItemView: UIView {

    var onTap: ((Int) -> Void)?
    private let index: Int

    private let iconView   = UIImageView()
    private let label      = UILabel()
    private let glowLayer  = HoloGlowLayer()
    private let item: HoloTabBarItem

    init(item: HoloTabBarItem, index: Int) {
        self.item  = item
        self.index = index
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        layer.insertSublayer(glowLayer, at: 0)
        glowLayer.opacity = 0

        iconView.contentMode    = .scaleAspectFit
        iconView.tintColor      = HoloColors.tabBarIcon
        iconView.image          = item.icon?.withRenderingMode(.alwaysTemplate)
        addSubview(iconView)

        label.font          = HoloFonts.pillLabel
        label.textAlignment = .center
        label.textColor     = HoloColors.tabBarIcon
        label.text          = item.label
        addSubview(label)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc private func tapped() {
        onTap?(index)
    }

    func setSelected(_ selected: Bool) {
        let color: UIColor = selected ? item.accentColor : HoloColors.tabBarIcon
        UIView.animate(withDuration: 0.22) {
            self.iconView.tintColor = color
            self.label.textColor    = color
            self.glowLayer.opacity  = selected ? 0.6 : 0
        }

        if selected {
            glowLayer.glowColor = item.accentColor
            let bounce = CAKeyframeAnimation(keyPath: "transform.scale")
            bounce.values    = [1.0, 1.2, 0.95, 1.0]
            bounce.keyTimes  = [0, 0.3, 0.7, 1]
            bounce.duration  = 0.4
            iconView.layer.add(bounce, forKey: "selectBounce")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let b       = bounds
        let iconS: CGFloat = 24
        let labelH: CGFloat = 12
        let totalH  = iconS + 4 + labelH
        let topY    = (b.height - totalH) / 2 - 4

        iconView.frame  = CGRect(x: (b.width - iconS) / 2, y: topY, width: iconS, height: iconS)
        label.frame     = CGRect(x: 0, y: topY + iconS + 4, width: b.width, height: labelH)
        glowLayer.frame = iconView.frame.insetBy(dx: -8, dy: -8)
        glowLayer.glowColor = item.accentColor
    }
}
