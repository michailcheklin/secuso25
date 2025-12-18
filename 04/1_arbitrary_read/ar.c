#include <err.h>
#include <stdio.h>
#include <stdlib.h>

void enter_sandbox();

#define FLAG_BUFFER_SIZE 0x40

// This buffer contains very sensitive and secret information and should never leak!
char flag[FLAG_BUFFER_SIZE] = {0};

typedef struct {
    char buf[28];
    char **ptr;
} data_t;

data_t *allocate_data() {
    data_t *dp = malloc(sizeof(data_t));
    if (dp == NULL)
        err(-1, "allocation failed - bailing out");

    dp->ptr = malloc(sizeof(char *));
    if (dp->ptr == NULL)
        err(-1, "allocation failed - bailing out");

    *dp->ptr = dp->buf;
    return dp;
}

void free_data(data_t *d) {
    if (d->ptr != NULL)
        free(d->ptr);
    free(d);
}

int main() {
    FILE *file = fopen("flag.txt", "rb");
    if (!file)
        err(1, "File not found! :(\n");

    fread(flag, sizeof(char), FLAG_BUFFER_SIZE - 1, file);
    flag[FLAG_BUFFER_SIZE - 1] = '\0';
    fclose(file);
    file = NULL;

    data_t *data = allocate_data();
    enter_sandbox();

    printf("[DEBUG] p (%p) -> (%p)\n", &data->ptr, data->ptr);
    puts("input:");
    if (fgets(*data->ptr, 48, stdin) == NULL)
        return -1;
    puts("output:");
    puts(*data->ptr);

    return 0;
}
