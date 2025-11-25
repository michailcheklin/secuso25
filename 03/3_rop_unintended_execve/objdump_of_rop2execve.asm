
./rop2execve:     file format elf64-x86-64


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

0000000000401020 <puts@plt-0x10>:
  401020:	ff 35 e2 2f 00 00    	push   QWORD PTR [rip+0x2fe2]        # 404008 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:	ff 25 e4 2f 00 00    	jmp    QWORD PTR [rip+0x2fe4]        # 404010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000401030 <puts@plt>:
  401030:	ff 25 e2 2f 00 00    	jmp    QWORD PTR [rip+0x2fe2]        # 404018 <puts@GLIBC_2.2.5>
  401036:	68 00 00 00 00       	push   0x0
  40103b:	e9 e0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401040 <printf@plt>:
  401040:	ff 25 da 2f 00 00    	jmp    QWORD PTR [rip+0x2fda]        # 404020 <printf@GLIBC_2.2.5>
  401046:	68 01 00 00 00       	push   0x1
  40104b:	e9 d0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401050 <fgets@plt>:
  401050:	ff 25 d2 2f 00 00    	jmp    QWORD PTR [rip+0x2fd2]        # 404028 <fgets@GLIBC_2.2.5>
  401056:	68 02 00 00 00       	push   0x2
  40105b:	e9 c0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401060 <explicit_bzero@plt>:
  401060:	ff 25 ca 2f 00 00    	jmp    QWORD PTR [rip+0x2fca]        # 404030 <explicit_bzero@GLIBC_2.25>
  401066:	68 03 00 00 00       	push   0x3
  40106b:	e9 b0 ff ff ff       	jmp    401020 <_init+0x20>

Disassembly of section .text:

0000000000401070 <_start>:
  401070:	f3 0f 1e fa          	endbr64 
  401074:	31 ed                	xor    ebp,ebp
  401076:	49 89 d1             	mov    r9,rdx
  401079:	5e                   	pop    rsi
  40107a:	48 89 e2             	mov    rdx,rsp
  40107d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
  401081:	50                   	push   rax
  401082:	54                   	push   rsp
  401083:	45 31 c0             	xor    r8d,r8d
  401086:	31 c9                	xor    ecx,ecx
  401088:	48 c7 c7 74 12 40 00 	mov    rdi,0x401274
  40108f:	ff 15 5b 2f 00 00    	call   QWORD PTR [rip+0x2f5b]        # 403ff0 <__libc_start_main@GLIBC_2.34>
  401095:	f4                   	hlt    
  401096:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  40109d:	00 00 00 

00000000004010a0 <_dl_relocate_static_pie>:
  4010a0:	f3 0f 1e fa          	endbr64 
  4010a4:	c3                   	ret    
  4010a5:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  4010ac:	00 00 00 
  4010af:	90                   	nop

00000000004010b0 <deregister_tm_clones>:
  4010b0:	b8 48 40 40 00       	mov    eax,0x404048
  4010b5:	48 3d 48 40 40 00    	cmp    rax,0x404048
  4010bb:	74 13                	je     4010d0 <deregister_tm_clones+0x20>
  4010bd:	b8 00 00 00 00       	mov    eax,0x0
  4010c2:	48 85 c0             	test   rax,rax
  4010c5:	74 09                	je     4010d0 <deregister_tm_clones+0x20>
  4010c7:	bf 48 40 40 00       	mov    edi,0x404048
  4010cc:	ff e0                	jmp    rax
  4010ce:	66 90                	xchg   ax,ax
  4010d0:	c3                   	ret    
  4010d1:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  4010d8:	00 00 00 00 
  4010dc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000004010e0 <register_tm_clones>:
  4010e0:	be 48 40 40 00       	mov    esi,0x404048
  4010e5:	48 81 ee 48 40 40 00 	sub    rsi,0x404048
  4010ec:	48 89 f0             	mov    rax,rsi
  4010ef:	48 c1 ee 3f          	shr    rsi,0x3f
  4010f3:	48 c1 f8 03          	sar    rax,0x3
  4010f7:	48 01 c6             	add    rsi,rax
  4010fa:	48 d1 fe             	sar    rsi,1
  4010fd:	74 11                	je     401110 <register_tm_clones+0x30>
  4010ff:	b8 00 00 00 00       	mov    eax,0x0
  401104:	48 85 c0             	test   rax,rax
  401107:	74 07                	je     401110 <register_tm_clones+0x30>
  401109:	bf 48 40 40 00       	mov    edi,0x404048
  40110e:	ff e0                	jmp    rax
  401110:	c3                   	ret    
  401111:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  401118:	00 00 00 00 
  40111c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000401120 <__do_global_dtors_aux>:
  401120:	f3 0f 1e fa          	endbr64 
  401124:	80 3d 2d 2f 00 00 00 	cmp    BYTE PTR [rip+0x2f2d],0x0        # 404058 <completed.0>
  40112b:	75 13                	jne    401140 <__do_global_dtors_aux+0x20>
  40112d:	55                   	push   rbp
  40112e:	48 89 e5             	mov    rbp,rsp
  401131:	e8 7a ff ff ff       	call   4010b0 <deregister_tm_clones>
  401136:	c6 05 1b 2f 00 00 01 	mov    BYTE PTR [rip+0x2f1b],0x1        # 404058 <completed.0>
  40113d:	5d                   	pop    rbp
  40113e:	c3                   	ret    
  40113f:	90                   	nop
  401140:	c3                   	ret    
  401141:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
  401148:	00 00 00 00 
  40114c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000401150 <frame_dummy>:
  401150:	f3 0f 1e fa          	endbr64 
  401154:	eb 8a                	jmp    4010e0 <register_tm_clones>
  401156:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
  40115d:	00 00 00 

