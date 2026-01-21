import AppKit

/// Accessory type for settings items.
enum SettingsAccessory {
  case toggle(getValue: () -> Bool, onToggle: (Bool) -> Void)
  case segmented(labels: [String], getIdx: () -> Int, onSelect: (Int) -> Void)
}

/// A settings menu item with title, optional info text, and an accessory control.
/// Supports toggle switches and segmented controls.
final class SettingsItemView: ItemView {
  private let titleLabel = Theme.primaryLabel()
  private let subtitleLabel = Theme.secondaryLabel()
  private let accessory: SettingsAccessory
  private var toggle: NSSwitch?
  private var segmented: NSSegmentedControl?

  init(title: String, infoText: String? = nil, accessory: SettingsAccessory) {
    self.accessory = accessory
    super.init(frame: .zero)

    titleLabel.stringValue = title
    setupLayout(infoText: infoText)
    refresh()
  }

  /// Convenience initializer for toggle accessory.
  convenience init(
    title: String, getValue: @escaping () -> Bool, onToggle: @escaping (Bool) -> Void
  ) {
    self.init(title: title, accessory: .toggle(getValue: getValue, onToggle: onToggle))
  }

  /// Convenience initializer for segmented accessory.
  convenience init(
    title: String,
    infoText: String?,
    labels: [String],
    getSelectedIndex: @escaping () -> Int,
    onSelect: @escaping (Int) -> Void
  ) {
    self.init(
      title: title,
      infoText: infoText,
      accessory: .segmented(labels: labels, getIdx: getSelectedIndex, onSelect: onSelect)
    )
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  private func setupLayout(infoText: String?) {
    // Create accessory control
    let accessoryView: NSView
    switch accessory {
    case .toggle(_, _):
      let sw = NSSwitch()
      sw.target = self
      sw.action = #selector(toggleChanged)
      sw.controlSize = .mini
      self.toggle = sw
      accessoryView = sw

    case .segmented(let labels, _, _):
      let seg = NSSegmentedControl(
        labels: labels, trackingMode: .selectOne, target: self, action: #selector(segmentChanged))
      seg.controlSize = .mini
      seg.font = NSFont.systemFont(ofSize: 10)
      seg.segmentDistribution = .fillEqually
      seg.appearance = NSApp.effectiveAppearance
      self.segmented = seg
      accessoryView = seg
    }

    // Title row: title + spacer + accessory
    let spacer = NSView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

    let titleRow = NSStackView(views: [titleLabel, spacer, accessoryView])
    titleRow.orientation = .horizontal
    titleRow.alignment = .centerY
    titleRow.spacing = 6

    // Main stack: title row + optional subtitle
    let mainStack = NSStackView(views: [titleRow])
    mainStack.orientation = .vertical
    mainStack.alignment = .leading
    mainStack.spacing = 0

    // Configure subtitle if provided
    if let infoText {
      subtitleLabel.stringValue = infoText
      subtitleLabel.textColor = Theme.Colors.textSecondary
      subtitleLabel.cell?.wraps = true
      subtitleLabel.cell?.isScrollable = false
      subtitleLabel.usesSingleLineMode = false
      subtitleLabel.maximumNumberOfLines = 0
      subtitleLabel.lineBreakMode = .byWordWrapping
      subtitleLabel.preferredMaxLayoutWidth = Layout.contentWidth
      mainStack.addArrangedSubview(subtitleLabel)
      mainStack.spacing = Layout.textLineSpacing
    }

    contentView.addSubview(mainStack)
    mainStack.pinToSuperview()

    // Ensure title row fills width
    titleRow.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
    // Min height to prevent layout shift
    titleRow.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
  }

  override var intrinsicContentSize: NSSize {
    let width = Layout.menuWidth
    // Calculate height based on whether we have a subtitle.
    // Using a fixed height avoids multiple layout passes that cause visual jitter
    // when the menu expands (the subtitle's text wrapping can cause fittingSize
    // to return different values before layout is complete).
    let hasSubtitle = !subtitleLabel.stringValue.isEmpty
    let height: CGFloat = hasSubtitle ? 70 : 30
    return NSSize(width: width, height: height)
  }

  func refresh() {
    switch accessory {
    case .toggle(let getValue, _):
      toggle?.state = getValue() ? .on : .off
    case .segmented(_, let getIdx, _):
      segmented?.selectedSegment = getIdx()
    }
  }

  @objc private func toggleChanged() {
    if case .toggle(_, let onToggle) = accessory {
      onToggle(toggle?.state == .on)
    }
  }

  @objc private func segmentChanged() {
    if case .segmented(_, _, let onSelect) = accessory, let seg = segmented {
      onSelect(seg.selectedSegment)
    }
  }

  override func mouseUp(with event: NSEvent) {
    // Only toggle switches respond to row clicks
    if case .toggle = accessory {
      toggle?.performClick(nil)
    }
  }

  override var highlightEnabled: Bool { false }
}
