import Foundation

/// Centralized access to simple persisted preferences.
enum UserSettings {
  private enum Keys {
    static let showQuantizedModels = "showQuantizedModels"
    static let showIncompatibleFamilies = "showIncompatibleFamilies"
    static let hasSeenWelcome = "hasSeenWelcome"
    static let exposeToNetwork = "exposeToNetwork"
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

  /// Whether to show families that have no compatible models for the current device.
  /// Defaults to `true` to show all families.
  static var showIncompatibleFamilies: Bool {
    get {
      defaults.object(forKey: Keys.showIncompatibleFamilies) as? Bool ?? true
    }
    set {
      guard (defaults.object(forKey: Keys.showIncompatibleFamilies) as? Bool ?? true) != newValue
      else { return }
      defaults.set(newValue, forKey: Keys.showIncompatibleFamilies)
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

  /// Whether to expose llama-server to the network (bind to 0.0.0.0).
  /// Defaults to `false` (localhost only). When `true`, allows connections from other devices
  /// on the same network.
  static var exposeToNetwork: Bool {
    get {
      defaults.bool(forKey: Keys.exposeToNetwork)
    }
    set {
      defaults.set(newValue, forKey: Keys.exposeToNetwork)
    }
  }
}
