#import <Foundation/Foundation.h>
#import "PathHelper.h"
#include <stdlib.h>

const char *GetDocumentsPath(void) {
    @autoreleasepool {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        return strdup([path UTF8String]);
    }
}
