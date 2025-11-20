import AppKit
import Foundation
import SwiftUI

/// Shared helpers that build individual sections of the status bar menu.
/// Breaks the large MenuController into focused collaborators so each
/// section owns its layout and mutation logic.

private func makeSectionHeaderItem(_ title: String) -> NSMenuItem {
  let view = SectionHeaderView(title: title)
  return NSMenuItem.viewItem(with: view)
}

/// Removes all items after the given index until hitting a separator or end of menu
private func removeItemsAfter(index: Int, in menu: NSMenu) {
  let indexToRemove = index + 1
  while indexToRemove < menu.items.count {
    let item = menu.items[indexToRemove]
    if item.isSeparatorItem { break }
    menu.removeItem(at: indexToRemove)
  }
}

@MainActor
final class MenuHeaderSection {
  private let server: LlamaServer
  private var titleView: HeaderView?

  init(server: LlamaServer) {
    self.server = server
  }

  func add(to menu: NSMenu) {
    let view = HeaderView(server: server)
    titleView = view
    menu.addItem(NSMenuItem.viewItem(with: view))
    menu.addItem(.separator())
  }

  func refresh() {
    titleView?.refresh()
  }
}

@MainActor
final class MenuSettingsSection {
  func add(to menu: NSMenu) {
    let rootView = SettingsView()
    let view = NSHostingView(rootView: rootView)
    let height = view.fittingSize.height
    view.frame = NSRect(x: 0, y: 0, width: Layout.menuWidth, height: height)
    let item = NSMenuItem.viewItem(with: view)
    menu.addItem(item)
  }
}

@MainActor
final class InstalledSection {
  private let modelManager: ModelManager
  private let server: LlamaServer
  private let onMembershipChanged: (CatalogEntry) -> Void

  private var installedViews: [InstalledModelItemView] = []
  private weak var headerItem: NSMenuItem?

  init(
    modelManager: ModelManager,
    server: LlamaServer,
    onMembershipChanged: @escaping (CatalogEntry) -> Void
  ) {
    self.modelManager = modelManager
    self.server = server
    self.onMembershipChanged = onMembershipChanged
  }

  func add(to menu: NSMenu) {
    let models = installedModels()
    guard !models.isEmpty else { return }

    let header = makeSectionHeaderItem("Installed")
    headerItem = header
    menu.addItem(header)

    buildInstalledItems(models).forEach { menu.addItem($0) }
  }

  /// Rebuilds the installed section to reflect current model state.
  /// Called during live updates to keep the UI in sync while menu stays open.
  func rebuild(in menu: NSMenu) {
    let models = installedModels()

    // Case 1: Section exists
    if let headerItem, let headerIndex = menu.items.firstIndex(of: headerItem) {
      // Remove all installed items
      removeItemsAfter(index: headerIndex, in: menu)

      if models.isEmpty {
        // No models left - remove the header
        menu.removeItem(at: headerIndex)
        self.headerItem = nil
      } else {
        // Re-add installed items
        let items = buildInstalledItems(models)
        var insertIndex = headerIndex + 1
        for item in items {
          menu.insertItem(item, at: insertIndex)
          insertIndex += 1
        }
      }
      return
    }

    // Case 2: Section doesn't exist - add it if there are models
    guard !models.isEmpty else { return }

    // Find the insertion point after the header separator.
    // The Installed section comes right after the menu header and its separator.
    var insertIndex = 0
    for (index, item) in menu.items.enumerated() {
      if item.isSeparatorItem {
        insertIndex = index + 1
        break
      }
    }

    let header = makeSectionHeaderItem("Installed")
    headerItem = header
    menu.insertItem(header, at: insertIndex)

    let items = buildInstalledItems(models)
    var itemInsertIndex = insertIndex + 1
    for item in items {
      menu.insertItem(item, at: itemInsertIndex)
      itemInsertIndex += 1
    }
  }

  func refresh() {
    installedViews.forEach { $0.refresh() }
  }

  private func installedModels() -> [CatalogEntry] {
    let downloading = Catalog.allModels().filter { modelManager.isDownloading($0) }
    return (modelManager.downloadedModels + downloading)
      .sorted(by: CatalogEntry.displayOrder(_:_:))
  }

  private func buildInstalledItems(_ models: [CatalogEntry]) -> [NSMenuItem] {
    installedViews.removeAll()

    return models.map { model in
      let view = InstalledModelItemView(
        model: model,
        server: server,
        modelManager: modelManager
      ) { [weak self] entry in
        self?.onMembershipChanged(entry)
      }
      installedViews.append(view)
      return NSMenuItem.viewItem(with: view)
    }
  }
}

