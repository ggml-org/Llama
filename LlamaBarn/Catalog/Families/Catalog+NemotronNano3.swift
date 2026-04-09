import Foundation

extension Catalog {
  static let nemotronNano3 = ModelFamily(
    name: "Nemotron Nano 3",
    series: "nvidia",
    description:
      "NVIDIA's efficient hybrid MoE model for agentic AI. Built for reasoning, coding, and tool use with 1M token context and 4x faster throughput.",
    serverArgs: nil,
    sizes: [
      ModelSize(
        name: "30B-A3B",
        parameterCount: 31_577_940_288,
        releaseDate: date(2025, 12, 15),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 6_291_456,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 33_585_495_328,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Nemotron-Nano-3-30B-A3B-GGUF/resolve/main/Nemotron-Nano-3-30B-A3B-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 24_515_129_632,
            downloadUrl: URL(
              string:
                "https://huggingface.co/ggml-org/Nemotron-Nano-3-30B-A3B-GGUF/resolve/main/Nemotron-Nano-3-30B-A3B-Q4_K_M.gguf"
            )!
          )
        ]
      )
    ]
  )
}
