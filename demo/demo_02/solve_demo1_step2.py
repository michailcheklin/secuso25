#!/usr/bin/env python3
import sys
from pwn import *

context.arch = 'i386'
vbin = "./demo1_reversing"
velf = ELF(vbin)
gdbscript = """
init-pwndbg
# break 
"""

vp = gdb.debug(vbin, gdbscript)

# enable verbose logging of raw input/output as hexdump
context.log_level = 'debug'

##############################################################################
# TODO: Find the right input, such that the program prints the string
# "SUCCESS!"

# functions to use/consider:
# cyclic()
# velf.symbols[]
# vp.send()
# vp.recvuntil()
# p32()
# hex()


# vp.interactive()

##############################################################################

x = vp.recvall()
log.info("received the following output:\n" + hexdump(x))
vp.close()
if b"SUCCESS" in x:
    log.info("Successfully found the secret!")
    sys.exit(0)
else:
    log.warning("Oh no, didn't send the right input...")
    sys.exit(1)
