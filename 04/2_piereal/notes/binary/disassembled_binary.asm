
./getreal3:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <warn@plt-0x10>:
    1020:	ff 35 22 2f 00 00    	push   QWORD PTR [rip+0x2f22]        # 3f48 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 24 2f 00 00    	jmp    QWORD PTR [rip+0x2f24]        # 3f50 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001030 <warn@plt>:
    1030:	ff 25 22 2f 00 00    	jmp    QWORD PTR [rip+0x2f22]        # 3f58 <warn@GLIBC_2.2.5>
    1036:	68 00 00 00 00       	push   0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001040 <puts@plt>:
    1040:	ff 25 1a 2f 00 00    	jmp    QWORD PTR [rip+0x2f1a]        # 3f60 <puts@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	push   0x1
    104b:	e9 d0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001050 <strtod@plt>:
    1050:	ff 25 12 2f 00 00    	jmp    QWORD PTR [rip+0x2f12]        # 3f68 <strtod@GLIBC_2.2.5>
    1056:	68 02 00 00 00       	push   0x2
    105b:	e9 c0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001060 <fclose@plt>:
    1060:	ff 25 0a 2f 00 00    	jmp    QWORD PTR [rip+0x2f0a]        # 3f70 <fclose@GLIBC_2.2.5>
    1066:	68 03 00 00 00       	push   0x3
    106b:	e9 b0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001070 <printf@plt>:
    1070:	ff 25 02 2f 00 00    	jmp    QWORD PTR [rip+0x2f02]        # 3f78 <printf@GLIBC_2.2.5>
    1076:	68 04 00 00 00       	push   0x4
    107b:	e9 a0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001080 <memset@plt>:
    1080:	ff 25 fa 2e 00 00    	jmp    QWORD PTR [rip+0x2efa]        # 3f80 <memset@GLIBC_2.2.5>
    1086:	68 05 00 00 00       	push   0x5
    108b:	e9 90 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001090 <fgets@plt>:
    1090:	ff 25 f2 2e 00 00    	jmp    QWORD PTR [rip+0x2ef2]        # 3f88 <fgets@GLIBC_2.2.5>
    1096:	68 06 00 00 00       	push   0x6
    109b:	e9 80 ff ff ff       	jmp    1020 <_init+0x20>

00000000000010a0 <strcmp@plt>:
    10a0:	ff 25 ea 2e 00 00    	jmp    QWORD PTR [rip+0x2eea]        # 3f90 <strcmp@GLIBC_2.2.5>
    10a6:	68 07 00 00 00       	push   0x7
    10ab:	e9 70 ff ff ff       	jmp    1020 <_init+0x20>

00000000000010b0 <fprintf@plt>:
    10b0:	ff 25 e2 2e 00 00    	jmp    QWORD PTR [rip+0x2ee2]        # 3f98 <fprintf@GLIBC_2.2.5>
    10b6:	68 08 00 00 00       	push   0x8
    10bb:	e9 60 ff ff ff       	jmp    1020 <_init+0x20>

00000000000010c0 <feof@plt>:
    10c0:	ff 25 da 2e 00 00    	jmp    QWORD PTR [rip+0x2eda]        # 3fa0 <feof@GLIBC_2.2.5>
    10c6:	68 09 00 00 00       	push   0x9
    10cb:	e9 50 ff ff ff       	jmp    1020 <_init+0x20>

00000000000010d0 <memcpy@plt>:
    10d0:	ff 25 d2 2e 00 00    	jmp    QWORD PTR [rip+0x2ed2]        # 3fa8 <memcpy@GLIBC_2.14>
    10d6:	68 0a 00 00 00       	push   0xa
    10db:	e9 40 ff ff ff       	jmp    1020 <_init+0x20>

