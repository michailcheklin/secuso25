
../cookie:     file format elf64-x86-64


Disassembly of section .init:

0000000000401000 <_init>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	48 83 ec 08          	sub    rsp,0x8
  401008:	48 8b 05 e9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fe9]        # 403ff8 <__gmon_start__@Base>
  40100f:	48 85 c0             	test   rax,rax
  401012:	74 02                	je     401016 <_init+0x16>
  401014:	ff d0                	call   rax
  401016:	48 83 c4 08          	add    rsp,0x8
  40101a:	c3                   	ret    

Disassembly of section .plt:

0000000000401020 <.plt>:
  401020:	ff 35 e2 2f 00 00    	push   QWORD PTR [rip+0x2fe2]        # 404008 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:	f2 ff 25 e3 2f 00 00 	bnd jmp QWORD PTR [rip+0x2fe3]        # 404010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102d:	0f 1f 00             	nop    DWORD PTR [rax]
  401030:	f3 0f 1e fa          	endbr64 
  401034:	68 00 00 00 00       	push   0x0
  401039:	f2 e9 e1 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40103f:	90                   	nop
  401040:	f3 0f 1e fa          	endbr64 
  401044:	68 01 00 00 00       	push   0x1
  401049:	f2 e9 d1 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40104f:	90                   	nop
  401050:	f3 0f 1e fa          	endbr64 
  401054:	68 02 00 00 00       	push   0x2
  401059:	f2 e9 c1 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40105f:	90                   	nop
  401060:	f3 0f 1e fa          	endbr64 
  401064:	68 03 00 00 00       	push   0x3
  401069:	f2 e9 b1 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40106f:	90                   	nop
  401070:	f3 0f 1e fa          	endbr64 
  401074:	68 04 00 00 00       	push   0x4
  401079:	f2 e9 a1 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40107f:	90                   	nop
  401080:	f3 0f 1e fa          	endbr64 
  401084:	68 05 00 00 00       	push   0x5
  401089:	f2 e9 91 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40108f:	90                   	nop
  401090:	f3 0f 1e fa          	endbr64 
  401094:	68 06 00 00 00       	push   0x6
  401099:	f2 e9 81 ff ff ff    	bnd jmp 401020 <_init+0x20>
  40109f:	90                   	nop

Disassembly of section .plt.sec:

00000000004010a0 <puts@plt>:
  4010a0:	f3 0f 1e fa          	endbr64 
  4010a4:	f2 ff 25 6d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f6d]        # 404018 <puts@GLIBC_2.2.5>
  4010ab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000004010b0 <__stack_chk_fail@plt>:
  4010b0:	f3 0f 1e fa          	endbr64 
  4010b4:	f2 ff 25 65 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f65]        # 404020 <__stack_chk_fail@GLIBC_2.4>
  4010bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000004010c0 <printf@plt>:
  4010c0:	f3 0f 1e fa          	endbr64 
  4010c4:	f2 ff 25 5d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f5d]        # 404028 <printf@GLIBC_2.2.5>
  4010cb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000004010d0 <read@plt>:
  4010d0:	f3 0f 1e fa          	endbr64 
  4010d4:	f2 ff 25 55 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f55]        # 404030 <read@GLIBC_2.2.5>
  4010db:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000004010e0 <strcmp@plt>:
  4010e0:	f3 0f 1e fa          	endbr64 
  4010e4:	f2 ff 25 4d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f4d]        # 404038 <strcmp@GLIBC_2.2.5>
  4010eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000004010f0 <fflush@plt>:
  4010f0:	f3 0f 1e fa          	endbr64 
  4010f4:	f2 ff 25 45 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f45]        # 404040 <fflush@GLIBC_2.2.5>
  4010fb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000401100 <execl@plt>:
  401100:	f3 0f 1e fa          	endbr64 
  401104:	f2 ff 25 3d 2f 00 00 	bnd jmp QWORD PTR [rip+0x2f3d]        # 404048 <execl@GLIBC_2.2.5>
  40110b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

