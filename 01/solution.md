# 1 Hello World-Assembler-Programm

## 1.1 Disassemblieren Sie die Routine _start in hello-x86 und erklären Sie kurz jede Instruktion.
```sh
pwndbg> disassemble /r _start
Dump of assembler code for function _start:
   0x08049000 <+0>:	    b8 04 00 00 00      mov    eax,0x4
    Zuerst wird die Zahl 0x4 in das Register EAX geschrieben.

   0x08049005 <+5>:	    bb 01 00 00 00      mov    ebx,0x1
    Danach wird die Zahl 0x1 in das Register EBX geschrieben

   0x0804900a <+10>:	b9 1f 90 04 08      mov    ecx,0x804901f
    Dann wird die Zahl 0x804901f in das Register ECX geschrieben

   0x0804900f <+15>:	ba 0d 00 00 00      mov    edx,0xd
    Anschließend wird die Zahl 0xd in das Register EDX geschrieben.

   0x08049014 <+20>:	cd 80               int    0x80
    Nach dem Beschreiben der Register EAX bis EDX wird ein System-Call mit den Werten aus EAX bis EDX ausgeführt.

   0x08049016 <+22>:	b8 01 00 00 00      mov    eax,0x1
    Hier wird das Register EAX mit der Zahl 0x1 beschrieben.

   0x0804901b <+27>:	31 db               xor    ebx,ebx
    An dieser Stelle wird das Register EBX auf 0 gesetzt. Die XOR-Operation einer Zahl mit sich selbst ergibt immer 0, weil beide Operanden des XOR-Operators die gleiche Bitfolge haben.

   0x0804901d <+29>:	cd 80               int    0x80
    Nun wird erneut ein System-Call basierend auf den aktuellen Werten der Register EAX bis EDX ausgeführt.

   0x0804901f <+31>:	48                  dec    eax
    Der Wert im Register EAX wird um 1 reduziert.

   0x08049020 <+32>:	65 6c               gs ins BYTE PTR es:[edi],dx
   0x08049022 <+34>:	6c                  ins    BYTE PTR es:[edi],dx
   0x08049023 <+35>:	6f                  outs   dx,DWORD PTR ds:[esi]
   0x08049024 <+36>:	20 57 6f            and    BYTE PTR [edi+0x6f],dl
    Hier werden die untersten 8 Bits des EDX-Registers mit dem Byte-Wert, der 0x6f Bytes nach dem aktuellen Ort des Ziels der vorhergehenden Position steht
   0x08049027 <+39>:	72 6c               jb     0x8049095
    Springe zur Adresse 0x8049095 sofern das Carry-Flag gesetzt ist
   0x08049029 <+41>:	64 21 0a            and    DWORD PTR fs:[edx],ecx
    An dieser Stelle wird der Wert des ECX-Registers mit dem Wert aus den 
   0x0804902c <+44>:	00                  .byte 0x0
    Hier wird das Byte 0x00 als fester Wert definiert (evtl. String-Terminator).
End of assembler dump.
```
## 1.2 Debuggen Sie das Programm hello-x86 mit dem Debugger gdb und bestimmen Sie die tatsächlichen Werte und Adressen in den Registern jeweils bevor die int 0x80 Instruktion ausgeführt wird. Erklären Sie die Bedeutung der verschiedenen Register.

Kurz vor dem ersten System Call (INT 0x80) sind die Register lt. `gdb` wie folgt belegt:
 EAX  0x4
 EBX  0x1
 ECX  0x804901f (_start+31) ◂— dec    eax /* 'Hello World!\n' */
 EDX  0xd
 EDI  0x0
 ESI  0x0
 EBP  0x0
 ESP  0xffffd1f0 ◂— 0x1
 EIP  0x8049014 (_start+20) ◂— int    0x80
Nach System Call-Tabelle in Anhang A werden die 13 (dezimaler Wert von EDX) Zeichen ab der Speicheradresse 0x804901f (Wert von ECX) nach `stdout` (Wert von EBX = 0x1 => file descriptor von `stdout`) geschrieben (Wert von EAX = 0x4 => Schreiboperation). Somit erscheint auf der Konsole der Text "Hello World" gefolgt von einem Zeilenumbruch.

Kurz vor dem zweiten System Call sind die Register lt. `gdb` wie folgt belegt:
 EAX  0x1
 EBX  0x0
 ECX  0x804901f (_start+31) ◂— dec    eax /* 'Hello World!\n' */
 EDX  0xd
 EDI  0x0
 ESI  0x0
 EBP  0x0
 ESP  0xffffd1f0 ◂— 0x1
 EIP  0x804901d (_start+29) ◂— int    0x80
Nach System Call-Tabelle wird das Programm beendet, da bei diesem System Call der Wert von EAX 0x1 beträgt. Der Exit-Status ist entsprechend des Werts im Register EBX gleich 0, also terminierte das Programm erfolgreich.

Daraus folgt, dass alle Assembly-Instruktionen nach der Adresse 0x0804901d (s. Aufg. 1.1), wo der 2. System Call war, nur das Ergebnis dessen sind, dass Daten fälschlich als Instruktionen interpretiert wurden.

