#!/usr/bin/env python

from __future__ import print_function
import subprocess as sp
import signal
import sys

BIN_NAME = "main"
if len(sys.argv) > 1:
    BIN_NAME = sys.argv[1]

signames = {
    k: v
    for v, k in reversed(sorted(signal.__dict__.items()))
    if v.startswith('SIG') and not v.startswith('SIG_')
}

success = []
failure = []


def launch(s):
    proc = sp.Popen(
        ["./" + BIN_NAME], stdin=sp.PIPE, stdout=sp.PIPE, stderr=sp.PIPE)
    out, err = proc.communicate(s)
    expected = len(s)
    if b"\x00" in s:
        expected = s.index(b"\x00")
        s_ = s[:s.index(b"\x00")]
    else:
        s_ = s
    if err:
        failure.append((s, expected, s_, proc.returncode, out, err))
        return False
    elif proc.returncode < 0:
        failure.append((s, expected, s_, proc.returncode, out,
                        signames[-proc.returncode]))
        return False
    else:
        if out == s_ and proc.returncode == expected:
            success.append((s, expected, s_, proc.returncode, out, None))
        else:
            failure.append((s, expected, s_, proc.returncode, out, None))
        return True


print("[+] Building with `make`")
sp.check_call(['make', BIN_NAME])

print("[+] Running Testcases")
total = 96
for i in range(0, 48):
    s = (b"A" * i)
    if not launch(s):
        break
    if i == 0:
        continue
for i in range(0, 48):
    s = bytearray(b"A" * 48)
    s[i] = 0
    if not launch(bytes(s)):
        break

if failure:
    print("Failure Details")
    print("---------------")
    print()
    for inp, exp_ret, exp_out, ret, out, err in failure:
        print("input:", repr(inp), "(strlen {})".format(exp_ret))
        print("output:", repr(out), "( != expected value", repr(exp_out), ")")
        print("return code:", ret, "( != expected value", exp_ret, ")")
        if err:
            print("error:", err)
        print()
print()
print("SUMMARY")
print("-------")
print("Total:   ", total)
if (len(failure) + len(success)) < total:
    print("\033[93mSkipped: ", total - len(success) - len(failure), '\033[0m')
if failure:
    print("Success: ", len(success))
    print("\033[91mFailure: ", len(failure), '\033[0m')
else:
    print("\033[92mSuccess: ", len(success), '\033[0m')
    print("Failure: ", len(failure))
