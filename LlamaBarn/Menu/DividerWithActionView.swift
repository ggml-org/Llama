import AppKit

final class DividerWithActionView: NSView {
  private let line = NSBox()
  private let label = NSTextField(labelWithString: "")
  private let onToggle: () -> Void

  init(onToggle: @escaping () -> Void) {
    self.onToggle = onToggle
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize {
    NSSize(width: Layout.menuWidth, height: 16)
  }

  private func setup() {
    // Line
    line.boxType = .separator
    line.translatesAutoresizingMaskIntoConstraints = false
    addSubview(line)

    // Label
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 10, weight: .regular)
    label.textColor = .tertiaryLabelColor
    label.addGestureRecognizer(
      NSClickGestureRecognizer(target: self, action: #selector(labelClicked)))
    addSubview(label)

    NSLayoutConstraint.activate([
      // Label on the right
      label.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -12),
      label.centerYAnchor.constraint(equalTo: centerYAnchor),

      // Line takes remaining space
      line.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Layout.outerHorizontalPadding + Layout.innerHorizontalPadding + 1),
      line.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -4),
      line.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  @objc private func labelClicked() {
    onToggle()
    refresh()
  }

  func refresh() {
    let isShown = UserSettings.showQuantizedModels
    label.stringValue = isShown ? "hide quantized" : "show quantized"
    label.toolTip = "Compressed versions that use less memory but are slightly less accurate"
  }
}