0000000000401160 <gadgets>:
  401160:	0f 0b                	ud2    
  401162:	90                   	nop
  401163:	90                   	nop
  401164:	90                   	nop
  401165:	90                   	nop

0000000000401166 <g1>:
  401166:	48 31 db             	xor    rbx,rbx
  401169:	c3                   	ret    
  40116a:	90                   	nop
  40116b:	90                   	nop
  40116c:	90                   	nop
  40116d:	90                   	nop
  40116e:	0f 0b                	ud2    
  401170:	90                   	nop
  401171:	90                   	nop
  401172:	90                   	nop
  401173:	90                   	nop

0000000000401174 <g2>:
  401174:	5f                   	pop    rdi
  401175:	c3                   	ret    
  401176:	90                   	nop
  401177:	90                   	nop
  401178:	90                   	nop
  401179:	90                   	nop
  40117a:	0f 0b                	ud2    
  40117c:	90                   	nop
  40117d:	90                   	nop
  40117e:	90                   	nop
  40117f:	90                   	nop

0000000000401180 <g3>:
  401180:	5a                   	pop    rdx
  401181:	c3                   	ret    
  401182:	90                   	nop
  401183:	90                   	nop
  401184:	90                   	nop
  401185:	90                   	nop
  401186:	0f 0b                	ud2    
  401188:	90                   	nop
  401189:	90                   	nop
  40118a:	90                   	nop
  40118b:	90                   	nop

000000000040118c <g4>:
  40118c:	48 8b 4c 24 f0       	mov    rcx,QWORD PTR [rsp-0x10]
  401191:	c3                   	ret    
  401192:	90                   	nop
  401193:	90                   	nop
  401194:	90                   	nop
  401195:	90                   	nop
  401196:	0f 0b                	ud2    
  401198:	90                   	nop
  401199:	90                   	nop
  40119a:	90                   	nop
  40119b:	90                   	nop

000000000040119c <g5>:
  40119c:	41 58                	pop    r8
  40119e:	41 59                	pop    r9
  4011a0:	c3                   	ret    
  4011a1:	90                   	nop
  4011a2:	90                   	nop
  4011a3:	90                   	nop
  4011a4:	90                   	nop
  4011a5:	0f 0b                	ud2    
  4011a7:	90                   	nop
  4011a8:	90                   	nop
  4011a9:	90                   	nop
  4011aa:	90                   	nop

00000000004011ab <g6>:
  4011ab:	48 31 c0             	xor    rax,rax
  4011ae:	c3                   	ret    
  4011af:	90                   	nop
  4011b0:	90                   	nop
  4011b1:	90                   	nop
  4011b2:	90                   	nop
  4011b3:	0f 0b                	ud2    
  4011b5:	90                   	nop
  4011b6:	90                   	nop
  4011b7:	90                   	nop
  4011b8:	90                   	nop

00000000004011b9 <g7>:
  4011b9:	8b 04 25 48 89 c8 00 	mov    eax,DWORD PTR ds:0xc88948
  4011c0:	c3                   	ret    
  4011c1:	c3                   	ret    
  4011c2:	90                   	nop
  4011c3:	90                   	nop
  4011c4:	90                   	nop
  4011c5:	90                   	nop
  4011c6:	0f 0b                	ud2    
  4011c8:	90                   	nop
  4011c9:	90                   	nop
  4011ca:	90                   	nop
  4011cb:	90                   	nop

