import Foundation

extension Catalog {
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
      self.sizes = sizes
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
  }

  struct ModelSize {
    let name: String  // e.g. "4B", "30B"
    let parameterCount: Int64  // Total model parameters
    let releaseDate: Date
    let ctxWindow: Int
    let serverArgs: [String]?  // optional defaults for all builds
    let mmproj: URL?  // optional vision projection file for multimodal models
    let build: ModelBuild
    let quantizedBuilds: [ModelBuild]

    init(
      name: String,
      parameterCount: Int64,
      releaseDate: Date,
      ctxWindow: Int,
      serverArgs: [String]? = nil,
      mmproj: URL? = nil,
      build: ModelBuild,
      quantizedBuilds: [ModelBuild] = []
    ) {
      self.name = name
      self.parameterCount = parameterCount
      self.releaseDate = releaseDate
      self.ctxWindow = ctxWindow
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
    /// Estimated KV-cache bytes needed for a 1k-token context.
    let ctxBytesPer1kTokens: Int
    let downloadUrl: URL
    let additionalParts: [URL]?
    let serverArgs: [String]?

    init(
      id: String,
      quantization: String,
      fileSize: Int64,
      ctxBytesPer1kTokens: Int,
      downloadUrl: URL,
      additionalParts: [URL]? = nil,
      serverArgs: [String]? = nil
    ) {
      self.id = id
      self.quantization = quantization
      self.fileSize = fileSize
      self.ctxBytesPer1kTokens = ctxBytesPer1kTokens
      self.downloadUrl = downloadUrl
      self.additionalParts = additionalParts
      self.serverArgs = serverArgs
    }
  }
}
