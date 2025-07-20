#include "common.h"
#include "PathHelper.h"   // include the helper header
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>       // for free()
#include <limits.h>       // for PATH_MAX

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

static char default_corpus[PATH_MAX] = {0};

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

    // Build default corpus path
    snprintf(default_corpus, sizeof(default_corpus), "%s/corpus", docsPath);

    // Create the directory if it doesn't exist
    struct stat st;
    if (stat(default_corpus, &st) != 0) {
        if (mkdir(default_corpus, 0777) != 0) {
            perror("ERROR: Could not create corpus directory");
            free((void *)docsPath);
            return 1;
        } else {
            printf("INFO: Created corpus directory at %s\n", default_corpus);
        }
    } else {
        printf("INFO: corpus directory exists at %s\n", default_corpus);
    }

    free((void *)docsPath);

    return FuzzerMain(argc, argv);
}
