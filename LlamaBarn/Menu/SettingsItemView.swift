import AppKit

final class SettingsItemView: ItemView {
  private let titleLabel: NSTextField = {
    let label = NSTextField(labelWithString: "")
    label.font = Typography.primary
    label.textColor = Typography.secondaryColor
    return label
  }()
  private let subtitleLabel = Typography.makeSecondaryLabel()
  private let toggle = NSSwitch()
  private let onToggle: (Bool) -> Void
  private let getValue: () -> Bool

  init(
    title: String, subtitle: String? = nil, getValue: @escaping () -> Bool,
    onToggle: @escaping (Bool) -> Void
  ) {
    self.getValue = getValue
    self.onToggle = onToggle
    super.init(frame: .zero)

    titleLabel.stringValue = title
    if let subtitle = subtitle {
      subtitleLabel.stringValue = subtitle
    } else {
      subtitleLabel.isHidden = true
    }

    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize {
    let height: CGFloat = subtitleLabel.isHidden ? 30 : 44
    return NSSize(width: Layout.menuWidth, height: height)
  }

  private func setup() {
    let textStack = NSStackView(views: [titleLabel, subtitleLabel])
    textStack.orientation = .vertical
    textStack.alignment = .leading
    textStack.spacing = 2
    textStack.translatesAutoresizingMaskIntoConstraints = false

    toggle.translatesAutoresizingMaskIntoConstraints = false
    toggle.target = self
    toggle.action = #selector(toggleChanged)
    toggle.controlSize = .mini

    contentView.addSubview(textStack)
    contentView.addSubview(toggle)

    NSLayoutConstraint.activate([
      textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      textStack.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -8),

      toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])
  }

  func refresh() {
    toggle.state = getValue() ? .on : .off
  }

  @objc private func toggleChanged() {
    let isOn = toggle.state == .on
    onToggle(isOn)
  }

  override func mouseUp(with event: NSEvent) {
    toggle.performClick(nil)
  }
}
