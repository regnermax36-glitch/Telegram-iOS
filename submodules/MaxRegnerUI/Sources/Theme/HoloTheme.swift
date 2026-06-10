import UIKit

// MARK: - MaxRegnerUI · Master Theme Token Map · 2029

public final class HoloTheme {

    public static let shared = HoloTheme()
    private init() {}

    // MARK: Surfaces
    public var backgroundPrimary:   UIColor = HoloColors.void1
    public var backgroundSecondary: UIColor = HoloColors.void2
    public var backgroundTertiary:  UIColor = HoloColors.void3
    public var surfaceCard:         UIColor = UIColor(hex: 0x0A1020, alpha: 0.90)
    public var surfacePanel:        UIColor = HoloColors.ghost10
    public var surfaceOverlay:      UIColor = HoloColors.shadow60

    // MARK: Borders / Separators
    public var borderPrimary:       UIColor = HoloColors.plasma0.withAlphaComponent(0.25)
    public var borderSubtle:        UIColor = HoloColors.ghost14
    public var separatorColor:      UIColor = HoloColors.ghost10

    // MARK: Interactive
    public var accentPrimary:       UIColor = HoloColors.plasma0
    public var accentSecondary:     UIColor = HoloColors.aurora0
    public var accentTernary:       UIColor = HoloColors.neon0
    public var destructive:         UIColor = HoloColors.crimson0
    public var warning:             UIColor = HoloColors.solar0

    // MARK: Text
    public var textPrimary:         UIColor = HoloColors.textPrimary
    public var textSecondary:       UIColor = HoloColors.textSecondary
    public var textDisabled:        UIColor = HoloColors.textDisabled
    public var textAccent:          UIColor = HoloColors.plasma0

    // MARK: Tab Bar
    public var tabBarBackground:    UIColor = UIColor(hex: 0x050912, alpha: 0.95)
    public var tabBarIcon:          UIColor = HoloColors.ghost30
    public var tabBarIconActive:    UIColor = HoloColors.plasma0
    public var tabBarBadge:         UIColor = HoloColors.crimson0

    // MARK: Chat Bubbles
    public var bubbleOutgoing:      [UIColor] = [UIColor(hex: 0x003D6B), UIColor(hex: 0x0A1A3A)]
    public var bubbleIncoming:      UIColor   = UIColor(hex: 0x101828, alpha: 0.95)
    public var bubbleBorderOut:     UIColor   = HoloColors.plasma2.withAlphaComponent(0.35)
    public var bubbleBorderIn:      UIColor   = HoloColors.ghost14

    // MARK: Chat List
    public var chatRowBackground:   UIColor = .clear
    public var chatRowHighlight:    UIColor = HoloColors.ghost10
    public var unreadBadge:         UIColor = HoloColors.plasma0
    public var onlineDot:           UIColor = HoloColors.neon0

    // MARK: Input Bar
    public var inputBarBackground:  UIColor = UIColor(hex: 0x060D1A, alpha: 0.96)
    public var inputFieldBackground:UIColor = UIColor(hex: 0x0D1628, alpha: 0.90)
    public var inputFieldBorder:    UIColor = HoloColors.plasma2.withAlphaComponent(0.30)
    public var inputPlaceholder:    UIColor = HoloColors.ghost30
    public var sendButtonGradient:  [UIColor] = HoloColors.gradientCyan

    // MARK: Gradients
    public var gradientBackground:  [UIColor] = [
        UIColor(hex: 0x00060F),
        UIColor(hex: 0x020920),
        UIColor(hex: 0x04102B),
    ]
}
