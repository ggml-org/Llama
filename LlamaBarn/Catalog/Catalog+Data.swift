import Foundation

extension Catalog {
  /// All model families in the catalog. Each family is defined in its own file
  /// under Families/. Active families are shown in the catalog for new downloads;
  /// deprecated families only match installed models to preserve their curated metadata.
  static let families: [ModelFamily] = [
    // Active
    gptOss,
    gemma3,
    gemma4,
    qwen35Small,
    qwen35Medium,
    nemotronNano3,
    ministral3,
    glm47,
    devstral2,

    // Deprecated
    qwen3,
    qwen3VL,
    qwen3Coder,
  ]
}
