#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void omg() {
  puts("OMG!");
}

void vuln() {
    int test = 0xdeadbeef;
    char buf[32];
    scanf("%s", buf);
    if (test != 0xdeadbeef) {
        puts("what?");
    }
}

int main(int argc, char* argv[]) {
    puts("calling vuln function");
    vuln();
    puts("done");
    return 0;
}
