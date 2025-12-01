import AppKit
import SwiftUI

@MainActor
class SettingsWindowController: NSObject, NSWindowDelegate {
  private var window: NSWindow?

  func show() {
    if window == nil {
      let rootView = SettingsView()
        .frame(width: 300)  // Set a reasonable width
        .padding()

      let hostingController = NSHostingController(rootView: rootView)

      let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
        styleMask: [.titled, .closable, .miniaturizable],
        backing: .buffered,
        defer: false
      )

      window.contentViewController = hostingController
      window.title = "Settings"
      window.center()
      window.isReleasedWhenClosed = false
      window.delegate = self

      self.window = window
    }

    NSApp.setActivationPolicy(.regular)
    window?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  func windowWillClose(_ notification: Notification) {
    // We need to delay this slightly to ensure the window is fully closed
    // and to avoid issues if the user is quitting the app
    DispatchQueue.main.async {
      // Check if there are other visible windows (e.g. Sparkle updater)
      // We filter for titled windows that are visible and not the one being closed
      let openWindows = NSApp.windows.filter { window in
        return window.isVisible && window.styleMask.contains(.titled)
          && window !== notification.object as? NSWindow
      }

      if openWindows.isEmpty {
        NSApp.setActivationPolicy(.accessory)
      }
    }
  }
}
