# The used C compiler
CC=clang
# The command line arguments for the C compiler
CFLAGS=-m32 -fno-stack-protector -ggdb -no-pie -fno-pie -std=gnu99

# default build targets
all: demo0_compile

# Defines the build target, which depends on the demo0_compile.c file (the source code)
# run the C compiler with the configured arguments
# $^ is a shortcut for the file specified as dependency of this target
# $@ is the name of the target
demo0_compile: demo0_compile.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	-$(RM) demo0_compile *.o *.s *.i *.S
