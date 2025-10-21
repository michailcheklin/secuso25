#include "lib.h"

int _start() {
  size_t length;
  struct {
    char buf[48];
    size_t x;
    size_t y;
  } st;
  st.x = 0x6775625f;
  st.y = 0;
  memset(st.buf, 0, sizeof(st.buf));
  read(0, st.buf, sizeof(st.buf));
  asm("xor %%eax, %%eax" : : : "%eax");
  length = strlen(st.buf);
  write(1, st.buf, length);
  exit(length);
}