00000000004011cc <g8>:
  4011cc:	48 85 c0             	test   rax,rax
  4011cf:	c3                   	ret    
  4011d0:	90                   	nop
  4011d1:	90                   	nop
  4011d2:	90                   	nop
  4011d3:	90                   	nop
  4011d4:	0f 0b                	ud2    
  4011d6:	90                   	nop
  4011d7:	90                   	nop
  4011d8:	90                   	nop
  4011d9:	90                   	nop

00000000004011da <g9>:
  4011da:	5e                   	pop    rsi
  4011db:	c3                   	ret    
  4011dc:	90                   	nop
  4011dd:	90                   	nop
  4011de:	90                   	nop
  4011df:	90                   	nop
  4011e0:	0f 0b                	ud2    
  4011e2:	90                   	nop
  4011e3:	90                   	nop
  4011e4:	90                   	nop
  4011e5:	90                   	nop

00000000004011e6 <__gadgets_end>:
  4011e6:	90                   	nop
  4011e7:	90                   	nop
  4011e8:	90                   	nop
  4011e9:	90                   	nop

00000000004011ea <compute>:
  4011ea:	55                   	push   rbp
  4011eb:	48 89 e5             	mov    rbp,rsp
  4011ee:	89 7d ec             	mov    DWORD PTR [rbp-0x14],edi
  4011f1:	89 75 e8             	mov    DWORD PTR [rbp-0x18],esi
  4011f4:	8b 45 ec             	mov    eax,DWORD PTR [rbp-0x14]
  4011f7:	c1 e0 1e             	shl    eax,0x1e
  4011fa:	35 cd 43 00 00       	xor    eax,0x43cd
  4011ff:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  401202:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
  401205:	01 45 fc             	add    DWORD PTR [rbp-0x4],eax
  401208:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
  40120c:	79 07                	jns    401215 <compute+0x2b>
  40120e:	b8 0f 04 00 00       	mov    eax,0x40f
  401213:	eb 05                	jmp    40121a <compute+0x30>
  401215:	b8 0f 05 00 00       	mov    eax,0x50f
  40121a:	5d                   	pop    rbp
  40121b:	c3                   	ret    

000000000040121c <vuln>:
  40121c:	55                   	push   rbp
  40121d:	48 89 e5             	mov    rbp,rsp
  401220:	48 83 ec 30          	sub    rsp,0x30
  401224:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  40122b:	48 8d 45 d0          	lea    rax,[rbp-0x30]
  40122f:	48 89 c6             	mov    rsi,rax
  401232:	bf 08 20 40 00       	mov    edi,0x402008
  401237:	b8 00 00 00 00       	mov    eax,0x0
  40123c:	e8 ff fd ff ff       	call   401040 <printf@plt>
  401241:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  401244:	48 8b 15 05 2e 00 00 	mov    rdx,QWORD PTR [rip+0x2e05]        # 404050 <stdin@GLIBC_2.2.5>
  40124b:	48 8d 45 d0          	lea    rax,[rbp-0x30]
  40124f:	be 00 02 00 00       	mov    esi,0x200
  401254:	48 89 c7             	mov    rdi,rax
  401257:	e8 f4 fd ff ff       	call   401050 <fgets@plt>
  40125c:	48 8d 45 d0          	lea    rax,[rbp-0x30]
  401260:	be 20 00 00 00       	mov    esi,0x20
  401265:	48 89 c7             	mov    rdi,rax
  401268:	e8 f3 fd ff ff       	call   401060 <explicit_bzero@plt>
  40126d:	b8 00 00 00 00       	mov    eax,0x0
  401272:	c9                   	leave  
  401273:	c3                   	ret    

0000000000401274 <main>:
  401274:	55                   	push   rbp
  401275:	48 89 e5             	mov    rbp,rsp
  401278:	bf 2c 20 40 00       	mov    edi,0x40202c
  40127d:	e8 ae fd ff ff       	call   401030 <puts@plt>
  401282:	e8 95 ff ff ff       	call   40121c <vuln>
  401287:	b8 00 00 00 00       	mov    eax,0x0
  40128c:	5d                   	pop    rbp
  40128d:	c3                   	ret    

Disassembly of section .fini:

0000000000401290 <_fini>:
  401290:	f3 0f 1e fa          	endbr64 
  401294:	48 83 ec 08          	sub    rsp,0x8
  401298:	48 83 c4 08          	add    rsp,0x8
  40129c:	c3                   	ret    
