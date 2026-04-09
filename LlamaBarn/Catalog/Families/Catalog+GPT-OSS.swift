import Foundation

extension Catalog {
  static let gptOss = ModelFamily(
    name: "GPT-OSS",
    series: "gpt",
    description:
      "OpenAI's first open-weight models since GPT-2. Built for reasoning, agentic tasks, and developer use with function calling and tool use capabilities.",
    serverArgs: ["--temp", "1.0", "--top-p", "1.0"],
    sizes: [
      ModelSize(
        name: "20B",
        parameterCount: 20_000_000_000,
        releaseDate: date(2025, 8, 2),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 25_165_824,
        build: ModelBuild(
          quantization: "mxfp4",
          fileSize: 12_109_566_560,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf"
          )!
        )
      ),
      ModelSize(
        name: "120B",
        parameterCount: 120_000_000_000,
        releaseDate: date(2025, 8, 2),
        ctxWindow: 131_072,
        ctxBytesPer1kTokens: 37_748_736,
        build: ModelBuild(
          quantization: "mxfp4",
          fileSize: 63_387_346_464,
          downloadUrl: URL(
            string:
              "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00001-of-00003.gguf"
          )!,
          additionalParts: [
            URL(
              string:
                "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00002-of-00003.gguf"
            )!,
            URL(
              string:
                "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00003-of-00003.gguf"
            )!,
          ]
        )
      ),
    ]
  )
}
