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
#include <sys/mman.h>

const char PROMPT[] = "> ";

bool admin_enabled = false;
#define ADMIN_PASSWORD_LEN (32)
char *admin_password = NULL;
#define ADMIN_PASSWORD ((char *)0x100000)

typedef struct {
  size_t sz;
  char *s;
} string_t;

void string_read_line(string_t *str, FILE *f) {
  char *endptr;
  char buf[1024] = {0};
  printf("string size? ");
  fflush(stdout);
  fgets(buf, sizeof(buf) - 1, f);
  char *nl = strchr(buf, '\n');
  if (nl != NULL) {
    *nl = '\0';
  }

  size_t sz = strtol(buf, &endptr, 10);
  if (buf[0] == '\0' || errno != 0 || *endptr != '\0') {
    ;
  } else {
    if (sz >= sizeof(buf)) {
      sz = sizeof(buf) - 1;
    }
    printf("string? ");
    fflush(stdout);
    fgets(buf, sizeof(buf) - 1, f);
    nl = strchr(buf, '\n');
    if (nl != NULL) {
      *nl = '\0';
    }

    if (sz > 0) {
      if (sz > str->sz) {
        str->s = realloc(str->s, sz + 1);
      }
      str->sz = sz;
      memcpy(str->s, buf, str->sz);
      str->s[sz] = '\0';
    } else {
      str->sz = 0;
      str->s = NULL;
    }
  }
}

void string_clear(string_t *str) {
  if (str->s != NULL) {
    free(str->s);
  }
}

typedef uint64_t userid_t;

typedef struct {
  int32_t year;
  uint8_t month;
  uint8_t day;
} birthday_t;

typedef struct {
  userid_t id;
  string_t firstname;
  string_t lastname;
  birthday_t birthday;
} user_t;

#define MAX_USERS 100

user_t *users[MAX_USERS];

bool edit_user(user_t *usr) {
  char buf[1024] = {0};

  puts("# First name:");
  string_read_line(&usr->firstname, stdin);

  puts("# Last name:");
  string_read_line(&usr->lastname, stdin);

  char *endptr = NULL;
  puts("# Birthday:");
  puts("## year");
  fgets(buf, sizeof(buf) - 1, stdin);
  buf[strlen(buf) - 1] = '\0';
  errno = 0;
  // strtol allows error handling to detect invalid input, e.g. if the user
  // inputs something like "asdf", which obviously isn't a number
  usr->birthday.year = strtol(buf, &endptr, 10);
  if (buf[0] == '\0' || errno != 0 || *endptr != '\0') {
    puts("invalid year");
    // bail out early
    return false;
  }
  puts("## month");
  fgets(buf, sizeof(buf) - 1, stdin);
  buf[strlen(buf) - 1] = '\0';
  errno = 0;
  usr->birthday.month = strtol(buf, &endptr, 10);
  if (buf[0] == '\0' || errno != 0 || *endptr != '\0') {
    puts("invalid month");
    return false;
  }
  puts("## day");
  fgets(buf, sizeof(buf) - 1, stdin);
  buf[strlen(buf) - 1] = '\0';
  errno = 0;
  usr->birthday.day = strtol(buf, &endptr, 10);
  if (buf[0] == '\0' || errno != 0 || *endptr != '\0') {
    puts("invalid day");
    return false;
  }

  return true;
}

bool delete_user(user_t *usr) {
  string_clear(&usr->firstname);
  string_clear(&usr->lastname);
  free(usr);
  return true;
}

bool print_user(user_t *usr) {
  printf("User: %s %s (id %lu) born on %d-%d-%d", usr->firstname.s,
         usr->lastname.s, usr->id, usr->birthday.year, usr->birthday.month,
         usr->birthday.day);
  return true;
}

bool delete_user_at(size_t i) {
  if (users[i] != NULL) {
    // deallocate user
    bool r = delete_user(users[i]);
    // invalidate reference
    users[i] = NULL;
    return r;
  }
  return true;
}

bool new_user_at(size_t i) {
  if (users[i] != NULL) {
    puts("ERROR: user already exists");
    return false;
  }
  users[i] = malloc(sizeof(user_t));
  memset(users[i], 0, sizeof(user_t));
  users[i]->id = i;
  if (edit_user(users[i])) {
    return true;
  } else {
    // delete the user if editing went wrong
    delete_user_at(i);
    return false;
  }
}

bool edit_user_at(size_t idx) {
  if (edit_user(users[idx])) {
    return true;
  } else {
    // delete the user if editing went wrong
    delete_user(users[idx]);
    return false;
  }
}

