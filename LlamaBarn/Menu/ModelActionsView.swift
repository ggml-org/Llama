import AppKit
import Foundation

/// Action row in the expanded model view.
/// Shows a "delete" text button to remove the model.
final class ModelActionsView: ItemView {
  private let model: CatalogEntry
  private let actionHandler: ModelActionHandler

  private let deleteButton = NSButton()

  init(model: CatalogEntry, actionHandler: ModelActionHandler) {
    self.model = model
    self.actionHandler = actionHandler
    super.init(frame: .zero)
    setupLayout()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 24) }

  // Disable hover highlight since this is an action row
  override var highlightEnabled: Bool { false }

  private func setupLayout() {
    // Indent to align with model text
    let indent = NSView()
    indent.translatesAutoresizingMaskIntoConstraints = false
    indent.widthAnchor.constraint(equalToConstant: Layout.expandedIndent).isActive = true

    // Delete button styled as text
    deleteButton.isBordered = false
    deleteButton.title = "delete"
    deleteButton.font = Theme.Fonts.secondary
    deleteButton.contentTintColor = Theme.Colors.textSecondary
    deleteButton.target = self
    deleteButton.action = #selector(didClickDelete)

    let rootStack = NSStackView(views: [indent, deleteButton])
    rootStack.orientation = .horizontal
    rootStack.alignment = .centerY
    rootStack.spacing = 0

    contentView.addSubview(rootStack)
    rootStack.pinToSuperview(top: 0, leading: 0, trailing: 0, bottom: 4)
  }

  @objc private func didClickDelete() {
    actionHandler.delete(model: model)
  }
}
