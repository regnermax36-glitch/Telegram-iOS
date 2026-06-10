import UIKit

// MARK: - MaxRegnerUI · HoloNavigationBar · 2029

public final class HoloNavigationBar: UIView {

    // MARK: Public
    public var title: String = "" {
        didSet { titleLabel.text = title }
    }
    public var subtitle: String = "" {
        didSet {
            subtitleLabel.text    = subtitle
            subtitleLabel.isHidden = subtitle.isEmpty
        }
    }
    public var leftItem: UIView?  { didSet { rebuildItems() } }
    public var rightItem: UIView? { didSet { rebuildItems() } }
    public var rightItems: [UIView] = [] { didSet { rebuildItems() } }

    public var showScanLine: Bool = true { didSet { scanLine.isHidden = !showScanLine } }

    // MARK: Private
    private let bgLayer    = CALayer()
    private let blurView   = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let bottomLine = CALayer()
    private let scanLine   = HoloGradientLayer(
        colors: [UIColor.clear, HoloColors.plasma0.withAlphaComponent(0.35), UIColor.clear],
        style: .linear(start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0.5))
    )
    private let titleLabel    = UILabel()
    private let subtitleLabel = UILabel()
    private let leftStack     = UIStackView()
    private let rightStack    = UIStackView()

    // MARK: Init

    public init(title: String = "") {
        self.title = title
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)

        bgLayer.backgroundColor = UIColor(hex: 0x040A16, alpha: 0.88).cgColor
        layer.insertSublayer(bgLayer, at: 0)

        bottomLine.backgroundColor = HoloColors.plasma0.withAlphaComponent(0.18).cgColor
        layer.addSublayer(bottomLine)

        layer.addSublayer(scanLine)

        titleLabel.font          = HoloFonts.navTitle
        titleLabel.textColor     = HoloColors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.text          = title
        addSubview(titleLabel)

        subtitleLabel.font          = HoloFonts.caption(11, weight: .regular)
        subtitleLabel.textColor     = HoloColors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.isHidden      = true
        addSubview(subtitleLabel)

        leftStack.axis    = .horizontal
        leftStack.spacing = HoloSpacing.sm
        leftStack.alignment = .center
        addSubview(leftStack)

        rightStack.axis      = .horizontal
        rightStack.spacing   = HoloSpacing.sm
        rightStack.alignment = .center
        addSubview(rightStack)

        // Animate scan line sweep
        let anim = CABasicAnimation(keyPath: "position.x")
        anim.fromValue  = -bounds.width
        anim.toValue    = bounds.width * 2
        anim.duration   = 3.5
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scanLine.add(anim, forKey: "scanSweep")
    }

    private func rebuildItems() {
        leftStack.arrangedSubviews.forEach  { $0.removeFromSuperview() }
        rightStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let l = leftItem { leftStack.addArrangedSubview(l) }
        rightItems.forEach   { rightStack.addArrangedSubview($0) }
        if let r = rightItem { rightStack.addArrangedSubview(r) }
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let b = bounds
        bgLayer.frame  = b
        blurView.frame = b
        bottomLine.frame = CGRect(x: 0, y: b.height - 0.5, width: b.width, height: 0.5)
        scanLine.frame = CGRect(x: -b.width, y: b.height - 2, width: b.width, height: 1)

        let safeTop: CGFloat = safeAreaInsets.top
        let navH: CGFloat = 44
        let contentY = safeTop + (navH - 20) / 2

        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: b.midX, y: safeTop + navH / 2)
        subtitleLabel.sizeToFit()
        subtitleLabel.center = CGPoint(x: b.midX, y: titleLabel.frame.maxY + 2 + subtitleLabel.bounds.height / 2)

        leftStack.frame  = CGRect(x: HoloSpacing.base, y: safeTop, width: 120, height: navH)
        rightStack.frame = CGRect(x: b.width - 140 - HoloSpacing.base, y: safeTop, width: 140, height: navH)

        _ = contentY
        CATransaction.commit()
    }

    public override var intrinsicContentSize: CGSize {
        let safeTop = safeAreaInsets.top
        return CGSize(width: UIView.noIntrinsicMetric, height: safeTop + 44)
    }
}

// MARK: HoloBackButton convenience

public final class HoloBackButton: UIButton {

    public init() {
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let img = UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
            .withTintColor(HoloColors.plasma0, renderingMode: .alwaysOriginal)
        setImage(img, for: .normal)
        setTitle(" Back", for: .normal)
        setTitleColor(HoloColors.plasma0, for: .normal)
        titleLabel?.font = HoloFonts.label(17, weight: .regular)
        contentHorizontalAlignment = .left
    }

    public override var intrinsicContentSize: CGSize { CGSize(width: 80, height: 44) }
}
