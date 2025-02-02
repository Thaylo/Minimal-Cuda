// montecarlo_kernels.h
#ifndef MONTECARLO_KERNELS_H
#define MONTECARLO_KERNELS_H

#ifdef __cplusplus
extern "C" {
#endif

void runMonteCarlo(float S0, float K, float r, float sigma, float T,
                   int N, unsigned long seed, float discount, double* optionPrice);

#ifdef __cplusplus
}
#endif

#endif // MONTECARLO_KERNELS_H
