import SwiftUI

/// Settings window controller -- manages the settings window lifecycle.
/// Uses SwiftUI for the content but AppKit for window management to ensure
/// proper behavior as a menu bar app (no dock icon, proper activation).
@MainActor
final class SettingsWindowController: NSObject, NSWindowDelegate {
  static let shared = SettingsWindowController()

  private var window: NSWindow?
  private var observer: NSObjectProtocol?

  private override init() {
    super.init()
    // Listen for settings show requests
    observer = NotificationCenter.default.addObserver(
      forName: .LBShowSettings, object: nil, queue: .main
    ) { [weak self] _ in
      MainActor.assumeIsolated {
        self?.showSettings()
      }
    }
  }

  func showSettings() {
    // If window exists, just bring it to front
    if let window, window.isVisible {
      NSApp.setActivationPolicy(.regular)
      window.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
      return
    }

    // Create the SwiftUI content view
    let contentView = SettingsView()

    // Create the window
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 340, height: 280),
      styleMask: [.titled, .closable],
      backing: .buffered,
      defer: false
    )
    window.title = "Settings"
    window.contentView = NSHostingView(rootView: contentView)
    window.center()
    window.isReleasedWhenClosed = false
    window.delegate = self

    self.window = window

    // Show window and activate app
    NSApp.setActivationPolicy(.regular)
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  func windowWillClose(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)
  }
}

/// SwiftUI view for settings content.
struct SettingsView: View {
  @State private var launchAtLogin = LaunchAtLogin.isEnabled
  @State private var sleepIdleTime = UserSettings.sleepIdleTime
  @State private var enabledTiers = UserSettings.enabledContextTiers

  var body: some View {
    Form {
      // Launch at login toggle
      Toggle("Launch at login", isOn: $launchAtLogin)
        .onChange(of: launchAtLogin) { _, newValue in
          _ = LaunchAtLogin.setEnabled(newValue)
        }

      Divider()

      // Sleep idle time picker
      VStack(alignment: .leading, spacing: 4) {
        Picker("Unload when idle", selection: $sleepIdleTime) {
          ForEach(UserSettings.SleepIdleTime.allCases, id: \.self) { time in
            Text(time.displayName).tag(time)
          }
        }
        .pickerStyle(.segmented)
        .onChange(of: sleepIdleTime) { _, newValue in
          UserSettings.sleepIdleTime = newValue
        }

        Text("Automatically unloads the model from memory when not in use.")
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Divider()

      // Context tiers selection
      VStack(alignment: .leading, spacing: 8) {
        Text("Context variants")
          .font(.headline)

        // Grid of toggles for each tier option
        LazyVGrid(
          columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
          ], spacing: 8
        ) {
          ForEach(UserSettings.ContextTierOption.allCases, id: \.self) { option in
            Toggle(
              option.label,
              isOn: Binding(
                get: { enabledTiers.contains(option.rawValue) },
                set: { enabled in
                  if enabled {
                    enabledTiers.insert(option.rawValue)
                  } else {
                    enabledTiers.remove(option.rawValue)
                  }
                  UserSettings.enabledContextTiers = enabledTiers
                }
              )
            )
            .toggleStyle(.checkbox)
          }
        }

        Text("Select which context lengths to show for installed models.")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .formStyle(.grouped)
    .frame(width: 340)
    .fixedSize()
  }
}

#Preview {
  SettingsView()
}
