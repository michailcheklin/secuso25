#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef STEP1
int main(int argc, char* argv[]) {
  // argc <- is the number of command line arguments + 1 (the 0th argument is
  // always the name of the program)
  // argv <- this is an array of strings, argc is the length of this array,
  // every array entry is a string (so a char*) to the next command line
  // argument. argv[1] is the first command line argument.
  if (argc == 2) {
    // we can invoke the strcmp function to compare two strings. strcmp will
    // return 0 if the strings are equal.
    if (strcmp(argv[1], "secuso") == 0) {
      puts("Helloooo! :) Welcome back");
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", argv[1]);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
#endif

#ifdef STEP2
int main(int argc, char *argv[]) {
  // we can allocate space for the string on the stack
  char name[256];
  if (argc == 2) {
    // copy the string with a loop
    size_t i = 0;
    while (argv[1][i] != '\0') {
      name[i] = argv[1][i];
      i++;
    }
    name[i + 1] = '\0';

    // we can now modify the string, e.g., by changing the first letter to
    // upper case
    name[0] = toupper(name[0]);
    if (strcmp(argv[1], "secuso") == 0) {
      printf("Helloooo! :) Welcome back %s\n", name);
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", name);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
#endif

#ifdef STEP3
int main(int argc, char *argv[]) {
  // we can allocate space for the string on the stack
  char name[256];
  if (argc == 2) {
    // strncpy(char *dest, const char *src, size_t n)
    // dest <- name array
    // src <- the command line parameter
    // n <- the maximum string length, we use the size of the name array
    strncpy(name, argv[1], (sizeof name) - 1);
    // we can now modify the string, e.g., by changing the first letter to
    // upper case
    name[0] = toupper(name[0]);
    if (strcmp(argv[1], "secuso") == 0) {
      printf("Helloooo! :) Welcome back %s\n", name);
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", name);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
#endif

#ifdef STEP4
char *string_clone(char *str) {
  // first compute the length of the input string
  size_t sz = strlen(str);
  // allocate a new "object" on the heap
  char *new = malloc(sz);
  // only copy the string if the allocation did not fail, avoid nullptr
  // dereference here -> leads to crash
  if (new != NULL) {
    // memcpy(void *dest, const void *src, size_t n)
    // new <- destination
    // str <- source
    // n == sz <- length
    memcpy(new, str, sz);
  }
  return new;
}

int main(int argc, char *argv[]) {
  if (argc == 2) {
    // we invoke the clone function here, and we will receive a pointer to an
    // idential string as return value
    char *name = string_clone(argv[1]);
    name[0] = toupper(name[0]);
    if (strcmp(argv[1], "secuso") == 0) {
      printf("Helloooo! :) Welcome back %s\n", name);
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", name);
    }
    free(name);
  } else {
    puts("Hello World!");
  }
}
#endif
