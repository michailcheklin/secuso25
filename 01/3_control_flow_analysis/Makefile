# Lecture Secure Software Systems
# University of Duisburg-Essen
#
# https://www.syssec.wiwi.uni-due.de

CC=gcc
CFLAGS=-O0 -zexecstack -fno-stack-protector -no-pie -fno-pie -D_FORTIFY_SOURCE=0 -ggdb
BIN=cfa

test: cfa_reversed
	python3 test.py

clean:
	-$(RM) cfa_reversed
