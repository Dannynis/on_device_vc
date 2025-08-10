@echo off
echo 🚀 Jupyter Development Environment Selector
echo ==========================================
echo Choose which environment to start:
echo 1) C/C++ Development Only (Port 8888)
echo 2) ML/AI Development Only (Port 8889)
echo 3) Combined C/C++ + ML/AI (Port 8890)
echo 4) All Environments (Ports 8888, 8889, 8890)
echo ==========================================

set /p choice=Enter your choice (1-4): 

if "%choice%"=="1" (
    echo 🔧 Starting C/C++ Development Environment...
    call start-jupyter-c-only.bat
) else if "%choice%"=="2" (
    echo 🧠 Starting ML/AI Development Environment...
    call start-jupyter-ml.bat
) else if "%choice%"=="3" (
    echo 🚀 Starting Combined Development Environment...
    call start-jupyter-combined.bat
) else if "%choice%"=="4" (
    echo 🌟 Starting All Environments...
    docker-compose --version >nul 2>&1
    if %errorlevel% equ 0 (
        docker-compose up --build
    ) else (
        docker compose up --build
    )
    echo.
    echo 🌐 Environments running at:
    echo    C/C++ Development: http://localhost:8888
    echo    ML/AI Development: http://localhost:8889
    echo    Combined Environment: http://localhost:8890
) else (
    echo ❌ Invalid choice. Please run the script again.
    pause
    exit /b 1
)

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
