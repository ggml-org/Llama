import AppKit
import Foundation

/// Header row for the expanded model section.
/// Displays "Context variants / est mem usage" label.
final class ExpandedModelHeaderView: ItemView {
  private let label = Theme.secondaryLabel()

  init() {
    super.init(frame: .zero)
    setupLayout()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  // Compact height for header row
  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 20) }

  // Disable hover highlight since this is a header, not an interactive item
  override var highlightEnabled: Bool { false }

  private func setupLayout() {
    // Indent to align with model text
    let indent = NSView()
    indent.translatesAutoresizingMaskIntoConstraints = false
    indent.widthAnchor.constraint(equalToConstant: Layout.expandedIndent).isActive = true

    label.stringValue = "Context variants / memory usage"
    label.textColor = Theme.Colors.textSecondary

    let stack = NSStackView(views: [indent, label])
    stack.orientation = .horizontal
    stack.alignment = .centerY
    stack.spacing = 0

    contentView.addSubview(stack)
    stack.pinToSuperview(top: 4, leading: 0, trailing: 0, bottom: -2)
  }
}
