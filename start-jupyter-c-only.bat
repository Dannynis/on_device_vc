@echo off
echo 🚀 Starting Jupyter C/C++ Development Environment
echo =================================================
echo 📦 Includes: C/C++ development with GCC/G++
echo 🧠 Kernels: Python 3, C, C++
echo 🔧 Packages: cffi, cython, numpy, matplotlib
echo =================================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo    Visit: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

echo 🔧 Building and starting the C/C++ environment...

REM Try docker-compose first
docker-compose --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Using docker-compose...
    docker-compose up --build jupyter-c
) else (
    REM Try docker compose (newer syntax)
    docker compose version >nul 2>&1
    if %errorlevel% equ 0 (
        echo Using docker compose...
        docker compose up --build jupyter-c
    ) else (
        echo Using Docker directly...
        docker build -t jupyter-c-env .
        docker run -it --rm -p 8888:8888 -v "%cd%":/workspace jupyter-c-env
    )
)

echo.
echo 🌐 Jupyter is now running at: http://localhost:8888
echo 📝 Available kernels: Python 3, C, C++
echo 📁 Your files are mounted in /workspace
echo.
echo Press Ctrl+C to stop the environment
pause
