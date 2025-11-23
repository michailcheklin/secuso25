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


Um RSI zu setzen, wird die folgende ROP-Chain benötigt: Gadget 8 - (Wert für RSI) - 0 - Gadget 5 (einziges Gadget, das RSI modifiziert)
Um RDI zu setzen, wird die folgende ROP-Chain benötigt: Gadget 9 - (Wert für RDI) - Gadget 6 - Gadget 12
Um RAX nach RDX zu verschieben, ist es notwendig zu prüfen, welche Gadgets RDX modifizieren. Gadgets 13 und 9 modifizieren RDX direkt, Gadget 3 modifiziert die Adresse, an die RDX zeigt. RAX wird in Gadget 14 modifiziert; in Gadget 10 werden die unteren 32 Bits von RAX auf 0 gesetzt. Da die File Pointer niemals 32 Bits überschreiten, kann dies effektiv als das Rücksetzen von RAX auf 0 gesehen werden. Gadget 7 wird, obwohl EAX beteiligt ist, nicht benötigt, weil TEST RAX, RAX nur Statusflags setzt, die aber in keinem Gadget mit JNZ, JZ, ..., abgefragt werden. 