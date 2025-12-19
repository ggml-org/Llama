import AppKit

final class SettingsSegmentedView: StandardItemView {
  private let segmentedControl: NSSegmentedControl
  private let onSelect: (Int) -> Void
  private let getSelectedIndex: () -> Int
  private let infoIcon = NSImageView()
  private let infoText: String?
  private let mainStack = NSStackView()

  init(
    title: String, infoText: String? = nil, labels: [String],
    getSelectedIndex: @escaping () -> Int, onSelect: @escaping (Int) -> Void
  ) {
    self.getSelectedIndex = getSelectedIndex
    self.onSelect = onSelect
    self.infoText = infoText
    self.segmentedControl = NSSegmentedControl(
      labels: labels, trackingMode: .selectOne, target: nil, action: nil)

    super.init(frame: .zero)

    iconView.isHidden = true
    titleLabel.stringValue = title

    setupInfoView()
    configureSegmentedControl()
    setupLayout()

    accessoryStack.addArrangedSubview(segmentedControl)
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  private func setupInfoView() {
    guard infoText != nil else { return }

    Theme.configure(
      infoIcon, symbol: "info.circle", tooltip: nil,
      color: Theme.Colors.textSecondary)
    infoIcon.addGestureRecognizer(
      NSClickGestureRecognizer(target: self, action: #selector(toggleInfo)))
  }

  private func configureSegmentedControl() {
    segmentedControl.target = self
    segmentedControl.action = #selector(segmentChanged)
    segmentedControl.controlSize = .mini
    segmentedControl.font = NSFont.systemFont(ofSize: 10)
    segmentedControl.segmentDistribution = .fillEqually
    segmentedControl.appearance = NSApp.effectiveAppearance
  }

  private func setupLayout() {
    // Move rootStack (created by super) into our vertical mainStack
    rootStack.removeFromSuperview()

    // Configure mainStack
    mainStack.orientation = .vertical
    mainStack.alignment = .leading
    mainStack.spacing = 0  // Initially 0 as subtitle is hidden

    // Add views
    mainStack.addArrangedSubview(rootStack)
    mainStack.addArrangedSubview(subtitleLabel)

    // Add mainStack to contentView
    contentView.addSubview(mainStack)
    mainStack.pinToSuperview()

    // Ensure rootStack fills the width
    rootStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true

    // Configure subtitle initially
    subtitleLabel.isHidden = true

    // Enforce minimum height on rootStack to prevent layout shift when toggling info
    // 30 (min item height) - 8 (vertical padding) = 22
    rootStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
  }

  override func makeTextStack() -> NSStackView {
    if infoText != nil {
      let titleStack = NSStackView(views: [titleLabel, infoIcon])
      titleStack.orientation = .horizontal
      titleStack.spacing = 4
      titleStack.alignment = .centerY
      return titleStack
    }
    return super.makeTextStack()
  }

  override var intrinsicContentSize: NSSize {
    let width = Layout.menuWidth
    layoutSubtreeIfNeeded()
    let height = contentView.fittingSize.height + (Layout.verticalPadding * 2)
    return NSSize(width: width, height: max(30, height))
  }

  func refresh() {
    segmentedControl.selectedSegment = getSelectedIndex()
  }

  @objc private func segmentChanged() {
    onSelect(segmentedControl.selectedSegment)
  }

  @objc private func toggleInfo() {
    guard let infoText = infoText else { return }

    if subtitleLabel.isHidden {
      // Show info
      configureSubtitle(infoText, width: 274)  // 300 - 10 - 16
      subtitleLabel.textColor = Theme.Colors.textSecondary
      subtitleLabel.isHidden = false
      mainStack.spacing = Layout.textLineSpacing
    } else {
      // Hide info
      subtitleLabel.isHidden = true
      mainStack.spacing = 0
    }

    invalidateIntrinsicContentSize()
    enclosingMenuItem?.menu?.update()
  }

  override var highlightEnabled: Bool { false }
}