0000000000401110 <_start>:
  401110:	f3 0f 1e fa          	endbr64 
  401114:	31 ed                	xor    ebp,ebp
  401116:	49 89 d1             	mov    r9,rdx
  401119:	5e                   	pop    rsi
  40111a:	48 89 e2             	mov    rdx,rsp
  40111d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
  401121:	50                   	push   rax
  401122:	54                   	push   rsp
  401123:	45 31 c0             	xor    r8d,r8d
  401126:	31 c9                	xor    ecx,ecx
  401128:	48 c7 c7 f6 13 40 00 	mov    rdi,0x4013f6
  40112f:	ff 15 bb 2e 00 00    	call   QWORD PTR [rip+0x2ebb]        # 403ff0 <__libc_start_main@GLIBC_2.34>
  401135:	f4                   	hlt    
  401136:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  40113d:	00 00 00 

0000000000401140 <_dl_relocate_static_pie>:
  401140:	f3 0f 1e fa          	endbr64 
  401144:	c3                   	ret    
  401145:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  40114c:	00 00 00 
  40114f:	90                   	nop

0000000000401150 <deregister_tm_clones>:
  401150:	b8 60 40 40 00       	mov    eax,0x404060
  401155:	48 3d 60 40 40 00    	cmp    rax,0x404060
  40115b:	74 13                	je     401170 <deregister_tm_clones+0x20>
  40115d:	b8 00 00 00 00       	mov    eax,0x0
  401162:	48 85 c0             	test   rax,rax
  401165:	74 09                	je     401170 <deregister_tm_clones+0x20>
  401167:	bf 60 40 40 00       	mov    edi,0x404060
  40116c:	ff e0                	jmp    rax
  40116e:	66 90                	xchg   ax,ax
  401170:	c3                   	ret    
  401171:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  401178:	00 00 00 00 
  40117c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000401180 <register_tm_clones>:
  401180:	be 60 40 40 00       	mov    esi,0x404060
  401185:	48 81 ee 60 40 40 00 	sub    rsi,0x404060
  40118c:	48 89 f0             	mov    rax,rsi
  40118f:	48 c1 ee 3f          	shr    rsi,0x3f
  401193:	48 c1 f8 03          	sar    rax,0x3
  401197:	48 01 c6             	add    rsi,rax
  40119a:	48 d1 fe             	sar    rsi,1
  40119d:	74 11                	je     4011b0 <register_tm_clones+0x30>
  40119f:	b8 00 00 00 00       	mov    eax,0x0
  4011a4:	48 85 c0             	test   rax,rax
  4011a7:	74 07                	je     4011b0 <register_tm_clones+0x30>
  4011a9:	bf 60 40 40 00       	mov    edi,0x404060
  4011ae:	ff e0                	jmp    rax
  4011b0:	c3                   	ret    
  4011b1:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  4011b8:	00 00 00 00 
  4011bc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000004011c0 <__do_global_dtors_aux>:
  4011c0:	f3 0f 1e fa          	endbr64 
  4011c4:	80 3d 9d 2e 00 00 00 	cmp    BYTE PTR [rip+0x2e9d],0x0        # 404068 <completed.0>
  4011cb:	75 13                	jne    4011e0 <__do_global_dtors_aux+0x20>
  4011cd:	55                   	push   rbp
  4011ce:	48 89 e5             	mov    rbp,rsp
  4011d1:	e8 7a ff ff ff       	call   401150 <deregister_tm_clones>
  4011d6:	c6 05 8b 2e 00 00 01 	mov    BYTE PTR [rip+0x2e8b],0x1        # 404068 <completed.0>
  4011dd:	5d                   	pop    rbp
  4011de:	c3                   	ret    
  4011df:	90                   	nop
  4011e0:	c3                   	ret    
  4011e1:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  4011e8:	00 00 00 00 
  4011ec:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000004011f0 <frame_dummy>:
  4011f0:	f3 0f 1e fa          	endbr64 
  4011f4:	eb 8a                	jmp    401180 <register_tm_clones>

