CFLAGS=-m32 -O1 -fno-stack-protector -no-pie -fno-pie -D_FORTIFY_SOURCE=0

all: demo1_reversing demo2_vuln

demo1_reversing: demo1_reversing.c demo1_secrets.c
	$(CC) $(CFLAGS) -o $@ $^
	strip -N check_result -N '__initi' $@

demo2_vuln: demo2_vuln.c

clean:
	-$(RM) demo1_reversing demo2_vuln *.o *.s *.i
