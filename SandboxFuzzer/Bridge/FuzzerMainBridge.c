#include "common.h"
#include "PathHelper.h"   // include the helper header
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>       // for free()

// Declare your harness function and fuzzer entrypoint as usual

int harness_imtranscoder_test(const uint8_t *data, size_t size);

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    gFuzzIterationCount++;
    return harness_imtranscoder_test(data, size);
}

int FuzzerMain(int argc, char **argv) {
    extern int LLVMFuzzerRunDriver(int *argc, char ***argv,
                                   int (*UserCb)(const uint8_t *, size_t));
    return LLVMFuzzerRunDriver(&argc, &argv, LLVMFuzzerTestOneInput);
}

static const char *default_corpus = "./corpus";

static const char *choose_corpus_dir(int argc, char **argv) {
    for (int i = 1; i < argc; i++) {
        if (strncmp(argv[i], "--corpus-path=", 14) == 0) {
            return argv[i] + 14;
        }
    }
    return default_corpus;
}

int main(int argc, char **argv) {
    const char *docsPath = GetDocumentsPath();
    if (!docsPath) {
        fprintf(stderr, "ERROR: Failed to get Documents path\n");
        return 1;
    }

    if (chdir(docsPath) != 0) {
        fprintf(stderr, "ERROR: Failed to chdir to %s\n", docsPath);
        free((void *)docsPath);
        return 1;
    }

    free((void *)docsPath);

    const char *dir = choose_corpus_dir(argc, argv);
    struct stat st;
    if (stat(dir, &st) != 0) {
        fprintf(stderr, "ERROR: The required directory \"%s\" does not exist\n", dir);
        return 1;
    }

    return FuzzerMain(argc, argv);
}
