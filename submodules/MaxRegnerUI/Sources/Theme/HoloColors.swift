import UIKit

// MARK: - MaxRegnerUI · Holographic Color System · 2029

public enum HoloColors {

    // MARK: Void (deep space base)
    public static let void0      = UIColor(hex: 0x00000A) // absolute dark
    public static let void1      = UIColor(hex: 0x03050F)
    public static let void2      = UIColor(hex: 0x070B1A)
    public static let void3      = UIColor(hex: 0x0C1128)

    // MARK: Plasma (primary holographic tones)
    public static let plasma0    = UIColor(hex: 0x00D4FF) // ice cyan
    public static let plasma1    = UIColor(hex: 0x00A8F3)
    public static let plasma2    = UIColor(hex: 0x0070E0)
    public static let plasma3    = UIColor(hex: 0x0040B0)

    // MARK: Aurora (secondary glow — violet/purple)
    public static let aurora0    = UIColor(hex: 0xBF5FFF)
    public static let aurora1    = UIColor(hex: 0x9B30FF)
    public static let aurora2    = UIColor(hex: 0x7000E8)
    public static let aurora3    = UIColor(hex: 0x4A00B4)

    // MARK: Neon (accent — electric lime / green)
    public static let neon0      = UIColor(hex: 0x39FF84)
    public static let neon1      = UIColor(hex: 0x00F060)
    public static let neon2      = UIColor(hex: 0x00C040)
    public static let neon3      = UIColor(hex: 0x008030)

    // MARK: Solar (warning / notification — orange/amber)
    public static let solar0     = UIColor(hex: 0xFF9A00)
    public static let solar1     = UIColor(hex: 0xFF6A00)
    public static let solar2     = UIColor(hex: 0xFF3A00)

    // MARK: Crimson (destructive)
    public static let crimson0   = UIColor(hex: 0xFF1464)
    public static let crimson1   = UIColor(hex: 0xCC0044)

    // MARK: Ghost (glass surfaces / frosted panels)
    public static let ghost6     = UIColor(white: 1.0, alpha: 0.06)
    public static let ghost10    = UIColor(white: 1.0, alpha: 0.10)
    public static let ghost14    = UIColor(white: 1.0, alpha: 0.14)
    public static let ghost20    = UIColor(white: 1.0, alpha: 0.20)
    public static let ghost30    = UIColor(white: 1.0, alpha: 0.30)
    public static let ghost50    = UIColor(white: 1.0, alpha: 0.50)

    // MARK: Shadow (dark overlays)
    public static let shadow20   = UIColor(white: 0.0, alpha: 0.20)
    public static let shadow40   = UIColor(white: 0.0, alpha: 0.40)
    public static let shadow60   = UIColor(white: 0.0, alpha: 0.60)
    public static let shadow80   = UIColor(white: 0.0, alpha: 0.80)

    // MARK: Text
    public static let textPrimary   = UIColor(white: 1.0, alpha: 0.95)
    public static let textSecondary = UIColor(white: 1.0, alpha: 0.55)
    public static let textDisabled  = UIColor(white: 1.0, alpha: 0.25)
    public static let textInverse   = UIColor(white: 0.0, alpha: 0.90)

    // MARK: Holographic gradient presets
    public static let gradientCyan   = [plasma0, plasma2]
    public static let gradientAurora = [aurora0, aurora2]
    public static let gradientNeon   = [neon0, neon2]
    public static let gradientRainbow: [UIColor] = [
        UIColor(hex: 0x00D4FF),
        UIColor(hex: 0x7B2FFF),
        UIColor(hex: 0xFF1464),
        UIColor(hex: 0xFF9A00),
        UIColor(hex: 0x39FF84),
    ]
    public static let gradientVoidDeep = [void0, void3]
    public static let gradientHoloPrimary: [UIColor] = [
        UIColor(hex: 0x00D4FF).withAlphaComponent(0.8),
        UIColor(hex: 0x7B2FFF).withAlphaComponent(0.8),
    ]
}

// MARK: - UIColor hex convenience init

public extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8)  & 0xFF) / 255.0
        let b = CGFloat(hex         & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    func lighter(by amount: CGFloat = 0.2) -> UIColor {
        return adjustBrightness(by: amount)
    }

    func darker(by amount: CGFloat = 0.2) -> UIColor {
        return adjustBrightness(by: -amount)
    }

    private func adjustBrightness(by amount: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: max(0, min(1, b + amount)), alpha: a)
    }

    func withHolographicShimmer(intensity: CGFloat = 0.15) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, bl: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &bl, alpha: &a)
        return UIColor(
            red:   min(1, r + intensity * 0.3),
            green: min(1, g + intensity * 0.6),
            blue:  min(1, bl + intensity),
            alpha: a
        )
    }
}
