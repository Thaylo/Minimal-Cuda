#!/usr/bin/env bash

# Exit on error, and echo each command
set -eux

echo "=================================================="
echo "STARTING BUILD SCRIPT"
echo "=================================================="

echo ""
echo "--------------------------------------------------"
echo "1) System Information"
echo "--------------------------------------------------"
uname -a || true
echo ""

echo "--------------------------------------------------"
echo "2) Environment Variables (partial listing)"
echo "--------------------------------------------------"
# Print some selected environment variables that might matter
echo "PATH = $PATH"
echo "CUDA_PATH = ${CUDA_PATH:-not set}"
echo "CUDA_HOME = ${CUDA_HOME:-not set}"
echo "VCPKG_ROOT = ${VCPKG_ROOT:-not set}"
echo "--------------------------------------------------"

echo ""
echo "--------------------------------------------------"
echo "3) CUDA/NVCC Information"
echo "--------------------------------------------------"
which nvcc || true
nvcc --version || true

echo ""
echo "--------------------------------------------------"
echo "4) Compiler Information"
echo "--------------------------------------------------"
echo "Trying to locate C/C++ compiler..."
which gcc 2>/dev/null || true
gcc --version 2>/dev/null || true

# For MSVC on Windows, 'cl' may not be on PATH unless
# you are in the correct developer environment.
which cl 2>/dev/null || true
cl 2>/dev/null || true

echo ""
echo "--------------------------------------------------"
echo "5) CMake Information"
echo "--------------------------------------------------"
which cmake || true
cmake --version || true

# If you have a few extra environment variables or scripts to source on Windows,
# you might need to do that before calling cmake. For instance:
# source "C:/Program Files (x86)/Microsoft Visual Studio/2019/Professional/VC/Auxiliary/Build/vcvars64.bat"

echo ""
echo "--------------------------------------------------"
echo "6) Running CMake configuration and build"
echo "--------------------------------------------------"

# Remove or rename existing build directory, if you want a clean build:
if [ -d build ]; then
  rm -rf build
fi

# Create build directory
mkdir -p build
cd build

# You can modify the generator if needed, especially on Windows:
# e.g., -G "Visual Studio 17 2022" or -G "NMake Makefiles" etc.
# Here is a basic example that should work on Linux or with
# a suitable generator on Windows:
cmake -DCMAKE_BUILD_TYPE=Release ..

# Build the project (this uses the default target)
cmake --build . --config Release

echo ""
echo "--------------------------------------------------"
echo "7) Checking for outputs or artifacts"
echo "--------------------------------------------------"
# Optionally list the build output
ls -l

echo ""
echo "=================================================="
echo "BUILD SCRIPT FINISHED"
echo "=================================================="
