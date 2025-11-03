/************************************
 * Lecture Secure Software Systems
 * University of Duisburg-Essen
 *
 * https://www.syssec.wiwi.uni-due.de
 ************************************/

#include <err.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/// simple wrapper around malloc for simpler error handling
void *checked_malloc(size_t sz) {
  char *p = malloc(sz);
  if (p == NULL) {
    err(EXIT_FAILURE, "malloc failed - ");
  }
  return p;
}

void success(void) {
  puts("SUCCESS!");
  exit(0);
}

void fail(void) {
  puts("FAIL!");
  exit(0);
}

void interact(char *buf) {
  size_t length = 0;
  int r = 0;
  char *wr = 0;
  while (true) {
    puts("== Heartbeat ==");
    puts("Enter word length:");
    r = scanf("%zu", &length);
    // getchar also removes '\n' from buffer
    if (r == EOF || getchar() == EOF || r != 1 || length == 0) {
      puts("Exiting. Bye bye.");
      break;
    }
    puts("Enter a word:");
    wr = fgets(buf, length, stdin);
    if (wr == NULL || buf[length] != 0) {
      warn("Invalid word! (fgets? ");
      continue;
    }

    puts("Your word:");
    fwrite(buf, length, 1, stdout);
    if (buf[length - 2] != '\n') {
      fputc('\n', stdout);
    }
  }
}

int main(void) {
  char *input_buffer = checked_malloc(96);
  void (**fptr)(void) = checked_malloc(sizeof(void (*)(void)));
  *fptr = fail;

  interact(input_buffer);

  (*fptr)();

  return 0;
}
