#ifndef BRIDGE_H
#define BRIDGE_H

#include <stdatomic.h>
#include <stdint.h>

extern _Atomic uint64_t gFuzzIterationCount;

int FuzzerMain(int argc, char **argv);

#endif /* BRIDGE_H */