00000000004011f6 <shelly>:
  4011f6:	f3 0f 1e fa          	endbr64 
  4011fa:	48 83 ec 08          	sub    rsp,0x8
  4011fe:	bf 04 20 40 00       	mov    edi,0x402004
  401203:	e8 98 fe ff ff       	call   4010a0 <puts@plt>
  401208:	bf 20 20 40 00       	mov    edi,0x402020
  40120d:	e8 8e fe ff ff       	call   4010a0 <puts@plt>
  401212:	48 8b 3d 47 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2e47]        # 404060 <stdout@GLIBC_2.2.5>
  401219:	e8 d2 fe ff ff       	call   4010f0 <fflush@plt>
  40121e:	ba 00 00 00 00       	mov    edx,0x0
  401223:	be 38 20 40 00       	mov    esi,0x402038
  401228:	bf 33 20 40 00       	mov    edi,0x402033
  40122d:	b8 00 00 00 00       	mov    eax,0x0
  401232:	e8 c9 fe ff ff       	call   401100 <execl@plt>
  401237:	48 83 c4 08          	add    rsp,0x8
  40123b:	c3                   	ret    

000000000040123c <give_cookie>:
  40123c:	f3 0f 1e fa          	endbr64 
  401240:	48 83 ec 68          	sub    rsp,0x68
  401244:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
  40124b:	00 00 
  40124d:	48 89 44 24 58       	mov    QWORD PTR [rsp+0x58],rax
  401252:	31 c0                	xor    eax,eax
  401254:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
  40125b:	00 00 
  40125d:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  401264:	00 00 
  401266:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
  40126d:	00 00 
  40126f:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
  401276:	00 00 
  401278:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
  40127f:	00 00 
  401281:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  401288:	00 00 
  40128a:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
  401291:	00 00 
  401293:	48 c7 44 24 40 00 00 	mov    QWORD PTR [rsp+0x40],0x0
  40129a:	00 00 
  40129c:	48 c7 44 24 48 00 00 	mov    QWORD PTR [rsp+0x48],0x0
  4012a3:	00 00 
  4012a5:	bf c8 20 40 00       	mov    edi,0x4020c8
  4012aa:	e8 f1 fd ff ff       	call   4010a0 <puts@plt>
  4012af:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  4012b6:	00 00 
  4012b8:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
  4012bf:	00 00 
  4012c1:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
  4012c8:	00 00 
  4012ca:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
  4012d1:	00 00 
  4012d3:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  4012da:	00 00 
  4012dc:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
  4012e3:	00 00 
  4012e5:	48 c7 44 24 40 00 00 	mov    QWORD PTR [rsp+0x40],0x0
  4012ec:	00 00 
  4012ee:	48 c7 44 24 48 00 00 	mov    QWORD PTR [rsp+0x48],0x0
  4012f5:	00 00 
  4012f7:	ba 64 00 00 00       	mov    edx,0x64
  4012fc:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
  401301:	bf 00 00 00 00       	mov    edi,0x0
  401306:	e8 c5 fd ff ff       	call   4010d0 <read@plt>
  40130b:	be 3b 20 40 00       	mov    esi,0x40203b
  401310:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
  401315:	e8 c6 fd ff ff       	call   4010e0 <strcmp@plt>
  40131a:	85 c0                	test   eax,eax
  40131c:	74 49                	je     401367 <give_cookie+0x12b>
  40131e:	be 5b 20 40 00       	mov    esi,0x40205b
  401323:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
  401328:	e8 b3 fd ff ff       	call   4010e0 <strcmp@plt>
  40132d:	85 c0                	test   eax,eax
  40132f:	0f 84 84 00 00 00    	je     4013b9 <give_cookie+0x17d>
  401335:	be 62 20 40 00       	mov    esi,0x402062
  40133a:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
  40133f:	e8 9c fd ff ff       	call   4010e0 <strcmp@plt>
  401344:	85 c0                	test   eax,eax
  401346:	74 7d                	je     4013c5 <give_cookie+0x189>
  401348:	be 80 20 40 00       	mov    esi,0x402080
  40134d:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
  401352:	e8 89 fd ff ff       	call   4010e0 <strcmp@plt>
  401357:	85 c0                	test   eax,eax
  401359:	75 76                	jne    4013d1 <give_cookie+0x195>
  40135b:	bf 86 20 40 00       	mov    edi,0x402086
  401360:	e8 3b fd ff ff       	call   4010a0 <puts@plt>
  401365:	eb 0a                	jmp    401371 <give_cookie+0x135>
  401367:	bf 46 20 40 00       	mov    edi,0x402046
  40136c:	e8 2f fd ff ff       	call   4010a0 <puts@plt>
  401371:	bf 9d 20 40 00       	mov    edi,0x40209d
  401376:	e8 25 fd ff ff       	call   4010a0 <puts@plt>
  40137b:	ba 07 00 00 00       	mov    edx,0x7
  401380:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
  401385:	bf 00 00 00 00       	mov    edi,0x0
  40138a:	e8 41 fd ff ff       	call   4010d0 <read@plt>
  40138f:	80 7c 24 08 79       	cmp    BYTE PTR [rsp+0x8],0x79
  401394:	0f 84 0b ff ff ff    	je     4012a5 <give_cookie+0x69>
  40139a:	bf 68 21 40 00       	mov    edi,0x402168
  40139f:	e8 fc fc ff ff       	call   4010a0 <puts@plt>
  4013a4:	48 8b 44 24 58       	mov    rax,QWORD PTR [rsp+0x58]
  4013a9:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
  4013b0:	00 00 
  4013b2:	75 3d                	jne    4013f1 <give_cookie+0x1b5>
  4013b4:	48 83 c4 68          	add    rsp,0x68
  4013b8:	c3                   	ret    
  4013b9:	bf f0 20 40 00       	mov    edi,0x4020f0
  4013be:	e8 dd fc ff ff       	call   4010a0 <puts@plt>
  4013c3:	eb ac                	jmp    401371 <give_cookie+0x135>
  4013c5:	bf 6b 20 40 00       	mov    edi,0x40206b
  4013ca:	e8 d1 fc ff ff       	call   4010a0 <puts@plt>
  4013cf:	eb a0                	jmp    401371 <give_cookie+0x135>
  4013d1:	48 8d 74 24 10       	lea    rsi,[rsp+0x10]
  4013d6:	bf 18 21 40 00       	mov    edi,0x402118
  4013db:	b8 00 00 00 00       	mov    eax,0x0
  4013e0:	e8 db fc ff ff       	call   4010c0 <printf@plt>
  4013e5:	bf 38 21 40 00       	mov    edi,0x402138
  4013ea:	e8 b1 fc ff ff       	call   4010a0 <puts@plt>
  4013ef:	eb 80                	jmp    401371 <give_cookie+0x135>
  4013f1:	e8 ba fc ff ff       	call   4010b0 <__stack_chk_fail@plt>

00000000004013f6 <main>:
  4013f6:	f3 0f 1e fa          	endbr64 
  4013fa:	48 83 ec 08          	sub    rsp,0x8
  4013fe:	bf b0 20 40 00       	mov    edi,0x4020b0
  401403:	e8 98 fc ff ff       	call   4010a0 <puts@plt>
  401408:	b8 00 00 00 00       	mov    eax,0x0
  40140d:	e8 2a fe ff ff       	call   40123c <give_cookie>
  401412:	b8 00 00 00 00       	mov    eax,0x0
  401417:	48 83 c4 08          	add    rsp,0x8
  40141b:	c3                   	ret    

Disassembly of section .fini:

000000000040141c <_fini>:
  40141c:	f3 0f 1e fa          	endbr64 
  401420:	48 83 ec 08          	sub    rsp,0x8
  401424:	48 83 c4 08          	add    rsp,0x8
  401428:	c3                   	ret    
