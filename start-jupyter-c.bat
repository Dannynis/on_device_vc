@echo off
echo 🚀 Starting Jupyter Multi-Kernel Development Environment
echo =========================================================
echo 📦 Includes: C/C++ development + Python 3.10 ML/AI environment
echo 🧠 Kernels: Python 3, Python 3.10 (ML/AI), C, C++
echo 🔧 Packages: PyTorch, TensorFlow, ONNX, ai-edge-torch, nobuco
echo =========================================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo    Visit: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

echo 🔧 Building and starting the environment...

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Using Docker Compose...
    docker-compose up --build
) else (
    docker compose version >nul 2>&1
    if %errorlevel% equ 0 (
        echo Using Docker Compose (new syntax)...
        docker compose up --build
    ) else (
        echo Using Docker directly...
        docker build -t jupyter-c-env .
        echo 🎯 Starting Jupyter Lab...
        docker run -it --rm -p 8888:8888 -v "%cd%":/workspace jupyter-c-env
    )
)

echo.
echo 🎉 Environment is ready!
echo 📝 Open your browser and go to: http://localhost:8888
echo 📁 Your files are available in the /workspace directory
echo.
echo To stop the environment, press Ctrl+C
pause
