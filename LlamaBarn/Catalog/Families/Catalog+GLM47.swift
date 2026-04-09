import Foundation

extension Catalog {
  static let glm47 = ModelFamily(
    name: "GLM 4.7",
    series: "z",
    description:
      "Zhipu AI's agentic reasoning and coding models. Built for software engineering, browser automation, and multi-turn tool use.",
    serverArgs: nil,
    sizes: [
      ModelSize(
        name: "Flash",
        parameterCount: 29_943_393_920,
        releaseDate: date(2026, 1, 19),
        ctxWindow: 202_752,
        ctxBytesPer1kTokens: 110_886_912,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 31_842_799_232,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/GLM-4.7-Flash-GGUF/resolve/main/GLM-4.7-Flash-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K",
            fileSize: 18_244_193_920,
            downloadUrl: URL(
              string:
                "https://huggingface.co/ggml-org/GLM-4.7-Flash-GGUF/resolve/main/GLM-4.7-Flash-Q4_K.gguf"
            )!
          )
        ]
      )
    ]
  )
}
