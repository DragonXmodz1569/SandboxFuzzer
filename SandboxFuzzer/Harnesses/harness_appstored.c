#include <stdint.h>
#include <stdio.h> 
#include "common.h"

void harness_appstored_test(const uint8_t *data, size_t size) {
    printf("Fuzzing AppStore with %zu bytes\n", size);
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    gFuzzIterationCount++;
    harness_appstored_test(data, size);
    return 0;
}
