import UIKit

// MARK: - MaxRegnerUI · HoloChatListRow · 2029

public struct HoloChatRowModel {
    public let id: String
    public let name: String
    public let lastMessage: String
    public let timestamp: String
    public let avatar: UIImage?
    public let unreadCount: Int
    public let isOnline: Bool
    public let isPinned: Bool
    public let isVerified: Bool

    public init(
        id: String, name: String, lastMessage: String, timestamp: String,
        avatar: UIImage? = nil, unreadCount: Int = 0, isOnline: Bool = false,
        isPinned: Bool = false, isVerified: Bool = false
    ) {
        self.id          = id
        self.name        = name
        self.lastMessage = lastMessage
        self.timestamp   = timestamp
        self.avatar      = avatar
        self.unreadCount = unreadCount
        self.isOnline    = isOnline
        self.isPinned    = isPinned
        self.isVerified  = isVerified
    }
}

public final class HoloChatListRow: UITableViewCell {

    public static let reuseID = "HoloChatListRow"

    // MARK: Subviews
    private let avatarView    = HoloAvatar(size: .medium)
    private let nameLabel     = UILabel()
    private let messageLabel  = UILabel()
    private let timeLabel     = UILabel()
    private let badgeView     = HoloPill(style: .badge)
    private let pinnedIcon    = UILabel()
    private let verifiedIcon  = UILabel()
    private let highlightLayer = CALayer()
    private let separatorLine  = CALayer()

    // MARK: Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor         = .clear
        contentView.backgroundColor = .clear
        selectionStyle          = .none

        highlightLayer.backgroundColor = HoloColors.ghost10.cgColor
        highlightLayer.opacity         = 0
        highlightLayer.cornerRadius    = HoloRadius.card
        contentView.layer.insertSublayer(highlightLayer, at: 0)

        separatorLine.backgroundColor = HoloColors.ghost10.cgColor
        contentView.layer.addSublayer(separatorLine)

        contentView.addSubview(avatarView)

        nameLabel.font       = HoloFonts.label(16, weight: .semibold)
        nameLabel.textColor  = HoloColors.textPrimary
        contentView.addSubview(nameLabel)

        messageLabel.font      = HoloFonts.body
        messageLabel.textColor = HoloColors.textSecondary
        messageLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(messageLabel)

        timeLabel.font      = HoloFonts.caption(12)
        timeLabel.textColor = HoloColors.textDisabled
        timeLabel.textAlignment = .right
        contentView.addSubview(timeLabel)

        pinnedIcon.font       = HoloFonts.caption(13)
        pinnedIcon.textColor  = HoloColors.plasma0
        pinnedIcon.text       = "📌"
        pinnedIcon.isHidden   = true
        contentView.addSubview(pinnedIcon)

        verifiedIcon.font     = HoloFonts.caption(13)
        verifiedIcon.textColor = HoloColors.plasma0
        verifiedIcon.text     = "⬡"
        verifiedIcon.isHidden = true
        contentView.addSubview(verifiedIcon)

        contentView.addSubview(badgeView)
    }

    public func configure(with model: HoloChatRowModel) {
        avatarView.image     = model.avatar
        avatarView.initials  = String(model.name.prefix(2)).uppercased()
        avatarView.showOnline = model.isOnline

        // Accent color cycles through palette by hash
        let colors: [UIColor] = [HoloColors.plasma0, HoloColors.aurora0, HoloColors.neon0, HoloColors.solar0]
        let accent = colors[abs(model.id.hashValue) % colors.count]
        avatarView.accentColor = accent

        nameLabel.text   = model.name
        messageLabel.text = model.lastMessage
        timeLabel.text   = model.timestamp

        badgeView.text    = model.unreadCount > 0 ? "\(model.unreadCount)" : ""
        badgeView.isHidden = model.unreadCount == 0
        badgeView.pillStyle = model.unreadCount > 0 ? .badge : .ghost

        pinnedIcon.isHidden  = !model.isPinned
        verifiedIcon.isHidden = !model.isVerified

        if model.unreadCount > 0 {
            nameLabel.textColor = HoloColors.textPrimary
        } else {
            nameLabel.textColor = HoloColors.textSecondary
        }

        setNeedsLayout()
    }

    // MARK: Highlight

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.15) {
            self.highlightLayer.opacity = highlighted ? 1 : 0
        }
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let b   = contentView.bounds
        let pad = HoloSpacing.base
        let avD: CGFloat = 52
        let avY = (b.height - avD) / 2

        avatarView.frame = CGRect(x: pad, y: avY, width: avD, height: avD)

        let textX     = pad + avD + HoloSpacing.md
        let timeW: CGFloat = 56
        let textRight = b.width - pad - timeW - HoloSpacing.sm
        let textW     = textRight - textX

        nameLabel.frame   = CGRect(x: textX, y: 14, width: textW, height: 20)
        messageLabel.frame = CGRect(x: textX, y: 14 + 22, width: textW, height: 18)

        timeLabel.frame   = CGRect(x: b.width - pad - timeW, y: 14, width: timeW, height: 16)

        let badgeW: CGFloat = 22
        let badgeH: CGFloat = 20
        badgeView.frame = CGRect(
            x: b.width - pad - badgeW,
            y: b.height - 14 - badgeH,
            width: badgeW, height: badgeH
        )

        pinnedIcon.frame  = CGRect(x: b.width - pad - 16, y: 14, width: 16, height: 16)
        verifiedIcon.frame = CGRect(x: textX + nameLabel.intrinsicContentSize.width + 4, y: 16, width: 14, height: 14)

        highlightLayer.frame = b.insetBy(dx: HoloSpacing.xs, dy: HoloSpacing.xxs)
        separatorLine.frame  = CGRect(x: textX, y: b.height - 0.5, width: b.width - textX, height: 0.5)

        CATransaction.commit()
    }

    public override class var requiresConstraintBasedLayout: Bool { false }
}
