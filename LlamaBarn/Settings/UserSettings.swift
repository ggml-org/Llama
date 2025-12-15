import Foundation

/// Centralized access to simple persisted preferences.
enum UserSettings {
  private enum Keys {
    static let hasSeenWelcome = "hasSeenWelcome"
    static let exposeToNetwork = "exposeToNetwork"
    static let showMemUsageFor4kCtx = "showMemUsageFor4kCtx"
    static let runAtMaxContext = "runAtMaxContext"
  }

  private static let defaults = UserDefaults.standard

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
      guard defaults.bool(forKey: Keys.exposeToNetwork) != newValue else { return }
      defaults.set(newValue, forKey: Keys.exposeToNetwork)
      NotificationCenter.default.post(name: .LBUserSettingsDidChange, object: nil)
    }
  }

  /// Whether to show estimated memory usage next to size on disk.
  /// Shows 4k context by default, or device-capable context when 'Run at max context' is enabled.
  /// Defaults to `false`.
  static var showMemUsageFor4kCtx: Bool {
    get {
      defaults.bool(forKey: Keys.showMemUsageFor4kCtx)
    }
    set {
      guard defaults.bool(forKey: Keys.showMemUsageFor4kCtx) != newValue else { return }
      defaults.set(newValue, forKey: Keys.showMemUsageFor4kCtx)
      NotificationCenter.default.post(name: .LBUserSettingsDidChange, object: nil)
    }
  }

  /// Whether to run models at their maximum supported context window instead of the default 4k.
  /// Defaults to `false`.
  static var runAtMaxContext: Bool {
    get {
      defaults.bool(forKey: Keys.runAtMaxContext)
    }
    set {
      guard defaults.bool(forKey: Keys.runAtMaxContext) != newValue else { return }
      defaults.set(newValue, forKey: Keys.runAtMaxContext)
      NotificationCenter.default.post(name: .LBUserSettingsDidChange, object: nil)
    }
  }
}
