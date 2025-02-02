// montecarlo_kernels.cu
#include <cstdio>
#include <cmath>
#include <curand.h>
#include <curand_kernel.h>
#include <cuda_runtime.h>

#define CUDA_CHECK(call) do {                                \
    cudaError_t err = (call);                                \
    if (err != cudaSuccess) {                                \
        fprintf(stderr, "CUDA Error at %s:%d: %s\n",         \
                __FILE__, __LINE__, cudaGetErrorString(err));\
        exit(EXIT_FAILURE);                                  \
    }                                                        \
} while (0)

__global__ void initRNGKernel(curandState* states, unsigned long seed) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    curand_init(seed, idx, 0, &states[idx]);
}

__global__ void monteCarloKernel(curandState* states,
                                 float* d_payoffs,
                                 float  S0, 
                                 float  K,
                                 float  r, 
                                 float  sigma,
                                 float  T,
                                 int    N) 
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < N) {
        float z = curand_normal(&states[idx]);
        float ST = S0 * expf((r - 0.5f * sigma * sigma) * T +
                             sigma * sqrtf(T) * z);
        float payoff = fmaxf(ST - K, 0.0f);
        d_payoffs[idx] = payoff;
    }
}

// Host wrapper function callable from C++ code.
extern "C" void runMonteCarlo(float S0, float K, float r, float sigma, float T,
                              int N, unsigned long seed, float discount, double* optionPrice)
{
    curandState* d_states = nullptr;
    float* d_payoffs = nullptr;
    CUDA_CHECK(cudaMalloc(&d_states, N * sizeof(curandState)));
    CUDA_CHECK(cudaMalloc(&d_payoffs, N * sizeof(float)));

    const int BLOCK_SIZE = 256;
    const int GRID_SIZE  = (N + BLOCK_SIZE - 1) / BLOCK_SIZE;

    // Initialize RNG on device.
    initRNGKernel<<<GRID_SIZE, BLOCK_SIZE>>>(d_states, seed);
    CUDA_CHECK(cudaDeviceSynchronize());
 
    // Launch the Monte Carlo kernel.
    monteCarloKernel<<<GRID_SIZE, BLOCK_SIZE>>>(
        d_states, d_payoffs, 
        S0, K, r, sigma, T, N
    );
    CUDA_CHECK(cudaDeviceSynchronize());

    // Copy results back to host.
    float* h_payoffs = (float*)malloc(N * sizeof(float));
    CUDA_CHECK(cudaMemcpy(h_payoffs, d_payoffs, N * sizeof(float), cudaMemcpyDeviceToHost));

    double sum = 0.0;
    for (int i = 0; i < N; ++i) {
        sum += (double)h_payoffs[i] / N;
    }
    *optionPrice = discount * sum;

    free(h_payoffs);
    CUDA_CHECK(cudaFree(d_states));
    CUDA_CHECK(cudaFree(d_payoffs));
}