00000000000010e0 <fopen@plt>:
    10e0:	ff 25 ca 2e 00 00    	jmp    QWORD PTR [rip+0x2eca]        # 3fb0 <fopen@GLIBC_2.2.5>
    10e6:	68 0b 00 00 00       	push   0xb
    10eb:	e9 30 ff ff ff       	jmp    1020 <_init+0x20>

00000000000010f0 <__isoc99_scanf@plt>:
    10f0:	ff 25 c2 2e 00 00    	jmp    QWORD PTR [rip+0x2ec2]        # 3fb8 <__isoc99_scanf@GLIBC_2.7>
    10f6:	68 0c 00 00 00       	push   0xc
    10fb:	e9 20 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001100 <explicit_bzero@plt>:
    1100:	ff 25 ba 2e 00 00    	jmp    QWORD PTR [rip+0x2eba]        # 3fc0 <explicit_bzero@GLIBC_2.25>
    1106:	68 0d 00 00 00       	push   0xd
    110b:	e9 10 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001110 <getc@plt>:
    1110:	ff 25 b2 2e 00 00    	jmp    QWORD PTR [rip+0x2eb2]        # 3fc8 <getc@GLIBC_2.2.5>
    1116:	68 0e 00 00 00       	push   0xe
    111b:	e9 00 ff ff ff       	jmp    1020 <_init+0x20>

Disassembly of section .plt.got:

0000000000001120 <__cxa_finalize@plt>:
    1120:	ff 25 d2 2e 00 00    	jmp    QWORD PTR [rip+0x2ed2]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1126:	66 90                	xchg   ax,ax

Disassembly of section .text:

0000000000001130 <_start>:
    1130:	f3 0f 1e fa          	endbr64 
    1134:	31 ed                	xor    ebp,ebp
    1136:	49 89 d1             	mov    r9,rdx
    1139:	5e                   	pop    rsi
    113a:	48 89 e2             	mov    rdx,rsp
    113d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    1141:	50                   	push   rax
    1142:	54                   	push   rsp
    1143:	45 31 c0             	xor    r8d,r8d
    1146:	31 c9                	xor    ecx,ecx
    1148:	48 8d 3d 11 05 00 00 	lea    rdi,[rip+0x511]        # 1660 <main>
    114f:	ff 15 7b 2e 00 00    	call   QWORD PTR [rip+0x2e7b]        # 3fd0 <__libc_start_main@GLIBC_2.34>
    1155:	f4                   	hlt    
    1156:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    115d:	00 00 00 

0000000000001160 <deregister_tm_clones>:
    1160:	48 8d 3d b9 2e 00 00 	lea    rdi,[rip+0x2eb9]        # 4020 <__TMC_END__>
    1167:	48 8d 05 b2 2e 00 00 	lea    rax,[rip+0x2eb2]        # 4020 <__TMC_END__>
    116e:	48 39 f8             	cmp    rax,rdi
    1171:	74 15                	je     1188 <deregister_tm_clones+0x28>
    1173:	48 8b 05 5e 2e 00 00 	mov    rax,QWORD PTR [rip+0x2e5e]        # 3fd8 <_ITM_deregisterTMCloneTable@Base>
    117a:	48 85 c0             	test   rax,rax
    117d:	74 09                	je     1188 <deregister_tm_clones+0x28>
    117f:	ff e0                	jmp    rax
    1181:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    1188:	c3                   	ret    
    1189:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001190 <register_tm_clones>:
    1190:	48 8d 3d 89 2e 00 00 	lea    rdi,[rip+0x2e89]        # 4020 <__TMC_END__>
    1197:	48 8d 35 82 2e 00 00 	lea    rsi,[rip+0x2e82]        # 4020 <__TMC_END__>
    119e:	48 29 fe             	sub    rsi,rdi
    11a1:	48 89 f0             	mov    rax,rsi
    11a4:	48 c1 ee 3f          	shr    rsi,0x3f
    11a8:	48 c1 f8 03          	sar    rax,0x3
    11ac:	48 01 c6             	add    rsi,rax
    11af:	48 d1 fe             	sar    rsi,1
    11b2:	74 14                	je     11c8 <register_tm_clones+0x38>
    11b4:	48 8b 05 35 2e 00 00 	mov    rax,QWORD PTR [rip+0x2e35]        # 3ff0 <_ITM_registerTMCloneTable@Base>
    11bb:	48 85 c0             	test   rax,rax
    11be:	74 08                	je     11c8 <register_tm_clones+0x38>
    11c0:	ff e0                	jmp    rax
    11c2:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    11c8:	c3                   	ret    
    11c9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

