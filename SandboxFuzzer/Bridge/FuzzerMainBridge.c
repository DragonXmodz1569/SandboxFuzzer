// FuzzerMainBridge.c
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

// Declare the real fuzz target
extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);

// Wrap the fuzzer main
int FuzzerMain(int argc, char **argv) {
    extern int LLVMFuzzerRunDriver(int *argc, char ***argv, int (*UserCb)(const uint8_t *, size_t));
    return LLVMFuzzerRunDriver(&argc, &argv, LLVMFuzzerTestOneInput);
}
