import Foundation

extension Catalog {
  static let qwen35Small = ModelFamily(
    name: "Qwen 3.5 Small",
    series: "qwen",
    description:
      "Alibaba's compact natively multimodal reasoning models. Supports thinking/non-thinking modes for text and vision tasks across 201 languages.",
    serverArgs: ["--temp", "0.6", "--top-k", "20", "--top-p", "0.95", "--min-p", "0"],
    overheadMultiplier: 1.1,
    sizes: [
      ModelSize(
        name: "0.8B",
        parameterCount: 758_372_368,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 12_582_912,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-0.8B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 811_843_840,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 532_517_120,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "2B",
        parameterCount: 1_887_854_608,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 12_582_912,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-2B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-2B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 2_012_012_800,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-2B-GGUF/resolve/main/Qwen3.5-2B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 1_280_835_840,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-2B-GGUF/resolve/main/Qwen3.5-2B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "4B",
        parameterCount: 4_212_196_816,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 33_554_432,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-4B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 4_482_403_488,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_740_937_888,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "9B",
        parameterCount: 8_960_348_656,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 33_554_432,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-9B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 9_527_502_048,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 5_680_522_464,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
    ]
  )
}
