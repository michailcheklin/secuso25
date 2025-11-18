#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BUFFER_SIZE 32

int compute(int a, int b) {
  int x = a << 30 ^ 0x43cd;
  x += b;
  if (x < 0) {
    return 0x40f;
  } else {
    return 0x50f;
  }
}

int vuln(void) {
  int sz = 0;
  char buffer[BUFFER_SIZE];
  sz = printf("[DEBUG] reading into buffer at: %p\n", buffer);
  fgets(buffer, 512, stdin);
  explicit_bzero(buffer, sizeof(buffer));
  return 0;
}

int main() {
  puts("exploit me!");
  vuln();
  return 0;
}
