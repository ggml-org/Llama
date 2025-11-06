import Foundation

/// Centralized access to simple persisted preferences.
enum UserSettings {
  private enum Keys {
    static let showQuantizedModels = "showQuantizedModels"
    static let hasSeenWelcome = "hasSeenWelcome"
  }

  private static let defaults = UserDefaults.standard

  /// Whether quantized model builds should appear in the catalog.
  /// Defaults to `false` to emphasize full-precision models for most users.
  static var showQuantizedModels: Bool {
    get {
      defaults.bool(forKey: Keys.showQuantizedModels)
    }
    set {
      guard defaults.bool(forKey: Keys.showQuantizedModels) != newValue else { return }
      defaults.set(newValue, forKey: Keys.showQuantizedModels)
      NotificationCenter.default.post(name: .LBUserSettingsDidChange, object: nil)
    }
  }

  /// Whether the user has seen the welcome popover on first launch.
  static var hasSeenWelcome: Bool {
    get {
      defaults.bool(forKey: Keys.hasSeenWelcome)
    }
    set {
      defaults.set(newValue, forKey: Keys.hasSeenWelcome)
    }
  }
}
