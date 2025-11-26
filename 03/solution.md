# Übungsblatt 3 - Praktische Übung Code-Reuse 1

## 1.1 Übernehmen Sie zuerst die Kontrolle über den Stack mit Hilfe der Buffer Overflow Schwachstelle Überschreiben Sie das Instruction Pointer Register (EIP bzw. RIP) mit einem kontrollierten Wert (z.B. 0x41414141). Welchen Input müssen Sie dazu verwenden? Wie lang ist dieser Input? Was sind hier die Unterschiede zwischen den 32- und 64-Bit Varianten?
Die Schwachstelle in bufovf.c ist in der Methode vuln, dass mit fgets() 1.024 Bytes in einen nur 128 Byte langen Buffer gelesen werden.

Der Input, um einen Buffer Overflow auszulösen lautet wie folgt:
Bei 32 Bit: `b"A"*128 + b"B"*4 + b"C"*8 + p32(<gewünschte Adresse als 32-Bit-Hex-Wert>)` (gesamt 140 Zeichen vor der modifizierten Return Address)
Bei 64 Bit: `b"A"*128 + b"B"*8 + p64(<gewünschte Adresse als 64-Bit-Hex-Wert>)` (gesamt 136 Zeichen vor der modifizierten Return Address)


## 1.2 32-Bit: Bauen Sie den Stack so auf, dass ein Return-into-libc Angriff zu Stande kommt. Verwenden Sie die system Funktion zum Erstellen einer Betriebssystem-Shell und verwenden Sie die exit Funktion, um das Programm danach sauber zu beenden. Als Parameter für system übergeben Sie den String, der den Pfad zur Shell enthält. Als Parameter für exit übergeben Sie den Status Code 0x42. Implementieren Sie den Angriff in exploit-32.py.

Der Stack wird wie folgt aussehen:
```
  4 Bytes: 1. Argument der exit-Funktion (Wert 0x42)
  4 Bytes: 1. Argument der system-Funktion (Addresse des Strings "/bin/sh")
  4 Bytes: Adresse zur 2. Funktion, die wir aufrufen möchten (exit)
  4 Bytes: Adresse zur 1. Funktion, die wir aufrufen möchten (system)
 12 Bytes: (Text, um die erste Return-Adresse zu erreichen)
128 Bytes: buffer
```

Somit ist der erforderliche Input, um den Return-into-libc-Angriff auszuführen:
`b"A"*128 + b"B"*4 + b"C"*8 + p32(system_addr) + p32(exit_addr) + p32(sh_string) + p32(0x42)`


## 1.3 64-Bit: Führen Sie den gleichen Angriff, wie in der vorhergehenden Aufgabe beschrieben, nun auf x86 64-Bit durch. Da hier die Parameter über Register übergeben werden, müssen Sie ROP Gadgets verwenden, um die Register zu setzten. Verwenden Sie die vorgegebenen ROP Gadgets und implementieren Sie den Angriff in exploit-64.py.
In x86-64 unter Linux werden die Parameter über die Register in folgender Reihenfolge übergeben: RDI, RSI, RDX, RCX, R8, R9. Aus diesem Grund wird wie folgt vorgegangen: 
1. Über Gadgets die Registerwerte so setzen: RDI=sh_string
2. system()-Funktion aufrufen
3. Über Gadgets die Registerwerte so setzen: RDI=0x42
4. exit()-Funktion aufrufen

Der Stack wird wie folgt aussehen:
```
  8 Bytes: Adresse der exit()-Funktion
  8 Bytes: 1. Argument der exit()-Funktion: Wert 0x42
  8 Bytes: Gadget 3 - POP RDI; RET
  8 Bytes: Adresse der system()-Funktion
  8 Bytes: 1. Argument der system()-Funktion: Adresse des "/bin/sh"-Strings
  8 Bytes: Gadget 3 - POP RDI; RET
  8 Bytes: Gadget 0 - RET (um das Alignment zu reparieren)
 12 Bytes: (Text, um die erste Return-Adresse zu erreichen)
128 Bytes: buffer
```

Somit ist der erforderliche Input, um den Return-into-libc-Angriff auszuführen:
`b"A"*128 + b"B"*8 + p64(g(0)) + p64(g(3)) + p64(sh_string) + p64(system_addr) + p64(g(3)) + p64(EXPECTED_EXIT_CODE) + p64(exit_addr)`

