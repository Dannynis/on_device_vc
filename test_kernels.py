#!/usr/bin/env python3
"""
Test script to verify both Python kernels and their packages
Run this inside the Docker container to verify installation
"""

import sys
import subprocess
import importlib

def test_package_import(package_name, version_attr=None):
    """Test if a package can be imported and optionally check version"""
    try:
        module = importlib.import_module(package_name)
        if version_attr and hasattr(module, version_attr):
            version = getattr(module, version_attr)
            print(f"✅ {package_name}: {version}")
        else:
            print(f"✅ {package_name}: imported successfully")
        return True
    except ImportError as e:
        print(f"❌ {package_name}: {e}")
        return False

def test_python_environment(python_cmd):
    """Test a specific Python environment"""
    print(f"\n{'='*50}")
    print(f"Testing {python_cmd} environment")
    print(f"{'='*50}")
    
    # Check Python version
    try:
        result = subprocess.run([python_cmd, "--version"], capture_output=True, text=True)
        print(f"Python version: {result.stdout.strip()}")
    except Exception as e:
        print(f"❌ Could not get Python version: {e}")
        return False
    
    # Test package imports in subprocess
    packages_to_test = [
        ("torch", "__version__"),
        ("torchvision", "__version__"),
        ("torchaudio", "__version__"),
        ("tensorflow", "__version__"),
        ("onnx", "__version__"),
        ("onnxruntime", "__version__"),
        ("ai_edge_torch", None),
        ("nobuco", None),
        ("numpy", "__version__"),
        ("jupyter", "__version__"),
        ("ipykernel", "__version__")
    ]
    
    success_count = 0
    total_count = len(packages_to_test)
    
    for package, version_attr in packages_to_test:
        test_code = f"""
import sys
try:
    import {package}
    if "{version_attr}" and hasattr({package}, "{version_attr}"):
        print(f"✅ {package}: {{getattr({package}, '{version_attr}')}}")
    else:
        print(f"✅ {package}: imported successfully")
    sys.exit(0)
except ImportError as e:
    print(f"❌ {package}: {{e}}")
    sys.exit(1)
"""
        
        try:
            result = subprocess.run([python_cmd, "-c", test_code], 
                                  capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                print(result.stdout.strip())
                success_count += 1
            else:
                print(result.stdout.strip() if result.stdout else f"❌ {package}: Import failed")
        except Exception as e:
            print(f"❌ {package}: {e}")
    
    print(f"\nSummary: {success_count}/{total_count} packages imported successfully")
    return success_count == total_count

def test_cuda_availability():
    """Test CUDA availability in PyTorch"""
    print(f"\n{'='*50}")
    print("Testing CUDA availability")
    print(f"{'='*50}")
    
    test_code = """
import torch
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"CUDA devices: {torch.cuda.device_count()}")
    print(f"Current device: {torch.cuda.current_device()}")
    print(f"Device name: {torch.cuda.get_device_name()}")
else:
    print("CUDA not available - running on CPU")
"""
    
    try:
        result = subprocess.run(["python3.10", "-c", test_code], 
                              capture_output=True, text=True, timeout=30)
        print(result.stdout.strip())
        if result.stderr:
            print(f"Warnings: {result.stderr.strip()}")
    except Exception as e:
        print(f"❌ CUDA test failed: {e}")

def list_jupyter_kernels():
    """List available Jupyter kernels"""
    print(f"\n{'='*50}")
    print("Available Jupyter Kernels")
    print(f"{'='*50}")
    
    try:
        result = subprocess.run(["jupyter", "kernelspec", "list"], 
                              capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print(f"Errors: {result.stderr}")
    except Exception as e:
        print(f"❌ Could not list kernels: {e}")

def main():
    print("🧪 Docker Container Package Testing Suite")
    print("This script tests both Python environments and their packages")
    
    # Test default Python 3 environment
    success1 = test_python_environment("python3")
    
    # Test Python 3.10 environment
    success2 = test_python_environment("python3.10")
    
    # Test CUDA availability
    test_cuda_availability()
    
    # List Jupyter kernels
    list_jupyter_kernels()
    
    # Final summary
    print(f"\n{'='*50}")
    print("FINAL SUMMARY")
    print(f"{'='*50}")
    
    if success1:
        print("✅ Default Python 3 environment: All packages working")
    else:
        print("❌ Default Python 3 environment: Some packages failed")
    
    if success2:
        print("✅ Python 3.10 ML/AI environment: All packages working")
    else:
        print("❌ Python 3.10 ML/AI environment: Some packages failed")
    
    if success1 and success2:
        print("\n🎉 All environments are ready for use!")
        print("\nTo use in Jupyter:")
        print("1. Start Jupyter: docker-compose up")
        print("2. Open browser: http://localhost:8888")
        print("3. Create new notebook and select kernel:")
        print("   - 'Python 3' for general development")
        print("   - 'Python 3.10 (ML/AI)' for machine learning")
    else:
        print("\n⚠️  Some packages failed to install. Check the logs above.")

if __name__ == "__main__":
    main()
