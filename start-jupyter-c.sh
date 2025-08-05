#!/bin/bash

echo "🚀 Starting Jupyter Multi-Kernel Development Environment"
echo "========================================================="
echo "📦 Includes: C/C++ development + Python 3.10 ML/AI environment"
echo "🧠 Kernels: Python 3, Python 3.10 (ML/AI), C, C++"
echo "🔧 Packages: PyTorch, TensorFlow, ONNX, ai-edge-torch, nobuco"
echo "========================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo "🔧 Building and starting the environment with Docker Compose..."
    
    # Try docker-compose first, then docker compose
    if command -v docker-compose &> /dev/null; then
        docker-compose up --build
    else
        docker compose up --build
    fi
else
    echo "🔧 Building and starting the environment with Docker..."
    
    # Build the Docker image
    docker build -t jupyter-c-env .
    
    # Run the container
    echo "🎯 Starting Jupyter Lab..."
    docker run -it --rm \
        -p 8888:8888 \
        -v "$(pwd)":/workspace \
        jupyter-c-env
fi

echo ""
echo "🎉 Environment is ready!"
echo "📝 Open your browser and go to: http://localhost:8888"
echo "📁 Your files are available in the /workspace directory"
echo ""
echo "To stop the environment, press Ctrl+C"
