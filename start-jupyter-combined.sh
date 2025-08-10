#!/bin/bash

echo "🚀 Starting Jupyter Combined Development Environment"
echo "==================================================="
echo "📦 Includes: C/C++ + Python 3.10 ML/AI environment"
echo "🧠 Kernels: Python 3, Python 3.10 (ML/AI), C, C++"
echo "🔧 Packages: GCC/G++, PyTorch, TensorFlow, ONNX, ai-edge-torch, nobuco"
echo "==================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo "🔧 Building and starting the combined environment with Docker Compose..."
    
    # Try docker-compose first, then docker compose
    if command -v docker-compose &> /dev/null; then
        docker-compose up --build jupyter-combined
    else
        docker compose up --build jupyter-combined
    fi
else
    echo "🔧 Building and starting with Docker (fallback)..."
    docker build -f Dockerfile.combined -t jupyter-combined-env .
    docker run -it --rm -p 8890:8888 -v "$(pwd):/workspace" jupyter-combined-env
fi

echo ""
echo "🌐 Jupyter is now running at: http://localhost:8890"
echo "📝 Available kernels: Python 3, Python 3.10 (ML/AI), C, C++"
echo "📁 Your files are mounted in /workspace"
echo ""
echo "🎯 Use this environment for:"
echo "   • C/C++ programming and compilation"
echo "   • Machine learning with PyTorch/TensorFlow"
echo "   • Model conversion and optimization"
echo "   • Complete development workflow"
echo ""
echo "Press Ctrl+C to stop the environment"
