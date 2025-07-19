// Harnesses/harness_airplay_rtsp.c
#include "../Bridge/Bridge.h"  // in .c files
#include <stdatomic.h>
#include <CoreFoundation/CoreFoundation.h>
#include <CFNetwork/CFHTTPMessage.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

// Stub for private parser call
extern void RTSPParserProcess(CFHTTPMessageRef msg);

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    atomic_fetch_add(&gFuzzIterationCount, 1);

    // Create a fake RTSP HTTP request
    CFURLRef url = CFURLCreateWithString(NULL, CFSTR("rtsp://localhost/stream"), NULL);
    CFHTTPMessageRef req = CFHTTPMessageCreateRequest(NULL, CFSTR("GET"), url, kCFHTTPVersion1_0);
    CFRelease(url);

    if (size > 0 && req) {
        CFDataRef hdr = CFDataCreate(NULL, data, size);
        CFHTTPMessageSetHeaderFieldValue(req, CFSTR("X-Apple-Payload"), hdr);
        RTSPParserProcess(req); // Process with stubbed parser
        CFRelease(hdr);
        CFRelease(req);
    }

    // Sandbox escape detection
    int fd = open("/var/root/secret.txt", O_RDONLY);
    if (fd >= 0) {
        close(fd);
        exit(0);
    }

    return 0;
}
