import UIKit

// MARK: - MaxRegnerUI · Chat List Screen · 2029

public final class HoloChatListViewController: UIViewController {

    // MARK: Subviews
    private let navBar          = HoloNavigationBar(title: "Messages")
    private let searchField     = HoloTextField(placeholder: "Search conversations…", accent: HoloColors.plasma0)
    private let filterStack     = UIStackView()
    private let tableView       = UITableView(frame: .zero, style: .plain)
    private let bgGradLayer     = HoloGradientLayer(
        colors: HoloTheme.shared.gradientBackground,
        style: .linear(start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
    )
    private let particleLayer   = HoloParticleLayer()
    private let newChatButton   = HoloButton(style: .pill, title: "  New Chat")
    private var filterTabs: [HoloPill] = []

    // MARK: Data
    private var allRows: [HoloChatRowModel] = HoloChatListViewController.sampleData()
    private var filteredRows: [HoloChatRowModel] = []
    private var activeFilter: Int = 0

    private let filterLabels = ["All", "Unread", "Groups", "Channels", "Bots"]
    private let filterAccents: [UIColor] = [
        HoloColors.plasma0, HoloColors.aurora0, HoloColors.neon0, HoloColors.solar0, HoloColors.crimson0,
    ]

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        applyFilter(0)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Build UI

    private func buildUI() {
        view.layer.insertSublayer(bgGradLayer, at: 0)
        view.layer.insertSublayer(particleLayer, at: 1)

        // Nav bar
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        // Right button in nav
        let composeBtn = HoloButton(style: .icon)
        let img = UIImage(systemName: "square.and.pencil")?
            .withTintColor(HoloColors.plasma0, renderingMode: .alwaysOriginal)
        composeBtn.setImage(img, for: .normal)
        composeBtn.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        navBar.rightItem = composeBtn

        // Search
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.onTextChanged = { [weak self] text in
            self?.searchChanged(text)
        }
        view.addSubview(searchField)

        // Filter chips
        filterStack.axis      = .horizontal
        filterStack.spacing   = HoloSpacing.sm
        filterStack.alignment = .center
        filterStack.translatesAutoresizingMaskIntoConstraints = false

        for (i, label) in filterLabels.enumerated() {
            let pill = HoloPill(text: label, style: .ghost)
            pill.tag = i
            pill.isUserInteractionEnabled = true
            pill.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterTapped(_:))))
            filterStack.addArrangedSubview(pill)
            filterTabs.append(pill)
        }

        let filterScroll = UIScrollView()
        filterScroll.showsHorizontalScrollIndicator = false
        filterScroll.translatesAutoresizingMaskIntoConstraints = false
        filterScroll.addSubview(filterStack)
        filterStack.frame = CGRect(x: HoloSpacing.base, y: 0, width: 400, height: 36)
        filterScroll.contentSize = CGSize(width: filterStack.frame.maxX + HoloSpacing.base, height: 36)
        view.addSubview(filterScroll)

        // Table
        tableView.backgroundColor             = .clear
        tableView.separatorStyle              = .none
        tableView.register(HoloChatListRow.self, forCellReuseIdentifier: HoloChatListRow.reuseID)
        tableView.dataSource                  = self
        tableView.delegate                    = self
        tableView.rowHeight                   = 74
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset                = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        view.addSubview(tableView)

        // FAB new chat
        newChatButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newChatButton)
        newChatButton.layer.applyHoloShadow(HoloShadow.glowCyan)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            searchField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: HoloSpacing.sm),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: HoloSpacing.base),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -HoloSpacing.base),

            filterScroll.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: HoloSpacing.sm),
            filterScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScroll.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: filterScroll.bottomAnchor, constant: HoloSpacing.sm),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            newChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -HoloSpacing.base),
            newChatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -HoloSpacing.base),
            newChatButton.widthAnchor.constraint(equalToConstant: 140),
            newChatButton.heightAnchor.constraint(equalToConstant: 50),
        ])

        selectFilter(0)
    }

    // MARK: Filter

    @objc private func filterTapped(_ g: UITapGestureRecognizer) {
        guard let idx = g.view?.tag else { return }
        selectFilter(idx)
        applyFilter(idx)
    }

    private func selectFilter(_ idx: Int) {
        activeFilter = idx
        for (i, pill) in filterTabs.enumerated() {
            if i == idx {
                pill.pillStyle = .gradient(HoloColors.gradientCyan)
            } else {
                pill.pillStyle = .ghost
            }
        }
    }

    private func applyFilter(_ idx: Int) {
        switch idx {
        case 1: filteredRows = allRows.filter { $0.unreadCount > 0 }
        case 2: filteredRows = allRows.filter { $0.name.contains("Group") }
        case 3: filteredRows = allRows.filter { $0.name.contains("Channel") }
        case 4: filteredRows = allRows.filter { $0.name.contains("Bot") }
        default: filteredRows = allRows
        }
        tableView.reloadData()
    }

    private func searchChanged(_ text: String) {
        if text.isEmpty {
            applyFilter(activeFilter)
        } else {
            filteredRows = allRows.filter {
                $0.name.lowercased().contains(text.lowercased()) ||
                $0.lastMessage.lowercased().contains(text.lowercased())
            }
            tableView.reloadData()
        }
    }

    // MARK: Layout

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgGradLayer.frame    = view.bounds
        particleLayer.frame  = view.bounds
    }

    // MARK: Sample Data

    private static func sampleData() -> [HoloChatRowModel] {
        [
            HoloChatRowModel(id: "1",  name: "Max Regner",        lastMessage: "Holographic layer is live ✨",       timestamp: "Now",    unreadCount: 3,  isOnline: true,  isPinned: true,  isVerified: true),
            HoloChatRowModel(id: "2",  name: "Alice Nova",         lastMessage: "Check the new UI drop 🔵",          timestamp: "2m",     unreadCount: 1,  isOnline: true),
            HoloChatRowModel(id: "3",  name: "Dev Group",          lastMessage: "Build passed ✓",                    timestamp: "5m",     unreadCount: 12, isOnline: false),
            HoloChatRowModel(id: "4",  name: "News Channel",       lastMessage: "2029 tech recap is out",            timestamp: "11m",    unreadCount: 0,  isOnline: false),
            HoloChatRowModel(id: "5",  name: "Cipher Bot",         lastMessage: "Encryption key rotated",            timestamp: "22m",    unreadCount: 2),
            HoloChatRowModel(id: "6",  name: "Zara Flux",          lastMessage: "See you at 22:00 node time",        timestamp: "1h",     unreadCount: 0,  isOnline: true),
            HoloChatRowModel(id: "7",  name: "NeuroNet Group",     lastMessage: "Latency down to 4ms 🟢",            timestamp: "2h",     unreadCount: 5),
            HoloChatRowModel(id: "8",  name: "Orbital Channel",    lastMessage: "Satellite uplink restored",         timestamp: "3h",     unreadCount: 0),
            HoloChatRowModel(id: "9",  name: "Jax Hyper",          lastMessage: "holo grid looks sick btw",         timestamp: "6h",     unreadCount: 0,  isOnline: false),
            HoloChatRowModel(id: "10", name: "Quantum Support Bot",lastMessage: "Your ticket #2029 is resolved",    timestamp: "8h",     unreadCount: 1),
        ]
    }
}

// MARK: - UITableViewDataSource / Delegate

extension HoloChatListViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoloChatListRow.reuseID, for: indexPath) as! HoloChatListRow
        cell.configure(with: filteredRows[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let row = filteredRows[indexPath.row]
        let chat = HoloChatViewController(peerName: row.name)
        navigationController?.pushViewController(chat, animated: true)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 12)
        UIView.animate(withDuration: 0.30, delay: Double(indexPath.row) * 0.03, options: [.allowUserInteraction]) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
}
