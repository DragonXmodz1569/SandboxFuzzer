#include "common.h"
#include <stdatomic.h>

uint64_t atomicLoadIterationCount(void) {
    return atomic_load(&gFuzzIterationCount);
}
