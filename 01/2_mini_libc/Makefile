CC=clang
AS=nasm
ASFLAGS=-f elf32
LDFLAGS=-m elf_i386
CFLAGS=-Wall -pedantic -m32 -O0 -ggdb -nostdlib -fno-stack-protector -fno-pie -no-pie -fcf-protection=none

all: main

%.o: %.asm
	$(AS) $(ASFLAGS) $^ -o $@

main: main.c lib.o
	$(CC) $(CFLAGS) $^ -o $@

main-patched: main-patched.c lib.o
	$(CC) $(CFLAGS) $^ -o $@

clean:
	-$(RM) main main-patched *.o

test:
	python test.py

test-patched:
	python test.py main-patched

.PHONY: clean test test-patched all
