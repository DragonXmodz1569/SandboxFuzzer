// Harnesses/harness_imtranscoder.c
#include <stdatomic.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include "../SandboxFuzzer-Bridging-Header.h"

_Atomic uint64_t gFuzzIterationCount = 0;

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    atomic_fetch_add_explicit(&gFuzzIterationCount, 1, memory_order_relaxed);
    
    // Example stub logic
    if (size > 0) {
        CFDataRef cf = CFDataCreate(NULL, data, size);
        if (cf) CFRelease(cf);
    }

    // Sandbox escape detection
    int fd = open("/var/root/secret.txt", O_RDONLY);
    if (fd >= 0) {
        close(fd);
        exit(0); // Treat as crash
    }

    return 0;
}
