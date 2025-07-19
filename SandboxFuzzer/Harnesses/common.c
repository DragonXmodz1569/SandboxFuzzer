// Harnesses/common.c
#include "../Bridge/Bridge.h"  // in .c files
#include <stdatomic.h>

// Atomic iteration counter, zero-initialized by C standard
_Atomic uint64_t gFuzzIterationCount = 0;
