import AppKit

final class SettingsSegmentedView: StandardItemView {
  private let segmentedControl: NSSegmentedControl
  private let onSelect: (Int) -> Void
  private let getSelectedIndex: () -> Int
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

    configureSegmentedControl()
    setupLayout()

    accessoryStack.addArrangedSubview(segmentedControl)
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

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
    mainStack.spacing = 0

    // Add views
    mainStack.addArrangedSubview(rootStack)
    mainStack.addArrangedSubview(subtitleLabel)

    // Add mainStack to contentView
    contentView.addSubview(mainStack)
    mainStack.pinToSuperview()

    // Ensure rootStack fills the width
    rootStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true

    // Configure subtitle
    if let infoText = infoText {
      configureSubtitle(infoText, width: Layout.contentWidth)
      subtitleLabel.textColor = Theme.Colors.textSecondary
      subtitleLabel.isHidden = false
      mainStack.spacing = Layout.textLineSpacing
    } else {
      subtitleLabel.isHidden = true
    }

    // Enforce minimum height on rootStack to prevent layout shift
    // 30 (min item height) - 8 (vertical padding) = 22
    rootStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
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

  override var highlightEnabled: Bool { false }
}
