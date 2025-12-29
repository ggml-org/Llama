import Foundation

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
