import SwiftUI

struct FooterButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(Font(Typography.secondary))
      // fixes: inverse color on mouse down
      .foregroundColor(Color(nsColor: .controlTextColor))
      .padding(.horizontal, 5)
      .padding(.vertical, 2)
      .background(Color(nsColor: .lbSubtleBackground))
      .cornerRadius(5)
      .controlSize(.small)
  }
}

struct FooterView: View {
  var onCheckForUpdates: () -> Void
  var onOpenSettings: () -> Void
  var onQuit: () -> Void

  var body: some View {
    HStack(spacing: 0) {
      Button(action: onCheckForUpdates) {
        Text(appVersionText)
          .font(Font(Typography.primary))
          .foregroundColor(Color(nsColor: .tertiaryLabelColor))
      }
      .buttonStyle(.plain)

      Text(" · llama.cpp \(AppInfo.llamaCppVersion)")
        .font(Font(Typography.primary))
        .foregroundColor(Color(nsColor: .tertiaryLabelColor))

      Spacer()

      Button("Settings", action: onOpenSettings)
        .buttonStyle(FooterButtonStyle())
        .keyboardShortcut(",")

      Button("Quit", action: onQuit)
        .buttonStyle(FooterButtonStyle())
        .padding(.leading, 5)
    }
    .padding(.horizontal, Layout.outerHorizontalPadding + Layout.innerHorizontalPadding)
    .padding(.vertical, 6)
    .frame(width: Layout.menuWidth)
  }

  private var appVersionText: String {
    #if DEBUG
      return "🔨"
    #else
      return AppInfo.shortVersion == "0.0.0"
        ? "build \(AppInfo.buildNumber)"
        : AppInfo.shortVersion
    #endif
  }
}
