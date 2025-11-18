#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BUFFER_SIZE 48

const char writeonly_mode[] = "w";
char flag_path[] = "flag.txt";
// const char readonly_mode[] = "r";
char some_buffer[256] = {
    0,
};

FILE *open_file(char *path, char *mode) {
  FILE *f = fopen(path, mode);
  if (f == NULL) {
    warn("failed to open file \"%s\" with mode \"%s\"", path, mode);
    return NULL;
  }
  return f;
}

int head(char *buf, size_t size, FILE *file) {
  if (file == NULL) {
    err(-1, "file is NULL!");
  }
  if (buf == NULL) {
    err(-1, "invalid buffer pointer!");
  }
  memset(buf, 0, size);

  fread(buf, 1, size, file);

  return puts(buf);
}

int vuln() {
  char buffer[BUFFER_SIZE];
  puts("exploit me!");
  fgets(buffer, 256 + BUFFER_SIZE, stdin);
  return 0;
}

int bye(int i) {
  printf("Bye Bye! (%d)\n", i);
  exit(i);
}

int main() {
  int i = vuln();
  bye(i);
}
