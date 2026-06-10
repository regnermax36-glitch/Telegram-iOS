import UIKit

// MARK: - MaxRegnerUI · Holographic Typography · 2029

public enum HoloFonts {

    // MARK: Display – hero text, headlines
    public static func display(_ size: CGFloat, weight: UIFont.Weight = .bold) -> UIFont {
        if let f = UIFont(name: "SF Pro Rounded", size: size) { return f }
        return .systemFont(ofSize: size, weight: weight)
    }

    // MARK: Mono – data readouts, IDs, addresses
    public static func mono(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        if let f = UIFont(name: "SF Mono", size: size) { return f }
        return .monospacedSystemFont(ofSize: size, weight: weight)
    }

    // MARK: Label – standard body / list items
    public static func label(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }

    // MARK: Caption – metadata, timestamps, secondary info
    public static func caption(_ size: CGFloat, weight: UIFont.Weight = .medium) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }

    // MARK: Semantic aliases
    public static let heroTitle      = display(34, weight: .black)
    public static let sectionHeader  = display(13, weight: .semibold)
    public static let navTitle       = display(17, weight: .bold)
    public static let bodyLarge      = label(17, weight: .regular)
    public static let body           = label(15, weight: .regular)
    public static let bodySmall      = label(13, weight: .regular)
    public static let buttonLabel    = display(16, weight: .semibold)
    public static let pillLabel      = display(12, weight: .bold)
    public static let timestamp      = mono(11, weight: .regular)
    public static let badge          = display(11, weight: .bold)
    public static let dataReadout    = mono(28, weight: .light)
}
