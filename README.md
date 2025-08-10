# Jupyter Multi-Environment Development Setup

This setup provides multiple specialized development environments for different use cases, all containerized and ready to use.

## 📋 Available Environments

### 1. C/C++ Development Environment (Port 8888)
- **Ubuntu 22.04** base with GCC/G++ compilers
- **Python 3** with Jupyter Lab
- **C/C++ kernels** for direct code execution
- **Development packages**: cffi, cython, numpy, matplotlib
- **Use case**: C/C++ programming, system development
- **Dockerfile**: `Dockerfile`

### 2. ML/AI Development Environment (Port 8889)
- **Python 3.10** with enhanced ML capabilities
- **PyTorch**: Latest version with CUDA 12.8 support
- **TensorFlow**: For neural network development
- **ONNX & ONNX Runtime**: Model interoperability
- **AI Edge Torch**: Mobile and edge deployment
- **Nobuco**: Neural network optimization
- **Use case**: Machine learning, AI model development, deployment
- **Dockerfile**: `Dockerfile.ml`

### 3. Combined Environment (Port 8890)
- **All features from both environments above**
- **Multiple kernels**: Python 3, Python 3.10 (ML/AI), C, C++
- **Complete toolchain**: GCC/G++ + PyTorch + TensorFlow
- **Use case**: Full-stack development, research, education
- **Dockerfile**: `Dockerfile.combined`

## 🚀 Quick Start Options

### Automated Setup (Recommended)

**Windows:**
```cmd
start-jupyter-c.bat
```

**Linux/Mac:**
```bash
chmod +x start-jupyter-c.sh
./start-jupyter-c.sh
```

The script will show you options:
1. **C/C++ Development Only** (Port 8888)
2. **ML/AI Development Only** (Port 8889)
3. **Combined Environment** (Port 8890)
4. **All Environments** (All ports)

### Individual Environment Startup

**C/C++ Environment:**
```bash
./start-jupyter-c-only.sh      # Linux/Mac
start-jupyter-c-only.bat       # Windows
```

**ML/AI Environment:**
```bash
./start-jupyter-ml.sh          # Linux/Mac
start-jupyter-ml.bat           # Windows
```

**Combined Environment:**
```bash
./start-jupyter-combined.sh    # Linux/Mac
start-jupyter-combined.bat     # Windows
```

### Manual Docker Commands

**Single Environment:**
```bash
# C/C++ Environment
docker-compose up --build jupyter-c

# ML/AI Environment  
docker-compose up --build jupyter-ml

# Combined Environment
docker-compose up --build jupyter-combined

# All Environments
docker-compose up --build
```

**Direct Docker:**
```bash
# C/C++ Environment
docker build -t jupyter-c-env .
docker run -p 8888:8888 -v $(pwd):/workspace jupyter-c-env

# ML/AI Environment
docker build -f Dockerfile.ml -t jupyter-ml-env .
docker run -p 8889:8888 -v $(pwd):/workspace jupyter-ml-env

# Combined Environment
docker build -f Dockerfile.combined -t jupyter-combined-env .
docker run -p 8890:8888 -v $(pwd):/workspace jupyter-combined-env
```

## 🌐 Access

Access your chosen environment(s) in the browser:

- **C/C++ Development**: http://localhost:8888
- **ML/AI Development**: http://localhost:8889  
- **Combined Environment**: http://localhost:8890

### Available Kernels by Environment

| Environment | Python 3 | Python 3.10 (ML/AI) | C | C++ |
|-------------|----------|---------------------|---|-----|
| C/C++ Only  | ✅ | ❌ | ✅ | ✅ |
| ML/AI Only  | ✅ | ✅ | ❌ | ❌ |
| Combined    | ✅ | ✅ | ✅ | ✅ |

## 📁 File Structure

