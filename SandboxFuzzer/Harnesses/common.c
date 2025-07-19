// Harnesses/common.c
#include <stdatomic.h>

// Atomic iteration counter, zero-initialized by C standard
_Atomic uint64_t gFuzzIterationCount = 0;
