#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <dirent.h>
#include "common.h"

// libFuzzer entrypoint
extern int FuzzerMain(int argc, char **argv);

// Called from Swift
int FuzzerHarness(const char *corpus_dir) {
    fprintf(stderr, "🔍 [Harness] corpus_dir = '%s'\n", corpus_dir);
    struct stat st;
    if (stat(corpus_dir, &st) != 0 || !S_ISDIR(st.st_mode)) {
        fprintf(stderr, "❌ ERROR: Corpus directory '%s' not found\n", corpus_dir);
        return 1;
    }

    DIR *dir = opendir(corpus_dir);
    if (!dir) { perror("opendir"); return 1; }
    fprintf(stderr, "📁 Corpus contents:\n");
    struct dirent *e;
    int count=0;
    while ((e = readdir(dir))) {
        if (e->d_type == DT_REG) {
            count++;
            char path[512];
            snprintf(path, sizeof(path), "%s/%s", corpus_dir, e->d_name);
            FILE *f = fopen(path, "rb");
            if (f) { fseek(f,0,SEEK_END); long sz=ftell(f); fclose(f);
                fprintf(stderr, "  📄 %s - %ld bytes\n", e->d_name, sz);
            }
        }
    }
    closedir(dir);
    if (count==0) {
        fprintf(stderr,"⚠️ Empty corpus, creating dummy seed\n");
        char dp[512]; snprintf(dp,sizeof(dp),"%s/seed",corpus_dir);
        FILE *f=fopen(dp,"wb");
        if(f){ fwrite("FUZZ_SEED",1,9,f); fclose(f);
            fprintf(stderr,"✅ Dummy seed at %s\n",dp);
            count=1;
        }
    }

    char *argv_new[6];
    argv_new[0] = "SandboxFuzzer";
    argv_new[1] = "-max_len=4096";
    argv_new[2] = "-print_final_stats=1";
    argv_new[3] = "-artifact_prefix=.";
    argv_new[4] = (char*)corpus_dir;
    argv_new[5] = NULL;

    fprintf(stderr,"🚀 Starting FuzzerMain with %s\n",corpus_dir);
    return FuzzerMain(5, argv_new);
}

// expose to Swift
uint64_t atomicLoadIterationCount(void) {
    return atomicLoadIterationCount_impl();
}
