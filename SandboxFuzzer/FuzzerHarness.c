#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <dirent.h>
#include "common.h"

// libFuzzer entry point
extern int FuzzerMain(int argc, char **argv);

int main(int argc, char **argv) {
    const char *default_corpus = "/var/mobile/Documents/corpus";
    const char *corpus_dir = default_corpus;

    // Optional override
    for (int i = 1; i < argc; i++) {
        if (strncmp(argv[i], "--corpus-path=", 14) == 0) {
            corpus_dir = argv[i] + 14;
            break;
        }
    }

    // Verify corpus directory exists
    struct stat st;
    if (stat(corpus_dir, &st) != 0 || !S_ISDIR(st.st_mode)) {
        fprintf(stderr, "❌ ERROR: Corpus directory \"%s\" not found or not a directory\n", corpus_dir);
        return 1;
    }

    // Debug: list corpus contents
    DIR *dir = opendir(corpus_dir);
    if (!dir) {
        perror("opendir");
        return 1;
    }

    printf("📁 Corpus directory contents:\n");
    struct dirent *entry;
    int file_count = 0;
    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_type == DT_REG) {
            file_count++;
            char fullpath[512];
            snprintf(fullpath, sizeof(fullpath), "%s/%s", corpus_dir, entry->d_name);
            FILE *fp = fopen(fullpath, "rb");
            if (fp) {
                fseek(fp, 0, SEEK_END);
                long size = ftell(fp);
                fclose(fp);
                printf("  📄 %s - %ld bytes\n", entry->d_name, size);
            }
        }
    }
    closedir(dir);

    if (file_count == 0) {
        printf("⚠️ Corpus directory empty, creating dummy seed file.\n");
        char dummy_path[512];
        snprintf(dummy_path, sizeof(dummy_path), "%s/seed", corpus_dir);
        FILE *fp = fopen(dummy_path, "wb");
        if (fp) {
            const char *seed = "FUZZ_SEED";
            fwrite(seed, 1, strlen(seed), fp);
            fclose(fp);
            printf("✅ Dummy seed file created at: %s\n", dummy_path);
            file_count = 1;
        }
    }

    if (file_count == 0) {
        fprintf(stderr, "❌ No seed files available, aborting.\n");
        return 1;
    }

    // Setup argv for FuzzerMain
    char *argv_new[6];
    argv_new[0] = argv[0];              // executable name
    argv_new[1] = "-max_len=4096";
    argv_new[2] = "-print_final_stats=1";
    argv_new[3] = "-artifact_prefix=.";
    argv_new[4] = (char *)corpus_dir;  // corpus folder for libFuzzer
    argv_new[5] = NULL;

    printf("🚀 Starting FuzzerMain with corpus: %s\n", corpus_dir);
    return FuzzerMain(5, argv_new);
}
