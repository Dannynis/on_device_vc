@echo off
echo 🚀 Starting Jupyter Combined Development Environment
echo ===================================================
echo 📦 Includes: C/C++ + Python 3.10 ML/AI environment
echo 🧠 Kernels: Python 3, Python 3.10 (ML/AI), C, C++
echo 🔧 Packages: GCC/G++, PyTorch, TensorFlow, ONNX, ai-edge-torch, nobuco
echo ===================================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo    Visit: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

echo 🔧 Building and starting the combined environment...

REM Try docker-compose first
docker-compose --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Using docker-compose...
    docker-compose up --build jupyter-combined
) else (
    REM Try docker compose (newer syntax)
    docker compose version >nul 2>&1
    if %errorlevel% equ 0 (
        echo Using docker compose...
        docker compose up --build jupyter-combined
    ) else (
        echo Using Docker directly...
        docker build -f Dockerfile.combined -t jupyter-combined-env .
        docker run -it --rm -p 8890:8888 -v "%cd%":/workspace jupyter-combined-env
    )
)

echo.
echo 🌐 Jupyter is now running at: http://localhost:8890
echo 📝 Available kernels: Python 3, Python 3.10 (ML/AI), C, C++
echo 📁 Your files are mounted in /workspace
echo.
echo 🎯 Use this environment for:
echo    • C/C++ programming and compilation
echo    • Machine learning with PyTorch/TensorFlow
echo    • Model conversion and optimization
echo    • Complete development workflow
echo.
echo Press Ctrl+C to stop the environment
pause
