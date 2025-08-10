#!/bin/bash

# ONNX Runtime Installation Verification Script
echo "=== ONNX Runtime Installation Verification ==="

# Check if ONNX_RUNTIME_ROOT is set
if [ -z "$ONNX_RUNTIME_ROOT" ]; then
    echo "⚠️  ONNX_RUNTIME_ROOT environment variable not set"
    echo "Checking default location: ~/onnxruntime"
    ONNX_RUNTIME_ROOT="$HOME/onnxruntime"
else
    echo "✅ ONNX_RUNTIME_ROOT: $ONNX_RUNTIME_ROOT"
fi

# Check if directory exists
if [ ! -d "$ONNX_RUNTIME_ROOT" ]; then
    echo "❌ ONNX Runtime directory not found: $ONNX_RUNTIME_ROOT"
    exit 1
else
    echo "✅ ONNX Runtime directory found"
fi

# Check for header file
HEADER_FILE="$ONNX_RUNTIME_ROOT/include/onnxruntime_c_api.h"
if [ ! -f "$HEADER_FILE" ]; then
    echo "❌ Header file not found: $HEADER_FILE"
    exit 1
else
    echo "✅ Header file found: $HEADER_FILE"
fi

# Check for library file
LIB_FILE="$ONNX_RUNTIME_ROOT/lib/libonnxruntime.so"
if [ ! -f "$LIB_FILE" ]; then
    echo "❌ Library file not found: $LIB_FILE"
    
    # Check for alternative library names
    ALT_LIB="$ONNX_RUNTIME_ROOT/lib/libonnxruntime.so.1"
    if [ -f "$ALT_LIB" ]; then
        echo "✅ Alternative library found: $ALT_LIB"
        LIB_FILE="$ALT_LIB"
    else
        echo "Available files in lib directory:"
        ls -la "$ONNX_RUNTIME_ROOT/lib/"
        exit 1
    fi
else
    echo "✅ Library file found: $LIB_FILE"
fi

# Check library dependencies
echo ""
echo "Library dependencies:"
ldd "$LIB_FILE" | head -10

# Check if library is in LD_LIBRARY_PATH
echo ""
if echo "$LD_LIBRARY_PATH" | grep -q "$ONNX_RUNTIME_ROOT/lib"; then
    echo "✅ ONNX Runtime lib directory is in LD_LIBRARY_PATH"
else
    echo "⚠️  ONNX Runtime lib directory not in LD_LIBRARY_PATH"
    echo "Add this to your ~/.bashrc:"
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$ONNX_RUNTIME_ROOT/lib"
fi

# Create a simple test program
echo ""
echo "Creating test program..."
TEST_FILE="/tmp/onnx_test.c"
cat > "$TEST_FILE" << 'EOF'
#include <stdio.h>
#include <onnxruntime_c_api.h>

int main() {
    const OrtApi* ort = OrtGetApiBase()->GetApi(ORT_API_VERSION);
    if (ort) {
        printf("✅ ONNX Runtime C API loaded successfully!\n");
        printf("ORT API Version: %d\n", ORT_API_VERSION);
        return 0;
    } else {
        printf("❌ Failed to load ONNX Runtime C API\n");
        return 1;
    }
}
EOF

# Compile test program
echo "Compiling test program..."
if gcc -I"$ONNX_RUNTIME_ROOT/include" -L"$ONNX_RUNTIME_ROOT/lib" "$TEST_FILE" -lonnxruntime -o /tmp/onnx_test; then
    echo "✅ Compilation successful"
    
    # Run test program
    echo "Running test program..."
    if /tmp/onnx_test; then
        echo "✅ Test program ran successfully"
    else
        echo "❌ Test program failed to run"
        echo "Make sure LD_LIBRARY_PATH includes: $ONNX_RUNTIME_ROOT/lib"
    fi
else
    echo "❌ Compilation failed"
    echo "Check that all paths are correct and dependencies are installed"
fi

# Clean up
rm -f "$TEST_FILE" /tmp/onnx_test

echo ""
echo "=== Verification Complete ==="
