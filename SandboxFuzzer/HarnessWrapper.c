#include "common.h"
#include <stdatomic.h>
#include <stdint.h>

// Forward‐declare your real harness function here.
// If you use harness_imtranscoder_test(), declare that.
// If you pick another, change this line accordingly!
int harness_imtranscoder_test(const uint8_t *data, size_t size);

// This is the one libFuzzer expects.
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // bump the counter
    atomic_fetch_add(&gFuzzIterationCount, 1);
    // forward to your actual harness
    return harness_imtranscoder_test(data, size);
}
