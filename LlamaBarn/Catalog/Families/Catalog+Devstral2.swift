import Foundation

extension Catalog {
  static let devstral2 = ModelFamily(
    name: "Devstral 2",
    series: "mistral",
    description:
      "Mistral AI's agentic coding models for software engineering tasks. Excels at exploring codebases, multi-file editing, and powering code agents.",
    serverArgs: nil,
    sizes: [
      ModelSize(
        name: "24B",
        parameterCount: 24_000_000_000,
        releaseDate: date(2025, 12, 18),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 167_772_160,
        mmproj: URL(
          string:
            "https://huggingface.co/ggml-org/Devstral-Small-2-24B-Instruct-2512-GGUF/resolve/main/mmproj-Devstral-Small-2-24B-Instruct-2512-F16.gguf"
        )!,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 25_055_308_352,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Devstral-Small-2-24B-Instruct-2512-GGUF/resolve/main/Devstral-Small-2-24B-Instruct-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 14_334_446_752,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Devstral-Small-2-24B-Instruct-2512-GGUF/resolve/main/Devstral-Small-2-24B-Instruct-2512-Q4_K_M.gguf"
            )!
          )
        ]
      ),
      ModelSize(
        name: "123B",
        parameterCount: 123_000_000_000,
        releaseDate: date(2025, 12, 19),
        ctxWindow: 262_144,
        ctxBytesPer1kTokens: 369_098_752,
        build: ModelBuild(
          quantization: "Q8_0",
          fileSize: 132_854_938_656,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/Devstral-2-123B-Instruct-2512-GGUF/resolve/main/Devstral-2-123B-Instruct-2512-Q8_0.gguf"
          )!
        ),
        quantizedBuilds: [
          ModelBuild(
            quantization: "Q4_K_M",
            fileSize: 74_897_662_400,
            downloadUrl: URL(
              string:
                "https://huggingface.co/unsloth/Devstral-2-123B-Instruct-2512-GGUF/resolve/main/Q4_K_M/Devstral-2-123B-Instruct-2512-Q4_K_M-00001-of-00002.gguf"
            )!,
            additionalParts: [
              URL(
                string:
                  "https://huggingface.co/unsloth/Devstral-2-123B-Instruct-2512-GGUF/resolve/main/Q4_K_M/Devstral-2-123B-Instruct-2512-Q4_K_M-00002-of-00002.gguf"
              )!
            ]
          )
        ]
      ),
    ]
  )
}
