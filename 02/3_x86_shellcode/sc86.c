/************************************
 * Lecture Secure Software Systems
 * University of Duisburg-Essen
 *
 * https://www.syssec.wiwi.uni-due.de
 ************************************/

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern char shellcode[128];

void vuln(void) {
  char buf[32];
  puts("exploit me!");
  read(0, buf, sizeof(buf) + 32);
}

int main(void) {
  puts("Welcome to \"shellcode as a service\"\n"
       "Send your shellcode now (max 128 bytes):");

  ssize_t r = read(0, shellcode, sizeof(shellcode));
  if (r < 0) {
    err(1, "failed to read shellcode (%zd)", r);
    return 1;
  }

  printf("OK - got %zd bytes of shellcode\n", r);
  puts("Calling vulnerable function");
  vuln();
  puts("nope... that didn't work out");
  return 0;
}
