#!/usr/bin/env python3

"""
Lecture Secure Software Systems
University of Duisburg-Essen

https://www.syssec.wiwi.uni-due.de
"""


import subprocess as sp
import signal
import sys

BINS = ("cfa", "cfa_reversed")

signames = {
    k: v
    for v, k in reversed(sorted(signal.__dict__.items()))
    if v.startswith('SIG') and not v.startswith('SIG_')
}

success = []
failure = []


def launch(bin_, arg):
    proc = sp.Popen(
        ["./" + bin_, arg],
        # stdin=sp.PIPE,
        stdout=sp.PIPE,
        stderr=sp.PIPE)
    out, err = proc.communicate()
    if err:
        return (proc.returncode, out, err)
    elif proc.returncode < 0:
        return (proc.returncode, out, signames[-proc.returncode])
    else:
        return (proc.returncode, out, None)


print("[+] Building with `make`")
sp.check_call(['make', BINS[1]])

print("[+] Running Tests")
for i in range(33):
    print("[+] input ", i)
    r0, o0, e0 = launch(BINS[0], str(i))
    r1, o1, e1 = launch(BINS[1], str(i))
    if (r0, o0, e0) != (r1, o1, e1):
        print("\033[91mFailure:\033[0m\n", "output difference!")
        print("exit_code cfa:", repr(r0))
        print("exit_code cfa_reversed:", repr(r1))
        print("stdout cfa:", repr(o0))
        print("stdout cfa_reversed:", repr(o1))
        print("stderr cfa:", repr(e0))
        print("stderr cfa_reversed:", repr(e1))
        sys.exit(1)

print("\033[92mSuccess:\033[0m\n",
      "It seems you reversed explain_me correctly!")
sys.exit(0)
