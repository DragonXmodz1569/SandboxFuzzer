#ifndef COMMON_H
#define COMMON_H

#include <stdint.h>
#include <stddef.h>
#include <stdatomic.h>

// Shared atomic counter (defined once in FuzzerMainBridge.c)
extern _Atomic(uint64_t) gFuzzIterationCount;

// Each harness’s entrypoint prototype
int harness_imtranscoder_test(const uint8_t *data, size_t size);
int harness_appstored_test(const uint8_t *data, size_t size);
int harness_airplay_rtsp_test(const uint8_t *data, size_t size);
// …add one prototype per harness you implement…

#endif // COMMON_H
