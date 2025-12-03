import AppKit

/// Displays a welcome message on first launch, pointing to the menu bar icon.
final class WelcomePopover: NSViewController, NSPopoverDelegate {
  private let popover = NSPopover()
  private var observer: NSObjectProtocol?
  private var clickMonitor: Any?

  override func loadView() {
    let label = NSTextField(labelWithString: "Hello, I'm LlamaBarn")
    label.font = .systemFont(ofSize: 13)
    label.textColor = .controlTextColor
    label.isBezeled = false
    label.drawsBackground = false
    label.isEditable = false
    label.isSelectable = false
    label.sizeToFit()

    let contentView = NSView(
      frame: NSRect(
        x: 0,
        y: 0,
        width: label.frame.width + 32,
        height: label.frame.height + 24
      ))

    label.frame.origin = NSPoint(
      x: 16,
      y: 12
    )
    contentView.addSubview(label)

    view = contentView
  }

  /// Shows the popover pointing to the status bar button.
  /// Dismisses when the user clicks the menu bar icon or clicks outside.
  func show(from statusItem: NSStatusItem) {
    guard let button = statusItem.button else { return }

    popover.contentViewController = self
    popover.delegate = self
    popover.behavior = .semitransient
    popover.animates = true

    popover.show(
      relativeTo: button.bounds,
      of: button,
      preferredEdge: .minY
    )

    // Dismiss when the menu opens
    observer = NotificationCenter.default.addObserver(
      forName: NSMenu.didBeginTrackingNotification,
      object: statusItem.menu,
      queue: .main
    ) { [weak self] _ in
      self?.popover.close()
    }

    // Monitor clicks outside to dismiss
    clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) {
      [weak self] event in
      guard let self else { return }

      DispatchQueue.main.async {
        guard let window = self.popover.contentViewController?.view.window else { return }

        let screenPoint: NSPoint
        if let eventWindow = event.window {
          let rect = NSRect(origin: event.locationInWindow, size: .zero)
          screenPoint = eventWindow.convertToScreen(rect).origin
        } else {
          screenPoint = event.locationInWindow
        }

        if !window.frame.contains(screenPoint) {
          self.popover.close()
        }
      }
    }
  }

  func popoverDidClose(_ notification: Notification) {
    if let observer {
      NotificationCenter.default.removeObserver(observer)
      self.observer = nil
    }
    if let clickMonitor {
      NSEvent.removeMonitor(clickMonitor)
      self.clickMonitor = nil
    }
  }
}
