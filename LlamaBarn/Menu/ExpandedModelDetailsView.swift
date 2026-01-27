import AppKit
import Foundation

/// Container view for all expanded model details.
/// Consolidates header, context variants, file size, and actions into a single view
/// with shared padding and consistent alignment.
final class ExpandedModelDetailsView: ItemView {
  private let model: CatalogEntry
  private let actionHandler: ModelActionHandler

  // Row views
  private let headerLabel = Theme.secondaryLabel()

  init(model: CatalogEntry, actionHandler: ModelActionHandler) {
    self.model = model
    self.actionHandler = actionHandler
    super.init(frame: .zero)
    setupLayout()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  // Disable hover highlight since this is an info container
  override var highlightEnabled: Bool { false }

  private func setupLayout() {
    // Main vertical stack for all rows
    let mainStack = NSStackView()
    mainStack.orientation = .vertical
    mainStack.alignment = .leading
    mainStack.spacing = 2

    // Header row with info button
    let headerRow = NSStackView()
    headerRow.orientation = .horizontal
    headerRow.alignment = .centerY
    headerRow.spacing = 4

    headerLabel.stringValue = "Context length configurations"
    headerLabel.textColor = Theme.Colors.modelIconTint
    headerRow.addArrangedSubview(headerLabel)

    // Info button that shows tooltip on hover
    let infoButton = NSButton()
    infoButton.bezelStyle = .inline
    infoButton.isBordered = false
    infoButton.image = NSImage(systemSymbolName: "info.circle", accessibilityDescription: "Info")
    infoButton.imagePosition = .imageOnly
    infoButton.contentTintColor = Theme.Colors.textSecondary
    infoButton.toolTip =
      "Each configuration runs the same model with a different context length. Longer contexts use more memory."
    headerRow.addArrangedSubview(infoButton)

    mainStack.addArrangedSubview(headerRow)

    // Context tier variant rows
    for tier in ContextTier.enabledCases {
      let row = buildVariantRow(for: tier)
      mainStack.addArrangedSubview(row)
    }

    // Add indent wrapper to align with model text
    let indent = NSView()
    indent.translatesAutoresizingMaskIntoConstraints = false
    indent.widthAnchor.constraint(equalToConstant: Layout.expandedIndent).isActive = true

    let rootStack = NSStackView(views: [indent, mainStack])
    rootStack.orientation = .horizontal
    rootStack.alignment = .top
    rootStack.spacing = 0

    contentView.addSubview(rootStack)
    rootStack.pinToSuperview(top: 2, leading: 0, trailing: 0, bottom: 2)
  }

  // MARK: - Variant Row

  private func buildVariantRow(for tier: ContextTier) -> NSView {
    let isCompatible = model.isCompatible(ctxWindowTokens: Double(tier.rawValue))
    let exceedsModelLimit = tier.rawValue > model.ctxWindow

    let row = NSStackView()
    row.orientation = .horizontal
    row.alignment = .centerY
    row.spacing = 0
    // Fixed row height prevents menu resizing when expanding different models
    row.heightAnchor.constraint(equalToConstant: 16).isActive = true

    let infoLabel = Theme.secondaryLabel()
    let secondaryColor = Theme.Colors.textSecondary
    let valueColor = isCompatible ? Theme.Colors.textPrimary : Theme.Colors.textSecondary
    // For supported configs, use medium color for labels; for unsupported, use secondary
    let labelColor = isCompatible ? Theme.Colors.modelIconTint : Theme.Colors.textSecondary

    // Build attributed string
    let result = NSMutableAttributedString()
    let secondaryAttrs = Theme.secondaryAttributes(color: secondaryColor)
    let labelAttrs = Theme.secondaryAttributes(color: labelColor)
    let valueAttrs = Theme.secondaryAttributes(color: valueColor)

    // Status icon using SF Symbols for consistent sizing
    let statusIcon = NSImageView()
    let statusSymbol = isCompatible ? "checkmark" : "xmark"
    let statusColor = isCompatible ? Theme.Colors.success : secondaryColor
    Theme.configure(statusIcon, symbol: statusSymbol, color: statusColor, pointSize: 10)
    // Fixed width ensures consistent alignment regardless of icon
    statusIcon.widthAnchor.constraint(equalToConstant: 12).isActive = true
    row.addArrangedSubview(statusIcon)

    // Spacing after icon
    let iconSpacer = NSView()
    iconSpacer.translatesAutoresizingMaskIntoConstraints = false
    iconSpacer.widthAnchor.constraint(equalToConstant: 4).isActive = true
    row.addArrangedSubview(iconSpacer)
    result.append(NSAttributedString(string: tier.label, attributes: valueAttrs))
    result.append(NSAttributedString(string: " ctx  ", attributes: labelAttrs))

    if exceedsModelLimit {
      // Model doesn't support this context length
      result.append(NSAttributedString(string: "—", attributes: secondaryAttrs))
      infoLabel.attributedStringValue = result
      row.addArrangedSubview(infoLabel)
    } else {
      // Show memory usage
      let ramMb = model.runtimeMemoryUsageMb(ctxWindowTokens: Double(tier.rawValue))
      let ramGb = Double(ramMb) / 1024.0
      let ramStr = String(format: "%.1f GB", ramGb)

      result.append(NSAttributedString(string: ramStr, attributes: valueAttrs))
      result.append(NSAttributedString(string: " mem", attributes: labelAttrs))

      infoLabel.attributedStringValue = result
      row.addArrangedSubview(infoLabel)

      // Copy button only for compatible tiers
      if isCompatible {
        let copyButton = HoverButton()
        copyButton.title = "  Copy ID"
        copyButton.font = Theme.Fonts.secondary
        copyButton.contentTintColor = Theme.Colors.modelIconTint
        copyButton.target = self
        copyButton.action = #selector(didClickCopy(_:))
        copyButton.tag = tier.rawValue
        row.addArrangedSubview(copyButton)
      }
    }

    return row
  }

  @objc private func didClickCopy(_ sender: NSButton) {
    guard let tier = ContextTier(rawValue: sender.tag) else { return }
    let idToCopy = "\(model.id)\(tier.suffix)"
    actionHandler.copyText(idToCopy)

    sender.title = "  Copied"
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak sender] in
      sender?.title = "  Copy ID"
    }
  }

}
