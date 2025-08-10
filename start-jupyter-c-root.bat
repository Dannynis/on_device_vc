@echo off
echo 🚀 Starting Jupyter C/C++ Development Environment (Root User)
echo =============================================================
echo 📦 Includes: C/C++ development with GCC/G++
echo 🧠 Kernels: Python 3, C, C++
echo 🔧 Packages: cffi, cython, numpy, matplotlib
echo 👑 Running as: ROOT USER
echo =============================================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker first.
    echo    Visit: https://docs.docker.com/get-docker/
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% equ 0 (
    echo 🔧 Building and starting the C/C++ environment with Docker Compose (Root)...
    
    REM Create a temporary docker-compose override for root user
    echo version: '3.8' > docker-compose.override.yml
    echo services: >> docker-compose.override.yml
    echo   jupyter-c: >> docker-compose.override.yml
    echo     user: root >> docker-compose.override.yml
    echo     command: jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' >> docker-compose.override.yml
    
    docker-compose up --build jupyter-c
    
    REM Clean up override file
    del docker-compose.override.yml >nul 2>&1
) else (
    docker compose --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo 🔧 Building and starting with Docker Compose v2 (Root)...
        
        REM Create a temporary docker-compose override for root user
        echo version: '3.8' > docker-compose.override.yml
        echo services: >> docker-compose.override.yml
        echo   jupyter-c: >> docker-compose.override.yml
        echo     user: root >> docker-compose.override.yml
        echo     command: jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' >> docker-compose.override.yml
        
        docker compose up --build jupyter-c
        
        REM Clean up override file
        del docker-compose.override.yml >nul 2>&1
    ) else (
        echo 🔧 Building and starting with Docker (fallback) as ROOT...
        docker build -t jupyter-c-env -f Dockerfile .
        docker run -it --rm --user root -p 8888:8888 -v "%cd%:/workspace" jupyter-c-env jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password=""
    )
)

echo.
echo 🎉 Jupyter Notebook is starting...
echo 📱 Access at: http://localhost:8888
echo 🔧 C/C++ kernels available for development
echo 💻 Workspace mounted at: /workspace
echo 👑 Running with ROOT privileges
echo.
echo Press Ctrl+C to stop the container
pause
