import AppKit

/// A simple item view that displays a multi-line description text.
/// Used for family descriptions in the catalog detail view.
final class DescriptionItemView: ItemView {
  private let label = Theme.tertiaryLabel()

  init(text: String) {
    super.init(frame: .zero)

    label.stringValue = text
    label.cell?.wraps = true
    label.cell?.isScrollable = false
    label.usesSingleLineMode = false
    label.maximumNumberOfLines = 0
    label.lineBreakMode = .byWordWrapping

    // Calculate available width:
    // Menu (300) - Outer (5*2) - Inner (8*2) = 274
    let availableWidth =
      Layout.menuWidth - (Layout.outerHorizontalPadding * 2) - (Layout.innerHorizontalPadding * 2)
    label.preferredMaxLayoutWidth = availableWidth

    contentView.addSubview(label)
    label.pinToSuperview()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var highlightEnabled: Bool { false }
}
