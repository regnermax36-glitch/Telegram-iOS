import UIKit

// MARK: - MaxRegnerUI · Root View Controller · 2029
// Drop-in replacement for TelegramRootController's tab setup.
// Hosts HoloTabBar + child view controllers in a custom container.

public final class HoloRootViewController: UIViewController {

    // MARK: Children
    private let chatsVC    = UINavigationController(rootViewController: HoloChatListViewController())
    private let contactsVC = HoloContactsViewController()
    private let callsVC    = HoloCallsViewController()
    private let settingsVC = UINavigationController(rootViewController: HoloSettingsViewController())

    // MARK: Tab Bar
    private let tabBar: HoloTabBar = {
        let items: [HoloTabBarItem] = [
            HoloTabBarItem(icon: UIImage(systemName: "message.fill"),        label: "Chats",    accent: HoloColors.plasma0),
            HoloTabBarItem(icon: UIImage(systemName: "person.2.fill"),       label: "Contacts", accent: HoloColors.aurora0),
            HoloTabBarItem(icon: UIImage(systemName: "phone.fill"),          label: "Calls",    accent: HoloColors.neon0),
            HoloTabBarItem(icon: UIImage(systemName: "gearshape.fill"),      label: "Settings", accent: HoloColors.solar0),
        ]
        return HoloTabBar(items: items)
    }()

    // MARK: State
    private var currentIndex: Int = 0
    private var viewControllers: [UIViewController] = []

    // MARK: Layers
    private let bgGradLayer = HoloGradientLayer(
        colors: HoloTheme.shared.gradientBackground,
        style: .linear(start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
    )

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(bgGradLayer, at: 0)

        viewControllers = [chatsVC, contactsVC, callsVC, settingsVC]
        viewControllers.forEach { addChild($0); $0.didMove(toParent: self) }

        setupTabBar()
        showChild(at: 0)
    }

    private func setupTabBar() {
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func showChild(at index: Int) {
        let prev = viewControllers[currentIndex]
        let next = viewControllers[index]

        guard prev != next else { return }

        prev.view.isHidden = true
        next.view.isHidden = false

        if next.view.superview == nil {
            view.insertSubview(next.view, belowSubview: tabBar)
            next.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                next.view.topAnchor.constraint(equalTo: view.topAnchor),
                next.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                next.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                next.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            ])
        }

        next.view.alpha = 0
        UIView.animate(withDuration: 0.22) { next.view.alpha = 1 }

        currentIndex = index
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgGradLayer.frame = view.bounds

        // Ensure initial child is visible
        let vc = viewControllers[currentIndex]
        if vc.view.superview == nil {
            view.insertSubview(vc.view, belowSubview: tabBar)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vc.view.topAnchor.constraint(equalTo: view.topAnchor),
                vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                vc.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            ])
        }
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}

// MARK: HoloTabBarDelegate

extension HoloRootViewController: HoloTabBarDelegate {
    public func holoTabBar(_ bar: HoloTabBar, didSelect index: Int) {
        showChild(at: index)
    }
}

// MARK: - Placeholder screens for Contacts & Calls

public final class HoloContactsViewController: UIViewController {
    private let navBar = HoloNavigationBar(title: "Contacts")

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HoloTheme.shared.backgroundPrimary
        view.layer.insertSublayer(
            HoloGradientLayer(colors: HoloTheme.shared.gradientBackground,
                              style: .linear(start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))),
            at: 0
        )
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        let grid = HoloGridView(columns: 2)
        grid.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(grid)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grid.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: HoloSpacing.sm),
            grid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grid.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        grid.dataSource = self
        grid.reloadData()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}

extension HoloContactsViewController: HoloGridDataSource {
    public func holoGrid(_ grid: HoloGridView, numberOfItems section: Int) -> Int { 12 }
    public func holoGrid(_ grid: HoloGridView, cellForItemAt index: Int) -> HoloGridCell {
        let cell     = HoloGridCell(frame: .zero)
        let av       = HoloAvatar(size: .large)
        let names    = ["Max R", "Alice N", "Jax H", "Zara F", "Cipher", "Nova X",
                        "Orion", "Lyra", "Vex", "Storm", "Aura", "Flux"]
        let initials = names[index % names.count].prefix(2).uppercased()
        av.initials = String(initials)
        let lbl = UILabel()
        lbl.text      = names[index % names.count]
        lbl.font      = HoloFonts.label(13, weight: .semibold)
        lbl.textColor = HoloColors.textPrimary
        lbl.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [av, lbl])
        stack.axis      = .vertical
        stack.alignment = .center
        stack.spacing   = HoloSpacing.xs
        cell.contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
        ])
        return cell
    }
}

public final class HoloCallsViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HoloTheme.shared.backgroundPrimary
        let navBar = HoloNavigationBar(title: "Calls")
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let label = UILabel()
        label.text      = "Recent Calls"
        label.font      = HoloFonts.display(22, weight: .light)
        label.textColor = HoloColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}
