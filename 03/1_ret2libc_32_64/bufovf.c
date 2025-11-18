/************************************
 * Lecture Secure Software Systems
 * University of Duisburg-Essen
 *
 * https://www.syssec.wiwi.uni-due.de
 ************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char __sh_string[] = "/bin/sh\x00\x00\x00";

void vuln() {
  char buffer[128];
  fgets(buffer, 1024, stdin);
}

int main(int argc, char *argv[]) {
  vuln();
  exit(0);
}
