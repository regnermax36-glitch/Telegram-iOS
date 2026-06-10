import UIKit

// MARK: - MaxRegnerUI · Chat Screen · 2029

public final class HoloChatViewController: UIViewController {

    // MARK: Config
    private let peerName: String

    // MARK: Subviews
    private let navBar       = HoloNavigationBar()
    private let tableView    = UITableView(frame: .zero, style: .plain)
    private let inputBar     = HoloChatInputBar()
    private let bgGradLayer  = HoloGradientLayer(
        colors: [UIColor(hex: 0x020810), UIColor(hex: 0x030C18)],
        style: .linear(start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
    )
    private let gridOverlay  = HoloScanGridLayer()
    private let avatarButton = HoloAvatar(size: .small, accent: HoloColors.plasma0)

    // MARK: Data
    private var messages: [HoloChatMessage] = HoloChatViewController.sampleMessages()

    // MARK: Init

    public init(peerName: String) {
        self.peerName = peerName
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        scrollToBottom()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        registerKeyboardObservers()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    // MARK: Build UI

    private func buildUI() {
        view.layer.insertSublayer(bgGradLayer, at: 0)
        view.layer.insertSublayer(gridOverlay, at: 1)

        // Nav
        navBar.title    = peerName
        navBar.subtitle = "Online · last seen just now"
        navBar.translatesAutoresizingMaskIntoConstraints = false

        let backBtn = HoloBackButton()
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navBar.leftItem = backBtn

        avatarButton.showGlowRing = true
        avatarButton.showOnline   = true
        avatarButton.initials     = String(peerName.prefix(2)).uppercased()
        navBar.rightItem = avatarButton

        view.addSubview(navBar)

        // Table
        tableView.backgroundColor  = .clear
        tableView.separatorStyle   = .none
        tableView.register(HoloChatBubbleCell.self, forCellReuseIdentifier: HoloChatBubbleCell.reuseID)
        tableView.dataSource       = self
        tableView.delegate         = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight        = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .interactive
        view.addSubview(tableView)

        // Input
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        inputBar.onSend = { [weak self] text in
            self?.sendMessage(text)
        }
        view.addSubview(inputBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputBar.topAnchor),

            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: Send

    private func sendMessage(_ text: String) {
        let msg = HoloChatMessage(text: text, isOutgoing: true, timestamp: "Now", isRead: false)
        messages.append(msg)
        let ip = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [ip], with: .none)
        scrollToBottom()
    }

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let ip = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: ip, at: .bottom, animated: true)
    }

    // MARK: Keyboard

    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardWillChange(_ n: Notification) {
        guard let info = n.userInfo,
              let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let bottom = max(0, view.bounds.height - frame.minY)
        inputBar.extraBottomInset = bottom > 0 ? bottom - view.safeAreaInsets.bottom : 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
        scrollToBottom()
    }

    // MARK: Layout

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgGradLayer.frame   = view.bounds
        gridOverlay.frame   = view.bounds
    }

    // MARK: Sample Data

    private static func sampleMessages() -> [HoloChatMessage] {
        [
            HoloChatMessage(text: "Hey! MaxRegnerUI looks incredible 🔵", isOutgoing: false, timestamp: "14:01", isRead: true),
            HoloChatMessage(text: "Thanks! 2029 holographic style 🌐", isOutgoing: true,  timestamp: "14:02", isRead: true),
            HoloChatMessage(text: "The glowing tab bar + glass bubbles are next level", isOutgoing: false, timestamp: "14:03", isRead: true),
            HoloChatMessage(text: "Yep — plasma cyan + aurora violet palette throughout", isOutgoing: true,  timestamp: "14:04", isRead: true),
            HoloChatMessage(text: "Even the scan line on the input bar is a nice touch", isOutgoing: false, timestamp: "14:05", isRead: true),
            HoloChatMessage(text: "Every layer is animated — glow pulses, shimmer sweeps ✨", isOutgoing: true, timestamp: "14:06", isRead: false),
        ]
    }
}

// MARK: - UITableViewDataSource / Delegate

extension HoloChatViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoloChatBubbleCell.reuseID, for: indexPath) as! HoloChatBubbleCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

// MARK: - HoloChatMessage model

public struct HoloChatMessage {
    public let text: String
    public let isOutgoing: Bool
    public let timestamp: String
    public var isRead: Bool
}

