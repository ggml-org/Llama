import Foundation

extension Catalog {
  static let gemma3 = ModelFamily(
    name: "Gemma 3",
    series: "gemma",
    description:
      "Google's multimodal models built from Gemini technology. Supports 140+ languages, vision, and text tasks with up to 128K context for edge to cloud deployment.",
    serverArgs: nil,
    overheadMultiplier: 1.3,
    sizes: [
      ModelSize(
        name: "27B",
        parameterCount: 27_432_406_640,
        releaseDate: date(2025, 4, 24),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 83_886_080,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/mmproj-model-f16-27B.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q4_0",
          fileSize: 15_908_791_488,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/gemma-3-27b-it-qat-Q4_0.gguf"
          )!
        )
      ),
      ModelSize(
        name: "12B",
        parameterCount: 12_187_325_040,
        releaseDate: date(2025, 4, 21),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 67_108_864,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/mmproj-model-f16-12B.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q4_0",
          fileSize: 7_131_017_792,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/gemma-3-12b-it-qat-Q4_0.gguf"
          )!
        )
      ),
      ModelSize(
        name: "4B",
        parameterCount: 4_300_079_472,
        releaseDate: date(2025, 4, 22),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 20_971_520,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-3-4b-it-qat-GGUF/resolve/main/mmproj-model-f16-4B.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q4_0",
          fileSize: 2_526_080_992,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-3-4b-it-qat-GGUF/resolve/main/gemma-3-4b-it-qat-Q4_0.gguf"
          )!
        )
      ),
      ModelSize(
        name: "1B",
        parameterCount: 999_885_952,
        releaseDate: date(2025, 8, 27),
        ctxWindow: 32_768,
        ctxBytesPer1kTokens: 4_194_304,
        build: ModelBuild(
          quantization: "Q4_0",
          fileSize: 720_425_600,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-3-1b-it-qat-GGUF/resolve/main/gemma-3-1b-it-qat-Q4_0.gguf"
          )!
        )
      ),
      ModelSize(
        name: "270M",
        parameterCount: 268_098_176,
        releaseDate: date(2025, 8, 14),
        ctxWindow: 32_768,
        ctxBytesPer1kTokens: 3_145_728,
        build: ModelBuild(
          quantization: "Q4_0",
          fileSize: 241_410_624,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-3-270m-it-qat-GGUF/resolve/main/gemma-3-270m-it-qat-Q4_0.gguf"
          )!
        )
      ),
    ]
  )
}
