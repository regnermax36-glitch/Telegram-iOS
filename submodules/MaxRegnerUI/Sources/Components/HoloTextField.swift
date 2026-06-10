import UIKit

// MARK: - MaxRegnerUI · HoloTextField · 2029

public final class HoloTextField: UIView {

    // MARK: Public
    public var placeholder: String = "" {
        didSet { textField.attributedPlaceholder = makePlaceholder(placeholder) }
    }
    public var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    public var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    public var isSecure: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    public var accentColor: UIColor = HoloColors.plasma0 {
        didSet { updateFocusState(focused: isEditing) }
    }

    public var onTextChanged: ((String) -> Void)?

    // MARK: Private
    private let bgLayer       = CALayer()
    private let borderLayer   = CAShapeLayer()
    private let glowLayer     = HoloGlowLayer()
    private let scanLine      = CALayer()
    public  let textField     = UITextField()
    private var isEditing     = false

    // MARK: Init

    public init(placeholder: String = "", accent: UIColor = HoloColors.plasma0) {
        self.accentColor = accent
        super.init(frame: .zero)
        setup()
        self.placeholder = placeholder
        textField.attributedPlaceholder = makePlaceholder(placeholder)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.addSublayer(bgLayer)
        layer.addSublayer(glowLayer)

        bgLayer.backgroundColor = HoloTheme.shared.inputFieldBackground.cgColor
        bgLayer.cornerRadius    = HoloRadius.card

        borderLayer.fillColor   = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)

        scanLine.backgroundColor = accentColor.withAlphaComponent(0.06).cgColor
        layer.addSublayer(scanLine)

        textField.font              = HoloFonts.body
        textField.textColor         = HoloColors.textPrimary
        textField.tintColor         = accentColor
        textField.backgroundColor   = .clear
        textField.borderStyle       = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        addSubview(textField)

        textField.addTarget(self, action: #selector(editingBegan),  for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingEnded),  for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        updateFocusState(focused: false)

        layer.cornerRadius  = HoloRadius.card
        clipsToBounds       = false
    }

    @objc private func editingBegan() {
        isEditing = true
        updateFocusState(focused: true)
    }

    @objc private func editingEnded() {
        isEditing = false
        updateFocusState(focused: false)
    }

    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }

    private func updateFocusState(focused: Bool) {
        let color = focused ? accentColor : HoloColors.ghost20
        UIView.animate(withDuration: 0.22) {
            self.glowLayer.opacity = focused ? 0.6 : 0
        }
        borderLayer.strokeColor = color.withAlphaComponent(focused ? 0.8 : 0.25).cgColor
        borderLayer.lineWidth   = focused ? 1.2 : 0.75
    }

    private func makePlaceholder(_ s: String) -> NSAttributedString {
        NSAttributedString(string: s, attributes: [
            .font: HoloFonts.body,
            .foregroundColor: HoloColors.ghost30,
        ])
    }

    // MARK: Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let b = bounds
        bgLayer.frame    = b
        glowLayer.frame  = b
        glowLayer.glowColor = accentColor

        let path = UIBezierPath(roundedRect: b.insetBy(dx: 0.5, dy: 0.5), cornerRadius: HoloRadius.card)
        borderLayer.path = path.cgPath

        let scanH: CGFloat = 1
        scanLine.frame = CGRect(x: 0, y: b.height / 2 - scanH / 2, width: b.width, height: scanH)

        textField.frame = b.insetBy(dx: HoloSpacing.base, dy: 0)
        CATransaction.commit()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 52)
    }
}
