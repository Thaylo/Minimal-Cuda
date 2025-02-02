# GPU-Accelerated Simulations for Option Pricing

This repository contains GPU-Accelerated Simulations for Option Pricing.

What has been implemented:
- A **single-step Monte Carlo simulation** for pricing a **European call option** under a **Geometric Brownian Motion (GBM)** model using **NVIDIA CUDA**. It’s a **GPU-accelerated** approach designed to demonstrate parallel computing, random number generation, and basic quantitative finance knowledge.

## Author

[Thaylo de Freitas](https://www.linkedin.com/in/thaylo-freitas/)

## Overview

### Languages and Technologies
- **C++/CUDA**
- **cuRAND** for random number generation
- **CMake** build system

### Core Functionality
- **Initialize random states** on the GPU using `curandState`.
- Launch a **Monte Carlo kernel**, where each GPU thread simulates one draw of the final asset price $S_T$.
- **Compute** the European call payoff $max(S_T - K, 0)$ for each thread/path.
- **Transfer** results back to the CPU and **average** (discounted) payoff to get the option price.

Because this is a **European** option - dependent only on the terminal price $S_T$ - we can do it **in one step**, without multiple time increments. For path-dependent or early-exercise options (Asian, Barrier, American), one could extend this with multi-step logic or further modifications.

## Prerequisites

- **CUDA Toolkit** (version 12.x or newer)
- **CMake** (version 3.20+ is recommended)
- A supported **C++ compiler** (e.g., MSVC, g++, clang++) with CUDA integration
- Bash shell environment for running the build script (available on Linux/macOS or via Git Bash on Windows)
- **Windows-specific**: Visual Studio Build Tools and Windows SDK are required; on Linux: install the CUDA Toolkit from your distro’s repository or the official NVIDIA repository
- **Linux**: Install the CUDA toolkit from your distro’s repository or the official NVIDIA repo.

## Building

Below is an example for **Windows** using **Git Bash**. Adjust paths for your environment:


```
git clone https://github.com/Thaylo/cuda-montecarlo.git
cd cuda-montecarlo
chmod +x build_script.sh
./build_script.sh
```
The script performs the following steps:

- Displays system, CUDA, compiler, and CMake information.
- Removes any existing build directory to ensure a clean build.
- Creates a new build directory.
- Configures the project with CMake (using the Release build type).
- Builds the project.
- Lists the generated artifacts.

*Note:
On Windows, if you are using Git Bash or another bash-compatible shell, the provided build script should work provided that the required tools (CMake, CUDA, and a suitable compiler) are in your PATH. Adjust environment variables or source any necessary setup scripts if required.*

## Running

Run the generated executable:

```
./MonteCarlo
```

Sample Output:

```
=== GPU Monte Carlo for European Call ===
Option Price ~= 15.0352
```

The result depends on the chosen parameters (spot price, strike, volatility, etc.) and random seed.

## Performance Discussion

By launching millions of threads, the GPU parallelizes each path’s payoff calculation. This code typically outperforms a CPU-only approach for large path counts $N$, especially if the GPU is well utilized.

## Future Work

Future enhancements may include:

- Implementing simulations for path-dependent options (e.g., multi-step simulation for Asian, Barrier, or American options).
- Adding data visualization to better analyze simulation outcomes.

## References & Acknowledgments

- John C. Hull, Options, Futures, and Other Derivatives – a standard reference for derivatives pricing.

- [Geometric Brownian motion Article on Wikipedia](https://en.wikipedia.org/wiki/Geometric_Brownian_motion)  

- [NVIDIA CUDA Docs](https://docs.nvidia.com/cuda/index.html)  

- [NVIDIA CURAND Docs](https://docs.nvidia.com/cuda/curand/index.html)