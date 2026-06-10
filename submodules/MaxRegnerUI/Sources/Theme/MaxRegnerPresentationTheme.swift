import UIKit

// MARK: - MaxRegnerUI · Telegram PresentationTheme Integration Guide · 2029
//
// MaxRegnerUI is a pure UIKit module — it does NOT import TelegramPresentationData
// so it can be used standalone without the full Telegram dependency tree.
//
// To inject the holographic palette into Telegram's existing PresentationTheme pipeline,
// call the helpers below from within a module that DOES import TelegramPresentationData
// (e.g. TelegramUI or a custom theme submodule):
//
//   import MaxRegnerUI
//   import TelegramPresentationData
//
//   let holoTheme = customizeDefaultDarkPresentationTheme(
//       theme: defaultDarkPresentationTheme,
//       editing: false,
//       title: "MaxRegner 2029",
//       accentColor: HoloColors.plasma0,    // 0x00D4FF
//       backgroundColors: [HoloColors.void1.rgb, HoloColors.void3.rgb],
//       bubbleColors: [HoloColors.plasma2.rgb, HoloColors.void3.rgb],
//       animateBubbleColors: true,
//       wallpaper: nil,
//       baseColor: nil
//   )
//
// UIAppearance proxy — call applyMaxRegnerTheme() before any window is created:
//   MaxRegnerUI.applyMaxRegnerTheme()

// MARK: Palette export helpers for callers that do have TelegramPresentationData

public struct MaxRegnerPalette {
    // Accent
    public static let accent:          UIColor = HoloColors.plasma0   // 0x00D4FF
    public static let accentSecondary: UIColor = HoloColors.aurora0   // 0xBF5FFF
    public static let accentTernary:   UIColor = HoloColors.neon0     // 0x39FF84

    // Backgrounds
    public static let bg0: UIColor = HoloColors.void0
    public static let bg1: UIColor = HoloColors.void1
    public static let bg2: UIColor = HoloColors.void2
    public static let bg3: UIColor = HoloColors.void3

    // Bubbles (outgoing gradient top/bottom)
    public static let bubbleOutTop: UIColor = UIColor(hex: 0x003D6B)
    public static let bubbleOutBot: UIColor = UIColor(hex: 0x0A1A3A)
    public static let bubbleIn:     UIColor = UIColor(hex: 0x101828)

    // Nav / tab bar
    public static let navBg:        UIColor = UIColor(hex: 0x040A16, alpha: 0.88)
    public static let tabBg:        UIColor = UIColor(hex: 0x040A16, alpha: 0.95)
    public static let separator:    UIColor = HoloColors.plasma0.withAlphaComponent(0.18)

    // Text
    public static let textPrimary:   UIColor = HoloColors.textPrimary
    public static let textSecondary: UIColor = HoloColors.textSecondary
    public static let textDisabled:  UIColor = HoloColors.textDisabled

    // Badges / status
    public static let badge:   UIColor = HoloColors.crimson0
    public static let online:  UIColor = HoloColors.neon0
}
