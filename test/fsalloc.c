#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fsalloc.h"

static void ferr(Error* e) {
    if (e->message != NULL) {
        fprintf(stderr, "line %u, function %s, file %s for %s\n", e->line, e->function, e->file, e->message);
        exit(1);
    }
}

static void fres(Result* r) {
    if (r->has_value) {
        return;
    }

    ferr(&r->result.error);
}

static int t32(void* dst) {
    *(int*)dst = rand();
    return *(int*)dst;
}

int main(int argc, char* argv[]) {
    FsAllocator allocator;

    Error error = fsalloc_init(&allocator, sizeof(int), 0, -1);

    ferr(&error);

    Result result = fsalloc(&allocator);

    fres(&result);

    int d = t32(result.result.data.to_ptr);

    printf("t32 returns %d\n", d);

    error = fsfree(&allocator, &result.result.data.to_ptr);

    ferr(&error);

    error = fsalloc_destroy(&allocator);

    ferr(&error);

    return 0;
}