size_t read_index() {
  char buf[1024] = {0};
  size_t idx = 0;
  char *endptr = NULL;
  puts("User index:");
  fgets(buf, sizeof(buf) - 1, stdin);
  buf[strlen(buf) - 1] = '\0';
  errno = 0;
  idx = strtol(buf, &endptr, 10);
  if (buf[0] == '\0' || errno != 0 || *endptr != '\0') {
    puts("invalid index");
    return -1;
  }
  return idx;
}

/**
 * Set up random admin password at a fixed address (0x100000).
 */
void init_admin_password() {
  char buf[ADMIN_PASSWORD_LEN] = {0};
  FILE *f = fopen("/dev/urandom", "r");
  if (f == NULL) {
    err(1, "failed to open file");
  }
  fread(buf, sizeof(buf), 1, f);
  fclose(f);
  static const char alphanum[] = "0123456789"
                                 "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                 "abcdefghijklmnopqrstuvwxyz";
  admin_password =
      mmap(ADMIN_PASSWORD, ADMIN_PASSWORD_LEN + 1, PROT_READ | PROT_WRITE,
           MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0);
  if (admin_password == MAP_FAILED) {
    err(1, "failed to setup admin_password");
  }
  if (admin_password != (void *)0x100000) {
    err(1, "admin_password allocated at wrong address: %p\n", admin_password);
  }

  size_t i = 0;
  for (; i < ADMIN_PASSWORD_LEN; ++i) {
    admin_password[i] = alphanum[buf[i] % (sizeof(alphanum) - 1)];
  }
  admin_password[i] = '\0';

  mprotect(admin_password, ADMIN_PASSWORD_LEN + 1, PROT_READ);
}

int main() {
  init_admin_password();

#define CHECK_IDX_BOUNDS(IDX)                                                  \
  if ((IDX) == -1) {                                                           \
    ret = false;                                                               \
    break;                                                                     \
  }                                                                            \
  if ((IDX) > MAX_USERS) {                                                     \
    puts("User index too big!");                                               \
    ret = false;                                                               \
    break;                                                                     \
  }
#define CHECK_USER_EXISTS(IDX)                                                 \
  if (users[(IDX)] == NULL) {                                                  \
    puts("No such user!");                                                     \
    ret = false;                                                               \
    break;                                                                     \
  }

  puts("Welcome to user manager 2000!");

  char choice[16] = "?";
  size_t idx = 0;
  bool ret = true;
  while (choice[0] != 'q') {
    printf("your choice: \"%s\"\n", choice);
    switch (choice[0]) {
    case 'c': {
      puts("= Create User =");
      idx = read_index();
      CHECK_IDX_BOUNDS(idx);
      ret = new_user_at(idx);
      break;
    }
    case 'd': {
      puts("= Delete User =");
      idx = read_index();
      CHECK_IDX_BOUNDS(idx);
      CHECK_USER_EXISTS(idx);
      ret = delete_user_at(idx);
      break;
    }
    case 'p': {
      puts("= Print User =");
      idx = read_index();
      CHECK_IDX_BOUNDS(idx);
      CHECK_USER_EXISTS(idx);
      ret = print_user(users[idx]);
      puts("");
      break;
    }
    case 'e': {
      puts("= Edit User =");
      idx = read_index();
      CHECK_IDX_BOUNDS(idx);
      CHECK_USER_EXISTS(idx);
      ret = edit_user_at(idx);
      break;
    }
    case 'l': {
      puts("= List Users =");
      for (size_t i = 0; i < MAX_USERS; ++i) {
        if (users[i] != NULL) {
          printf("%zu: ", i);
          print_user(users[i]);
          puts("");
        }
      }
      ret = true;
      break;
    }
    case 'a': {
      puts("= Admin Menu =");
      if (admin_enabled) {
        puts("Input admin password:");
        fflush(stdout);
        char buf[ADMIN_PASSWORD_LEN + 2] = {0};
        fgets(buf, sizeof(buf) - 1, stdin);
        char *nl = strchr(buf, '\n');
        if (nl != NULL) {
          *nl = '\0';
        }

        if (strcmp(buf, ADMIN_PASSWORD) == 0) {
          puts("ACCESS GRANTED!");
          puts("launching system shell:");
          system("/bin/sh");
          goto loop_exit;
        }
      }
      puts("ACCESS DENIED!");
      break;
    }
    case 'q':
      goto loop_exit;
    case 'h':
    default:
      puts("Available commands:\n"
           "create\n"
           "list\n"
           "print\n"
           "edit\n"
           "delete\n"
           "help\n"
           "quit\n");
      goto no_ret;
    }

    if (!ret) {
      puts("Command failed!");
    }
    ret = true;
  no_ret:
    printf(PROMPT);
    fflush(stdout);
    if (feof(stdin) || ferror(stdin)) {
      goto loop_exit;
    }
    fgets(choice, sizeof(choice) - 1, stdin);
    choice[strlen(choice) - 1] = '\0';
  }
loop_exit:
  puts("bye!");

  return 0;
}
