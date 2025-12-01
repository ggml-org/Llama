import ServiceManagement
import SwiftUI

struct SettingsView: View {
  @State private var launchAtLogin = LaunchAtLogin.isEnabled
  @State private var showQuantizedModels = UserSettings.showQuantizedModels
  @State private var showIncompatibleFamilies = UserSettings.showIncompatibleFamilies

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        VStack(alignment: .leading, spacing: 3) {
          Text("Launch at Login")
          Text("Automatically start LlamaBarn when you log in.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        Spacer()
        Toggle(
          "",
          isOn: Binding(
            get: { launchAtLogin },
            set: { newValue in
              if LaunchAtLogin.setEnabled(newValue) {
                launchAtLogin = newValue
              }
            }
          )
        )
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle())
      }
      HStack {
        VStack(alignment: .leading, spacing: 3) {
          Text("Show quantized models")
          Text("Show compressed versions of models (e.g. Q4_K_M) in addition to full precision.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        Spacer()
        Toggle("", isOn: $showQuantizedModels)
          .labelsHidden()
          .toggleStyle(SwitchToggleStyle())
          .onChange(of: showQuantizedModels) { _, newValue in
            UserSettings.showQuantizedModels = newValue
          }
      }
      HStack {
        VStack(alignment: .leading, spacing: 3) {
          Text("Show incompatible families")
          Text("Shows families that don't have any models compatible with your device.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        Spacer()
        Toggle("", isOn: $showIncompatibleFamilies)
          .labelsHidden()
          .toggleStyle(SwitchToggleStyle())
          .onChange(of: showIncompatibleFamilies) { _, newValue in
            UserSettings.showIncompatibleFamilies = newValue
          }
      }
    }
  }
}

#Preview {
  SettingsView()
}
