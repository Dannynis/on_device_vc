# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Update package list and install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    git \
    wget \
    curl \
    vim \
    nano \
    jupyter \
    jupyter-notebook \
    && rm -rf /var/lib/apt/lists/*

# Add Python 3.10 repository and install Python 3.10
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3.10-distutils \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.10
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.10 get-pip.py && \
    rm get-pip.py

# Install Python packages for default Python 3
RUN pip3 install --no-cache-dir \
    jupyter \
    jupyterlab \
    ipykernel \
    numpy \
    matplotlib \
    cffi \
    pycparser \
    cython \
    notebook

RUN pip install --upgrade notebook

# Install C kernel for Jupyter
RUN pip3 install --no-cache-dir jupyter-c-kernel jupyter-cpp-kernel
RUN install_c_kernel --user

# Install Python 3.10 packages for ML/AI workloads
RUN python3.10 -m pip install --no-cache-dir \
    jupyter \
    jupyterlab \
    ipykernel \
    numpy \
    matplotlib \
    ai-edge-torch \
    nobuco \
    onnx \
    tensorflow \
    onnxruntime

# Install PyTorch with CUDA support for Python 3.10
RUN python3.10 -m pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# Create Python 3.10 kernel for Jupyter
RUN python3.10 -m ipykernel install --user --name python310 --display-name "Python 3.10 (ML/AI)"

# Create a working directory
WORKDIR /workspace

# Copy the current directory contents into the container
# COPY . /workspace/

# Expose Jupyter port
EXPOSE 8888

# Create a non-root user
RUN useradd -m -s /bin/bash jupyter_user && \
    chown -R jupyter_user:jupyter_user /workspace

USER jupyter_user

# Start Jupyter Lab
CMD ["jupyter-notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
