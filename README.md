# Jupyter Multi-Kernel Development Environment

This setup provides a complete Linux-based development environment with dual Python kernels for C development and machine learning.

## 📋 What's Included

### Base Environment
- **Ubuntu 22.04** base image
- **GCC/G++** compilers for C/C++ development
- **Development tools**: make, cmake, git, vim, nano

### Python Environments

#### Default Python 3 Environment
- **Python 3** with Jupyter Lab
- **C/C++ kernels** for Jupyter notebooks
- **Development packages**: cffi, cython, numpy, matplotlib
- **Use case**: General development and C programming

#### Python 3.10 ML/AI Environment
- **Python 3.10** with enhanced ML capabilities
- **PyTorch**: Latest version with CUDA 12.8 support
- **TensorFlow**: For neural network development
- **ONNX & ONNX Runtime**: Model interoperability
- **AI Edge Torch**: Mobile and edge deployment
- **Nobuco**: Neural network optimization
- **Use case**: Machine learning, AI model development, and deployment

## 🚀 Quick Start

### Windows
```cmd
start-jupyter-c.bat
```

### Linux/Mac
```bash
chmod +x start-jupyter-c.sh
./start-jupyter-c.sh
```

### Manual Docker Commands

Using Docker Compose:
```bash
docker-compose up --build
```

Using Docker directly:
```bash
# Build the image
docker build -t jupyter-c-env .

# Run the container
docker run -p 8888:8888 -v $(pwd):/workspace jupyter-c-env
```

## 🌐 Access

Once started, open your browser and navigate to:
**http://localhost:8888**

You'll see multiple kernel options:
- **Python 3**: Default environment for C development
- **Python 3.10 (ML/AI)**: Enhanced environment for machine learning
- **C**: Direct C code execution (when available)
- **C++**: Direct C++ code execution (when available)

## 📁 File Structure

```
├── Dockerfile              # Container definition with dual Python environments
├── docker-compose.yml      # Multi-container setup
├── start-jupyter-c.sh      # Linux/Mac startup script
├── start-jupyter-c.bat     # Windows startup script
├── test_kernels.py         # Kernel and package testing script
├── c.ipynb                 # C programming examples and exercises
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
