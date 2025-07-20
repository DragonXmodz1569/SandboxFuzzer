#ifndef SandboxFuzzer_Bridging_Header_h
#define SandboxFuzzer_Bridging_Header_h

#include <stdint.h>

// from common.c
uint64_t atomicLoadIterationCount(void);

// our harness entrypoint
int FuzzerHarness(const char *corpus_dir);

// core libFuzzer symbol
extern int FuzzerMain(int argc, char **argv);

#endif /* SandboxFuzzer_Bridging_Header_h */
