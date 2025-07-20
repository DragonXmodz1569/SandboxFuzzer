#ifndef SandboxFuzzer_Bridging_Header_h
#define SandboxFuzzer_Bridging_Header_h

#include <stdint.h>
#include "common.h"

#ifdef __cplusplus
extern "C" {
#endif

uint64_t atomicLoadIterationCount(void);
int FuzzerMain(int argc, char **argv);  // <-- match this to actual function
uint64_t GetFuzzIterationCount(void);

#ifdef __cplusplus
}
#endif

#endif /* SandboxFuzzer_Bridging_Header_h */
