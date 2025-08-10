#!/bin/bash

echo "🚀 Starting Jupyter C/C++ Development Environment"
echo "================================================="
echo "📦 Includes: C/C++ development with GCC/G++"
echo "🧠 Kernels: Python 3, C, C++"
echo "🔧 Packages: cffi, cython, numpy, matplotlib"
echo "================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo "🔧 Building and starting the C/C++ environment with Docker Compose..."
    
    # Try docker-compose first, then docker compose
    if command -v docker-compose &> /dev/null; then
        docker-compose up --build jupyter-c
    else
        docker compose up --build jupyter-c
    fi
else
    echo "🔧 Building and starting with Docker (fallback)..."
    docker build -t jupyter-c-env .
    docker run -it --rm -p 8888:8888 -v "$(pwd):/workspace" jupyter-c-env
fi

echo ""
echo "🌐 Jupyter is now running at: http://localhost:8888"
echo "📝 Available kernels: Python 3, C, C++"
echo "📁 Your files are mounted in /workspace"
echo ""
echo "Press Ctrl+C to stop the environment"
