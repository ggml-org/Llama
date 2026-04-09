import Foundation

extension Catalog {
  static let qwen3Coder = ModelFamily(
    name: "Qwen3 Coder",
    series: "qwen",
    description:
      "Alibaba's specialized coding model for agentic software engineering. Optimized for function calling, tool use, and repository-scale reasoning.",
    serverArgs: ["--temp", "0.7", "--top-p", "0.8", "--top-k", "20"],
    overheadMultiplier: 1.1,
    deprecated: true,
    sizes: [
      ModelSize(
        name: "30B-A3B",
        parameterCount: 30_532_122_624,
        releaseDate: date(2025, 7, 31),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 100_663_296,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 32_483_935_392,
          downloadUrl: URL(
            string:
              "https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF/resolve/main/Qwen3-Coder-30B-A3B-Instruct-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 18_556_689_568,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF/resolve/main/Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf"
            )!
          )
        ]
      )
    ]
  )
}
