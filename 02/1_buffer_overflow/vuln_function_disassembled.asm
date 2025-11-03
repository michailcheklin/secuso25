   0x080491b6 <+0>:	push   ebp
   0x080491b7 <+1>:	mov    ebp,esp
   0x080491b9 <+3>:	push   edi
   0x080491ba <+4>:	sub    esp,0x94
   0x080491c0 <+10>:	mov    DWORD PTR [ebp-0x94],0x0
   0x080491ca <+20>:	lea    edx,[ebp-0x90]
   0x080491d0 <+26>:	mov    eax,0x0
   0x080491d5 <+31>:	mov    ecx,0x22
   0x080491da <+36>:	mov    edi,edx
   0x080491dc <+38>:	rep stos DWORD PTR es:[edi],eax
   0x080491de <+40>:	sub    esp,0xc
   0x080491e1 <+43>:	push   0x804a011
   0x080491e6 <+48>:	call   0x8049060 <puts@plt>
   0x080491eb <+53>:	add    esp,0x10
   0x080491ee <+56>:	sub    esp,0x4
   0x080491f1 <+59>:	push   0xac
   0x080491f6 <+64>:	lea    eax,[ebp-0x94]
   0x080491fc <+70>:	push   eax
   0x080491fd <+71>:	push   0x0
   0x080491ff <+73>:	call   0x8049050 <read@plt>
   0x08049204 <+78>:	add    esp,0x10
   0x08049207 <+81>:	nop
   0x08049208 <+82>:	mov    edi,DWORD PTR [ebp-0x4]
   0x0804920b <+85>:	leave  
   0x0804920c <+86>:	ret  