```
├── Dockerfile                  # C/C++ development environment
├── Dockerfile.ml              # ML/AI development environment  
├── Dockerfile.combined         # Combined environment
├── docker-compose.yml          # Multi-environment orchestration
├── start-jupyter-c.sh/.bat     # Main environment selector
├── start-jupyter-c-only.sh/.bat    # C/C++ only launcher
├── start-jupyter-ml.sh/.bat        # ML/AI only launcher
├── start-jupyter-combined.sh/.bat  # Combined launcher
├── test_kernels.py             # Environment testing script
├── c.ipynb                     # C programming examples
├── cpp.ipynb                   # C++ programming tutorial
├── cpp.ipynb              # C++ programming tutorial
├── mnist.ipynb            # ML example using Python 3.10 kernel
└── README.md              # This file
```

## 🧪 Testing Your Installation

After starting the container, test both environments:

```bash
# Inside the container
python3 /workspace/test_kernels.py
```

This will verify:
- Both Python environments are working
- All packages are properly installed
- CUDA availability (if applicable)
- Jupyter kernel availability

## 🎯 Kernel Selection Guide

### Use **Python 3** kernel for:
- C/C++ development and compilation
- General programming tasks
- Educational C programming exercises
- Basic Python development

### Use **Python 3.10 (ML/AI)** kernel for:
- PyTorch model development and training
- TensorFlow/Keras neural networks
- ONNX model conversion and optimization
- Mobile/edge AI deployment with ai-edge-torch
- Model optimization with nobuco
- Computer vision with torchvision
- Audio processing with torchaudio

## 🔧 Available Methods for Development

## 🔧 Available Methods for Development

### C/C++ Development (Python 3 kernel)
1. **Subprocess Method**: Write C code as strings, compile with GCC, execute and capture output
2. **CFFI Integration**: Call C functions directly from Python for performance-critical code
3. **C/C++ Kernels**: Direct code execution in notebook cells (when available)

### Machine Learning Development (Python 3.10 ML/AI kernel)
1. **PyTorch**: Deep learning with CUDA support
2. **TensorFlow**: Neural network development and deployment
3. **Model Conversion**: ONNX for model interoperability
4. **Mobile Deployment**: ai-edge-torch for mobile and edge devices
5. **Optimization**: nobuco for neural network compression

## 🛠️ Example Notebooks

### c.ipynb - C Programming
- Hello World examples
- Mathematical calculations
- Arrays, loops, and functions
- Memory management
- CFFI integration examples

### cpp.ipynb - C++ Programming
- Object-oriented programming
- STL containers and algorithms
- Template programming
- Advanced C++ features

### mnist.ipynb - Machine Learning Pipeline
- PyTorch model training
- ONNX model conversion
- TensorFlow Lite optimization
- Android deployment code
- Complete ML workflow example

## 🔍 Troubleshooting

### Package Installation Issues
If packages fail to install, rebuild the container:
```bash
docker-compose down
docker-compose up --build
```

### Kernel Not Available
If kernels don't appear in Jupyter:
```bash
# Inside container, reinstall kernels
python3.10 -m ipykernel install --user --name python310 --display-name "Python 3.10 (ML/AI)"
install_c_kernel --user
```

### CUDA Issues
For CUDA support, ensure:
- Host system has NVIDIA drivers
- Docker has GPU access configured
- Use `nvidia/cuda` base image if needed

### Memory Issues
For large ML models, increase Docker memory:
```bash
# In docker-compose.yml, add:
services:
  jupyter-c:
    deploy:
      resources:
        limits:
          memory: 8G
```

### Docker Issues
- Ensure Docker Desktop is running
- Check port 8888 is not in use
- Verify Docker has sufficient memory (4GB recommended)

### Compilation Issues
- All compilation happens inside the Linux container
- GCC and build tools are pre-installed
- Check the notebook output for detailed error messages

## 🧹 Cleanup

To stop and remove containers:
```bash
docker-compose down
```

To remove the built image:
```bash
docker rmi jupyter-c-env
```

## 📝 Notes

- The container runs as a non-root user for security
- All files in the current directory are mounted to `/workspace`
- Changes to notebooks are persistent on your host system
- The Jupyter server runs without authentication for development convenience
