@echo off
echo 🧠 Starting Jupyter ML/AI Development Environment
echo =================================================
echo 📦 Includes: Python 3.10 with ML/AI packages
echo 🧠 Kernels: Python 3, Python 3.10 (ML/AI)
echo 🔧 Packages: PyTorch, TensorFlow, ONNX, ai-edge-torch, nobuco
echo =================================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo    Visit: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

echo 🔧 Building and starting the ML/AI environment...

REM Try docker-compose first
docker-compose --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Using docker-compose...
    docker-compose up --build jupyter-ml
) else (
    REM Try docker compose (newer syntax)
    docker compose version >nul 2>&1
    if %errorlevel% equ 0 (
        echo Using docker compose...
        docker compose up --build jupyter-ml
    ) else (
        echo Using Docker directly...
        docker build -f Dockerfile.ml -t jupyter-ml-env .
        docker run -it --rm -p 8889:8888 -v "%cd%":/workspace jupyter-ml-env
    )
)

echo.
echo 🌐 Jupyter is now running at: http://localhost:8889
echo 📝 Available kernels: Python 3, Python 3.10 (ML/AI)
echo 📁 Your files are mounted in /workspace
echo.
echo Press Ctrl+C to stop the environment
pause
