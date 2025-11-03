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
#include <sys/random.h>
#include <unistd.h>

// You do not need to understand this sandbox function. This code will simply
// constrain you, such that you cannot use some system calls in your
// shellcode (for example execve). You need to work around that by writing
// shellcode that directly opens the file and prints it to you.
void setup_sandbox();

double real;
char password[16] = {0};

int store_real() {
  char buf[64] = {0};
  puts("Input password:");
  fgets(buf, sizeof(buf) - 1, stdin);
  strncpy(password, buf, sizeof(password));
  // password[sizeof(password) - 1] = '\0';
  explicit_bzero(buf, sizeof(buf));
  puts("Input real number:");
  fgets(buf, sizeof(buf) - 1, stdin);
  errno = 0;
  real = strtod(buf, NULL);
  explicit_bzero(buf, sizeof(buf));
  if (errno != 0) {
    printf("This is not a legit real number! (%s)\n", strerror(errno));
    return 1;
  }
  FILE *f = fopen("./secret.log", "a");
  if (f != NULL) {
    fprintf(f, "%f\n", real);
    fclose(f);
  } else {
    warn("FILE* was null");
  }
  explicit_bzero(buf, sizeof(buf));
  return 0;
}

int load_real() {
  char buf[32] = {0};
  puts("Input password:");
  fgets(buf, 48, stdin);
  if (strcmp(buf, password) == 0) {
    printf("Your real is %f\n", real);
  } else {
    puts("ACCESS DENIED: invalid password");
  }
  explicit_bzero(buf, sizeof(buf));
  return 0;
}

int print_log() {
  FILE *f = fopen("./secret.log", "r");

  if (f != NULL) {
#if 0
        char* buf = malloc(128);
        fread(buf, 127, 1, f);
        puts(buf);
        fclose(f);
        return EXIT_SUCCESS;
#endif
  } else {
    warn("FILE* was null");
  }
  return EXIT_FAILURE;
}

int real_main() {
  char cmd[24] = {0};

  while (!feof(stdin)) {
    puts("Input command:");

    if (fgets(cmd, sizeof(cmd) - 1, stdin) == NULL)
      return EXIT_FAILURE;

    switch (cmd[0]) {
    case 's': {
      if (store_real() != 0) {
        return EXIT_FAILURE;
      }
      break;
    }
    case 'r': {
      if (load_real() != 0) {
        return EXIT_FAILURE;
      }
      break;
    }
    case 'q': {
      return EXIT_SUCCESS;
    }
    case 'l': {
      return print_log();
    }
    case 'h':
    default: {
      puts("Store a real number protected with a password.\n"
           "Commands:\n"
           "[s]tore - store real\n"
           "[r]ead - read real\n"
           "[h]elp - print this menu\n"
           "[q]uit - quit the program\n\n");
    }
    }

    explicit_bzero(cmd, sizeof(cmd));
  }

  return EXIT_SUCCESS;
}

int main(int argc, char *argv[], char *envp[]) {
#define clear_argv(_argv)                                                      \
  for (; *_argv; ++_argv) {                                                    \
    explicit_bzero(*_argv, strlen(*_argv));                                    \
  }
  // enter hardened mode
  clear_argv(argv);
  clear_argv(envp);
  setup_sandbox();
  // start real main
  return real_main();
}
