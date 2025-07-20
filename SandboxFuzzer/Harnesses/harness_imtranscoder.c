#include "common.h"
#include <stdatomic.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

// This is now a normal function, not the Fuzzer entrypoint.
int harness_imtranscoder_test(const uint8_t *data, size_t size) {
    atomic_fetch_add(&gFuzzIterationCount, 1);

    if (size > 0) {
        CFDataRef cf = CFDataCreate(NULL, data, size);
        if (cf) CFRelease(cf);
    }
    int fd = open("/var/root/secret.txt", O_RDONLY);
    if (fd >= 0) {
        close(fd);
        exit(1);
    }
    return 0;
}
