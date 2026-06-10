import UIKit

// MARK: - MaxRegnerUI · Settings Screen · 2029

public final class HoloSettingsViewController: UIViewController {

    // MARK: Subviews
    private let navBar       = HoloNavigationBar(title: "Settings")
    private let scrollView   = UIScrollView()
    private let contentView  = UIView()
    private let bgGradLayer  = HoloGradientLayer(
        colors: HoloTheme.shared.gradientBackground,
        style: .linear(start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
    )

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Build UI

    private func buildUI() {
        view.layer.insertSublayer(bgGradLayer, at: 0)

        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        buildContent()
    }

    private func buildContent() {
        let pad: CGFloat = HoloSpacing.base
        var y: CGFloat   = pad

        // Profile card
        let profileCard = buildProfileCard()
        profileCard.frame = CGRect(x: pad, y: y, width: 0, height: 0)
        contentView.addSubview(profileCard)
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: pad),
            profileCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: pad),
            profileCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -pad),
            profileCard.heightAnchor.constraint(equalToConstant: 120),
        ])
        y += 120 + HoloSpacing.lg

        // Stat widgets row
        let statsRow = buildStatsRow()
        statsRow.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsRow)
        NSLayoutConstraint.activate([
            statsRow.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: HoloSpacing.lg),
            statsRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: pad),
            statsRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -pad),
            statsRow.heightAnchor.constraint(equalToConstant: 90),
        ])

        // Settings sections
        let sections = buildSettingsSections()
        sections.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sections)
        NSLayoutConstraint.activate([
            sections.topAnchor.constraint(equalTo: statsRow.bottomAnchor, constant: HoloSpacing.lg),
            sections.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: pad),
            sections.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -pad),
            sections.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -pad),
        ])

        _ = y
    }

    // MARK: Profile Card

    private func buildProfileCard() -> HoloCard {
        let card = HoloCard(variant: .glass)
        card.accentColor = HoloColors.plasma0

        let avatar = HoloAvatar(size: .large, accent: HoloColors.plasma0)
        avatar.initials      = "MR"
        avatar.showGlowRing  = true
        avatar.showOnline    = true
        card.contentView.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text      = "Max Regner"
        nameLabel.font      = HoloFonts.display(20, weight: .bold)
        nameLabel.textColor = HoloColors.textPrimary
        card.contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let handleLabel = UILabel()
        handleLabel.text      = "@maxregner · MaxRegnerUI 2029"
        handleLabel.font      = HoloFonts.caption(13)
        handleLabel.textColor = HoloColors.textSecondary
        card.contentView.addSubview(handleLabel)
        handleLabel.translatesAutoresizingMaskIntoConstraints = false

        let editBtn = HoloButton(style: .secondary, title: "Edit Profile")
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        card.contentView.addSubview(editBtn)

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: card.contentView.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: card.contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 72),
            avatar.heightAnchor.constraint(equalToConstant: 72),

            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: HoloSpacing.md),
            nameLabel.topAnchor.constraint(equalTo: card.contentView.topAnchor, constant: HoloSpacing.xs),

            handleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),

            editBtn.trailingAnchor.constraint(equalTo: card.contentView.trailingAnchor),
            editBtn.centerYAnchor.constraint(equalTo: card.contentView.centerYAnchor),
            editBtn.widthAnchor.constraint(equalToConstant: 110),
            editBtn.heightAnchor.constraint(equalToConstant: 36),
        ])

        return card
    }

    // MARK: Stats Row

    private func buildStatsRow() -> UIStackView {
        let items: [(String, String, UIColor)] = [
            ("2,048",  "Messages",  HoloColors.plasma0),
            ("316",    "Contacts",  HoloColors.aurora0),
            ("29",     "Groups",    HoloColors.neon0),
        ]

        let stack = UIStackView()
        stack.axis         = .horizontal
        stack.spacing      = HoloSpacing.sm
        stack.distribution = .fillEqually

        for (val, title, color) in items {
            let widget = HoloStatWidget(title: title, value: val, accent: color)
            stack.addArrangedSubview(widget)
        }

        return stack
    }

    // MARK: Settings Sections

    private func buildSettingsSections() -> UIStackView {
        let outer = UIStackView()
        outer.axis    = .vertical
        outer.spacing = HoloSpacing.lg

        let sections: [(String, [(String, String, UIColor)])] = [
            ("Account", [
                ("person.fill",          "My Profile",         HoloColors.plasma0),
                ("bell.fill",            "Notifications",      HoloColors.aurora0),
                ("lock.shield.fill",     "Privacy & Security", HoloColors.neon0),
            ]),
            ("Appearance", [
                ("paintpalette.fill",    "Theme & Colors",     HoloColors.solar0),
                ("textformat",           "Chat Font & Size",   HoloColors.plasma0),
                ("bubbles.and.sparkles", "Bubble Style",       HoloColors.aurora0),
            ]),
            ("Storage & Data", [
                ("internaldrive.fill",   "Storage",            HoloColors.neon0),
                ("network",              "Network Usage",      HoloColors.plasma0),
                ("arrow.down.circle.fill","Auto-Download",     HoloColors.solar0),
            ]),
            ("Advanced", [
                ("wrench.and.screwdriver.fill","Developer Mode", HoloColors.crimson0),
                ("questionmark.circle.fill",   "Help & Support", HoloColors.plasma0),
            ]),
        ]

        for (sectionTitle, rows) in sections {
            let section = buildSection(title: sectionTitle, rows: rows)
            outer.addArrangedSubview(section)
        }

        return outer
    }

    private func buildSection(title: String, rows: [(String, String, UIColor)]) -> UIView {
        let container = UIView()

        let header = UILabel()
        header.text      = title.uppercased()
        header.font      = HoloFonts.sectionHeader
        header.textColor = HoloColors.textSecondary
        container.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false

        let card = HoloCard(variant: .solidDark)
        container.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false

        let rowStack = UIStackView()
        rowStack.axis    = .vertical
        rowStack.spacing = 0
        card.contentView.addSubview(rowStack)
        rowStack.translatesAutoresizingMaskIntoConstraints = false

        for (i, (icon, label, accent)) in rows.enumerated() {
            let row = buildSettingsRow(icon: icon, label: label, accent: accent)
            rowStack.addArrangedSubview(row)

            if i < rows.count - 1 {
                let sep = UIView()
                sep.backgroundColor = HoloColors.ghost10
                sep.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                rowStack.addArrangedSubview(sep)
            }
        }

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),

            card.topAnchor.constraint(equalTo: header.bottomAnchor, constant: HoloSpacing.xs),
            card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            rowStack.topAnchor.constraint(equalTo: card.contentView.topAnchor),
            rowStack.leadingAnchor.constraint(equalTo: card.contentView.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: card.contentView.trailingAnchor),
            rowStack.bottomAnchor.constraint(equalTo: card.contentView.bottomAnchor),
        ])

        return container
    }

    private func buildSettingsRow(icon: String, label: String, accent: UIColor) -> UIView {
        let row = UIView()
        row.heightAnchor.constraint(equalToConstant: 52).isActive = true

        let iconBg = UIView()
        iconBg.backgroundColor = accent.withAlphaComponent(0.15)
        iconBg.layer.cornerRadius = 10
        row.addSubview(iconBg)
        iconBg.translatesAutoresizingMaskIntoConstraints = false

        let iconImg = UIImageView(image: UIImage(systemName: icon)?
            .withTintColor(accent, renderingMode: .alwaysOriginal))
        iconImg.contentMode = .scaleAspectFit
        iconBg.addSubview(iconImg)
        iconImg.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text      = label
        titleLabel.font      = HoloFonts.body
        titleLabel.textColor = HoloColors.textPrimary
        row.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right")?
            .withTintColor(HoloColors.ghost30, renderingMode: .alwaysOriginal))
        chevron.contentMode = .scaleAspectFit
        row.addSubview(chevron)
        chevron.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconBg.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            iconBg.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconBg.widthAnchor.constraint(equalToConstant: 34),
            iconBg.heightAnchor.constraint(equalToConstant: 34),

            iconImg.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconImg.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconImg.widthAnchor.constraint(equalToConstant: 18),
            iconImg.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.leadingAnchor.constraint(equalTo: iconBg.trailingAnchor, constant: HoloSpacing.md),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 16),
            chevron.heightAnchor.constraint(equalToConstant: 16),
        ])

        return row
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgGradLayer.frame = view.bounds
    }
}
