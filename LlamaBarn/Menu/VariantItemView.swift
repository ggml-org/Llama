import AppKit
import Foundation

/// Displays a context tier variant (4k, 32k, 128k) in the expanded model view.
/// Format: "– 4k ctx  ~2.5 GB mem  (copy model ID)"
/// This is an informational row, not an interactive menu item — hover highlighting is disabled.
final class VariantItemView: ItemView {
  private let model: CatalogEntry
  private let tier: ContextTier
  private let isLoaded: Bool
  private let isCompatible: Bool
  private let copyAction: (String) -> Void

  private let infoLabel = Theme.secondaryLabel()
  private let copyButton = NSButton()
  private let loadedIndicator = Theme.secondaryLabel()

  init(
    model: CatalogEntry,
    tier: ContextTier,
    isLoaded: Bool,
    copyAction: @escaping (String) -> Void
  ) {
    self.model = model
    self.tier = tier
    self.isLoaded = isLoaded
    self.copyAction = copyAction

    // Check compatibility for this specific tier
    self.isCompatible = model.isCompatible(ctxWindowTokens: Double(tier.rawValue))

    super.init(frame: .zero)
    setupLayout()
    configureViews()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  // Compact height for tightly grouped variant rows
  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 16) }

  // Disable hover highlight since this is an info row, not an interactive item
  override var highlightEnabled: Bool { false }

  private func setupLayout() {
    // Layout: [Indent] [– 4k ctx  ~2.5 GB mem  (copy model ID)] [loaded indicator]
    // Natural text flow, no spacer pushing things apart

    // Indent to align with model text
    let indent = NSView()
    indent.translatesAutoresizingMaskIntoConstraints = false
    indent.widthAnchor.constraint(equalToConstant: Layout.expandedIndent).isActive = true

    // Copy button styled as text link
    copyButton.isBordered = false
    copyButton.title = "(copy model ID)"
    copyButton.font = Theme.Fonts.secondary
    copyButton.contentTintColor = Theme.Colors.textSecondary
    copyButton.target = self
    copyButton.action = #selector(didClickCopy)

    let stack = NSStackView(views: [indent, infoLabel, copyButton, loadedIndicator])
    stack.orientation = .horizontal
    stack.alignment = .centerY
    stack.spacing = 0

    contentView.addSubview(stack)
    // Use negative top/bottom to counteract ItemView's verticalPadding for tighter rows
    stack.pinToSuperview(top: -2, leading: 0, trailing: 0, bottom: -2)
  }

  private func configureViews() {
    // Values (4k, ~2.5 GB) use a more prominent color than labels (ctx, mem)
    let secondaryColor = Theme.Colors.textSecondary
    let valueColor = isCompatible ? Theme.Colors.modelIconTint : Theme.Colors.textSecondary

    if isCompatible {
      let ramMb = model.runtimeMemoryUsageMb(ctxWindowTokens: Double(tier.rawValue))
      let ramGb = Double(ramMb) / 1024.0
      let ramStr = String(format: "%.1f GB", ramGb)

      // Build attributed string: "– 4k ctx  ~2.5 GB mem"
      // Values (4k, ~2.5 GB) are darker, labels (ctx, mem) are lighter
      let result = NSMutableAttributedString()
      let secondaryAttrs = Theme.secondaryAttributes(color: secondaryColor)
      let valueAttrs = Theme.secondaryAttributes(color: valueColor)

      result.append(NSAttributedString(string: "•  ", attributes: secondaryAttrs))
      result.append(NSAttributedString(string: tier.label, attributes: valueAttrs))
      result.append(NSAttributedString(string: " ctx  ", attributes: secondaryAttrs))
      result.append(NSAttributedString(string: ramStr, attributes: valueAttrs))
      result.append(NSAttributedString(string: " mem  ", attributes: secondaryAttrs))

      infoLabel.attributedStringValue = result
      copyButton.isHidden = false
      loadedIndicator.stringValue = ""
    } else {
      // Incompatible tier: show tier label + "not enough memory" as plain text
      infoLabel.stringValue = "•  \(tier.label) ctx  not enough memory"
      infoLabel.textColor = secondaryColor
      copyButton.isHidden = true
      loadedIndicator.stringValue = ""
    }
  }

  @objc private func didClickCopy() {
    let idToCopy = "\(model.id)\(tier.suffix)"
    copyAction(idToCopy)

    copyButton.title = "(copied)"

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      guard let self else { return }
      self.copyButton.title = "(copy model ID)"
    }
  }
}
