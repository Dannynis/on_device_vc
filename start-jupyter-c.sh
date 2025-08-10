#!/bin/bash

echo "🚀 Jupyter Development Environment Selector"
echo "=========================================="
echo "Choose which environment to start:"
echo "1) C/C++ Development Only (Port 8888)"
echo "2) ML/AI Development Only (Port 8889)" 
echo "3) Combined C/C++ + ML/AI (Port 8890)"
echo "4) All Environments (Ports 8888, 8889, 8890)"
echo "=========================================="

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "🔧 Starting C/C++ Development Environment..."
        ./start-jupyter-c-only.sh
        ;;
    2)
        echo "🧠 Starting ML/AI Development Environment..."
        ./start-jupyter-ml.sh
        ;;
    3)
        echo "🚀 Starting Combined Development Environment..."
        ./start-jupyter-combined.sh
        ;;
    4)
        echo "🌟 Starting All Environments..."
        if command -v docker-compose &> /dev/null; then
            docker-compose up --build
        else
            docker compose up --build
        fi
        echo ""
        echo "🌐 Environments running at:"
        echo "   C/C++ Development: http://localhost:8888"
        echo "   ML/AI Development: http://localhost:8889"
        echo "   Combined Environment: http://localhost:8890"
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac
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
