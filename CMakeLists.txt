cmake_minimum_required(VERSION 3.20)
project(MonteCarloOption LANGUAGES CXX CUDA)

enable_language(CUDA)

# Set your C++/CUDA standards as needed.
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CUDA_STANDARD 14)

# Enable device code separation for easier linking.
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)

# Create an executable named 'MonteCarlo' with both source files.
add_executable(MonteCarlo main.cpp montecarlo_kernels.cu)

# (Optional) Add special compiler flags for CUDA if needed.
# target_compile_options(MonteCarlo PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-Xptxas -v>)
