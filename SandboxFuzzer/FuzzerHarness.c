#include <stdatomic.h>
#include <stdint.h>

extern _Atomic uint64_t gFuzzIterationCount;

uint64_t atomicLoadIterationCount(void) {
    return atomic_load_explicit(&gFuzzIterationCount, memory_order_relaxed);
}
