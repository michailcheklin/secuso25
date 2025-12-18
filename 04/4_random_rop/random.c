#include <err.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#define BASE 0x5500000000
#define SPACE 4096

int secret_function(uint64_t a, uint64_t b, uint64_t c, uint64_t d) {
  if (!a) {
    return a + b + c + d;
  } else if (a & ~0xff) {
    return secret_function(0, a, a, a);
  }

  if (a && b && c && d && a > b && a + b == 0xBE && c > d && c + d == 0xEF) {
    puts("YOU DID IT !");
    exit(0);
  } else {
    puts("almost!");
    exit(1);
  }
}

int main(int argc, char const *argv[]) {
  // get some memory at BASE address
  uint8_t *rnd = (uint8_t *)mmap(
      (void *)BASE, SPACE + sizeof(void *), PROT_READ | PROT_WRITE,
      MAP_ANON | MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
  if (rnd == MAP_FAILED)
    err(1, "Oh no, mmap failed! - ");

  // fill with random data (almost)
  srand(time(NULL) * (uint64_t)secret_function + rnd[0]);
  for (size_t i = 0; i < SPACE; ++i) {
    rnd[i] = rand();
    if (i % 15 == rand() % 15)
      rnd[i] = -1;
    if (i % 5 == rand() % 5) {
      rnd[i] = rnd[i] >> 4 | 0x50;
      if (i % 15 == rand() % 15 + 1)
        rnd[i - 1] &= 0x5f;
    }
    if (i % 6 == rand() % 6)
      rnd[i] = 0xc3;
    if (i && rnd[i - 1] == 0xff && rand() & 1)
      rnd[i] = 0xc0 * (rnd[i] & 1) + 16 | rnd[i] >> 4;
  }

#ifndef HARDMODE
  *(void **)&rnd[SPACE] = secret_function;
#endif

  // make it executable
  if (mprotect(rnd, SPACE, PROT_READ | PROT_EXEC)) {
    err(1, "Oh no, mprotect failed! - ");
  }

  // "information leak"
  for (size_t i = 0; i < SPACE; ++i) {
    if (i && !(i % 64))
      puts("");
    printf("%02x", rnd[i]);
  }
  puts("\nHere random code, now find some ROP gadgets!\n"
       "Even skipped the overflow part for you! Just send the chain!");
  char buf[256];
  ssize_t r = read(0, buf, sizeof(buf));
  if (r < 5) {
    errx(2, "need more gadgets! got only %zd bytes", r);
  }

  // start the chain
  secret_function((uint64_t)secret_function, 0, 0, 0);
  asm("mov %0, %%rsp; ret" ::"r"(buf));
  return 0;
}
