// Harnesses/harness_appstored.c
#include "../Bridge/Bridge.h"  // in .c files
#include <stdatomic.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    atomic_fetch_add(&gFuzzIterationCount, 1);

    // Simulate basic request inspection
    if (size > 0 && data[0] == 'A') {
        // Stub logic for valid AppStore install request
    }

    // Sandbox escape detection
    int fd = open("/var/root/secret.txt", O_RDONLY);
    if (fd >= 0) {
        close(fd);
        exit(0);
    }

    return 0;
}
