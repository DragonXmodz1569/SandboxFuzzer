#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <limits.h>
#include "common.h"

// libFuzzer entry point
extern int FuzzerMain(int argc, char **argv);

int main(int argc, char **argv) {
    // Get sandbox Documents path (inside app container)
    const char *home_dir = getenv("HOME");
    if (!home_dir) {
        fprintf(stderr, "ERROR: Could not get HOME environment variable.\n");
        return 1;
    }

    char corpus_path[PATH_MAX];
    snprintf(corpus_path, sizeof(corpus_path), "%s/Documents/corpus", home_dir);

    // Create the directory if it doesn't exist
    struct stat st;
    if (stat(corpus_path, &st) != 0) {
        if (mkdir(corpus_path, 0777) != 0) {
            perror("ERROR: Could not create corpus directory");
            return 1;
        } else {
            printf("INFO: Created directory: %s\n", corpus_path);
        }
    } else {
        printf("INFO: corpus directory already exists at: %s\n", corpus_path);
    }

    // Prepare arguments for libFuzzer
    char *fuzzer_argv[] = {
        "fuzzer",
        corpus_path,
        NULL
    };

    return FuzzerMain(2, fuzzer_argv);
}