## 2.1 Identifizieren und erklären Sie die nötigen Gadgets, um die Parameter von open_file und head zu setzen. In welchen Registern werden welche Parameter übergeben und welche Gadgets verwenden Sie zum setzen der Parameter? Finden und erklären Sie die Gadgets, die es erlauben den Rückgabewert von open_file als 3. Parameter von head zu verwenden.

Um open_file auszuführen, müssen die Register vor dem Aufruf wie folgt gesetzt sein:
RDI = (Adresse zum String "./flag.txt")
RSI = String "r\0"
Der zurückgegebene File Descriptor ist in RAX.

Um head auszuführen, müssen die Register vor dem Aufruf wie folgt gesetzt sein:
RDI = (Pointer zu some_buffer, um dorthin die Inhalte aus der Datei zu schreiben und auszugeben)
RSI = 0xff (genauso lang wie some_buffer ist)
RDX = RAX aus der fopen-Funktion = der File Descriptor der soeben geöffneten Datei

Um das Programm sauber zu beenden, muss exit(0) aufgerufen werden. Hierfür muss dieses Register gesetzt sein:
RDI = 0


* Um RSI zu setzen, wird die ROP-Chain im Folgenden rückwärts konstruiert:
  * Das Gadget 5 ist das einzige Gadget, worin RSI beschrieben wird. Dieses erfordert allerdings, dass das Register RCX gesetzt ist. Allerdings wird RCX um den Wert, der in R8 steht, reduziert.
  * Im Gadget 8 werden sowohl RCX als auch R8 eingelesen. Damit der Wert in RCX, der in Gadget 5 nach RSI kopiert wird, gleich bleibt, muss R8 gleich 0 sein. 
Somit ist die ROP-Chain, um RSI zu setzen, wie folgt: G8 - (Wert für RSI) - 0 - G5

* Um RDI zu setzen, wird die ROP-Chain im Folgenden rückwärts konstruiert:
  * RDI wird als Zielregister in den Gadgets 6 und 12 benutzt. Gadget 6 setzt RDI auf 0, weil das Ergebnis der XOR-Verknüpfung zweier gleicher Werte immer 0 beträgt. Somit muss RDI in Gadget 12 über die Addition von RDX und RDI gesetzt werden. 
  * Da mit Gadget 6 RDI auf 0 gesetzt werden kann, ist es notwendig, dass das RDX-Register auf den später gewünschten Wert für RDI gesetzt wird. Hierfür wird das Gadget 9 verwendet, um den gewünschten konstanten Wert für RDI zu setzen.
Somit ist die ROP-Chain, um RDI zu setzen, wie folgt: G9 - (Wert für RDI) - G6 - G12


* Um RAX nach RDX zu verschieben, ist es notwendig zu prüfen, welche Gadgets RDX modifizieren. Hierfür wird in zwei Teilen vorgegangen. Zuerst wird rückwärts vorgegangen, um zu bestimmen, welche Register als Zwischenschritt gesetzt werden müssen, bevor RDX gesetzt werden kann.
  * Die Gadgets 13, 11 und 9 modifizieren RDX direkt: Gadget 13 negiert RDX, Gadget 11 nimmt einen Wert aus dem Stack nach RDX und Gadget 9 lädt den Wert an der Speicherstelle, wo RCX hin zeigt, nach RDX. Da Gadget 9 als einziges Gadget aus dem Speicher Werte in RDX lädt, wird dieses Gadget in der ROP-Chain benötigt. Da die Adresse, auf die RCX hinzeigte, bereits nach RDX dereferenziert wurde, kann für POP RCX ein beliebiger Wert vom Stack verwendet werden.
  * Weil Gadget 11 aus RCX liest und daraus die einzulesende Speicheradresse ableitet, muss RCX gesetzt werden. Hierfür stehen die Gadgets 8, 5 und 2 zur Verfügung. In Gadget 2 wird RAX mit XOR RAX, RAX auf 0 gesetzt, bevor mit MOV RAX, QWORD PTR \[RAX\] die Speicherstelle, auf die RAX zeigt, dereferenziert wird. Gadget 2 scheidet aus, da der NULL-Pointer dereferenziert wird, was immer zu einem Segmentation Fault führt. Gadget 5 scheidet aus, da es als Seiteneffekt das RSI-Register, was zuvor gesetzt wurde, modifiziert. Somit bleibt Gadget 8 übrig, um RCX einzulesen. Da auch R8 eingelesen wird, aber R8 nicht benötigt wird, kann R8 auf einen beliebigen Wert gesetzt werden. Als Wert für RCX wird some_buffer_addr gewählt, da dies ein Symbol eines bekannten, beschreibbaren Datenbereichs (globaler Buffer) ist.
