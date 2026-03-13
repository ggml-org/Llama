import AppKit

/// Interactive item for catalog families.
final class FamilyItemView: ItemView {
  let family: String
  private let onAction: ((String) -> Void)?
  private let chevronView = NSImageView()
  private let linkLabel = Theme.secondaryLabel()
  private var linkUrl: URL?

  init(
    family: String,
    sizes: [(String, Bool)],
    description: String? = nil,
    linkText: String? = nil,
    linkUrl: URL? = nil,
    onAction: ((String) -> Void)? = nil
  ) {
    self.family = family
    self.onAction = onAction
    self.linkUrl = linkUrl
    super.init(frame: .zero)

    // Title label
    let titleLabel = Theme.secondaryLabel()
    titleLabel.textColor = Theme.Colors.textPrimary
    titleLabel.attributedStringValue = Format.familyItem(name: family, sizes: sizes)
    titleLabel.maximumNumberOfLines = 1
    titleLabel.lineBreakMode = .byTruncatingTail
    titleLabel.cell?.truncatesLastVisibleLine = true
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    // Build title row (title + optional link)
    let titleRow: NSView
    if let linkText = linkText, linkUrl != nil {
      let attrLink = NSAttributedString(
        string: linkText,
        attributes: [
          .foregroundColor: NSColor.linkColor,
          .font: Theme.Fonts.secondary,
        ]
      )
      linkLabel.attributedStringValue = attrLink
      linkLabel.isSelectable = false
      let linkClick = NSClickGestureRecognizer(target: self, action: #selector(openLink))
      linkLabel.addGestureRecognizer(linkClick)

      let row = NSStackView(views: [titleLabel, linkLabel])
      row.orientation = .horizontal
      row.spacing = 4
      row.alignment = .firstBaseline
      titleRow = row
    } else {
      titleRow = titleLabel
    }

    // Subtitle (description)
    let subtitleLabel = Theme.secondaryLabel()
    subtitleLabel.textColor = Theme.Colors.textSecondary

    // Text column
    let textColumn = NSStackView(views: [titleRow])
    textColumn.orientation = .vertical
    textColumn.alignment = .leading
    textColumn.spacing = Layout.textLineSpacing

    if let description {
      subtitleLabel.stringValue = description
      subtitleLabel.maximumNumberOfLines = 1
      subtitleLabel.lineBreakMode = .byTruncatingTail
      subtitleLabel.cell?.truncatesLastVisibleLine = true
      subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      textColumn.addArrangedSubview(subtitleLabel)
    }

    // Chevron
    Theme.configure(chevronView, symbol: "chevron.right", color: .tertiaryLabelColor, pointSize: 10)
    chevronView.isHidden = onAction == nil

    // Spacer
    let spacer = NSView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

    // Root stack
    let rootStack = NSStackView(views: [textColumn, spacer, chevronView])
    rootStack.orientation = .horizontal
    rootStack.alignment = .centerY
    rootStack.spacing = 6

    contentView.addSubview(rootStack)
    rootStack.pinToSuperview()

    // Accessibility
    if onAction != nil {
      setAccessibilityElement(true)
      setAccessibilityRole(.button)
      setAccessibilityLabel(family)
    }
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var highlightEnabled: Bool { onAction != nil }

  override func mouseUp(with event: NSEvent) {
    super.mouseUp(with: event)
    // Only toggle if mouse is still within bounds (allows canceling by dragging away)
    if bounds.contains(convert(event.locationInWindow, from: nil)), let onAction = onAction {
      onAction(family)
    }
  }

  @objc private func openLink() {
    if let url = linkUrl {
      NSWorkspace.shared.open(url)
    }
  }
}
