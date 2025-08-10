#!/bin/bash

echo "🚀 Starting Jupyter C/C++ Development Environment (Root User)"
echo "============================================================="
echo "📦 Includes: C/C++ development with GCC/G++"
echo "🧠 Kernels: Python 3, C, C++"
echo "🔧 Packages: cffi, cython, numpy, matplotlib"
echo "👑 Running as: ROOT USER"
echo "============================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo "🔧 Building and starting the C/C++ environment with Docker Compose (Root)..."
    
    # Create a temporary docker-compose override for root user
    cat > docker-compose.override.yml << EOF
version: '3.8'
services:
  jupyter-c:
    user: root
    command: jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''
EOF
    
    # Try docker-compose first, then docker compose
    if command -v docker-compose &> /dev/null; then
        docker-compose up --build jupyter-c
    else
        docker compose up --build jupyter-c
    fi
    
    # Clean up override file
    rm -f docker-compose.override.yml
else
    echo "🔧 Building and starting with Docker (fallback) as ROOT..."
    docker build -t jupyter-c-env -f Dockerfile .
    docker run -it --rm \
        --user root \
        -p 8888:8888 \
        -v "$(pwd):/workspace" \
        jupyter-c-env \
        jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''
fi

echo ""
echo "🎉 Jupyter Notebook is starting..."
echo "📱 Access at: http://localhost:8888"
echo "🔧 C/C++ kernels available for development"
echo "💻 Workspace mounted at: /workspace"
echo "👑 Running with ROOT privileges"
echo ""
echo "Press Ctrl+C to stop the container"