Nun ist das Teilziel, den Wert aus RAX an den Beginn von some_buffer_addr zu kopieren. Hierfür gehen wir von Anfang an vorwärts vor, bis der Beginn des 1. Teils erreicht ist.
  * Die Adresse some_buffer_addr wird auch am Anfang gewählt, um den Wert aus RAX zwischenzuspeichern. Gadget 1 ist das einzige Gadget, welches den Wert aus RAX in ein anderes Register oder in einen Speicherbereich schreibt. Deswegen wird ganz am Anfang Gadget 1 genutzt, um den Wert aus RAX zunächst in R9 zwischenzuspeichern. Hierbei werden allerdings nach dem Kopiervorgang in R9 alle Bits negiert. 
  * R9 wird in den Gadgets 0, 3 und 14 als Quellregister für Kopieroperationen benutzt, wobe  in Gadgets 0 und 14 die Register RAX bzw. RDI mit R9 XOR-verknüpft werden. Dies ist weniger zielführend, weil der Wert aus RAX verloren geht bzw. der bereits gesetzte Wert in RDI zerstört wird. Das Gadget 3 kopiert den Wert aus R9 direkt an die Speicheradresse, wo RDX hinzeigt.
  * Um dafür zu sorgen, dass das Gadget 3 den Wert aus R9 (negierter RAX-Wert) entspricht, nach some_buffer_addr kopiert, wird vorher als Zwischenschritt mit Gadget 9 RDX auf die Adresse von some_buffer_addr gesetzt.
Jetzt verknüpfen wir die beiden Teile:
  * Da der negierte Wert aus RAX nun an some_buffer_addr vorliegt, funktioniert es, dass RCX auf some_buffer_addr gesetzt wird. Somit kann dann durch Gadget 11 der zwischengespeicherte negierte RAX-Wert an der Adresse some_buffer_addr nach RDX geladen werden.
  * Als letzten Schritt wird Gadget 13 genutzt, um in RDX den negierten Wert von RAX wieder zurückzugenieren.
Somit ist die ROP-Chain, um MOV RDX, RAX zu simulieren: G1 - G9 - some_buffer_addr - G3 - G8 - some_buffer_addr - (beliebiger Dummy-Wert) - G11 - (beliebiger Dummy-Wert) - G13


## 2.2 Erweitern Sie exploit.py zu einem funktionsfähigen Exploit. Der Exploit soll zuerst open_file mit den richtigen Parametern aufrufen, um die Datei flag.txt zu öffnen. Verwenden Sie danach die Funktion head, um die Datei auszugeben.
Die Gesamt-ROP-Chain ist wie folgt (s. exploit.py):
MOV RDI, flag_path_addr <=> G9 - flag_path_addr - G6 - G12
MOV RSI, readonly_mode_addr <=> G8 - readonly_mode_addr - 0 - G5
CALL open_file <=> open_file_function_addr
MOV RDI, some_buffer_addr <=> G9 - some_buffer_addr - G6 - G12
MOV RSI, 200 <=> G8 - 200 - 0 - G5
MOV RDX, RAX <=> G1 - G9 - some_buffer_addr - G3 - G8 - some_buffer_addr - (beliebiger Dummy-Wert) - G11 - (beliebiger Dummy-Wert) - G13
CALL head <=> head_function_addr
MOV RDI, 0 <=> G6
CALL exit <=> exit_function_addr

## 3.1 Überschreiben Sie die Return-Adresse zuerst mit dem Wert 0x4141414141414141, um zu demonstrieren, dass Sie den Instruction Pointer übernehmen können. Wo im Programm ist die Schwachstelle? Welchen Input müssen Sie dem Programm schicken? Wie lang ist der Input?
Im Programm ist die Schwachstelle in Z. 23. Dort werden 512 Zeichen in einen 32 Zeichen langen Buffer eingelesen. Um den Instruction-Pointer zu überschreiben, müssen 64 Bytes eingegeben werden, wovon die letzten 8 Bytes "A"-Bytes sein müssen, um die Return-Adresse auf 0x4141414141414141 setzen zu können.


