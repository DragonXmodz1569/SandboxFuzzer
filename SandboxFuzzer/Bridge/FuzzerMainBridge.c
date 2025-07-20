#include "common.h"
#include "PathHelper.h"
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <limits.h>

int harness_imtranscoder_test(const uint8_t *data, size_t size);

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    gFuzzIterationCount++;
    return harness_imtranscoder_test(data, size);
}

int LLVMFuzzerRunDriver(int *argc, char ***argv, int (*UserCb)(const uint8_t *, size_t));

int FuzzerMain(int argc, char **argv) {
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

    // Build path to SandboxFuzzer/corpus
    snprintf(default_corpus, sizeof(default_corpus), "%s/corpus", docsPath);
    char sandboxDir[PATH_MAX];
    snprintf(sandboxDir, sizeof(sandboxDir), "%s/SandboxFuzzer", docsPath);

    struct stat st;

    // Create SandboxFuzzer directory if it doesn't exist
    if (stat(sandboxDir, &st) != 0) {
        if (mkdir(sandboxDir, 0777) != 0) {
            perror("ERROR: Could not create SandboxFuzzer directory");
            free((void *)docsPath);
            return 1;
        }
    }

    // Create corpus directory if it doesn't exist
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
