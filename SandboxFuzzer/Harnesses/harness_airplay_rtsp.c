#include <stdint.h>
#include <stdio.h>
#include "common.h"

// Minimal implementation for AirPlay RTSP testing
void harness_airplay_rtsp_test(const uint8_t *data, size_t size) {
    printf("Fuzzing AirPlay RTSP with %zu bytes\n", size);
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    gFuzzIterationCount++;
    harness_airplay_rtsp_test(data, size);
    return 0;
}
