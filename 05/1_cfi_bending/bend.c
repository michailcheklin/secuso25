/************************************
 * Lecture Secure Software Systems
 * University of Duisburg-Essen
 *
 * https://www.syssec.wiwi.uni-due.de
 ************************************/

#include <err.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/random.h>
#include <unistd.h>

#ifndef CLANG_FLAGS
#define CLANG_FLAGS ""
#endif

typedef struct _String String;
struct _String {
  char buffer[32];
  void (*append)(String *self, char *x);
  void (*print)(String *self);
  void (*set)(String *self, char *x);
  int (*terminate)(char *);
};

String *str;

void _print_to_stdout(String *self) {
  puts("Current String:");
  puts(self->buffer);
}

void _set_from_file(String *self, char *filepath) {
  FILE *f = fopen(filepath, "r");
  if (f != NULL) {
    fgets(str->buffer, 32, f);
  }
}

void _print_to_file(String *self) {
  FILE *f = fopen("./str.log", "w");
  if (f != NULL) {
    fputs(self->buffer, f);
  }
  fclose(f);
  puts("wrote to file");
}

int exit_func(char *msg) {
  puts(msg);
  exit(EXIT_SUCCESS);
  return EXIT_SUCCESS;
}

void string_append(String *self, char *other) { strcat(self->buffer, other); }

void string_set(String *self, char *value) { strncpy(self->buffer, value, 32); }

void print_usage() {
  puts("String Storage Service:");
  printf("compiled with clang (%s)\n", CLANG_FLAGS);
  puts("Commands:\n"
       "[r]ead string\n"
       "[p]rint string\n"
       "[a]ppend data to string\n"
       "[m]ode switch between file and stdout printing\n"
       "[h]elp - print this menu\n"
       "[q]uit - quit the program\n\n");
}

int main(void) {
  char cmd[32] = {0};
  char buffer[128] = {0};

  printf("Hello ");
  fflush(stdout);
  system("echo $USER");
  print_usage();

  // initialize String object
  str = calloc(sizeof(String), 1);
  str->append = string_append;
  str->terminate = exit_func;
  str->print = _print_to_stdout;

  // we set the initial string from a file
  str->set = _set_from_file;
  str->set(str, "./welcome");
  // then we change the function pointer to the normal setter
  str->set = string_set;

  while (true) {
    puts("Input command: ");
    fgets(cmd, sizeof(cmd) - 1, stdin);

    if (cmd[0] == '\0') {
      continue;
    }

    switch (cmd[0]) {
    case 'r': {
      // make sure we use the right string_set method, just in case
      str->set = string_set;

      puts("Input string:");
      fgets(buffer, sizeof(buffer) - 1, stdin);
      char *nl = strchr(buffer, '\n');
      if (nl != NULL) {
        *nl = '\0';
      }
      str->set(str, buffer);
      break;
    }
    case 'a': {
      puts("Input string:");
      fgets(buffer, sizeof(buffer) - 1, stdin);
      char *nl = strchr(buffer, '\n');
      if (nl != NULL) {
        *nl = '\0';
      }
      str->append(str, buffer);
      break;
    }
    case 'p': {
      str->print(str);
      break;
    }
    case 'm': {
      if (str->print == _print_to_stdout) {
        str->print = _print_to_file;
      } else {
        str->print = _print_to_stdout;
      }
      break;
    }
    case 'q': {
      str->terminate(str->buffer);
      return EXIT_SUCCESS;
      break;
    }
    case 'h':
    default:
      print_usage();
    }

    memset(cmd, 0, sizeof(cmd));
    memset(buffer, 0, sizeof(buffer));
  }

  return EXIT_SUCCESS;
}
