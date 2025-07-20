#ifndef PATHHELPER_H
#define PATHHELPER_H

#ifdef __cplusplus
extern "C" {
#endif

// Returns a strdup'ed string with the Documents path.
// Caller must free() the returned pointer.
const char *GetDocumentsPath(void);

#ifdef __cplusplus
}
#endif

#endif /* PATHHELPER_H */
