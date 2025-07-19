#ifndef SandboxFuzzer_Bridging_Header_h
#define SandboxFuzzer_Bridging_Header_h

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void FuzzerMain(void);
uint64_t atomicLoadIterationCount(void);

#ifdef __cplusplus
}
#endif

#endif /* SandboxFuzzer_Bridging_Header_h */
