/* Lecture Secure Software Systems
 * University of Duisburg-Essen
 * Winter Term 2022
 */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int check_result;
extern char* NOT_SO_SECRET_KEY;

void find_me(void) {
  puts("Congratulations, you found me!");

  char line[256];
  char* not_so_secret_key = NOT_SO_SECRET_KEY;

  puts("Do you know the secret key?");

  if (fgets(line, (sizeof line), stdin) != NULL) {
    if (strcmp(line, not_so_secret_key) == 0) {
      puts("SUCCESS!");
      exit(0);
    } else {
      puts("FAILURE!");
      exit(1);
    }
  }
  exit(1);
}

int main(void) {
  puts("Input address of 'find_me' function (packed binary format):");
  char line[256];

  if (fgets(line, sizeof line, stdin) != NULL) {
    int check = *((int *)line);
    printf("Input cast to (interpreted as) integer: %p\n", (void *)check);
    if ((check ^ 0x3184a39) == check_result) {
      // equivalent to calling `find_me();`
      ((void (*)(void))check)();
    }
  }
  puts("FAILURE!");
  exit(1);
}
