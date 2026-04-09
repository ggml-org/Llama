import Foundation

extension Catalog {
  static let qwen3VL = ModelFamily(
    name: "Qwen3 VL",
    series: "qwen",
    description:
      "Alibaba's vision-language model for understanding text, images, and video. Features OCR in 32 languages, GUI agents, and spatial reasoning.",
    serverArgs: ["--temp", "0.7", "--top-p", "0.8", "--top-k", "20"],
    overheadMultiplier: 1.1,
    deprecated: true,
    sizes: [
      ModelSize(
        name: "2B",
        parameterCount: 2_127_532_032,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 117_440_512,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-2B-Instruct-GGUF/resolve/main/mmproj-Qwen3VL-2B-Instruct-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 1_834_427_424,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-2B-Instruct-GGUF/resolve/main/Qwen3VL-2B-Instruct-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 1_107_409_952,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-2B-Instruct-GGUF/resolve/main/Qwen3VL-2B-Instruct-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "2B Thinking",
        parameterCount: 2_127_532_032,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 117_440_512,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-2B-Thinking-GGUF/resolve/main/mmproj-Qwen3VL-2B-Thinking-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 1_834_427_360,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-2B-Thinking-GGUF/resolve/main/Qwen3VL-2B-Thinking-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 1_107_409_888,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-2B-Thinking-GGUF/resolve/main/Qwen3VL-2B-Thinking-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "4B",
        parameterCount: 4_437_815_808,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 150_994_944,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-4B-Instruct-GGUF/resolve/main/mmproj-Qwen3VL-4B-Instruct-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 4_280_406_144,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-4B-Instruct-GGUF/resolve/main/Qwen3VL-4B-Instruct-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_497_281_664,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-4B-Instruct-GGUF/resolve/main/Qwen3VL-4B-Instruct-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "4B Thinking",
        parameterCount: 4_437_815_808,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 150_994_944,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-4B-Thinking-GGUF/resolve/main/mmproj-Qwen3VL-4B-Thinking-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 4_280_405_952,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-4B-Thinking-GGUF/resolve/main/Qwen3VL-4B-Thinking-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_497_281_472,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-4B-Thinking-GGUF/resolve/main/Qwen3VL-4B-Thinking-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "8B",
        parameterCount: 8_767_123_696,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 150_994_944,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-8B-Instruct-GGUF/resolve/main/mmproj-Qwen3VL-8B-Instruct-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 8_709_519_456,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-8B-Instruct-GGUF/resolve/main/Qwen3VL-8B-Instruct-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 5_027_784_800,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-8B-Instruct-GGUF/resolve/main/Qwen3VL-8B-Instruct-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "8B Thinking",
        parameterCount: 8_767_123_696,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 150_994_944,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-8B-Thinking-GGUF/resolve/main/mmproj-Qwen3VL-8B-Thinking-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 8_709_519_360,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-8B-Thinking-GGUF/resolve/main/Qwen3VL-8B-Thinking-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 5_027_784_704,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-8B-Thinking-GGUF/resolve/main/Qwen3VL-8B-Thinking-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "30B-A3B",
        parameterCount: 31_070_754_032,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 100_663_296,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Instruct-GGUF/resolve/main/mmproj-Qwen3VL-30B-A3B-Instruct-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 32_483_932_992,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Instruct-GGUF/resolve/main/Qwen3VL-30B-A3B-Instruct-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 18_556_687_168,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Instruct-GGUF/resolve/main/Qwen3VL-30B-A3B-Instruct-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "30B-A3B Thinking",
        parameterCount: 31_070_754_032,
        releaseDate: date(2025, 10, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 100_663_296,
        mmproj: URL(
          string:
            "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Thinking-GGUF/resolve/main/mmproj-Qwen3VL-30B-A3B-Thinking-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 32_483_933_024,
          downloadUrl: URL(
            string:
              "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Thinking-GGUF/resolve/main/Qwen3VL-30B-A3B-Thinking-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 18_556_687_200,
            downloadUrl: URL(
              string:
                "https://huggingface.co/Qwen/Qwen3-VL-30B-A3B-Thinking-GGUF/resolve/main/Qwen3VL-30B-A3B-Thinking-Q4_K_M.gguf"
            )!
          )
        ]
      ),
    ]
  )
}
