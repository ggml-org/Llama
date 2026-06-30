import Foundation
import ServiceManagement

enum LaunchAtLogin {
  static var isEnabled: Bool {
    SMAppService.mainApp.status == .enabled
  }

  /// Enables launch-at-login by default, but only on the first launch. Llama's
  /// whole point is being always available in the menu bar, so we opt in by
  /// default -- macOS surfaces a "login item added" notification and the user
  /// can flip it off in Settings (or System Settings). The
  /// `hasSetDefaultLaunchAtLogin` flag ensures this runs once, so a deliberate
  /// later opt-out isn't undone on the next launch.
  ///
  /// We mark the default applied before enabling -- even if `setEnabled` fails
  /// -- so a persistently failing `register()` doesn't re-attempt on every
  /// launch. We'd rather a rare silent miss than nag the OS forever.
  static func enableOnFirstLaunch() {
    guard !UserSettings.hasSetDefaultLaunchAtLogin else { return }
    UserSettings.hasSetDefaultLaunchAtLogin = true
    setEnabled(true)
  }

  @discardableResult
  static func setEnabled(_ enabled: Bool) -> Bool {
    do {
      if enabled {
        try SMAppService.mainApp.register()
      } else {
        try SMAppService.mainApp.unregister()
      }
      return true
    } catch {
      return false
    }
  }
}
