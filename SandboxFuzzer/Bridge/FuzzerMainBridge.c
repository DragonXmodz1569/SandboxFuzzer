#include <stdatomic.h>

extern _Atomic uint64_t gFuzzIterationCount;

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    atomic_fetch_add(&gFuzzIterationCount, 1);
    // your fuzzing code...
    return 0;
}

int FuzzerMain(int argc, char **argv) {
    extern int LLVMFuzzerRunDriver(int *argc, char ***argv,
                                   int (*UserCb)(const uint8_t *, size_t));
    return LLVMFuzzerRunDriver(&argc, &argv, LLVMFuzzerTestOneInput);
}

uint64_t GetFuzzIterationCount(void) {
    return atomic_load(&gFuzzIterationCount);
}
