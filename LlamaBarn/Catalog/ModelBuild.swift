import Foundation

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