@MainActor
final class CatalogSection {
  private let modelManager: ModelManager
  private let onDownloadStatusChange: (CatalogEntry) -> Void
  private let onRebuild: () -> Void
  private var catalogViews: [CatalogModelItemView] = []
  private weak var separatorItem: NSMenuItem?
  private var collapsedFamilies: Set<String> = []
  private var knownFamilies: Set<String> = []

  init(
    modelManager: ModelManager,
    onDownloadStatusChange: @escaping (CatalogEntry) -> Void,
    onRebuild: @escaping () -> Void
  ) {
    self.modelManager = modelManager
    self.onDownloadStatusChange = onDownloadStatusChange
    self.onRebuild = onRebuild
  }

  func add(to menu: NSMenu) {
    let availableModels = filterAvailableModels()
    guard !availableModels.isEmpty else { return }

    // Initialize families as collapsed when menu first opens.
    // On subsequent rebuilds during the same session (e.g., toggling settings),
    // preserve the collapse state and collapse any newly appearing families.
    let families = Set(availableModels.map { $0.family })
    if collapsedFamilies.isEmpty && knownFamilies.isEmpty {
      collapsedFamilies = families
    } else {
      // Add newly appearing families to collapsed state
      let newFamilies = families.subtracting(knownFamilies)
      collapsedFamilies.formUnion(newFamilies)
      collapsedFamilies.formIntersection(families)  // Remove families no longer in catalog
    }
    knownFamilies = families

    let separator = NSMenuItem.separator()
    separatorItem = separator
    menu.addItem(separator)

    buildCatalogItems(availableModels).forEach { menu.addItem($0) }
  }

  /// Rebuilds the catalog section to reflect current model availability.
  /// Called when models move between catalog and installed (e.g., when downloads start/cancel).
  func rebuild(in menu: NSMenu) {
    let availableModels = filterAvailableModels()

    // Case 1: Section exists
    if let separatorItem, let separatorIndex = menu.items.firstIndex(of: separatorItem) {
      // Remove all catalog items (everything after the separator until the next separator or end)
      removeItemsAfter(index: separatorIndex, in: menu)

      if availableModels.isEmpty {
        // No models left - remove the separator
        menu.removeItem(at: separatorIndex)
        self.separatorItem = nil
      } else {
        // Re-add catalog items
        let items = buildCatalogItems(availableModels)
        var insertIndex = separatorIndex + 1
        for item in items {
          menu.insertItem(item, at: insertIndex)
          insertIndex += 1
        }
      }
      return
    }

    // Case 2: Section doesn't exist - add it if there are models
    guard !availableModels.isEmpty else { return }

    // Find the footer separator by searching backwards from the end.
    // Insert the catalog section (separator + items) right before it.
    var insertIndex = menu.items.count
    for (index, item) in menu.items.enumerated().reversed() {
      if item.isSeparatorItem {
        insertIndex = index
        break
      }
    }

    let separator = NSMenuItem.separator()
    separatorItem = separator
    menu.insertItem(separator, at: insertIndex)

    let items = buildCatalogItems(availableModels)
    var itemInsertIndex = insertIndex + 1
    for item in items {
      menu.insertItem(item, at: itemInsertIndex)
      itemInsertIndex += 1
    }
  }

  /// Filters catalog to show only compatible models that haven't been installed
  private func filterAvailableModels() -> [CatalogEntry] {
    let showQuantized = UserSettings.showQuantizedModels
    return Catalog.allModels().filter { model in
      let isAvailable = !modelManager.isInstalled(model) && !modelManager.isDownloading(model)
      let isCompatible = Catalog.isModelCompatible(model)
      return isAvailable && isCompatible && (showQuantized || model.isFullPrecision)
    }
  }

  /// Builds a flat list of catalog model items with family headers
  private func buildCatalogItems(_ models: [CatalogEntry]) -> [NSMenuItem] {
    catalogViews.removeAll()

    let sortedModels = models.sorted(by: CatalogEntry.displayOrder(_:_:))

    // Group models by family to collect unique sizes
    var familySizes: [String: [String]] = [:]
    for model in sortedModels {
      if !familySizes[model.family, default: []].contains(model.sizeLabel) {
        familySizes[model.family, default: []].append(model.sizeLabel)
      }
    }

    var items: [NSMenuItem] = []
    var previousFamily: String?

    for model in sortedModels {
      // Insert family header when family changes
      if previousFamily != model.family {
        let sizes = familySizes[model.family] ?? []
        let headerView = FamilyHeaderView(
          family: model.family,
          sizes: sizes,
          isCollapsed: collapsedFamilies.contains(model.family)
        ) { [weak self] family in
          self?.toggleFamilyCollapsed(family)
        }
        let headerItem = NSMenuItem.viewItem(with: headerView)
        headerItem.isEnabled = true
        items.append(headerItem)
      }

      // Only add model if family is not collapsed
      if !collapsedFamilies.contains(model.family) {
        let view = CatalogModelItemView(model: model, modelManager: modelManager) {
          [weak self] in
          self?.onDownloadStatusChange(model)
        }
        catalogViews.append(view)
        items.append(NSMenuItem.viewItem(with: view))
      }

      previousFamily = model.family
    }

    return items
  }

