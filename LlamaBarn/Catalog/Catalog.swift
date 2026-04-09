import Foundation

/// Static catalog of available AI models with their configurations and metadata
enum Catalog {

  // MARK: - Public Accessors

  /// Non-deprecated families, used for the catalog browse view.
  static var activeFamilies: [ModelFamily] {
    families.filter { !$0.deprecated }
  }

  /// Returns all catalog entries by traversing the hierarchy
  static func allModels() -> [CatalogEntry] {
    families.flatMap { $0.allModels }
  }

  /// Finds a catalog entry by ID by traversing the hierarchy
  static func findModel(id: String) -> CatalogEntry? {
    allModels().first { $0.id == id }
  }

  // MARK: - Helpers

  /// Helper to create dates concisely for model release dates
  static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
  }

  /// Builds a CatalogEntry from hierarchy components
  static func entry(family: ModelFamily, size: ModelSize, build: ModelBuild)
    -> CatalogEntry
  {
    let effectiveArgs =
      (family.serverArgs ?? []) + (size.serverArgs ?? []) + (build.serverArgs ?? [])

    // Primary build = the one in size.build (higher quality, e.g. Q8)
    // Quantized builds = the ones in size.quantizedBuilds (lower quality, e.g. Q4)
    let isFullPrecision = build.downloadUrl == size.build.downloadUrl

    // Generate ID from family name + size, normalized to lowercase with dashes.
    // Quantized builds get a "-q4" suffix to distinguish them.
    let baseId = "\(family.name) \(size.name)"
      .lowercased()
      .replacingOccurrences(of: " ", with: "-")
    let id = isFullPrecision ? baseId : "\(baseId)-q4"

    return CatalogEntry(
      id: id,
      family: family.name,
      parameterCount: size.parameterCount,
      size: size.name,
      ctxWindow: size.ctxWindow,
      fileSize: build.fileSize,
      ctxBytesPer1kTokens: size.ctxBytesPer1kTokens,
      overheadMultiplier: family.overheadMultiplier,
      downloadUrl: build.downloadUrl,
      additionalParts: build.additionalParts,
      mmprojUrl: size.mmproj,
      mmprojLocalFilename: size.mmprojLocalFilename,
      serverArgs: effectiveArgs,
      icon: family.iconName,
      quantization: build.quantization,
      isFullPrecision: isFullPrecision
    )
  }

}
