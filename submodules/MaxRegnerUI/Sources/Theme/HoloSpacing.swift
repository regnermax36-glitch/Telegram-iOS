import CoreGraphics

// MARK: - MaxRegnerUI · Spacing & Layout Tokens · 2029

public enum HoloSpacing {
    public static let xxs:  CGFloat = 2
    public static let xs:   CGFloat = 4
    public static let sm:   CGFloat = 8
    public static let md:   CGFloat = 12
    public static let base: CGFloat = 16
    public static let lg:   CGFloat = 20
    public static let xl:   CGFloat = 24
    public static let xxl:  CGFloat = 32
    public static let xxxl: CGFloat = 48
    public static let hero: CGFloat = 64
}

public enum HoloRadius {
    public static let chip:    CGFloat = 6
    public static let card:    CGFloat = 18
    public static let panel:   CGFloat = 24
    public static let modal:   CGFloat = 32
    public static let pill:    CGFloat = 999  // fully-rounded
}

public enum HoloShadow {
    /// Returns an array of shadow parameters suitable for application via CALayer
    public struct Config {
        public let color: CGColor
        public let opacity: Float
        public let radius: CGFloat
        public let offset: CGSize

        public init(color: CGColor, opacity: Float, radius: CGFloat, offset: CGSize) {
            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }
    }

    public static let glowCyan = Config(
        color: HoloColors.plasma0.cgColor,
        opacity: 0.55,
        radius: 18,
        offset: .zero
    )
    public static let glowAurora = Config(
        color: HoloColors.aurora0.cgColor,
        opacity: 0.45,
        radius: 16,
        offset: .zero
    )
    public static let glowNeon = Config(
        color: HoloColors.neon0.cgColor,
        opacity: 0.50,
        radius: 14,
        offset: .zero
    )
    public static let cardElevation = Config(
        color: HoloColors.void0.cgColor,
        opacity: 0.60,
        radius: 24,
        offset: CGSize(width: 0, height: 8)
    )
}