00000000000011d0 <__do_global_dtors_aux>:
    11d0:	f3 0f 1e fa          	endbr64 
    11d4:	80 3d 45 2e 00 00 00 	cmp    BYTE PTR [rip+0x2e45],0x0        # 4020 <__TMC_END__>
    11db:	75 2b                	jne    1208 <__do_global_dtors_aux+0x38>
    11dd:	55                   	push   rbp
    11de:	48 83 3d 12 2e 00 00 	cmp    QWORD PTR [rip+0x2e12],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    11e5:	00 
    11e6:	48 89 e5             	mov    rbp,rsp
    11e9:	74 0c                	je     11f7 <__do_global_dtors_aux+0x27>
    11eb:	48 8b 3d 16 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2e16]        # 4008 <__dso_handle>
    11f2:	e8 29 ff ff ff       	call   1120 <__cxa_finalize@plt>
    11f7:	e8 64 ff ff ff       	call   1160 <deregister_tm_clones>
    11fc:	c6 05 1d 2e 00 00 01 	mov    BYTE PTR [rip+0x2e1d],0x1        # 4020 <__TMC_END__>
    1203:	5d                   	pop    rbp
    1204:	c3                   	ret    
    1205:	0f 1f 00             	nop    DWORD PTR [rax]
    1208:	c3                   	ret    
    1209:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001210 <frame_dummy>:
    1210:	f3 0f 1e fa          	endbr64 
    1214:	e9 77 ff ff ff       	jmp    1190 <register_tm_clones>
    1219:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001220 <print_help>:
    1220:	41 56                	push   r14
    1222:	53                   	push   rbx
    1223:	50                   	push   rax
    1224:	49 89 fe             	mov    r14,rdi
    1227:	48 39 3d e2 2d 00 00 	cmp    QWORD PTR [rip+0x2de2],rdi        # 4010 <help_msg>
    122e:	74 48                	je     1278 <print_help+0x58>
    1230:	b2 01                	mov    dl,0x1
    1232:	31 c9                	xor    ecx,ecx
    1234:	48 8d 05 d5 2d 00 00 	lea    rax,[rip+0x2dd5]        # 4010 <help_msg>
    123b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
    1240:	48 83 f9 01          	cmp    rcx,0x1
    1244:	74 1f                	je     1265 <print_help+0x45>
    1246:	89 d3                	mov    ebx,edx
    1248:	48 8d 71 01          	lea    rsi,[rcx+0x1]
    124c:	31 d2                	xor    edx,edx
    124e:	4c 39 74 c8 08       	cmp    QWORD PTR [rax+rcx*8+0x8],r14
    1253:	48 89 f1             	mov    rcx,rsi
    1256:	75 e8                	jne    1240 <print_help+0x20>
    1258:	4c 89 f7             	mov    rdi,r14
    125b:	e8 e0 fd ff ff       	call   1040 <puts@plt>
    1260:	f6 c3 01             	test   bl,0x1
    1263:	75 1b                	jne    1280 <print_help+0x60>
    1265:	48 8d 3d 6f 0f 00 00 	lea    rdi,[rip+0xf6f]        # 21db <_IO_stdin_used+0x1db>
    126c:	4c 89 f6             	mov    rsi,r14
    126f:	31 c0                	xor    eax,eax
    1271:	e8 fa fd ff ff       	call   1070 <printf@plt>
    1276:	eb 08                	jmp    1280 <print_help+0x60>
    1278:	4c 89 f7             	mov    rdi,r14
    127b:	e8 c0 fd ff ff       	call   1040 <puts@plt>
    1280:	48 83 c4 08          	add    rsp,0x8
    1284:	5b                   	pop    rbx
    1285:	41 5e                	pop    r14
    1287:	c3                   	ret    
    1288:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
    128f:	00 

