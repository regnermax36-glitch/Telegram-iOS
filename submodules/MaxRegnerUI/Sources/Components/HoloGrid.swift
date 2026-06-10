import UIKit

// MARK: - MaxRegnerUI · HoloGrid · 2029
// A holographic CSS-grid-inspired layout engine that renders items as floating panels
// with staggered reveal animations, glow trails, and optional scan-line overlays.

public protocol HoloGridDataSource: AnyObject {
    func holoGrid(_ grid: HoloGridView, numberOfItems section: Int) -> Int
    func holoGrid(_ grid: HoloGridView, cellForItemAt index: Int) -> HoloGridCell
}

public protocol HoloGridDelegate: AnyObject {
    func holoGrid(_ grid: HoloGridView, didSelectItemAt index: Int)
}

// MARK: HoloGridCell — base cell class

open class HoloGridCell: UIView {
    open var accentColor: UIColor = HoloColors.plasma0
    private let card = HoloCard(variant: .solidDark)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        card.frame = bounds
        card.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(card)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var contentView: UIView { card.contentView }

    open func configure(accent: UIColor = HoloColors.plasma0) {
        self.accentColor = accent
        card.accentColor = accent
    }

    open func animateIn(delay: Double = 0) {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.92, y: 0.92)
        UIView.animate(
            withDuration: 0.55,
            delay: delay,
            usingSpringWithDamping: 0.72,
            initialSpringVelocity: 0.4,
            options: [.allowUserInteraction]
        ) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

// MARK: HoloGridView

public final class HoloGridView: UIScrollView {

    // MARK: Config
    public var columns:         Int     = 2       { didSet { setNeedsLayout() } }
    public var itemSpacing:     CGFloat = HoloSpacing.sm { didSet { setNeedsLayout() } }
    public var sectionInset:    UIEdgeInsets = UIEdgeInsets(
        top: HoloSpacing.base, left: HoloSpacing.base,
        bottom: HoloSpacing.base, right: HoloSpacing.base
    ) { didSet { setNeedsLayout() } }

    public weak var dataSource: HoloGridDataSource?
    public weak var gridDelegate: HoloGridDelegate?

    // MARK: Private
    private var cells: [HoloGridCell] = []
    private let scanOverlay = HoloShimmerLayer()

    // MARK: Init

    public init(columns: Int = 2) {
        self.columns = columns
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor         = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        scanOverlay.opacity = 0.04
        scanOverlay.startAnimating()
        layer.addSublayer(scanOverlay)
    }

    public func reloadData() {
        cells.forEach { $0.removeFromSuperview() }
        cells = []

        guard let ds = dataSource else { return }
        let count = ds.holoGrid(self, numberOfItems: 0)
        let colors: [UIColor] = [HoloColors.plasma0, HoloColors.aurora0, HoloColors.neon0, HoloColors.solar0]

        for i in 0..<count {
            let cell = ds.holoGrid(self, cellForItemAt: i)
            cell.configure(accent: colors[i % colors.count])
            addSubview(cell)
            cells.append(cell)

            let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            cell.addGestureRecognizer(tap)
            cell.tag = i
        }

        setNeedsLayout()

        // Staggered reveal
        for (i, cell) in cells.enumerated() {
            cell.animateIn(delay: Double(i) * 0.05)
        }
    }

    @objc private func cellTapped(_ g: UITapGestureRecognizer) {
        guard let view = g.view else { return }
        gridDelegate?.holoGrid(self, didSelectItemAt: view.tag)

        UIView.animate(withDuration: 0.12, animations: {
            view.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8) {
                view.transform = .identity
            }
        }
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        let inset  = sectionInset
        let cols   = max(1, columns)
        let total  = bounds.width - inset.left - inset.right
        let gap    = itemSpacing * CGFloat(cols - 1)
        let cellW  = (total - gap) / CGFloat(cols)

        var maxY: [CGFloat] = Array(repeating: inset.top, count: cols)

        for (i, cell) in cells.enumerated() {
            let col = i % cols
            let y   = maxY[col]
            // Aspect ratio 1:1.15
            let cellH = cellW * 1.15
            cell.frame = CGRect(
                x: inset.left + CGFloat(col) * (cellW + itemSpacing),
                y: y,
                width: cellW,
                height: cellH
            )
            maxY[col] += cellH + itemSpacing
        }

        let totalH = (maxY.max() ?? inset.top) + inset.bottom
        contentSize = CGSize(width: bounds.width, height: totalH)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        scanOverlay.frame = CGRect(x: 0, y: 0, width: bounds.width, height: totalH)
        CATransaction.commit()
    }
}
