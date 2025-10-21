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

// TODO: re-implement according to the binary `cfa`
void explain_me() {
  // TODO:
}

int main(int argc, char *argv[]) {
  if (argc == 2) {
    printf("%i\n", explain_me(atoi(argv[1])));
  } else {
    printf("usage: %s <arg>(int)\n", argv[0]);
  }
  return 0;
}
