import sys
import textwrap
from typing import Iterable, List
import capstone
from pwn import context, ELF, gdb, p64, log, disasm, hexdump, process, sleep, cyclic, ROP
from pwn import *  # noqa

# Zusatz-Importe
from pygments import highlight
from pygments.formatters import TerminalFormatter
from pwnlib.lexer import PwntoolsLexer
from capstone.x86_const import X86_INS_RET, X86_INS_NOP, X86_INS_UD2

# Nach Gadgets suchen

# Wiederverwendung der Disassembler-Funktionen aus der Exploit-Vorlage von P3 Nr. 3
# um die gefundenen Gadgets im Terminal auszugeben

# vulnerable binary path
vbin = "./getreal3"
# create ELF object, useful to lookup symbols etc.
velf = ELF(vbin)
# explicitly set architecture
context.arch = velf.arch
try:
    libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")
except FileNotFoundError:
    libc = ELF("/usr/lib/libc.so.6")


def cs_disasm_at(
    elf: ELF,
    virtual_address: int,
    count: int,
    md=capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
) -> List[capstone.CsInsn]:
    """
    Disassemble `count` bytes at `virtual_address` in the `elf`
    file. Return a list of capstone instruction objects for further
    processing/analysis.

    Use cs_format_insts to obtain a nicely formatted string.
    """
    code_buf = elf.read(virtual_address, count)
    md.detail = True
    return list(md.disasm(code_buf, virtual_address))

def cs_format_insts(insts: Iterable[capstone.CsInsn]) -> str:
    """
    Format a set of capstone instructions to a nicely formatted
    disassembly string.
    """
    insts = list(insts)
    bytes_fmt_length = 10
    bytes_fmt_length = (bytes_fmt_length * 2) + bytes_fmt_length
    inst_text = []
    for i in insts:
        i_bytes = ((" ".join(textwrap.wrap(i.bytes.hex(),
                                           2))).ljust(bytes_fmt_length, ' '))
        asm_text = f"{i.mnemonic}\t{i.op_str}"
        inst_text.append(f"{i.address:#010x}:\t{i_bytes}  {asm_text}")
    return "\n".join(inst_text)


# Versuche in der Binary ROP-Gadgets zu finden
gadgets_start_addr = 0x1000
gadgets_end_addr = 0x1674
_read_length = gadgets_end_addr - gadgets_start_addr

ret_bytes = b"\xc3"  # we directly hardcode the byte of the return instruction
ret_insts = [(gadgets_start_addr + offset)
            for offset, byte in enumerate(libc.read(gadgets_start_addr, _read_length))
            if byte == ret_bytes[0]]
log.info(
    f"discovered {len(ret_insts)} return instructions at addresses {list(map(hex, ret_insts))}"
)

inter_ret_part_starts = [gadgets_start_addr] + ret_insts 
inter_ret_part_starts = [x+1 for x in inter_ret_part_starts]
inter_ret_part_starts[0] -= 1

inter_ret_part_ends = ret_insts + [gadgets_end_addr]
log.debug(f"Inter-RET-ranges: { ''.join([f'{hex(x)} - {hex(y)}; ' for x, y in zip(inter_ret_part_starts, inter_ret_part_ends)])}")

MAX_BYTES_PER_ROP_GADGET = 15

with open("./notes/possible_rop_gadgets.txt", "w") as notes:
    for begin_of_inter_ret_part, end_of_inter_ret_part in zip(inter_ret_part_starts, inter_ret_part_ends):
        length_of_inter_ret_part = end_of_inter_ret_part - begin_of_inter_ret_part
        for i in range(length_of_inter_ret_part):
            amount_of_processed_bytes = length_of_inter_ret_part-i+1
            instructions = cs_disasm_at(velf, begin_of_inter_ret_part+i, amount_of_processed_bytes)
            if len(instructions)>0 and amount_of_processed_bytes < MAX_BYTES_PER_ROP_GADGET and instructions[-1].mnemonic == "ret":
                log.debug(instructions)
                notes.write("\n")
                notes.write(f"Von {hex(begin_of_inter_ret_part+i)} bis {hex(end_of_inter_ret_part)}")
                notes.write("\n")
                notes.write(f"{amount_of_processed_bytes} Bytes vom RET entfernt")
                notes.write("\n")
                notes.write(cs_format_insts(instructions))
                notes.write("\n")

# Versuche in libc ROP-Gadgets zu finden
# WARNUNG: Das dauert ca. 20 Minuten!
gadgets_start_addr = 0x28000
gadgets_end_addr = 0x1bcfff
_read_length = gadgets_end_addr - gadgets_start_addr

ret_bytes = b"\xc3"  # we directly hardcode the byte of the return instruction
ret_insts = [(gadgets_start_addr + offset)
            for offset, byte in enumerate(libc.read(gadgets_start_addr, _read_length))
            if byte == ret_bytes[0]]
log.info(
    f"discovered {len(ret_insts)} return instructions at addresses {list(map(hex, ret_insts))}"
)

inter_ret_part_starts = [gadgets_start_addr] + ret_insts 
inter_ret_part_starts = [x+1 for x in inter_ret_part_starts]
inter_ret_part_starts[0] -= 1

inter_ret_part_ends = ret_insts + [gadgets_end_addr]
log.debug(f"Inter-RET-ranges: { ''.join([f'{hex(x)} - {hex(y)}; ' for x, y in zip(inter_ret_part_starts, inter_ret_part_ends)])}")

with open("./notes/possible_rop_gadgets_libc.txt", "w") as notes:
    for begin_of_inter_ret_part, end_of_inter_ret_part in zip(inter_ret_part_starts, inter_ret_part_ends):
        length_of_inter_ret_part = end_of_inter_ret_part - begin_of_inter_ret_part
        for i in range(length_of_inter_ret_part):
            amount_of_processed_bytes = length_of_inter_ret_part-i+1
            instructions = cs_disasm_at(libc, begin_of_inter_ret_part+i, amount_of_processed_bytes)
            if len(instructions)>0 and amount_of_processed_bytes < MAX_BYTES_PER_ROP_GADGET and instructions[-1].mnemonic == "ret":
                log.debug(instructions)
                notes.write("\n")
                notes.write(f"Von {hex(begin_of_inter_ret_part+i)} bis {hex(end_of_inter_ret_part)}")
                notes.write("\n")
                notes.write(f"{amount_of_processed_bytes} Bytes vom RET entfernt")
                notes.write("\n")
                notes.write(cs_format_insts(instructions))
                notes.write("\n")
