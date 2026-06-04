import Foundation
import os.log

/// The remote model catalog.
///
/// LlamaBarn no longer ships a hard-coded catalog; curation lives on the web at
/// `llama.app`, which also publishes a JSON endpoint the app can
/// consume. We use it for a lightweight in-app "Discover" section — a handful of
/// featured families, one best-fit build each — so a fresh install can get a
/// model running in a couple of clicks without first visiting the website.
///
/// The full browsing experience stays on the web; the app only ever reads the
/// `featured` slice and picks a single device-appropriate build per family.
enum Catalog {
  private static let logger = Logger(subsystem: Logging.subsystem, category: "Catalog")

  /// Published catalog endpoint. Same URL for dev and production builds — the
  /// catalog is environment-agnostic; only the install deeplink scheme differs.
  static let endpoint = URL(string: "https://llama.app/v1/catalog.json")!

  // MARK: - Wire format
  //
  // Mirrors the catalog's published shape: family → size → build. Only the
  // fields the app reads are decoded; everything else (publisher prose, etc.)
  // is the website's concern and is ignored here.

  /// A downloadable quant of a size — the same weights at a given quantization.
  /// Each build carries its own repo since quants sometimes live in different
  /// orgs (e.g. Q4 under the publisher, Q8 mirrored under ggml-org).
  struct Build: Decodable {
    let quant: String?
    let size: String?  // human label, e.g. "5.0 GB"
    let repo: String  // "{org}/{repo}"
  }

  /// A parameter tier within a family, e.g. "Gemma 4 E4B".
  struct Size: Decodable {
    let name: String
    let builds: [Build]
  }

  /// A named release line, e.g. "Gemma 4". Holds the shared metadata.
  struct Family: Decodable {
    let name: String
    let brand: String
    /// Whether the catalog flags this family for in-app highlighting. Absent → false.
    let featured: Bool?
    let sizes: [Size]
  }

  // MARK: - Featured suggestions

  /// One catalog pick, resolved to a single best-fit build for this Mac. This is
  /// the unit the Discover section renders and installs from. The `repo` matches
  /// the `{org}/{repo}` prefix of the model id the resolver produces, so the
  /// Discover section can hide a suggestion once its repo is installed.
  struct Suggestion {
    let brand: String  // "Gemma" — drives the logo
    let sizeName: String  // "Gemma 4 E4B" — the row title
    let repo: String  // "{org}/{repo}"
    let quant: String?  // catalog quant label, e.g. "Q8_0"
    let sizeLabel: String?  // human size, e.g. "5.0 GB"
  }

  /// Fetches the catalog and returns one best-fit suggestion per featured family.
  /// Returns an empty list on any failure — Discover simply doesn't appear, and
  /// the user can still install from the web catalog or via deeplink.
  static func fetchFeatured(systemMemoryMb: UInt64) async -> [Suggestion] {
    let families: [Family]
    do {
      let (data, response) = try await URLSession.shared.data(from: endpoint)
      guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
        logger.error("Catalog fetch returned non-2xx")
        return []
      }
      families = try JSONDecoder().decode([Family].self, from: data)
    } catch {
      logger.error("Catalog fetch failed: \(error.localizedDescription)")
      return []
    }

    let budgetMb = Model.memoryBudget(systemMemoryMb: systemMemoryMb)
    return
      families
      .filter { $0.featured == true }
      .compactMap { bestFit(for: $0, budgetMb: budgetMb) }
  }

  // MARK: - Selection

  /// Picks the single build to suggest for a family: the largest that fits this
  /// Mac's memory budget. Returns nil when no build fits — Discover is a "quick
  /// start" surface, so a family this Mac can't run is dropped entirely rather
  /// than shown as an uninstallable row. If the whole featured set is too big,
  /// the section is empty and the menu falls back to the "Browse models" link.
  private static func bestFit(for family: Family, budgetMb: Double) -> Suggestion? {
    // Flatten to (size, build) candidates, tagging each with its parsed byte size.
    let candidates: [(size: Size, build: Build, bytes: Int64)] =
      family.sizes.flatMap { size in
        size.builds.map { build in (size, build, parseBytes(build.size)) }
      }

    // A build fits when its estimated weight memory is within budget. Unknown
    // sizes are treated as fitting (don't hide), matching the resolver's posture.
    func fits(_ bytes: Int64) -> Bool {
      guard bytes > 0 else { return true }
      let weightMb = Double(bytes) / 1_048_576.0 * 1.05
      return weightMb <= budgetMb
    }

    let fitting = candidates.filter { fits($0.bytes) }
    guard let chosen = fitting.max(by: { $0.bytes < $1.bytes }) else { return nil }

    return Suggestion(
      brand: family.brand,
      sizeName: chosen.size.name,
      repo: chosen.build.repo,
      quant: chosen.build.quant,
      sizeLabel: chosen.build.size
    )
  }

  /// Parses catalog size strings like "5.0 GB", "806 MB", "12.1 GB" into bytes.
  /// Uses decimal units (1 GB = 1e9) to match how the catalog and download UI
  /// report sizes. Returns 0 when missing or unparseable.
  private static func parseBytes(_ label: String?) -> Int64 {
    guard let label = label?.trimmingCharacters(in: .whitespaces), !label.isEmpty else { return 0 }
    let parts = label.split(separator: " ")
    guard let value = Double(parts.first ?? "") else { return 0 }
    let unit = parts.count > 1 ? parts[1].uppercased() : "GB"
    let multiplier: Double
    switch unit {
    case "GB", "G": multiplier = 1_000_000_000
    case "MB", "M": multiplier = 1_000_000
    case "KB", "K": multiplier = 1_000
    default: multiplier = 1_000_000_000
    }
    return Int64(value * multiplier)
  }
}

extension Catalog.Suggestion {
  /// Brand logo asset in `Assets.xcassets/ModelLogos`, matched from the catalog
  /// `brand`. Nil when the brand has no known mark — the row falls back to a
  /// generic system symbol. Keyed on brand (not family) since the catalog gives
  /// us the brand directly, e.g. "OpenAI" → the GPT mark.
  var brandLogoAsset: String? {
    let key = brand.lowercased()
    let brands: [(keyword: String, asset: String)] = [
      ("qwen", "qwen"),
      ("gemma", "gemma"),
      ("openai", "gpt"),
      ("gpt", "gpt"),
      ("mistral", "mistral"),
      ("ministral", "mistral"),
      ("devstral", "mistral"),
      ("glm", "z"),
      ("nemotron", "nvidia"),
      ("nvidia", "nvidia"),
    ]
    guard let asset = brands.first(where: { key.contains($0.keyword) })?.asset else { return nil }
    return "ModelLogos/\(asset)"
  }
}
