#include "common.h"
#include <stdatomic.h>

// Change gFuzzIterationCount to be atomic
uint64_t atomicLoadIterationCount(void) {
    return atomic_load((atomic_int*)&gFuzzIterationCount);
}
