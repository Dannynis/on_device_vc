#!/bin/bash

# ONNX Runtime download script for Linux
echo "Downloading ONNX Runtime for Linux..."

# Set variables
ONNX_VERSION="1.16.3"
PLATFORM="linux-x64"
DOWNLOAD_URL="https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_VERSION}/onnxruntime-${PLATFORM}-${ONNX_VERSION}.tgz"
INSTALL_DIR="$HOME/onnxruntime"
TEMP_DIR="/tmp/onnxruntime_download"

# Create directories
mkdir -p "$TEMP_DIR"
mkdir -p "$INSTALL_DIR"

# Download ONNX Runtime
echo "Downloading from: $DOWNLOAD_URL"
cd "$TEMP_DIR"
wget "$DOWNLOAD_URL" -O onnxruntime.tgz

if [ $? -eq 0 ]; then
    echo "Download completed successfully"
else
    echo "Download failed. Please check your internet connection and try again."
    exit 1
fi

# Extract the archive
echo "Extracting ONNX Runtime..."
tar -xzf onnxruntime.tgz

# Move to installation directory
EXTRACTED_DIR=$(find . -name "onnxruntime-*" -type d | head -1)
if [ -n "$EXTRACTED_DIR" ]; then
    cp -r "$EXTRACTED_DIR"/* "$INSTALL_DIR/"
    echo "ONNX Runtime installed to: $INSTALL_DIR"
else
    echo "Error: Could not find extracted directory"
    exit 1
fi

# Clean up
cd /
rm -rf "$TEMP_DIR"

# Display installation info
echo ""
echo "Installation completed!"
echo "ONNX Runtime location: $INSTALL_DIR"
echo ""
echo "Directory structure:"
ls -la "$INSTALL_DIR"
echo ""
echo "Include directory:"
ls -la "$INSTALL_DIR/include"
echo ""
echo "Library directory:"
ls -la "$INSTALL_DIR/lib"

# Set up environment variables
echo ""
echo "Add these environment variables to your ~/.bashrc or ~/.profile:"
echo "export ONNX_RUNTIME_ROOT=$INSTALL_DIR"
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$INSTALL_DIR/lib"
echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$INSTALL_DIR/include"
echo "export LIBRARY_PATH=\$LIBRARY_PATH:$INSTALL_DIR/lib"

echo ""
echo "To automatically set up environment variables, run:"
echo "echo 'export ONNX_RUNTIME_ROOT=$INSTALL_DIR' >> ~/.bashrc"
echo "echo 'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$INSTALL_DIR/lib' >> ~/.bashrc"
echo "echo 'export C_INCLUDE_PATH=\$C_INCLUDE_PATH:$INSTALL_DIR/include' >> ~/.bashrc"
echo "echo 'export LIBRARY_PATH=\$LIBRARY_PATH:$INSTALL_DIR/lib' >> ~/.bashrc"
echo "source ~/.bashrc"
