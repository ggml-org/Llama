import Foundation

extension Catalog {
  static let ministral3 = ModelFamily(
    name: "Ministral 3",
    series: "mistral",
    description:
      "Mistral AI's compact edge models with vision capabilities. Offers best cost-to-performance ratio for on-device deployment in 3B, 8B, 14B sizes.",
    serverArgs: nil,
    sizes: [
      ModelSize(
        name: "3B",
        parameterCount: 4_000_000_000,
        releaseDate: date(2025, 12, 2),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 106_496_000,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Ministral-3-3B-Instruct-2512-GGUF/resolve/main/mmproj-Ministral-3-3B-Instruct-2512-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 3_913_606_144,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Ministral-3-3B-Instruct-2512-GGUF/resolve/main/Ministral-3-3B-Instruct-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_147_023_008,
            downloadUrl: URL(
              string:
                "https://huggingface.co/mistralai/Ministral-3-3B-Instruct-2512-GGUF/resolve/main/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "3B Reasoning",
        parameterCount: 4_000_000_000,
        releaseDate: date(2025, 12, 2),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 106_496_000,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Ministral-3-3B-Reasoning-2512-GGUF/resolve/main/mmproj-Ministral-3-3B-Reasoning-2512-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 3_916_269_568,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Ministral-3-3B-Reasoning-2512-GGUF/resolve/main/Ministral-3-3B-Reasoning-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_147_021_472,
            downloadUrl: URL(
              string:
                "https://huggingface.co/mistralai/Ministral-3-3B-Reasoning-2512-GGUF/resolve/main/Ministral-3-3B-Reasoning-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "8B",
        parameterCount: 9_000_000_000,
        releaseDate: date(2025, 12, 2),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 139_264_000,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Ministral-3-8B-Instruct-2512-GGUF/resolve/main/mmproj-Ministral-3-8B-Instruct-2512-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 9_703_104_512,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Ministral-3-8B-Instruct-2512-GGUF/resolve/main/Ministral-3-8B-Instruct-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 5_198_911_904,
            downloadUrl: URL(
              string:
                "https://huggingface.co/mistralai/Ministral-3-8B-Instruct-2512-GGUF/resolve/main/Ministral-3-8B-Instruct-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "8B Reasoning",
        parameterCount: 9_000_000_000,
        releaseDate: date(2025, 12, 2),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 139_264_000,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Ministral-3-8B-Reasoning-2512-GGUF/resolve/main/mmproj-Ministral-3-8B-Reasoning-2512-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 9_701_376_000,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Ministral-3-8B-Reasoning-2512-GGUF/resolve/main/Ministral-3-8B-Reasoning-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 5_198_910_368,
            downloadUrl: URL(
              string:
                "https://huggingface.co/mistralai/Ministral-3-8B-Reasoning-2512-GGUF/resolve/main/Ministral-3-8B-Reasoning-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "14B",
        parameterCount: 14_000_000_000,
        releaseDate: date(2025, 12, 2),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 163_840_000,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Ministral-3-14B-Instruct-2512-GGUF/resolve/main/mmproj-Ministral-3-14B-Instruct-2512-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 14_359_311_264,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Ministral-3-14B-Instruct-2512-GGUF/resolve/main/Ministral-3-14B-Instruct-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 8_239_593_024,
            downloadUrl: URL(
              string:
                "https://huggingface.co/mistralai/Ministral-3-14B-Instruct-2512-GGUF/resolve/main/Ministral-3-14B-Instruct-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "14B Reasoning",
        parameterCount: 14_000_000_000,
        releaseDate: date(2025, 12, 2),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 163_840_000,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Ministral-3-14B-Reasoning-2512-GGUF/resolve/main/mmproj-Ministral-3-14B-Reasoning-2512-Q8_0.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 14_359_309_728,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Ministral-3-14B-Reasoning-2512-GGUF/resolve/main/Ministral-3-14B-Reasoning-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 8_239_591_488,
            downloadUrl: URL(
              string:
                "https://huggingface.co/mistralai/Ministral-3-14B-Reasoning-2512-GGUF/resolve/main/Ministral-3-14B-Reasoning-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
    ]
  )
}
