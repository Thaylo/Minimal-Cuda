// main.cpp
#include <cstdio>
#include "montecarlo_kernels.h"
#include <cmath>  // for expf()

int main() {
    printf("=== GPU Monte Carlo for European Call ===\n");

    const int   N        = 1 << 24;  // Number of simulation paths.
    const float S0       = 106.162f;   // Spot price.
    const float K        = 95.0f;      // Strike.
    const float r        = 0.01f;      // Risk-free rate.
    const float sigma    = 0.5f;       // Volatility.
    const float T        = 2.0f/12;    // Time to maturity.
    const float discount = expf(-r * T);

    double optionPrice = 0.0;
    runMonteCarlo(S0, K, r, sigma, T, N, 1234UL, discount, &optionPrice);

    printf("Option Price ~= %.4f\n", optionPrice);

    return 0;
}
