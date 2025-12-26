# LlamaBarn

LlamaBarn is a tiny (`12 MB`) menu bar app that makes running local LLMs as easy as connecting to Wi-Fi.

**Install** with `brew install --cask llamabarn` or download from [Releases ↗](https://github.com/ggml-org/LlamaBarn/releases)

<br>

![LlamaBarn](https://github.com/user-attachments/assets/ec4237e4-3a7b-41b7-8506-445838f0519f)

<br>

## Why LlamaBarn

Running local LLMs from the command line is error-prone and time-consuming. You must handle model formats like GGUF and MLX, quantization, context windows, device configurations, and prevent system freezes.

Other tools automate some tasks but often create new problems, such as bloated interfaces, proprietary abstractions, or cloud dependencies that complicate local workflows.

LlamaBarn stands out as a clean, platform-focused solution:

- **Native macOS App** — Built with Swift for optimal performance and minimal resource usage.
- **Simple GUI for llama.cpp** — A menu bar interface that handles all the technical heavy-lifting of llama.cpp without the terminal hassle.
- **Platform, not a product** — Like Wi-Fi for your Mac, it lets you use local models in any app (chat UIs, editors, scripts) via a standard API — no vendor lock-in.
- **GGML-Native Integration** — Built as part of the GGML org alongside llama.cpp, with direct, unbloated integration for optimal performance and reliability.
- **Optimized Model Library** — Pre-selected GGUF models tailored to your Mac, auto-configured, and freeze-proof.

## How it works

LlamaBarn runs as a tiny menu bar app on your Mac.

Simply:

- **Install a model from the built-in catalog** -- only models that can run on your Mac are shown
- **Select an installed model to run it** -- configures and starts a server at `http://localhost:2276`
- **Use the running model via the API or web UI** -- both at `http://localhost:2276`

No complex setup — just install, run, and connect.

## Common use cases

Connect to any app that supports custom APIs, such as:

- **Chat UIs** like `Chatbox` or `Open WebUI`
- **CLI assistants** like `OpenCode` or `Codex`
- **Editors** like `VS Code` or `Zed`
- **Editor extensions** like `Cline` or `Continue`
- **Custom scripts** using `curl` or libs like `AI SDK`

Or use the built-in web UI at `http://localhost:2276` to chat with the running model directly.

## API Reference

LlamaBarn uses the llama.cpp server API. Example:

```sh
# say "Hello" to the running model
curl http://localhost:2276/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}]}'
```

See complete reference in `llama-server` [docs ↗](https://github.com/ggml-org/llama.cpp/tree/master/tools/server#api-endpoints)
