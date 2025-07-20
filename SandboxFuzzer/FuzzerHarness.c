#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include "common.h"

// Declare FuzzerMain as provided by your libfuzzer stub
extern int FuzzerMain(int argc, char **argv);

int main(int argc, char **argv) {
    // ── 1) Default in case no flag is passed ───────────────────────────
    const char *default_corpus = "/var/mobile/Documents/corpus/";
    const char *corpus_dir = default_corpus;

    // ── 2) Scan argv for our flag ─────────────────────────────────────
    for (int i = 1; i < argc; i++) {
        if (strncmp(argv[i], "--corpus-path=", 14) == 0) {
            corpus_dir = argv[i] + 14;
            break;
        }
    }

    // ── 3) Verify the directory exists ─────────────────────────────────
    struct stat st;
    if (stat(corpus_dir, &st) != 0) {
        fprintf(stderr,
                "ERROR: The required directory \"%s\" does not exist\n",
                corpus_dir);
        return 1;
    }

    // ── 4) Now call your fuzzer entry point ────────────────────────────
    //    If your FuzzerMain has a different signature, adjust accordingly
    return FuzzerMain(argc, argv);
}
