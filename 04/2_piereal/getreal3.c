/************************************
 * Lecture Secure Software Systems
 * University of Duisburg-Essen
 *
 * https://www.syssec.wiwi.uni-due.de
 ************************************/

#include <err.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/random.h>
#include <unistd.h>

double real = 0.0;
char password[256] = {0};

char *help_msg[] = {
    "Store a real number protected with a password.\n"
    "Commands:\n"
    "[s]tore - store real\n"
    "[r]ead - read real\n"
    "[h]elp - print this menu\n"
    "[l]ang - change the language of the help message\n"
    "[q]uit - quit the program\n\n",

    "Speichere eine reelle Zahl, mit einem Passwort geschuetzt.\n"
    "Kommandos:\n"
    "[s]tore - Speichere eine reelle Zahl\n"
    "[r]ead - Lade eine reelle Zahl\n"
    "[h]elp - Ausgabe der Hilfe\n"
    "[l]ang - Sprache der Hilfemeldung aendern\n"
    "[q]uit - Beenden des Programms\n\n"
};

void print_help(char *help) {
    // apparently we need to sanitize to avoid crashes
    for (size_t i = 0; i < 2; i++) {
        if (help == help_msg[i]) {
            puts(help);
            goto done;
        }
    }
    printf("Invalid language selected!!!! (error code: %p)\n", help);
done:
    return;
}

int append_log(double real) {
    FILE *f = fopen("./secret.log", "a");
    if (f == NULL) {
        warn("FILE* was null");
        return -1;
    }
    fprintf(f, "%f\n", real);
    fclose(f);
    return 0;
}

int store_real() {
    char buf[sizeof(password) + 8] = {0};
    puts("Input password:");
    fgets(buf, sizeof(password), stdin);
    memcpy(password, buf, sizeof(password));
    password[sizeof(password) - 1] = '\0';
    memset(buf, 0, sizeof(buf));
    puts("Input real number:");
    fgets(buf, sizeof(buf), stdin);
    real = strtod(buf, NULL);
    append_log(real);
    explicit_bzero(buf, sizeof(buf));
    return 0;
}

int load_real() {
    char buf[64] = {0};
    puts("Input password:");
    fgets(buf, 640, stdin);
    if (strcmp(buf, password) == 0) {
        printf("Your real is %f\n", real);
    } else {
        printf("ACCESS DENIED: your input:\n%s", buf);
    }
    explicit_bzero(buf, sizeof(buf));
    return 0;
}

int real_main() {
    char cmd[32] = {0};
    char *help = help_msg[0];

    while (!feof(stdin)) {
        puts("Input command: ");

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
            puts("Switching languages\nPlease enter language number:\n"
                     "  0 - English\n"
                     "  1 - German/Deutsch\n");
            printf("=> ");
            size_t choice = 0;
            scanf("%zu", &choice);
            getchar();
            help = help_msg[choice];
        }
        case 'h':
        default:
            print_help(help);
        }

        explicit_bzero(cmd, sizeof(cmd));
    }

    return EXIT_SUCCESS;
}

int main(int argc, char *argv[], char *envp[]) {
    // start real main
    return real_main();
}