// MARK: - HoloChatBubbleCell

public final class HoloChatBubbleCell: UITableViewCell {

    public static let reuseID = "HoloChatBubbleCell"

    private let bubble = HoloChatBubble()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle  = .none
        contentView.addSubview(bubble)
    }

    public required init?(coder: NSCoder) { fatalError() }

    public func configure(with message: HoloChatMessage) {
        bubble.direction   = message.isOutgoing ? .outgoing : .incoming
        bubble.messageText = message.text
        bubble.timestamp   = message.timestamp
        bubble.isRead      = message.isRead
        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let maxW = contentView.bounds.width * 0.72
        let size = bubble.sizeThatFits(maxWidth: maxW)
        let pad: CGFloat = HoloSpacing.sm

        if bubble.direction == .outgoing {
            bubble.frame = CGRect(
                x: contentView.bounds.width - size.width - HoloSpacing.base,
                y: pad, width: size.width, height: size.height
            )
        } else {
            bubble.frame = CGRect(
                x: HoloSpacing.base, y: pad,
                width: size.width, height: size.height
            )
        }
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize,
        withHorizontalFittingPriority hfp: UILayoutPriority,
        verticalFittingPriority vfp: UILayoutPriority) -> CGSize {
        let maxW = targetSize.width * 0.72
        let s = bubble.sizeThatFits(maxWidth: maxW)
        return CGSize(width: targetSize.width, height: s.height + HoloSpacing.sm * 2)
    }
}

// MARK: - HoloChatInputBar

public final class HoloChatInputBar: UIView {

    public var onSend: ((String) -> Void)?
    public var extraBottomInset: CGFloat = 0 { didSet { setNeedsLayout() } }

    private let bgLayer       = CALayer()
    private let topBorder     = CALayer()
    private let textField     = HoloTextField(placeholder: "Message…", accent: HoloColors.plasma0)
    private let sendButton    = HoloButton(style: .primary)
    private let attachButton  = HoloButton(style: .icon)
    private let audioButton   = HoloButton(style: .icon)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        bgLayer.backgroundColor = HoloTheme.shared.inputBarBackground.cgColor
        layer.insertSublayer(bgLayer, at: 0)

        topBorder.backgroundColor = HoloColors.plasma0.withAlphaComponent(0.15).cgColor
        layer.addSublayer(topBorder)

        let attachImg = UIImage(systemName: "paperclip")?
            .withTintColor(HoloColors.plasma0, renderingMode: .alwaysOriginal)
        attachButton.setImage(attachImg, for: .normal)
        addSubview(attachButton)

        addSubview(textField)

        let sendImg = UIImage(systemName: "arrow.up")?
            .withTintColor(HoloColors.textInverse, renderingMode: .alwaysOriginal)
        sendButton.setImage(sendImg, for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        addSubview(sendButton)

        let micImg = UIImage(systemName: "mic.fill")?
            .withTintColor(HoloColors.plasma0, renderingMode: .alwaysOriginal)
        audioButton.setImage(micImg, for: .normal)
        addSubview(audioButton)
    }

    @objc private func sendTapped() {
        let t = textField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        onSend?(t)
        textField.text = ""
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let safeB = safeAreaInsets.bottom + extraBottomInset
        let pad: CGFloat = HoloSpacing.sm
        let h: CGFloat   = 52
        let btnS: CGFloat = 40

        let b = bounds
        bgLayer.frame    = b
        topBorder.frame  = CGRect(x: 0, y: 0, width: b.width, height: 0.5)

        let y = pad
        attachButton.frame = CGRect(x: pad, y: y + (h - btnS) / 2, width: btnS, height: btnS)
        sendButton.frame   = CGRect(x: b.width - pad - btnS, y: y + (h - btnS) / 2, width: btnS, height: btnS)
        audioButton.frame  = CGRect(x: b.width - pad * 2 - btnS * 2, y: y + (h - btnS) / 2, width: btnS, height: btnS)

        let tfX = attachButton.frame.maxX + pad
        let tfW = audioButton.frame.minX - tfX - pad
        textField.frame = CGRect(x: tfX, y: y, width: tfW, height: h)

        _ = safeB
        CATransaction.commit()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 68 + safeAreaInsets.bottom + extraBottomInset)
    }
}
