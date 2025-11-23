import AppKit
import Foundation

/// Header row showing app name and server status.
final class HeaderView: NSView {

  private unowned let server: LlamaServer
  private let appNameLabel = Typography.makePrimaryLabel()
  private let serverStatusLabel = Typography.makeSecondaryLabel()
  private let backgroundView = NSView()

  init(server: LlamaServer) {
    self.server = server
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 40) }

  private func setup() {
    wantsLayer = true
    backgroundView.wantsLayer = true

    appNameLabel.stringValue = "LlamaBarn"

    serverStatusLabel.allowsEditingTextAttributes = true
    serverStatusLabel.isSelectable = true

    let stack = NSStackView(views: [appNameLabel, serverStatusLabel])
    stack.orientation = .vertical
    stack.alignment = .leading
    stack.spacing = 2

    addSubview(backgroundView)
    backgroundView.addSubview(stack)

    backgroundView.pinToSuperview(
      leading: Layout.outerHorizontalPadding,
      trailing: Layout.outerHorizontalPadding
    )
    stack.pinToSuperview(
      top: 6,
      leading: Layout.innerHorizontalPadding,
      trailing: Layout.innerHorizontalPadding,
      bottom: 6
    )
  }

  func refresh() {
    // Update server status based on server state.
    if server.isRunning {
      let host = UserSettings.exposeToNetwork ? (getLocalIpAddress() ?? "0.0.0.0") : "localhost"
      let linkText = "\(host):\(LlamaServer.defaultPort)"
      let modelName = server.activeModelName ?? "model"
      let full = "\(modelName) is running on \(linkText)"
      let url = URL(string: "http://\(linkText)/")!

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineBreakMode = .byTruncatingTail

      var baseAttributes = Typography.makeSecondaryAttributes(color: Typography.primaryColor)
      baseAttributes[.paragraphStyle] = paragraphStyle

      let attributed = NSMutableAttributedString(string: full, attributes: baseAttributes)

      if let modelRange = full.range(of: modelName) {
        attributed.addAttribute(
          .foregroundColor, value: NSColor.llamaGreen, range: NSRange(modelRange, in: full))
      }

      if let linkRange = full.range(of: linkText) {
        attributed.addAttributes(
          [
            .link: url,
            .foregroundColor: NSColor.linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
          ],
          range: NSRange(linkRange, in: full)
        )
      }
      serverStatusLabel.attributedStringValue = attributed
      serverStatusLabel.toolTip = "Open llama-server"
    } else {
      serverStatusLabel.attributedStringValue = NSAttributedString(
        string: "Select a model to run",
        attributes: Typography.secondaryAttributes
      )
      serverStatusLabel.toolTip = nil
    }

    needsDisplay = true
  }

  /// Returns the IPv4 address of en0 (primary network interface).
  private func getLocalIpAddress() -> String? {
    var ifaddr: UnsafeMutablePointer<ifaddrs>?

    // Get linked list of all network interfaces (returns 0 on success)
    guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
    // Ensure memory is freed when function exits
    defer { freeifaddrs(ifaddr) }

    // Walk through linked list of network interfaces
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
      let interface = ifptr.pointee

      // Skip non-IPv4 addresses (AF_INET = IPv4, AF_INET6 = IPv6)
      guard interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) else { continue }

      // Get interface name (e.g., "en0", "en1", "lo0")
      let name = String(cString: interface.ifa_name)

      // Only look for en0 (primary interface on most Macs)
      guard name == "en0" else { continue }

      // Convert socket address to human-readable IP string
      var addr = [CChar](repeating: 0, count: Int(NI_MAXHOST))
      getnameinfo(
        interface.ifa_addr,
        socklen_t(interface.ifa_addr.pointee.sa_len),
        &addr,
        socklen_t(addr.count),
        nil,
        socklen_t(0),
        NI_NUMERICHOST  // Return numeric address (e.g., "192.168.1.5")
      )

      return String(cString: addr)
    }

    return nil
  }

}