0000000000001290 <append_log>:
    1290:	53                   	push   rbx
    1291:	48 83 ec 10          	sub    rsp,0x10
    1295:	f2 0f 11 44 24 08    	movsd  QWORD PTR [rsp+0x8],xmm0
    129b:	48 8d 3d 69 0f 00 00 	lea    rdi,[rip+0xf69]        # 220b <_IO_stdin_used+0x20b>
    12a2:	48 8d 35 6f 0f 00 00 	lea    rsi,[rip+0xf6f]        # 2218 <_IO_stdin_used+0x218>
    12a9:	e8 32 fe ff ff       	call   10e0 <fopen@plt>
    12ae:	48 85 c0             	test   rax,rax
    12b1:	74 26                	je     12d9 <append_log+0x49>
    12b3:	48 89 c3             	mov    rbx,rax
    12b6:	48 8d 35 9c 0f 00 00 	lea    rsi,[rip+0xf9c]        # 2259 <_IO_stdin_used+0x259>
    12bd:	48 89 c7             	mov    rdi,rax
    12c0:	f2 0f 10 44 24 08    	movsd  xmm0,QWORD PTR [rsp+0x8]
    12c6:	b0 01                	mov    al,0x1
    12c8:	e8 e3 fd ff ff       	call   10b0 <fprintf@plt>
    12cd:	48 89 df             	mov    rdi,rbx
    12d0:	e8 8b fd ff ff       	call   1060 <fclose@plt>
    12d5:	31 c0                	xor    eax,eax
    12d7:	eb 13                	jmp    12ec <append_log+0x5c>
    12d9:	48 8d 3d 3a 0f 00 00 	lea    rdi,[rip+0xf3a]        # 221a <_IO_stdin_used+0x21a>
    12e0:	31 c0                	xor    eax,eax
    12e2:	e8 49 fd ff ff       	call   1030 <warn@plt>
    12e7:	b8 ff ff ff ff       	mov    eax,0xffffffff
    12ec:	48 83 c4 10          	add    rsp,0x10
    12f0:	5b                   	pop    rbx
    12f1:	c3                   	ret    
    12f2:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    12f9:	00 00 00 
    12fc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001300 <store_real>:
    1300:	41 56                	push   r14
    1302:	53                   	push   rbx
    1303:	48 81 ec 18 01 00 00 	sub    rsp,0x118
    130a:	48 8d 5c 24 10       	lea    rbx,[rsp+0x10]
    130f:	ba 08 01 00 00       	mov    edx,0x108
    1314:	48 89 df             	mov    rdi,rbx
    1317:	31 f6                	xor    esi,esi
    1319:	e8 62 fd ff ff       	call   1080 <memset@plt>
    131e:	48 8d 3d 04 0f 00 00 	lea    rdi,[rip+0xf04]        # 2229 <_IO_stdin_used+0x229>
    1325:	e8 16 fd ff ff       	call   1040 <puts@plt>
    132a:	4c 8b 35 af 2c 00 00 	mov    r14,QWORD PTR [rip+0x2caf]        # 3fe0 <stdin@GLIBC_2.2.5>
    1331:	49 8b 16             	mov    rdx,QWORD PTR [r14]
    1334:	48 89 df             	mov    rdi,rbx
    1337:	be 00 01 00 00       	mov    esi,0x100
    133c:	e8 4f fd ff ff       	call   1090 <fgets@plt>
    1341:	48 8d 3d f8 2c 00 00 	lea    rdi,[rip+0x2cf8]        # 4040 <password>
    1348:	ba 00 01 00 00       	mov    edx,0x100
    134d:	48 89 de             	mov    rsi,rbx
    1350:	e8 7b fd ff ff       	call   10d0 <memcpy@plt>
    1355:	c6 05 e3 2d 00 00 00 	mov    BYTE PTR [rip+0x2de3],0x0        # 413f <password+0xff>
    135c:	ba 08 01 00 00       	mov    edx,0x108
    1361:	48 89 df             	mov    rdi,rbx
    1364:	31 f6                	xor    esi,esi
    1366:	e8 15 fd ff ff       	call   1080 <memset@plt>
    136b:	48 8d 3d c7 0e 00 00 	lea    rdi,[rip+0xec7]        # 2239 <_IO_stdin_used+0x239>
    1372:	e8 c9 fc ff ff       	call   1040 <puts@plt>
    1377:	49 8b 16             	mov    rdx,QWORD PTR [r14]
    137a:	48 89 df             	mov    rdi,rbx
    137d:	be 08 01 00 00       	mov    esi,0x108
    1382:	e8 09 fd ff ff       	call   1090 <fgets@plt>
    1387:	48 89 df             	mov    rdi,rbx
    138a:	31 f6                	xor    esi,esi
    138c:	e8 bf fc ff ff       	call   1050 <strtod@plt>
    1391:	f2 0f 11 44 24 08    	movsd  QWORD PTR [rsp+0x8],xmm0
    1397:	f2 0f 11 05 91 2c 00 	movsd  QWORD PTR [rip+0x2c91],xmm0        # 4030 <real>
    139e:	00 
    139f:	48 8d 3d 65 0e 00 00 	lea    rdi,[rip+0xe65]        # 220b <_IO_stdin_used+0x20b>
    13a6:	48 8d 35 6b 0e 00 00 	lea    rsi,[rip+0xe6b]        # 2218 <_IO_stdin_used+0x218>
    13ad:	e8 2e fd ff ff       	call   10e0 <fopen@plt>
    13b2:	48 85 c0             	test   rax,rax
    13b5:	74 24                	je     13db <store_real+0xdb>
    13b7:	48 89 c3             	mov    rbx,rax
    13ba:	48 8d 35 98 0e 00 00 	lea    rsi,[rip+0xe98]        # 2259 <_IO_stdin_used+0x259>
    13c1:	48 89 c7             	mov    rdi,rax
    13c4:	f2 0f 10 44 24 08    	movsd  xmm0,QWORD PTR [rsp+0x8]
    13ca:	b0 01                	mov    al,0x1
    13cc:	e8 df fc ff ff       	call   10b0 <fprintf@plt>
    13d1:	48 89 df             	mov    rdi,rbx
    13d4:	e8 87 fc ff ff       	call   1060 <fclose@plt>
    13d9:	eb 0e                	jmp    13e9 <store_real+0xe9>
    13db:	48 8d 3d 38 0e 00 00 	lea    rdi,[rip+0xe38]        # 221a <_IO_stdin_used+0x21a>
    13e2:	31 c0                	xor    eax,eax
    13e4:	e8 47 fc ff ff       	call   1030 <warn@plt>
    13e9:	48 8d 7c 24 10       	lea    rdi,[rsp+0x10]
    13ee:	be 08 01 00 00       	mov    esi,0x108
    13f3:	e8 08 fd ff ff       	call   1100 <explicit_bzero@plt>
    13f8:	31 c0                	xor    eax,eax
    13fa:	48 81 c4 18 01 00 00 	add    rsp,0x118
    1401:	5b                   	pop    rbx
    1402:	41 5e                	pop    r14
    1404:	c3                   	ret    
    1405:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    140c:	00 00 00 
    140f:	90                   	nop

