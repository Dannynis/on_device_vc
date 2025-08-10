# ONNX Runtime C/C++ Development Container

This dev container provides a complete development environment for C/C++ programming with ONNX Runtime support.

## Features

### 🔧 Pre-installed Tools
- **GCC/G++** - Latest C/C++ compilers
- **ONNX Runtime 1.16.3** - C/C++ libraries and headers
- **Jupyter Notebook** - For interactive development
- **Python 3.10** - With ML/AI packages
- **Git** - Version control
- **CMake & Make** - Build systems

### 📦 VS Code Extensions
- **C/C++ Extension Pack** - IntelliSense, debugging, code formatting
- **CMake Tools** - CMake project support
- **Makefile Tools** - Makefile project support
- **Jupyter** - Notebook support with C kernel
- **Code Runner** - Quick execution of C/C++ files
- **GitLens** - Enhanced Git capabilities

### 🛠️ Configured Build Tasks
- **Build C with ONNX Runtime** (Ctrl+Shift+P → Tasks: Run Task)
- **Build and Run C with ONNX Runtime**
- **Build C++ with ONNX Runtime**
- **Clean build artifacts**
- **Start Jupyter Server**
- **Verify ONNX Runtime Installation**

## Quick Start

### 1. Open in Dev Container
```bash
# Clone the repository
git clone <your-repo>
cd <your-repo>

# Open in VS Code
code .

# When prompted, click "Reopen in Container"
# Or use Command Palette: "Dev Containers: Reopen in Container"
```

### 2. Verify Installation
```bash
# Run verification task
Ctrl+Shift+P → Tasks: Run Task → "Verify ONNX Runtime Installation"

# Or manually in terminal
./verify_onnxruntime.sh
```

### 3. Compile and Run Your Code
```bash
# Using VS Code tasks (recommended)
# Open a .c file and press Ctrl+Shift+P
# Tasks: Run Task → "Build and Run C with ONNX Runtime"

# Or manually in terminal
gcc -I/usr/local/onnxruntime/include -L/usr/local/onnxruntime/lib your_file.c -lonnxruntime -o your_program
./your_program
```

## Environment Variables

The container automatically sets up:
```bash
ONNX_RUNTIME_ROOT=/usr/local/onnxruntime
LD_LIBRARY_PATH=/usr/local/onnxruntime/lib:$LD_LIBRARY_PATH
C_INCLUDE_PATH=/usr/local/onnxruntime/include:$C_INCLUDE_PATH
LIBRARY_PATH=/usr/local/onnxruntime/lib:$LIBRARY_PATH
```

## Sample Programs

### Basic ONNX Runtime Test
```c
#include <stdio.h>
#include <onnxruntime_c_api.h>

int main() {
    const OrtApi* ort = OrtGetApiBase()->GetApi(ORT_API_VERSION);
    if (ort) {
        printf("✅ ONNX Runtime C API loaded successfully!\n");
        printf("ORT API Version: %d\n", ORT_API_VERSION);
        return 0;
    } else {
        printf("❌ Failed to load ONNX Runtime C API\n");
        return 1;
    }
}
```

### Compilation Commands
```bash
# Basic compilation
gcc -I/usr/local/onnxruntime/include -L/usr/local/onnxruntime/lib test.c -lonnxruntime -o test

# With debugging symbols
gcc -g -I/usr/local/onnxruntime/include -L/usr/local/onnxruntime/lib test.c -lonnxruntime -o test

# With optimization
gcc -O2 -I/usr/local/onnxruntime/include -L/usr/local/onnxruntime/lib test.c -lonnxruntime -o test
```

## Jupyter Notebooks

### Start Jupyter Server
```bash
# Using VS Code task
Ctrl+Shift+P → Tasks: Run Task → "Start Jupyter Server"

# Or manually
jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

Access at: http://localhost:8888

### Available Kernels
- **C** - For C programming with ONNX Runtime
- **Python 3** - Standard Python kernel
- **Python 3.10 (ML/AI)** - Python with ML/AI packages

## Troubleshooting

### Library Not Found
If you get library errors:
```bash
# Check library path
echo $LD_LIBRARY_PATH

# Verify ONNX Runtime installation
ls -la /usr/local/onnxruntime/lib/

# Check library dependencies
ldd /usr/local/onnxruntime/lib/libonnxruntime.so
```

### Compilation Errors
```bash
# Check include path
echo $C_INCLUDE_PATH

# Verify headers exist
ls -la /usr/local/onnxruntime/include/

# Test minimal compilation
gcc -I/usr/local/onnxruntime/include -E -dM - < /dev/null | grep -i onnx
```

### IntelliSense Issues
- Reload VS Code window: Ctrl+Shift+P → "Developer: Reload Window"
- Rebuild IntelliSense: Ctrl+Shift+P → "C/C++: Reset IntelliSense Database"

## File Structure
```
.devcontainer/
  └── devcontainer.json      # Dev container configuration

.vscode/
  ├── tasks.json             # Build and run tasks
  ├── launch.json            # Debug configurations  
  └── c_cpp_properties.json  # C/C++ IntelliSense settings

Dockerfile.combined          # Container image definition
install_onnxruntime.sh      # ONNX Runtime installation script
verify_onnxruntime.sh       # Installation verification script
```

## Ports
- **8888** - Jupyter Notebook server

Happy coding! 🚀
