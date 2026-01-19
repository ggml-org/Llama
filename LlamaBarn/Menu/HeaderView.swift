import AppKit
import Foundation

/// Header row showing app name and server status.
final class HeaderView: ItemView {

  private unowned let server: LlamaServer
  private let appNameLabel = Theme.primaryLabel()
  private let statusStackView = NSStackView()
  private let statusLabel = Theme.secondaryLabel()
  private let linkLabel = Theme.secondaryLabel()
  private let copyButton = NSButton()
  private let webUiLabel = Theme.secondaryLabel()

  private var currentUrl: URL?
  private var webUiUrl: URL?
  private var showingCopyConfirmation = false

  init(server: LlamaServer) {
    self.server = server
    super.init(frame: .zero)
    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var highlightEnabled: Bool { false }

  private func setup() {
    widthAnchor.constraint(equalToConstant: Layout.menuWidth).isActive = true

    appNameLabel.stringValue = "LlamaBarn"

    // Status stack for horizontal layout of status elements
    statusStackView.translatesAutoresizingMaskIntoConstraints = false
    statusStackView.orientation = .horizontal
    statusStackView.spacing = 0
    statusStackView.alignment = .firstBaseline
    statusStackView.distribution = .fill

    // Main stack for vertical layout of app name and status
    let mainStack = NSStackView(views: [appNameLabel, statusStackView])
    mainStack.orientation = .vertical
    mainStack.alignment = .leading
    mainStack.spacing = Layout.textLineSpacing

    contentView.addSubview(mainStack)
    mainStack.pinToSuperview()

    // Link Label Configuration
    linkLabel.isSelectable = false  // Make it look like a label, not editable

    // Copy Button Configuration
    Theme.configure(copyButton, symbol: "doc.on.doc", tooltip: "Copy URL", pointSize: 11)
    copyButton.target = self
    copyButton.action = #selector(copyUrl)

    // WebUI Label Configuration
    let webUiClick = NSClickGestureRecognizer(target: self, action: #selector(openWebUi))
    webUiLabel.addGestureRecognizer(webUiClick)
    webUiLabel.isSelectable = false

    statusStackView.addArrangedSubview(statusLabel)
    statusStackView.addArrangedSubview(linkLabel)
    statusStackView.addArrangedSubview(NSView.spacer(width: 4))
    statusStackView.addArrangedSubview(copyButton)
    statusStackView.addArrangedSubview(NSView.spacer(width: 8))
    statusStackView.addArrangedSubview(NSView.flexibleSpacer())
    statusStackView.addArrangedSubview(webUiLabel)
  }

  func refresh() {
    // Dim title while server is loading/reloading
    appNameLabel.textColor =
      server.isLoading ? Theme.Colors.textSecondary : Theme.Colors.textPrimary

    // Connect to server info
    appNameLabel.stringValue = "LlamaBarn"

    // Determine host: use bind address if set, otherwise localhost
    // For 0.0.0.0, show the actual local IP for user convenience
    let host: String
    if let bindAddress = UserSettings.networkBindAddress {
      host =
        bindAddress == "0.0.0.0"
        ? (LlamaServer.getLocalIpAddress() ?? "0.0.0.0")
        : bindAddress
    } else {
      host = "localhost"
    }
    let linkText = "\(host):\(LlamaServer.defaultPort)"
    let apiUrlString = "http://\(linkText)/v1"
    let webUiUrlString = "http://\(linkText)/"

    self.currentUrl = URL(string: apiUrlString)!
    self.webUiUrl = URL(string: webUiUrlString)!

    statusLabel.stringValue = "Base URL: "
    statusLabel.textColor = Theme.Colors.textSecondary
    statusLabel.isHidden = false

    let displayString = apiUrlString.replacingOccurrences(of: "http://", with: "")
    let attrTitle = NSAttributedString(
      string: displayString,
      attributes: [
        .foregroundColor: Theme.Colors.textPrimary,
        .font: Theme.Fonts.secondary,
      ]
    )
    linkLabel.attributedStringValue = attrTitle
    linkLabel.isHidden = false
    copyButton.isHidden = false
    webUiLabel.isHidden = false

    let attrWebUi = NSAttributedString(
      string: "WebUI",
      attributes: [
        .foregroundColor: NSColor.linkColor,
        .font: Theme.Fonts.secondary,
      ]
    )
    webUiLabel.attributedStringValue = attrWebUi

    // Update copy icon based on confirmation state
    Theme.updateCopyIcon(copyButton, showingConfirmation: showingCopyConfirmation)

    needsDisplay = true
  }

  @objc private func openWebUi() {
    if let url = webUiUrl {
      NSWorkspace.shared.open(url)
    }
  }

  @objc private func copyUrl() {
    if let url = currentUrl {
      let pasteboard = NSPasteboard.general
      pasteboard.clearContents()
      pasteboard.setString(url.absoluteString, forType: .string)

      // Show checkmark confirmation
      showingCopyConfirmation = true
      refresh()

      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
        self?.showingCopyConfirmation = false
        self?.refresh()
      }
    }
  }

}
