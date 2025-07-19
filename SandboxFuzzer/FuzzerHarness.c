// FuzzerHarness.c
#include <stdatomic.h>
#include <stdint.h>
#include <stddef.h>
#include <CoreFoundation/CoreFoundation.h>

// Use C11 _Atomic on a uint64_t
_Atomic uint64_t gFuzzIterationCount = 0;

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // increment the counter atomically
    atomic_fetch_add(&gFuzzIterationCount, 1);

    if (size == 0) return 0;
    CFDataRef cfData = CFDataCreate(NULL, data, size);
    if (cfData) CFRelease(cfData);
    return 0;
}
