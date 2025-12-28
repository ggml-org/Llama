import Foundation

/// Static catalog of available AI models with their configurations and metadata
enum Catalog {

  // MARK: - Data Structures

  struct ModelFamily {
    let name: String  // e.g. "Qwen3 2507"
    let series: String  // e.g. "qwen"
    let serverArgs: [String]?  // optional defaults for all models/builds
    let overheadMultiplier: Double  // overhead multiplier for file size
    let sizes: [ModelSize]

    init(
      name: String,
      series: String,
      serverArgs: [String]? = nil,
      overheadMultiplier: Double = 1.05,
      sizes: [ModelSize]
    ) {
      self.name = name
      self.series = series
      self.serverArgs = serverArgs
      self.overheadMultiplier = overheadMultiplier
      self.sizes = sizes.sorted { $0.parameterCount < $1.parameterCount }
    }

    var iconName: String {
      "ModelLogos/\(series.lowercased())"
    }

    var allModels: [CatalogEntry] {
      sizes.flatMap { size in
        ([size.build] + size.quantizedBuilds).map { build in
          Catalog.entry(family: self, size: size, build: build)
        }
      }
    }

    func selectableModels() -> [CatalogEntry] {
      let compatibleModels = allModels.filter { $0.isCompatible() }

      // Group by size (e.g., "27B") to pick the preferred version
      let modelsBySize = Dictionary(grouping: compatibleModels, by: { $0.size })

      return modelsBySize.values.compactMap { models in
        bestModel(in: models)
      }.sorted(by: CatalogEntry.displayOrder(_:_:))
    }

    private func bestModel(in models: [CatalogEntry]) -> CatalogEntry? {
      // Prefer full precision, fallback to quantized
      return models.first(where: { $0.isFullPrecision })
        ?? models.first(where: { !$0.isFullPrecision })
    }
  }

  struct ModelSize {
    let name: String  // e.g. "4B", "30B"
    let parameterCount: Int64  // Total model parameters
    let releaseDate: Date
    let ctxWindow: Int
    /// Estimated KV-cache bytes needed for a 1k-token context.
    let ctxBytesPer1kTokens: Int
    let serverArgs: [String]?  // optional defaults for all builds
    let mmproj: URL?  // optional vision projection file for multimodal models
    let build: ModelBuild
    let quantizedBuilds: [ModelBuild]

    init(
      name: String,
      parameterCount: Int64,
      releaseDate: Date,
      ctxWindow: Int,
      ctxBytesPer1kTokens: Int,
      serverArgs: [String]? = nil,
      mmproj: URL? = nil,
      build: ModelBuild,
      quantizedBuilds: [ModelBuild] = []
    ) {
      self.name = name
      self.parameterCount = parameterCount
      self.releaseDate = releaseDate
      self.ctxWindow = ctxWindow
      self.ctxBytesPer1kTokens = ctxBytesPer1kTokens
      self.serverArgs = serverArgs
      self.mmproj = mmproj
      self.build = build
      self.quantizedBuilds = quantizedBuilds
    }
  }

  struct ModelBuild {
    let id: String  // unique identifier
    let quantization: String
    let fileSize: Int64
    let downloadUrl: URL
    let additionalParts: [URL]?
    let serverArgs: [String]?

    init(
      id: String,
      quantization: String,
      fileSize: Int64,
      downloadUrl: URL,
      additionalParts: [URL]? = nil,
      serverArgs: [String]? = nil
    ) {
      self.id = id
      self.quantization = quantization
      self.fileSize = fileSize
      self.downloadUrl = downloadUrl
      self.additionalParts = additionalParts
      self.serverArgs = serverArgs
    }
  }

  // MARK: - Public Data

  // MARK: - Public Accessors

  /// Returns all catalog entries by traversing the hierarchy
  static func allModels() -> [CatalogEntry] {
    families.flatMap { $0.allModels }
  }

  /// Finds a catalog entry by ID by traversing the hierarchy
  static func findModel(id: String) -> CatalogEntry? {
    allModels().first { $0.id == id }
  }

  // MARK: - Memory Calculations

  // Moved to CatalogEntry+Compatibility.swift

  // MARK: - Private Helpers

  /// Builds a CatalogEntry from hierarchy components
  static func entry(family: ModelFamily, size: ModelSize, build: ModelBuild)
    -> CatalogEntry
  {
    let effectiveArgs =
      (family.serverArgs ?? []) + (size.serverArgs ?? []) + (build.serverArgs ?? [])

    let isFullPrecision = build.id == size.build.id

    return CatalogEntry(
      id: build.id,
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
      serverArgs: effectiveArgs,
      icon: family.iconName,
      quantization: build.quantization,
      isFullPrecision: isFullPrecision
    )
  }

}
