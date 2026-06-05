import Foundation
import os.log

/// Resolves the `llama` executable the app drives, and classifies who owns it.
///
/// The app follows a shared-path model:
/// - it owns the curl-install path (`~/.installama/llama`, what `installama.sh`
///   produces): it may install a binary there and keep it updated
/// - any other install (e.g. Homebrew) is treated as external: the app uses it
///   but never modifies it
///
/// `llama` is the unified llama.cpp executable -- the server is `llama serve`
/// and memory profiling is `llama fit-params`, both subcommands of this one
/// binary. There is no separate `llama-server` / `llama-fit-params` to find.
enum LlamaBinaries {

  private static let logger = Logger(subsystem: Logging.subsystem, category: "LlamaBinaries")

  /// The curl-install path the app owns (matches `installama.sh`'s layout).
  /// The real binary lives in `~/.installama`; `installama.sh` also drops a
  /// `~/.local/bin/llama` symlink onto PATH, but the app points at the real file.
  static let appOwnedPath: String =
    (NSHomeDirectory() as NSString).appendingPathComponent(".installama/llama")

  /// External locations to probe when the app hasn't installed its own binary.
  /// Covers the Homebrew bin dirs (Apple Silicon and Intel).
  private static let externalDirs = ["/opt/homebrew/bin", "/usr/local/bin"]

  /// Where the `llama` binary is and who owns it.
  enum Resolution: Equatable {
    /// App-managed binary at the curl-install path; the app may update it.
    case appOwned(path: String)
    /// A pre-existing install (e.g. Homebrew); use it but never modify it.
    case external(path: String)
    /// No `llama` binary found anywhere; the install flow needs to run.
    case missing
  }

  /// Resolves the active `llama` binary. The app-owned path wins, then the
  /// external locations in order, else `.missing`.
  static func resolve() -> Resolution {
    let fm = FileManager.default

    if fm.isExecutableFile(atPath: appOwnedPath) {
      return .appOwned(path: appOwnedPath)
    }

    for dir in externalDirs {
      let path = dir + "/llama"
      if fm.isExecutableFile(atPath: path) {
        return .external(path: path)
      }
    }

    return .missing
  }

  /// The path to the `llama` binary to invoke, or `nil` if none is installed.
  static var llamaPath: String? {
    switch resolve() {
    case .appOwned(let path), .external(let path):
      logger.debug("Using llama binary at \(path, privacy: .public)")
      return path
    case .missing:
      logger.error("No llama binary found")
      return nil
    }
  }
}