## 1.3 Wie funktionieren Linux System-Calls auf x86 32-Bit? Wie werden Parameter übergeben? Wie wird der Rückgabewert übergeben?
Linux System-Calls werden dann ausgeführt, wenn im Assembler-Code INT 0x80 ausgeführt wird. In diesem Moment werden die Werte aus allen Registern gelesen. Der Wert von EAX definiert die Art der Aktion nach System Call-Tabelle (z. B. Programm starten/beenden, Datei schreiben/lesen/löschen) und die Werte der anderen Register (EBX, ECX, EDX, ESI, EDI) definieren die Argumente, die übergeben werden. Der Rückgabewert wird nach dem System Call in das Register EAX geschrieben.


## 2.1 Finden Sie heraus, wie auf x86 Parameter übergeben werden (cdecl Calling Conventions) und wie die Funktion read auf die übergebenen Parameter zugreifen kann:
Die Register und der Stack sind am Breakpoint `read`wie folgt belegt:
```sh
pwndbg> regs
 EAX  0xffffd1ac ◂— 0x0
 EBX  0x0
 ECX  0x0
 EDX  0xffffd1ac ◂— 0x0
 EDI  0x0
 ESI  0x0
 EBP  0xffffd1ec ◂— 0x0
 ESP  0xffffd190 —▸ 0x804904e (_start+78) ◂— xor    eax, eax
 EIP  0x804909e (read) ◂— ud2    
pwndbg> stack
00:0000│ esp     0xffffd190 —▸ 0x804904e (_start+78) ◂— xor    eax, eax
01:0004│         0xffffd194 ◂— 0x0
02:0008│         0xffffd198 —▸ 0xffffd1ac ◂— 0x0
03:000c│         0xffffd19c ◂— 0x30 /* '0' */
04:0010│         0xffffd1a0 ◂— 0x0
... ↓            3 skipped
pwndbg> 
```

Die cdecl-Calling Convention besagt, dass die Funktionsargumente zunächst auf den Stack gepusht werden, bevor die Funktion aufgerufen wird. Die Funktion ruft die Werte vom Stack ab und danach wird die Funktion ausgeführt. Die Rückgabe wird am Ende in EAX geschrieben, und der Stack-Pointer wird wieder über die abgelegten Funktionsargumente geschoben.

## 2.2 Implementieren Sie die Funktionen read und write in der Datei lib.asm. Diese sollen sich äquivalent zu den Standard-C-Funktionen verhalten. Implementieren Sie die Funktionen als einfache Wrapper um die entsprechenden Linux x86 System Calls. Im Gegensatz zu den Standard C Funktionen müssen Sie kein Error-Handling implementieren.
s. `./2_mini_libc/lib.asm`

## 2.3 Wie werden Schleifen auf Assemblerebene implementiert? Analysieren Sie die memset Funktion und beschreiben Sie, wie die Schleife implementiert wurde. Nutzen Sie dafür auch die Graphansicht von Cutter.
Die Schleife in `memset` besteht aus 3 Teilen `memset_loop_check`, `memset_loop_body` und `memset_loop_end`:
```asm
;-- _memset_loop_check:
0x080490d4      cmp     ecx, dword [arg_ch]
0x080490d7      je      _memset_loop_end
;-- _memset_loop_body:
0x080490d9      mov     byte [edx + ecx], al
0x080490dc      inc     ecx
0x080490dd      jmp     _memset_loop_check
;-- _memset_loop_end:
0x080490df      mov     eax, dword [arg_4h]
0x080490e2      mov     esp, ebp
0x080490e4      pop     ebp
0x080490e5      ret
```
(Graph in `./loc_memset_graph.png`)

Zu Beginn wird `memset_loop_check` eine Subroutine zur Prüfung der Abbruchbedingung durchgeführt. Ist die Abbruchbedingung erfüllt, wird zum Ende der Schleife bei `memset_loop_end` gesprungen, wo die Subroutine verlassen wird. Ist die Abbruchbedingung noch nicht erfüllt, wird der Schleifenkörper in `memset_loop_end` ausgeführt. Am Ende des Schleifenkörpers wird durch Sprung nach `memset_loop_check` erneut die Abbruchbedingung geprüft.

## 2.4 C-Strings werden als char* dargestellt, also ein Pointer auf einen char (1 Byte). Erklären Sie, wie ein C-String im Speicher aussieht und wie die Länge eines C-Strings festgestellt werden kann. Implementieren Sie die strlen Funktion, welche die Länge eines C-Strings berechnet, in der Datei lib.asm Testen Sie die Implementierung mit make test. Die Implementierung muss alle der mitgelieferten Tests bestehen.
Im Speicher werden die Bytes des C-Strings gespeichert, wobei das Ende des Strings mit einem 0x00-Byte, dem String-Terminator markiert wird. Die Länge des Strings wird festgestellt, indem man ausgehend von der Speicheradresse des Strings die Anzahl der Bytes zählt, bis das nächste 0x00-Byte auftritt.

## 3.1 Erklären Sie, wie auf x86 64-Bit Parameter übergeben werden (cdecl Calling Conventions auf Linux).Erklären Sie auch, wie der Rückgabewert übergeben wird.
Finden Sie heraus wie viele Parameter an die Funktion explain_me übergeben werden und ob die
Funktion einen Rückgabewert hat. Beschreiben Sie ihr Vorgehen.