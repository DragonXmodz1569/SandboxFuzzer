#include <stddef.h>

void __sanitizer_acquire_crash_state(void) { }
void __sanitizer_print_stack_trace(void) { }
void __sanitizer_set_death_callback(void (*callback)(void)) {
    (void)callback;
}
