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
__uint32_t explain_me(__uint64_t arg1) {

  __uint32_t var_10h = arg1;

  if(var_10h < 2){
    if(var_10h != 1){
      __uint32_t var_ch = 0;
      __uint32_t eax = var_ch;
      return eax;
    } else {
      __uint32_t var_ch = 1;
      __uint32_t eax = var_ch;
      return eax;
    }
  } else {
    __uint32_t edi = var_10h;
    edi --;
    __uint32_t eax = explain_me(edi);
    __uint32_t var_14h = eax;
    edi = var_10h;
    edi -=2;
    eax = explain_me(edi);
    __uint32_t ecx = eax;
    eax = var_14h;
    eax += ecx;
    __uint32_t var_ch = eax;
    eax = var_ch;
    return eax;


  }
}

int main(int argc, char *argv[]) {
  if (argc == 2) {
    printf("%i\n", explain_me(atoi(argv[1])));
  } else {
    printf("usage: %s <arg>(int)\n", argv[0]);
  }
  return 0;
}
