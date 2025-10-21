Dump of assembler code for function _start:
   0x08049000 <+0>:	mov    eax,0x4
   0x08049005 <+5>:	mov    ebx,0x1
   0x0804900a <+10>:	mov    ecx,0x804901f
   0x0804900f <+15>:	mov    edx,0xd
   0x08049014 <+20>:	int    0x80
   0x08049016 <+22>:	mov    eax,0x1
   0x0804901b <+27>:	xor    ebx,ebx
   0x0804901d <+29>:	int    0x80
   0x0804901f <+31>:	dec    eax
   0x08049020 <+32>:	gs ins BYTE PTR es:[edi],dx
   0x08049022 <+34>:	ins    BYTE PTR es:[edi],dx
   0x08049023 <+35>:	outs   dx,DWORD PTR ds:[esi]
   0x08049024 <+36>:	and    BYTE PTR [edi+0x6f],dl
   0x08049027 <+39>:	jb     0x8049095
   0x08049029 <+41>:	and    DWORD PTR fs:[edx],ecx
   0x0804902c <+44>:	.byte 0x0
End of assembler dump.
