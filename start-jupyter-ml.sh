#!/bin/bash

echo "🧠 Starting Jupyter ML/AI Development Environment"
echo "================================================="
echo "📦 Includes: Python 3.10 with ML/AI packages"
echo "🧠 Kernels: Python 3, Python 3.10 (ML/AI)"
echo "🔧 Packages: PyTorch, TensorFlow, ONNX, ai-edge-torch, nobuco"
echo "================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo "🔧 Building and starting the ML/AI environment with Docker Compose..."
    
    # Try docker-compose first, then docker compose
    if command -v docker-compose &> /dev/null; then
        docker-compose up --build jupyter-ml
    else
        docker compose up --build jupyter-ml
    fi
else
    echo "🔧 Building and starting with Docker (fallback)..."
    docker build -f Dockerfile.ml -t jupyter-ml-env .
    docker run -it --rm -p 8889:8888 -v "$(pwd):/workspace" jupyter-ml-env
fi

echo ""
echo "🌐 Jupyter is now running at: http://localhost:8889"
echo "📝 Available kernels: Python 3, Python 3.10 (ML/AI)"
echo "📁 Your files are mounted in /workspace"
echo ""
echo "Press Ctrl+C to stop the environment"
