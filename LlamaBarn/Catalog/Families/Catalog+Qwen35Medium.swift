import Foundation

extension Catalog {
  static let qwen35Medium = ModelFamily(
    name: "Qwen 3.5 Medium",
    series: "qwen",
    description:
      "Alibaba's flagship natively multimodal reasoning models. Dense and MoE variants that rival models many times their size on coding and vision tasks.",
    serverArgs: ["--temp", "0.6", "--top-k", "20", "--top-p", "0.95", "--min-p", "0"],
    overheadMultiplier: 1.1,
    sizes: [
      ModelSize(
        name: "27B",
        parameterCount: 26_883_041_792,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 67_108_864,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-27B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-27B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 28_595_763_104,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-27B-GGUF/resolve/main/Qwen3.5-27B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 16_740_812_704,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-27B-GGUF/resolve/main/Qwen3.5-27B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "35B-A3B",
        parameterCount: 34_691_457_024,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 20_971_520,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-35B-A3B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 36_903_139_968,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF/resolve/main/Qwen3.5-35B-A3B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 22_016_023_168,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF/resolve/main/Qwen3.5-35B-A3B-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "122B-A10B",
        parameterCount: 122_000_000_000,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 25_165_824,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-122B-A10B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 129_871_935_040,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q8_0/Qwen3.5-122B-A10B-Q8_0-00001-of-00004.gguf"
          )!,
          additionalParts: [
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q8_0/Qwen3.5-122B-A10B-Q8_0-00002-of-00004.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q8_0/Qwen3.5-122B-A10B-Q8_0-00003-of-00004.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q8_0/Qwen3.5-122B-A10B-Q8_0-00004-of-00004.gguf"
            )!,
          ]
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 76_536_964_608,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q4_K_M/Qwen3.5-122B-A10B-Q4_K_M-00001-of-00003.gguf"
            )!,
            additionalParts: [
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q4_K_M/Qwen3.5-122B-A10B-Q4_K_M-00002-of-00003.gguf"
              )!,
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/Q4_K_M/Qwen3.5-122B-A10B-Q4_K_M-00003-of-00003.gguf"
              )!,
            ]
          )
        ]
      ),
      ModelSize(
        name: "397B-A17B",
        parameterCount: 397_000_000_000,
        releaseDate: date(2026, 3, 3),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 31_457_280,
        mmproj: URL(
          string:
            "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/mmproj-F16.gguf"
        )!,
        mmprojLocalFilename: "Qwen3.5-397B-A17B-mmproj-F16.gguf",
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 421_507_365_376,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00001-of-00010.gguf"
          )!,
          additionalParts: [
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00002-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00003-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00004-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00005-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00006-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00007-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00008-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00009-of-00010.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q8_0/Qwen3.5-397B-A17B-Q8_0-00010-of-00010.gguf"
            )!,
          ]
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 244_093_630_912,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q4_K_M/Qwen3.5-397B-A17B-Q4_K_M-00001-of-00006.gguf"
            )!,
            additionalParts: [
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q4_K_M/Qwen3.5-397B-A17B-Q4_K_M-00002-of-00006.gguf"
              )!,
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q4_K_M/Qwen3.5-397B-A17B-Q4_K_M-00003-of-00006.gguf"
              )!,
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q4_K_M/Qwen3.5-397B-A17B-Q4_K_M-00004-of-00006.gguf"
              )!,
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q4_K_M/Qwen3.5-397B-A17B-Q4_K_M-00005-of-00006.gguf"
              )!,
              URL(
                string:
                  "https://huggingface.co/unsloth/Qwen3.5-397B-A17B-GGUF/resolve/main/Q4_K_M/Qwen3.5-397B-A17B-Q4_K_M-00006-of-00006.gguf"
              )!,
            ]
          )
        ]
      ),
    ]
  )
}
