import Foundation

extension Catalog {
  static let qwen36 = ModelFamily(
    name: "Qwen 3.6",
    series: "qwen",
    description:
      "Alibaba's next-gen natively multimodal reasoning models. Dense and MoE variants that rival models many times their size on coding and vision tasks.",
    serverArgs: ["--temp", "0.6", "--top-k", "20", "--top-p", "0.95", "--min-p", "0"],
    overheadMultiplier: 1.1,
    sizes: [
      ModelSize(
        name: "27B",
        parameterCount: 26_895_998_464,
        releaseDate: date(2026, 4, 18),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 67_108_864,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.6-27B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 28_595_763_424,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/resolve/main/Qwen3.6-27B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 16_817_244_384,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/resolve/main/Qwen3.6-27B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "35B-A3B",
        parameterCount: 34_660_610_688,
        releaseDate: date(2026, 4, 18),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 20_971_520,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.6-35B-A3B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 36_903_140_320,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 22_134_528_992,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf"
            )!
          )
        ]
      ),
    ]
  )
}
