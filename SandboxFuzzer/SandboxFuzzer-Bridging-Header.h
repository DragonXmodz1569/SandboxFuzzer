// SandboxFuzzer-Bridging-Header.h

#ifndef SandboxFuzzer_Bridging_Header_h
#define SandboxFuzzer_Bridging_Header_h

#include <stdint.h>

// From common.c
uint64_t atomicLoadIterationCount(void);

// Our harness entrypoint
int FuzzerHarness(const char *corpus_dir);

// Core libFuzzer entrypoint (linked from the harness library)
extern int FuzzerMain(int argc, char **argv);

#endif /* SandboxFuzzer_Bridging_Header_h */
