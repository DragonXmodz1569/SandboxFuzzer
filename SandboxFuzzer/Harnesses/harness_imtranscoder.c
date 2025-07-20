#include <stdint.h>
#include <ImageIO/ImageIO.h>
#include "common.h"

int harness_imtranscoder_test(const uint8_t *data, size_t size) {
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, size, NULL);
    if (!provider) return 0;

    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    if (source) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        if (image) CGImageRelease(image);
        CFRelease(source);
    }

    CGDataProviderRelease(provider);
    return 0;
}
