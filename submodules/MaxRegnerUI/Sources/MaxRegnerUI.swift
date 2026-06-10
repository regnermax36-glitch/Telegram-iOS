// MARK: - MaxRegnerUI — Holographic 2029 UI Framework
// Public re-exports so consumers only need `import MaxRegnerUI`.

// Theme
@_exported import Foundation
@_exported import UIKit
@_exported import QuartzCore

// All types are public and defined in their own files.
// This file exists so the module has a well-known entry point.

/// Configures the global holographic theme.
/// Call once from the app's entry point, before any window is created.
public func applyMaxRegnerTheme() {
    let w = UIWindow.appearance()
    w.tintColor = HoloColors.plasma0

    let nav = UINavigationBar.appearance()
    nav.barStyle            = .black
    nav.isTranslucent       = true
    nav.tintColor           = HoloColors.plasma0
    nav.titleTextAttributes = [
        .foregroundColor: HoloColors.textPrimary,
        .font: HoloFonts.navTitle,
    ]
    nav.largeTitleTextAttributes = [
        .foregroundColor: HoloColors.textPrimary,
        .font: HoloFonts.heroTitle,
    ]

    let tab = UITabBar.appearance()
    tab.barStyle      = .black
    tab.isTranslucent = true
    tab.tintColor     = HoloColors.plasma0

    let tv = UITableView.appearance()
    tv.backgroundColor = .clear

    let cell = UITableViewCell.appearance()
    cell.backgroundColor = .clear

    let searchBar = UISearchBar.appearance()
    searchBar.barStyle = .black
    searchBar.tintColor = HoloColors.plasma0

    let tf = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
    tf.textColor = HoloColors.textPrimary

    let seg = UISegmentedControl.appearance()
    seg.selectedSegmentTintColor = HoloColors.plasma0
    seg.setTitleTextAttributes([.foregroundColor: HoloColors.textPrimary], for: .normal)
    seg.setTitleTextAttributes([.foregroundColor: HoloColors.textInverse], for: .selected)

    let sw = UISwitch.appearance()
    sw.onTintColor = HoloColors.plasma0
}
