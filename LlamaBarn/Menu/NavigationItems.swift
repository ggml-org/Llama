import AppKit

/// A simple text-based menu item with optional back arrow and action.
/// Replaces both BackItemView and TitleItemView with a single unified view.
final class TextItemView: ItemView {
  private let label: NSTextField
  private let iconView: NSImageView?
  private let onAction: (() -> Void)?

  /// Creates a text item view.
  /// - Parameters:
  ///   - text: The text to display
  ///   - showBackArrow: If true, shows a back arrow icon before the text
  ///   - onAction: Optional action to perform on click. If nil, item is non-interactive.
  init(text: String, showBackArrow: Bool = false, onAction: (() -> Void)? = nil) {
    self.onAction = onAction

    // Configure label style based on whether it's a back button or title
    if showBackArrow {
      self.label = Theme.secondaryLabel()
      self.label.textColor = Theme.Colors.textSecondary

      let icon = NSImageView()
      Theme.configure(
        icon,
        symbol: "arrow.left",
        color: Theme.Colors.textSecondary,
        pointSize: 10
      )
      self.iconView = icon
    } else {
      self.label = Theme.primaryLabel()
      self.label.font = Theme.Fonts.primary
      self.label.textColor = Theme.Colors.textPrimary
      self.iconView = nil
    }

    super.init(frame: .zero)

    label.stringValue = text

    // Build content
    if let iconView {
      let stack = NSStackView(views: [iconView, label])
      stack.orientation = .horizontal
      stack.spacing = 4
      stack.alignment = .centerY
      contentView.addSubview(stack)
      stack.pinToSuperview()
    } else {
      contentView.addSubview(label)
      label.pinToSuperview()
    }
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var highlightEnabled: Bool { onAction != nil }

  override func mouseUp(with event: NSEvent) {
    super.mouseUp(with: event)
    if bounds.contains(convert(event.locationInWindow, from: nil)) {
      onAction?()
    }
  }
}
