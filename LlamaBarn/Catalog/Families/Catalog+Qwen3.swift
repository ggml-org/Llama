import Foundation

extension Catalog {
  static let qwen3 = ModelFamily(
    name: "Qwen3",
    series: "qwen",
    description:
      "Alibaba's hybrid reasoning models with thinking/non-thinking modes. Excels at coding, math, and multilingual tasks across 119 languages.",
    serverArgs: ["--temp", "0.6", "--top-k", "20", "--top-p", "0.95", "--min-p", "0"],
    overheadMultiplier: 1.1,
    deprecated: true,
    sizes: [
      ModelSize(
        name: "4B",
        parameterCount: 4_022_468_096,
        releaseDate: date(2025, 7, 1),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 150_994_944,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 4_280_405_600,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Qwen3-4B-Instruct-2507-Q8_0-GGUF/resolve/main/qwen3-4b-instruct-2507-q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_497_281_120,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3-4B-Instruct-2507-GGUF/resolve/main/Qwen3-4B-Instruct-2507-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "4B Thinking",
        parameterCount: 4_022_468_096,
        releaseDate: date(2025, 7, 1),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 150_994_944,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 4_280_405_632,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Qwen3-4B-Thinking-2507-Q8_0-GGUF/resolve/main/qwen3-4b-thinking-2507-q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 2_497_281_152,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3-4B-Thinking-2507-GGUF/resolve/main/Qwen3-4B-Thinking-2507-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "30B-A3B",
        parameterCount: 30_532_122_624,
        releaseDate: date(2025, 7, 1),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 100_663_296,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 32_483_932_576,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Qwen3-30B-A3B-Instruct-2507-Q8_0-GGUF/resolve/main/qwen3-30b-a3b-instruct-2507-q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 18_556_686_752,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3-30B-A3B-Instruct-2507-GGUF/resolve/main/Qwen3-30B-A3B-Instruct-2507-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "30B-A3B Thinking",
        parameterCount: 30_532_122_624,
        releaseDate: date(2025, 7, 1),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 100_663_296,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 32_483_931_872,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Qwen3-30B-A3B-Thinking-2507-Q8_0-GGUF/resolve/main/qwen3-30b-a3b-thinking-2507-q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 18_556_686_752,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3-30B-A3B-Thinking-2507-GGUF/resolve/main/Qwen3-30B-A3B-Thinking-2507-Q4_K_M.gguf"
            )!
          )
        ]
      ),
    ]
  )
}
