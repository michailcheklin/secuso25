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

void success(void) {
  puts("SUCCESS!");
  exit(0);
}

void vuln(void) {
  char buf[140] = {0};
  puts("exploit me!");
  read(0, buf, sizeof(buf) + 32);
}

int main(void) {
  puts("Calling vulnerable function");
  vuln();
  puts("FAILURE!");
  exit(1);
}
