import Cocoa

/// AppleScript command handler for "show settings"
/// Usage: tell application "LlamaBarn" to show settings
class ShowSettingsCommand: NSScriptCommand {
  override func performDefaultImplementation() -> Any? {
    DispatchQueue.main.async {
      SettingsWindowController.shared.showSettings()
    }
    return nil
  }
}