## 3.2 Identifizieren Sie mögliche Gadgets, die Sie für die ROP-Chain nutzen können. Suchen Sie an den im Exploit-Template vorgegebenen Adressen nach möglichen Gadgets. Implementieren Sie dazu einen einfachen ROP-Gadget-Finder. Untersuchen Sie dazu den Assembler Code im Bereich des Symbols gadgets und der Funktion compute (dies ist im exploit.py Template bereits vorgegeben).

Im Bereich des Symbols `gadgets` bis `gadget_end` wurden folgende Gadgets gefunden:
```
Gadget 0:
0x00401166:     48 31 db   xor  rbx,  rbx
0x00401169:     c3         ret
Gadget 1:
0x00401174:     5f   pop        rdi
0x00401175:     c3   ret
Gadget 2:
0x00401180:     5a   pop        rdx
0x00401181:     c3   ret
Gadget 3:
0x0040118c:     48 8b 4c 24 f0   mov    rcx,  qword ptr [rsp - 0x10]
0x00401191:     c3               ret
Gadget 4:
0x0040119c:     41 58   pop     r8
0x0040119e:     41 59   pop     r9
0x004011a0:     c3      ret
Gadget 5:
0x004011ab:     48 31 c0   xor  rax,  rax
0x004011ae:     c3         ret
Gadget 6:
0x004011b9:     8b 04 25 48 89 c8 00   mov      eax,  dword ptr [0xc88948]
0x004011c0:     c3                     ret
Gadget 7:
0x004011c1:     c3   ret
Gadget 8:
0x004011cc:     48 85 c0   test rax,  rax
0x004011cf:     c3         ret
Gadget 9:
0x004011da:     5e   pop        rsi
0x004011db:     c3   ret
```

## 3.3 Welche der Gadgets können Sie verwenden, um die benötigten Register für den Systemcall execve zu setzen?
Um den Syscall für execve zu setzen, müssen die Register wie folgt gesetzt sein:
RAX = 59
RDI = Pointer zum Programmnamen 
RSI = Pointer zu den Argumenten
RDX = Pointer zu den Umgebungsvariablen 

* Um RAX zu setzen, kann mit Gadget 6 das Register RAX auf 0 gesetzt werden und in die unteren 32 Bit von RAX der Wert 59  aus der Speicheradresse 0xc88948 geschrieben werden.
* Um RDI zu setzen, kann Gadget 1 direkt verwendet werden.
* Um RSI zu setzen, kann Gadget 9 direkt verwendet werden. 
* Um RDX zu setzen, kann Gadget 2 direkt verwendet werden.

## 3.4 Erklären Sie „Unintended Instruction Sequences“ im Kontext von ROP auf x86. Eine solche Sequenz befindet sich unter den gegebenen ROP-Gadgets und enthält ein Gadget, welches Sie für einen erfolgreichen Angriff benötigen. Beschreiben Sie: • Welches Gadget haben Sie gefunden? • Warum ist das gefundene Gadget eine unintended instruction sequence? • Wie haben Sie es gefunden?

In Intel x86-64 kann jedes Byte direkt adressiert werden. Wird der Bytestream nicht vom vorgesehenen Beginn an gelesen, können durch die Byte-Verschiebungen zufällig andere Instruktionen als vorgesehen entstehen. Dies eröffnet mehr Möglichkeiten, ROP-Angriffe durchzuführen, da mehr mögliche Gadgets zur Verfügung stehen und man mit den zusätzlichen Gadgets wahrscheinlicher die Turing-Vollständigkeit erreicht. Liest man auf normale Weise rückwärts von allen RET-Instruktionen und disasssembliert, scheinen Gadget 6 und 7, die im Speicher hintereinander liegen, zusammen wie folgt auszusehen:

```
Gadget 6:
0x004011b9:     8b 04 25 48 89 c8 00   mov      eax,  dword ptr [0xc88948]
0x004011c0:     c3                     ret
Gadget 7:
0x004011c1:     c3   ret
```

