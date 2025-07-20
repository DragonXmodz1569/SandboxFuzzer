#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include "common.h"

// Declare FuzzerMain from libFuzzer stub
extern int FuzzerMain(int argc, char **argv);

int main(int argc, char **argv) {
    const char *default_corpus = "/var/mobile/Documents/corpus/";
    const char *corpus_dir = default_corpus;

    // Scan for custom --corpus-path override
    for (int i = 1; i < argc; i++) {
        if (strncmp(argv[i], "--corpus-path=", 14) == 0) {
            corpus_dir = argv[i] + 14;
            break;
        }
    }

    // Check corpus directory exists
    struct stat st;
    if (stat(corpus_dir, &st) != 0 || !S_ISDIR(st.st_mode)) {
        fprintf(stderr, "❌ ERROR: Corpus directory \"%s\" not found or not a directory\n", corpus_dir);
        return 1;
    }

    // Construct new argv with corpus_dir if no files passed
    char *argv_new[3];
    argv_new[0] = argv[0]; // binary name
    argv_new[1] = (char *)corpus_dir;
    argv_new[2] = NULL;

    printf("🚀 Launching FuzzerMain with corpus dir: %s\n", corpus_dir);
    return FuzzerMain(2, argv_new);
}
