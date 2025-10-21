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

vp = process(vbin)
# vp = gdb.debug(vbin, gdbscript)

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
# hex()

find_me_address = velf.symbols['find_me']

vp.sendline(p32(find_me_address))

vp.send(b"not_so_secret_key_42")
vp.shutdown()  
# after shutdown the standard input stream (stdin) is marked as EOF, so fgets 
# stops reading even without sending a '\n' character

# alternatively we can also add a NULL byte to terminate the string, so strcmp 
# will succeed and fgets will still not hang due to the newline
# vp.sendline(b"not_so_secret_key_42\x00")

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