  private func toggleFamilyCollapsed(_ family: String) {
    if collapsedFamilies.contains(family) {
      collapsedFamilies.remove(family)
    } else {
      collapsedFamilies.insert(family)
    }
    onRebuild()
  }

  func refresh() {
    catalogViews.forEach { $0.refresh() }
  }

  func reset() {
    collapsedFamilies.removeAll()
    knownFamilies.removeAll()
  }
}

@MainActor
final class FooterSection {
  func add(to menu: NSMenu) {
    menu.addItem(.separator())

    let container = NSView()
    container.translatesAutoresizingMaskIntoConstraints = false

    let appVersionText: String
    #if DEBUG
      // Debug builds show hammer emoji
      appVersionText = "🔨"
    #else
      appVersionText =
        AppInfo.shortVersion == "0.0.0"
        // Internal builds (0.0.0) show build number
        ? "build \(AppInfo.buildNumber)"
        // Public builds show marketing version
        : AppInfo.shortVersion
    #endif

    let versionButton = NSButton(title: "", target: self, action: #selector(checkForUpdates))
    versionButton.isBordered = false
    versionButton.translatesAutoresizingMaskIntoConstraints = false
    versionButton.lineBreakMode = .byTruncatingMiddle
    versionButton.attributedTitle = NSAttributedString(
      string: appVersionText,
      attributes: [
        .font: Typography.primary,
        .foregroundColor: NSColor.tertiaryLabelColor,
      ])
    (versionButton.cell as? NSButtonCell)?.highlightsBy = []

    let llamaCppLabel = Typography.makePrimaryLabel(" · llama.cpp \(AppInfo.llamaCppVersion)")
    llamaCppLabel.textColor = .tertiaryLabelColor
    llamaCppLabel.lineBreakMode = .byTruncatingMiddle
    llamaCppLabel.translatesAutoresizingMaskIntoConstraints = false

    let settingsButton = NSButton(
      title: "Settings", target: self, action: #selector(toggleSettings))
    settingsButton.font = Typography.secondary
    settingsButton.bezelStyle = .texturedRounded
    settingsButton.translatesAutoresizingMaskIntoConstraints = false
    settingsButton.keyEquivalent = ","

    let quitButton = NSButton(title: "Quit", target: self, action: #selector(quitApp))
    quitButton.font = Typography.secondary
    quitButton.bezelStyle = .texturedRounded
    quitButton.translatesAutoresizingMaskIntoConstraints = false

    container.addSubview(versionButton)
    container.addSubview(llamaCppLabel)
    container.addSubview(settingsButton)
    container.addSubview(quitButton)

    let horizontalPadding = Layout.outerHorizontalPadding + Layout.innerHorizontalPadding

    NSLayoutConstraint.activate([
      container.widthAnchor.constraint(equalToConstant: Layout.menuWidth),
      container.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
      versionButton.leadingAnchor.constraint(
        equalTo: container.leadingAnchor, constant: horizontalPadding),
      versionButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),

      llamaCppLabel.leadingAnchor.constraint(equalTo: versionButton.trailingAnchor),
      llamaCppLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),

      settingsButton.trailingAnchor.constraint(
        equalTo: quitButton.leadingAnchor, constant: -8),
      settingsButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),

      quitButton.trailingAnchor.constraint(
        equalTo: container.trailingAnchor, constant: -horizontalPadding),
      quitButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),

      llamaCppLabel.trailingAnchor.constraint(
        lessThanOrEqualTo: settingsButton.leadingAnchor, constant: -8),
    ])

    let item = NSMenuItem.viewItem(with: container)
    item.isEnabled = true
    menu.addItem(item)
  }

  @objc private func checkForUpdates() {
    NotificationCenter.default.post(name: .LBCheckForUpdates, object: nil)
  }

  @objc private func toggleSettings() {
    NotificationCenter.default.post(name: .LBToggleSettingsVisibility, object: nil)
  }

  @objc private func quitApp() {
    NSApplication.shared.terminate(nil)
  }
}
