import Foundation

extension Catalog {
  static let gemma4 = ModelFamily(
    name: "Gemma 4",
    series: "gemma",
    description:
      "Google's most capable open models, built from Gemini 3 technology. Supports multimodal reasoning, agentic workflows, and 140+ languages.",
    serverArgs: nil,
    overheadMultiplier: 1.3,
    sizes: [
      ModelSize(
        name: "31B",
        parameterCount: 31_273_088_876,
        releaseDate: date(2026, 4, 1),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 335_544_320,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-4-31B-it-GGUF/resolve/main/mmproj-gemma-4-31B-it-bf16.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 32_635_674_400,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-4-31B-it-GGUF/resolve/main/gemma-4-31B-it-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 18_687_061_792,
            downloadUrl: URL(
              string:
                "https://huggingface.co/ggml-org/gemma-4-31B-it-GGUF/resolve/main/gemma-4-31B-it-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "26B-A4B",
        parameterCount: 25_805_936_206,
        releaseDate: date(2026, 4, 1),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 83_886_080,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-4-26B-A4B-it-GGUF/resolve/main/mmproj-gemma-4-26B-A4B-it-bf16.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 26_859_858_464,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-4-26B-A4B-it-GGUF/resolve/main/gemma-4-26B-A4B-it-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 16_796_015_136,
            downloadUrl: URL(
              string:
                "https://huggingface.co/ggml-org/gemma-4-26B-A4B-it-GGUF/resolve/main/gemma-4-26B-A4B-it-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "E4B",
        parameterCount: 7_996_156_490,
        releaseDate: date(2026, 4, 1),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 29_360_128,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-4-E4B-it-GGUF/resolve/main/mmproj-gemma-4-E4B-it-bf16.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 8_031_240_160,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-4-E4B-it-GGUF/resolve/main/gemma-4-E4B-it-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 5_335_289_824,
            downloadUrl: URL(
              string:
                "https://huggingface.co/ggml-org/gemma-4-E4B-it-GGUF/resolve/main/gemma-4-E4B-it-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "E2B",
        parameterCount: 5_123_178_051,
        releaseDate: date(2026, 4, 1),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 10_485_760,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/gemma-4-E2B-it-GGUF/resolve/main/mmproj-gemma-4-E2B-it-bf16.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 4_967_494_592,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gemma-4-E2B-it-GGUF/resolve/main/gemma-4-E2B-it-Q8_0.gguf"
          )!
        )
      ),
    ]
  )
}