Da eine absolute Speicheradresse gelesen wird, die durch die anderen Gadgets nicht adressiert wird, kam der Verdacht auf, dass eine unintended Instruction Sequence vorliegt. Indem nach und nach von links die Bytes aus Gadget 6 entfernt wurden, wurden die entstehenden Instruktionsfolgen betrachtet. Beginnt man 3 Bytes nach dem scheinbaren Beginn des Gadget 6 zu disassemblieren, entsteht stattdessen diese Instruktionsfolge für Gadget 6 (nun Gadget 6N, N=Neu):
```
Gadget 6N:
0x004011bc:     48 89 c8   mov  rax,  rcx
0x004011bf:     00 c3      add  bl,  al
0x004011c1:     c3         ret
```

Gadget 3, wo auf einen Wert 16 Bytes unter dem Stack-Pointer zugegriffen wird, kann verwendet werden, um das Register RCX zu setzen, um dann in Gadget 6N den Wert aus RCX nach RAX zu übernehmen. Gadget 7 an Adresse 0x4011c1 kann weiterhin als NOP-Gadget verwendet werden, da dieses Gadget nur aus dem Byte für die RET-Instruktion besteht.


## 3.5 Finden Sie eine Möglichkeit, um einen Systemcall als Teil Ihres ROP-Angriffes auszuführen. Welche Instruktion(en) bzw. ROP-Gadgets können Sie verwenden, um den Systemcall durchzuführen? Erklären Sie den Assembler Code und den Zweck der Gadgets.
In x86-64 entspricht die Instruktion `SYSCALL` den Bytes `0f 05`. Da es kein Gadget (inkl. Gadget 6N) gibt, worin ein Syscall ausgeführt wird, muss im .text-Bereich relativ zu einem Funktionssymbol die Byte-Folge `0f 05` gefunden werden. Auch wenn ASLR aktiviert ist, randomisieren sich nur die Startadressen der Funktionen im .text-Bereich, der relative Abstand zwischen Instruktion in einer Funktion zum Funktionsanfang bleibt jedoch gleich. In der Compute-Funktion existiert eine Bytefolge `0f 05` am 45. und 46. Byte innerhalb der Funktion.

## 3.6 Vervollständigen Sie exploit.py zu einem funktionsfähigen Exploit, der mit ROP eine Shell mittels des execve Systemcalls startet.
Wir benötigen:
RAX = 59
RDI = (Ptr -> "/bin/sh")
RSI = (Ptr -> {Ptr -> "/bin/sh", NULL})
RDX = NULL

* Um RAX zu setzen, kann Gadget 6N verwendet werden, welches den Wert aus RCX in RAX einliest. Um RCX zu setzen, muss über Gadget 3 stackpointer-relativ die Zahl 59 gesetzt werden. Die Zahl 59 wurde kurz vor der ROP-Chain im Buffer-Overflow geschrieben, damit die anderen Register ungestört befüllt werden können.
* RDI kann über Gadget 1 direkt gesetzt werden. Direkt über dem Gadget wird der Pointer auf "/bin/sh" geschrieben. Die Adresse des Pointers wird relativ zur geleakten Stack-Adresse bestimmt.
* RSI kann über Gadget 9 direkt gesetzt werden. Direkt über dem Gadget wird der Pointer auf einen Array von Pointern geschrieben. Der Pointer-Array besteht aus dem Pointer zu "/bin/sh" und aus dem NULL-Pointer, welche im Speicher direkt hintereinander liegen müssen. Die Adresse des Pointers zum Pointer-Array wird ebenfalls relativ zur geleakten Stack-Adresse bestimmt.
* RDX kann über Gadget 2 direkt auf 0 gesetzt werden, da wenn keine Umgebungsvariablen übergeben werden, für RDX der NULL-Pointer übergeben werden muss.
* Sobald die Register für den Syscall gesetzt sind, wird der Syscall ausgeführt. Da beim execve-Syscall ein neues Programm ausgeführt wird, werden im Gadget 10 die Instruktionen nach dem Syscall nicht mehr ausgeführt.
* In den höheren Adressen der ROP-Chain befindet sich der Datenbereich. Dort ist der String "/bin/sh" für RDI und der Pointer-Array {Ptr -> "/bin/sh", NULL} für RSI enthalten.
