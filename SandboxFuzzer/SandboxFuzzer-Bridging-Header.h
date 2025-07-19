// SandboxFuzzer-Bridging-Header.h

#ifndef SandboxFuzzer_Bridging_Header_h
#define SandboxFuzzer_Bridging_Header_h

#include <stdint.h>

// Expose only what Swift needs:
extern uint64_t gFuzzIterationCount;
int FuzzerMain(int argc, char **argv);

#endif /* SandboxFuzzer_Bridging_Header_h */
