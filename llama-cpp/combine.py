import os

required_files = [
    "libggml.dylib",
    "libggml-base.dylib",
    "libggml-blas.dylib",
    "libggml-cpu.dylib",
    "libggml-rpc.dylib",
    "libggml-metal.dylib",
    "libllama.dylib",
    "libmtmd.dylib",
    "llama-server"
]

arm64_llamacpp_dir = input("Enter the path to the arm64 llamacpp bin directory: ")
x86_llamacpp_dir = input("Enter the path to the x86 llamacpp bin directory: ")
output_dir = input("Enter the output directory for the combined files: ")

if not os.path.exists(output_dir):
    os.makedirs(output_dir)
    
# Using lipo to create a universal binary/dylib
for file in required_files:
    arm64_file_path = os.path.join(arm64_llamacpp_dir, file)
    x86_file_path = os.path.join(x86_llamacpp_dir, file)
    output_file_path = os.path.join(output_dir, file)
    
    if os.path.exists(arm64_file_path) and os.path.exists(x86_file_path):
        lipo_command = f"lipo -create '{arm64_file_path}' '{x86_file_path}' -output '{output_file_path}'"
        os.system(lipo_command)
        print(f"Created universal binary: {output_file_path}")
    else:
        print(f"Missing file for lipo: {file}")