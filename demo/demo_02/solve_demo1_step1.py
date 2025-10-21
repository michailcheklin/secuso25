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
# vp = process(vbin)
# afterwards attach the debugger to the running program
# gdb.attach(vp, gdbscript)

# alternatively: start the program in the debugger from the beginning
vp = gdb.debug(vbin, gdbscript)

# enable verbose logging of raw input/output as hexdump
context.log_level = 'debug'

##############################################################################
# TODO: 
#
# 1. first input a 16 byte string and find its address with gdb/pwndbg
# (you don't need to include this into your final script)
#
# 2. find the address of the `find_me` function and send it as input to the
# program

# functions to use/consider:
# cyclic()
# velf.symbols[]
# vp.send()
# vp.recvuntil()
# hex()
# p32()

find_me_address = 0xdeadbeef  # placeholder value


##############################################################################

# pwntools gives us nice logging functionality
log.info("function find_me is at " + hex(find_me_address))

# this enters an interactive input/output mode, where you can type inputs and
# see any resulting outputs, this can be exited with ctrl+d to continue the
# rest of the python script.
vp.interactive()
