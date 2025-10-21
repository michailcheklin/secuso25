#!/usr/bin/env python3
from pwn import *

# tell pwntols about the architecture of the binary
context.arch = 'i386'
# path to the binary file
vbin = "./demo1_reversing"
# create an ELF object, which offers a nice API to access all kind of
# information about the ELF file (such as e.g., symbols)
velf = ELF(vbin)
# gdb commands, which are executed at the beginning of the debugging session
gdbscript = """
init-pwndbg
break main
"""

# first launch the program
vp = process(vbin)
# afterwards attach the debugger to the running program
# gdb.attach(vp, gdbscript)

# alternatively: start the program in the debugger from the beginning
# vp = gdb.debug(vbin, gdbscript)

# enable verbose logging of raw input/output as hexdump
context.log_level = 'debug'

##############################################################################
# TODO: first input a 16 byte string and find its address with gdb/pwndbg
# then find the address of the `find_me` function and send it

# functions to use/consider:
# cyclic()
# velf.symbols[]
# vp.send()
# vp.recvuntil()
# hex()

find_me_address = velf.symbols['find_me']
log.info(f"""
dec: {find_me_address}
hex: {hex(find_me_address)}
bytes: {p32(find_me_address)!r}
hexdump:\n{hexdump(p32(find_me_address))}
""")

vp.sendline(p32(find_me_address))

vp.sendline(b"")

##############################################################################

# pwntools gives us nice logging functionality
log.info("function find_me is at " + hex(find_me_address))

# this enters an interactive input/output mode, where you can type inputs and
# see any resulting outputs, this can be exited with ctrl+d to continue the
# rest of the python script.
# log.info("entering interactive mode, exit with `ctrl+d`")
# vp.interactive()

x = vp.recvall()
log.info("received the following output:\n" + hexdump(x))
vp.close()
if b"found me!" in x:
    log.info("Successfully found the function!")
    sys.exit(0)
else:
    log.warning("Oh no, didn't send the right input...")
    sys.exit(1)
