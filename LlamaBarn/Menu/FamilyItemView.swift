import AppKit

/// Interactive item for catalog families.
final class FamilyItemView: StandardItemView {
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

    // Configure StandardItemView elements
    iconView.isHidden = true

    // Title
    titleLabel.font = Theme.Fonts.secondary
    titleLabel.textColor = Theme.Colors.textPrimary
    titleLabel.attributedStringValue = Format.familyItem(name: family, sizes: sizes)
    titleLabel.lineBreakMode = .byTruncatingTail

    // Link (optional, shown inline after title)
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

      // Insert link label right after title in the title's superview (the text stack)
      if let textStack = titleLabel.superview as? NSStackView {
        // Remove title, create horizontal stack with title + link, insert back
        textStack.removeArrangedSubview(titleLabel)
        titleLabel.removeFromSuperview()

        let titleRow = NSStackView(views: [titleLabel, linkLabel])
        titleRow.orientation = .horizontal
        titleRow.spacing = 6
        titleRow.alignment = .firstBaseline

        textStack.insertArrangedSubview(titleRow, at: 0)
      }
    }

    // Subtitle (Description)
    subtitleLabel.textColor = Theme.Colors.textSecondary

    // Calculate available width:
    // Menu (300) - Outer (5*2) - Inner (8*2) - Chevron (10) - Spacing (6) = ~258
    let availableWidth =
      Layout.menuWidth - (Layout.outerHorizontalPadding * 2) - (Layout.innerHorizontalPadding * 2)
      - 16
    configureSubtitle(description, width: availableWidth)

    if description != nil {
      subtitleLabel.maximumNumberOfLines = 1
      subtitleLabel.lineBreakMode = .byTruncatingTail
      subtitleLabel.cell?.truncatesLastVisibleLine = true
      subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    // Chevron
    Theme.configure(
      chevronView,
      symbol: "chevron.right",
      color: .tertiaryLabelColor,
      pointSize: 10
    )
    chevronView.isHidden = onAction == nil

    accessoryStack.addArrangedSubview(chevronView)

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
