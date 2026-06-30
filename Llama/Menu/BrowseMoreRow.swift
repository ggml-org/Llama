import AppKit

/// Trailing row under the Recommended suggestions that links to the web catalog
/// for more models — the curated picks are a starting point, and the catalog has
/// more (it's curated, not all of Hugging Face, hence "more" not "all").
///
/// Styled to match the model rows it follows, not the section headers above them:
/// flush-left gray text put it in the header gutter, where it read as a heading
/// for content that isn't there. It borrows a model row's whole grammar — a
/// leading icon in the same circular container (a globe for the web catalog),
/// two-line text (label over caption), and a trailing glyph naming the action.
/// Where a model row's trailing glyph is a download arrow, here it's
/// arrow.up.forward, signaling the click navigates away to the web.
final class BrowseMoreRow: ItemView {
  private let url: URL

  init(url: URL) {
    self.url = url
    super.init(frame: .zero)

    // Globe in the same circular container the model rows use for their logos —
    // it reads as "the web catalog" and keeps the icon column visually consistent.
    let icon = IconView()
    icon.imageView.image = NSImage(
      systemSymbolName: "globe", accessibilityDescription: "Web catalog")
    icon.inactiveTintColor = Theme.Colors.modelIconTint

    // Two-line text echoing a model row: primary name over a tertiary caption.
    let title = Theme.primaryLabel("Browse more")
    let subtitle = Theme.tertiaryLabel("Full catalog on the web")
    let textColumn = NSStackView(views: [title, subtitle])
    textColumn.orientation = .vertical
    textColumn.alignment = .leading
    textColumn.spacing = Layout.textLineSpacing

    let leading = NSStackView(views: [icon, textColumn])
    leading.orientation = .horizontal
    leading.alignment = .centerY
    leading.spacing = 6

    // Trailing action glyph, mirroring the model rows' download control: the
    // arrow points up-and-out to signal navigating away to the web.
    let action = NSImageView()
    Theme.configure(
      action, symbol: "arrow.up.forward", tooltip: "Browse the catalog",
      color: .tertiaryLabelColor)
    Layout.constrainToIconSize(action)
    action.setContentHuggingPriority(.required, for: .horizontal)
    action.setContentCompressionResistancePriority(.required, for: .horizontal)

    let spacer = NSView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
    spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    let stack = NSStackView(views: [leading, spacer, action])
    stack.orientation = .horizontal
    stack.alignment = .centerY
    stack.spacing = 6
    contentView.addSubview(stack)
    stack.pinToSuperview()

    // Same fixed width and height as the model rows above (ModelItemView /
    // CatalogItemView), so this row's hover highlight and vertical rhythm line up
    // with them instead of sitting a few points shorter.
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: Layout.menuWidth),
      heightAnchor.constraint(equalToConstant: 40),
    ])

    addGesture(action: #selector(openBrowse))
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  @objc private func openBrowse() {
    openInBrowser(url)
  }
}
