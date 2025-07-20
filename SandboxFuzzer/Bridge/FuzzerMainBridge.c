#include "common.h"
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>

// Declare the harness function
int harness_imtranscoder_test(const uint8_t *data, size_t size);

// libFuzzer callback: defined exactly once
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // Dispatch to the desired harness
    return harness_imtranscoder_test(data, size);
}

// Shim that calls into libFuzzer's driver
int FuzzerMain(int argc, char **argv) {
    extern int LLVMFuzzerRunDriver(int *argc, char ***argv,
                                    int (*UserCb)(const uint8_t *, size_t));
    return LLVMFuzzerRunDriver(&argc, &argv, LLVMFuzzerTestOneInput);
}

// Default corpus path if not overridden
static const char *default_corpus = "/var/mobile/Documents/corpus/";

// Look for "--corpus-path=" in argv
static const char *choose_corpus_dir(int argc, char **argv) {
    for (int i = 1; i < argc; i++) {
        if (strncmp(argv[i], "--corpus-path=", 14) == 0) {
            return argv[i] + 14;
        }
    }
    return default_corpus;
}

// Actual main(): verify corpus dir, then hand off to FuzzerMain shim
int main(int argc, char **argv) {
    const char *dir = choose_corpus_dir(argc, argv);
    struct stat st;
    if (stat(dir, &st) != 0) {
        fprintf(stderr,
                "ERROR: The required directory \"%s\" does not exist\n", dir);
        return 1;
    }
    return FuzzerMain(argc, argv);
}
