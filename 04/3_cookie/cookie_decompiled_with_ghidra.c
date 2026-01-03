/* Dekompiliert mit Ghidra */

#include <stdio.h>

int main(int argc, char **argv, char **envp)
{
    puts("COOOOKKIIEEESSS!");
    give_cookie();
    return 0;
}

void give_cookie()
{
    /* An dieser Stelle wird der Stack Canary bestimmt */

    /* Locals */
    char command[8] = {0};        // local_60
    char wanted_cookie[64] = {0}; // local_58, 50, ..., 28, 20
    do
    {
        puts("What kind of cookie do you want?");
        read(stdin, &wanted_cookie, 100);
        if (strcmp(wanted_cookie, "chocolate\n") == 0)
        {
            puts("There you go a: \xf0\x9f\x8d\xaa"); // \xf0\x9f\x8d\xaa = 🍪
        }
        else if (strcmp(wanted_cookie, "pizza\n") == 0)
        {
            puts("Technically not a cookie, but ok: \xf0\x9f\x8d\x95"); // \xf0\x9f\x8d\x95 = 🍕
        }
        else if (strcmp(wanted_cookie, "fortune\n") == 0)
        {
            puts("There you go a: \xf0\x9f\xa5\xa0"); // \xf0\x9f\xa5\xa0 = 🥠
        }
        else if (strcmp(wanted_cookie, "rice\n") == 0)
        {
            puts("Pretty boring...: \xf0\x9f\x8d\x98"); // \xf0\x9f\x8d\x98 = 🍘
        }
        else
        {
            printf("You asked for a \"%s\" cookie...", &wanted_cookie);
            puts("Sorry, but I don\'t know that type of cookie :(");
        }

        puts("Another one? (y/n)");
        read(stdin, &command, 7);
    } while (command[0] == 'y');

    puts("OK. Then enjoy your cookies! Bye.");

    /* An dieser Stelle geschieht die Überprüfung des Stack Canary */
}

void shelly(void)
{
    puts("Ah, I see you know the \xf0\x9f\x90\xa6\x00"); // \xf0\x9f\x90\xa6 = 🐦
    puts("Please have a \xf0\x9f\x90\x9a\x00"); // \xf0\x9f\x90\x9a = 🐚
    fflush(stdout);
    execl("/bin/sh", "sh", NULL);
    return;
}