0000000000001410 <load_real>:
    1410:	53                   	push   rbx
    1411:	48 83 ec 40          	sub    rsp,0x40
    1415:	0f 57 c0             	xorps  xmm0,xmm0
    1418:	0f 29 44 24 30       	movaps XMMWORD PTR [rsp+0x30],xmm0
    141d:	0f 29 44 24 20       	movaps XMMWORD PTR [rsp+0x20],xmm0
    1422:	0f 29 44 24 10       	movaps XMMWORD PTR [rsp+0x10],xmm0
    1427:	0f 29 04 24          	movaps XMMWORD PTR [rsp],xmm0
    142b:	48 8d 3d f7 0d 00 00 	lea    rdi,[rip+0xdf7]        # 2229 <_IO_stdin_used+0x229>
    1432:	e8 09 fc ff ff       	call   1040 <puts@plt>
    1437:	48 8b 05 a2 2b 00 00 	mov    rax,QWORD PTR [rip+0x2ba2]        # 3fe0 <stdin@GLIBC_2.2.5>
    143e:	48 8b 10             	mov    rdx,QWORD PTR [rax]
    1441:	48 89 e3             	mov    rbx,rsp
    1444:	48 89 df             	mov    rdi,rbx
    1447:	be 80 02 00 00       	mov    esi,0x280
    144c:	e8 3f fc ff ff       	call   1090 <fgets@plt>
    1451:	48 8d 35 e8 2b 00 00 	lea    rsi,[rip+0x2be8]        # 4040 <password>
    1458:	48 89 df             	mov    rdi,rbx
    145b:	e8 40 fc ff ff       	call   10a0 <strcmp@plt>
    1460:	85 c0                	test   eax,eax
    1462:	74 13                	je     1477 <load_real+0x67>
    1464:	48 8d 3d f2 0d 00 00 	lea    rdi,[rip+0xdf2]        # 225d <_IO_stdin_used+0x25d>
    146b:	48 89 e6             	mov    rsi,rsp
    146e:	31 c0                	xor    eax,eax
    1470:	e8 fb fb ff ff       	call   1070 <printf@plt>
    1475:	eb 16                	jmp    148d <load_real+0x7d>
    1477:	f2 0f 10 05 b1 2b 00 	movsd  xmm0,QWORD PTR [rip+0x2bb1]        # 4030 <real>
    147e:	00 
    147f:	48 8d 3d c6 0d 00 00 	lea    rdi,[rip+0xdc6]        # 224c <_IO_stdin_used+0x24c>
    1486:	b0 01                	mov    al,0x1
    1488:	e8 e3 fb ff ff       	call   1070 <printf@plt>
    148d:	48 89 e7             	mov    rdi,rsp
    1490:	be 40 00 00 00       	mov    esi,0x40
    1495:	e8 66 fc ff ff       	call   1100 <explicit_bzero@plt>
    149a:	31 c0                	xor    eax,eax
    149c:	48 83 c4 40          	add    rsp,0x40
    14a0:	5b                   	pop    rbx
    14a1:	c3                   	ret    
    14a2:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    14a9:	00 00 00 
    14ac:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000000014b0 <real_main>:
    14b0:	55                   	push   rbp
    14b1:	41 57                	push   r15
    14b3:	41 56                	push   r14
    14b5:	41 55                	push   r13
    14b7:	41 54                	push   r12
    14b9:	53                   	push   rbx
    14ba:	48 83 ec 38          	sub    rsp,0x38
    14be:	0f 57 c0             	xorps  xmm0,xmm0
    14c1:	0f 29 44 24 20       	movaps XMMWORD PTR [rsp+0x20],xmm0
    14c6:	0f 29 44 24 10       	movaps XMMWORD PTR [rsp+0x10],xmm0
    14cb:	4c 8b 3d 3e 2b 00 00 	mov    r15,QWORD PTR [rip+0x2b3e]        # 4010 <help_msg>
    14d2:	48 8b 1d 07 2b 00 00 	mov    rbx,QWORD PTR [rip+0x2b07]        # 3fe0 <stdin@GLIBC_2.2.5>
    14d9:	48 8b 3b             	mov    rdi,QWORD PTR [rbx]
    14dc:	e8 df fb ff ff       	call   10c0 <feof@plt>
    14e1:	c7 44 24 04 00 00 00 	mov    DWORD PTR [rsp+0x4],0x0
    14e8:	00 
    14e9:	85 c0                	test   eax,eax
    14eb:	0f 85 4e 01 00 00    	jne    163f <real_main+0x18f>
    14f1:	4c 8d 35 83 0d 00 00 	lea    r14,[rip+0xd83]        # 227b <_IO_stdin_used+0x27b>
    14f8:	48 8d 6c 24 10       	lea    rbp,[rsp+0x10]
    14fd:	4c 8d 25 0c 2b 00 00 	lea    r12,[rip+0x2b0c]        # 4010 <help_msg>
    1504:	4c 8d 2d f9 0a 00 00 	lea    r13,[rip+0xaf9]        # 2004 <_IO_stdin_used+0x4>
    150b:	eb 25                	jmp    1532 <real_main+0x82>
    150d:	0f 1f 00             	nop    DWORD PTR [rax]
    1510:	e8 fb fe ff ff       	call   1410 <load_real>
    1515:	be 20 00 00 00       	mov    esi,0x20
    151a:	48 89 ef             	mov    rdi,rbp
    151d:	e8 de fb ff ff       	call   1100 <explicit_bzero@plt>
    1522:	48 8b 3b             	mov    rdi,QWORD PTR [rbx]
    1525:	e8 96 fb ff ff       	call   10c0 <feof@plt>
    152a:	85 c0                	test   eax,eax
    152c:	0f 85 0d 01 00 00    	jne    163f <real_main+0x18f>
    1532:	4c 89 f7             	mov    rdi,r14
    1535:	e8 06 fb ff ff       	call   1040 <puts@plt>
    153a:	48 8b 13             	mov    rdx,QWORD PTR [rbx]
    153d:	48 89 ef             	mov    rdi,rbp
    1540:	be 1f 00 00 00       	mov    esi,0x1f
    1545:	e8 46 fb ff ff       	call   1090 <fgets@plt>
    154a:	48 85 c0             	test   rax,rax
    154d:	0f 84 e4 00 00 00    	je     1637 <real_main+0x187>
    1553:	0f be 44 24 10       	movsx  eax,BYTE PTR [rsp+0x10]
    1558:	c7 44 24 04 00 00 00 	mov    DWORD PTR [rsp+0x4],0x0
    155f:	00 
    1560:	83 c0 94             	add    eax,0xffffff94
    1563:	83 f8 07             	cmp    eax,0x7
    1566:	77 51                	ja     15b9 <real_main+0x109>
    1568:	49 63 44 85 00       	movsxd rax,DWORD PTR [r13+rax*4+0x0]
    156d:	4c 01 e8             	add    rax,r13
    1570:	ff e0                	jmp    rax
    1572:	48 8d 3d 12 0d 00 00 	lea    rdi,[rip+0xd12]        # 228b <_IO_stdin_used+0x28b>
    1579:	e8 c2 fa ff ff       	call   1040 <puts@plt>
    157e:	48 8d 3d 5c 0d 00 00 	lea    rdi,[rip+0xd5c]        # 22e1 <_IO_stdin_used+0x2e1>
    1585:	31 c0                	xor    eax,eax
    1587:	e8 e4 fa ff ff       	call   1070 <printf@plt>
    158c:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
    1593:	00 00 
    1595:	48 8d 3d 49 0d 00 00 	lea    rdi,[rip+0xd49]        # 22e5 <_IO_stdin_used+0x2e5>
    159c:	48 8d 74 24 08       	lea    rsi,[rsp+0x8]
    15a1:	31 c0                	xor    eax,eax
    15a3:	e8 48 fb ff ff       	call   10f0 <__isoc99_scanf@plt>
    15a8:	48 8b 3b             	mov    rdi,QWORD PTR [rbx]
    15ab:	e8 60 fb ff ff       	call   1110 <getc@plt>
    15b0:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
    15b5:	4d 8b 3c c4          	mov    r15,QWORD PTR [r12+rax*8]
    15b9:	4c 39 3d 50 2a 00 00 	cmp    QWORD PTR [rip+0x2a50],r15        # 4010 <help_msg>
    15c0:	74 68                	je     162a <real_main+0x17a>
    15c2:	49 89 dd             	mov    r13,rbx
    15c5:	4c 89 f3             	mov    rbx,r14
    15c8:	b1 01                	mov    cl,0x1
    15ca:	31 c0                	xor    eax,eax
    15cc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    15d0:	48 83 f8 01          	cmp    rax,0x1
    15d4:	74 21                	je     15f7 <real_main+0x147>
    15d6:	41 89 ce             	mov    r14d,ecx
    15d9:	48 8d 50 01          	lea    rdx,[rax+0x1]
    15dd:	31 c9                	xor    ecx,ecx
    15df:	4d 39 7c c4 08       	cmp    QWORD PTR [r12+rax*8+0x8],r15
    15e4:	48 89 d0             	mov    rax,rdx
    15e7:	75 e7                	jne    15d0 <real_main+0x120>
    15e9:	4c 89 ff             	mov    rdi,r15
    15ec:	e8 4f fa ff ff       	call   1040 <puts@plt>
    15f1:	41 f6 c6 01          	test   r14b,0x1
    15f5:	75 11                	jne    1608 <real_main+0x158>
    15f7:	48 8d 3d dd 0b 00 00 	lea    rdi,[rip+0xbdd]        # 21db <_IO_stdin_used+0x1db>
    15fe:	4c 89 fe             	mov    rsi,r15
    1601:	31 c0                	xor    eax,eax
    1603:	e8 68 fa ff ff       	call   1070 <printf@plt>
    1608:	49 89 de             	mov    r14,rbx
    160b:	4c 89 eb             	mov    rbx,r13
    160e:	4c 8d 2d ef 09 00 00 	lea    r13,[rip+0x9ef]        # 2004 <_IO_stdin_used+0x4>
    1615:	e9 fb fe ff ff       	jmp    1515 <real_main+0x65>
    161a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1620:	e8 db fc ff ff       	call   1300 <store_real>
    1625:	e9 eb fe ff ff       	jmp    1515 <real_main+0x65>
    162a:	4c 89 ff             	mov    rdi,r15
    162d:	e8 0e fa ff ff       	call   1040 <puts@plt>
    1632:	e9 de fe ff ff       	jmp    1515 <real_main+0x65>
    1637:	c7 44 24 04 01 00 00 	mov    DWORD PTR [rsp+0x4],0x1
    163e:	00 
    163f:	8b 44 24 04          	mov    eax,DWORD PTR [rsp+0x4]
    1643:	48 83 c4 38          	add    rsp,0x38
    1647:	5b                   	pop    rbx
    1648:	41 5c                	pop    r12
    164a:	41 5d                	pop    r13
    164c:	41 5e                	pop    r14
    164e:	41 5f                	pop    r15
    1650:	5d                   	pop    rbp
    1651:	c3                   	ret    
    1652:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    1659:	00 00 00 
    165c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001660 <main>:
    1660:	50                   	push   rax
    1661:	e8 4a fe ff ff       	call   14b0 <real_main>
    1666:	59                   	pop    rcx
    1667:	c3                   	ret    

Disassembly of section .fini:

0000000000001668 <_fini>:
    1668:	f3 0f 1e fa          	endbr64 
    166c:	48 83 ec 08          	sub    rsp,0x8
    1670:	48 83 c4 08          	add    rsp,0x8
    1674:	c3                   	ret    
