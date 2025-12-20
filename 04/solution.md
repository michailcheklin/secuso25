## Übungsblatt 4 - Praktische Übung Randomisation

## 1.1 Wo befindet sich die Buffer Overflow Schwachstelle in diesem Programm? Als Teil eines Arbitrary Read muss immer ein Pointer manipuliert werden. • Welchen Pointer können Sie überschreiben? • Wo und wie wird dieser Pointer später verwendet? • Wie erhalten Sie dadurch einen Arbitrary Read ? • Wie viele Daten können Sie dann damit lesen?
Die Buffer-Overflow-Schwachstelle ist in `if (fgets(*data->ptr, 48, stdin) == NULL)` (ar.c, Z. 51). Dort werden 48 Bytes in data.ptr über `stdin` gelesen. `data->ptr` ist ein doppelter Pointer, und somit ist `*data->ptr` wegen `*dp->ptr = dp->buf;` (ar.c, Z. 26) immer ein einfacher Pointer auf `data->buf`. Der Datenbereich, auf den `data->ptr`, wenn es vollständig dereferenziert wurde, im Struct zeigt, nur 28 Bytes lang, wodurch über die eigentlichen Grenzen `data->buf` um 20 Bytes hinausgeschrieben werden kann.

Auch wenn ASLR aktiviert ist, ergibt `(long)(&data->buf) - (long)(&data->ptr)` in jedem Durchlauf -32. Daraus folgt, dass `data->buf` im Speicher immer 32 Bytes vor `data->ptr` liegt. Somit kann der doppelte Pointer `data->ptr` überschrieben werden. Der Speicher sieht, relativ zu P = Position von `data->ptr` so aus:

```
P-0x20: data->buf [0...7]
P-0x18: data->buf [8...15]
P-0x10: data->buf [16...23]
P-0x08: data->buf [24...27] + 4 Bytes Padding, um das 8-Byte-Alignment in x64 zu erfüllen 
P+0x00: data->ptr (Pointer zu P+0x10)
P+0x08: p64(0x21)
P+0x10: (Pointer zu P-0x20 = data->buf[0])
```
Im Normalfall zeigt der doppelte Pointer `data->ptr` wegen `dp->ptr = malloc(sizeof(char *));` (ar.c, Z. 22) auf einen einfachen Pointer, der wegen `dp->ptr = malloc(sizeof(char *));` (ar.c, Z. 26) wiederum auf den Anfang von `dp->buf` zeigt. 

Da wegen `if (fgets(*data->ptr, 48, stdin) == NULL)` (ar.c, Z. 51) 48 Bytes beschrieben werden, sind die Bytes im Bereich von P-0x18 bis P+0x08 über den Buffer-Overflow erreichbar. Da der einfache Pointer zu data->buf[0] nach dem vom Buffer-Overflow betroffenen Bereich liegt, kann dieser nicht direkt überschrieben werden. 

Um dieses Problem zu lösen, wird der doppelte Pointer bei `data->ptr` manipuliert, indem in der Eingabe nach den 32 Bytes, um den eigentlichen Buffer zu füllen, eine 64-Bit-Repräsentation der Adresse des Beginns von `data->buf` übermittelt wird. Da die Position von `data->ptr` bekannt ist, und diese immer 32 Bytes nach `data->buf` ist, kann trotz ASLR die Adresse des Beginns von `data->buf` berechnet werden. Da wegen des doppelten Pointers an `data->ptr` am Anfang von `data->buf` ein einfacher Pointer erwartet wird der in `puts(*data->ptr);` (ar.c, Z. 54) dereferenziert wird, werden die ersten 8 Bytes der Eingabe auf die 64-Bit-Repräsentation der Adresse des Symbols `flag` gesetzt, wo der gewünschte Text liegt. Durch die im Quellcode definierte Länge des globalen `flag`-Strings können so 64 Bytes an Daten gelesen werden (`#define FLAG_BUFFER_SIZE 0x40 [...] char flag[FLAG_BUFFER_SIZE] = {0};`, ar.c, Z. 7-10).

## 1.2 Erweitern Sie das Exploit-Template zu einem funktionierenden Exploit. Überschreiben Sie den Poin- ter so, dass das Programm den Inhalt des Strings flag ausgibt.
Der Payload lautet nach dem in Aufg. 1.1. aufgestellten Plan wie folgt:
`p64(flag_addr) + (24 Bytes Dummy-Daten) + p64(location_of_pointer_data_ptr_itself-32)`. Die Dummy-Daten dürfen keinesfalls ein \0-Byte oder einen Zeilenumbruch enthalten, weil fgets() sonst vorzeitig aufhört, die Eingabe einzulesen.


## 2.1 Finden Sie eine Möglichkeit ASLR zu umgehen. Identifizieren Sie dazu einen Information Leak Bug, mit dem es möglich ist, Adressen auszulesen. Erklären Sie den Bug und wie Sie ihn dazu nutzen können, um die Adressen der Gadgets zu berechnen.
In der Methode `print_help` (getreal3.c, Z. 38 ff.) wird die Adresse, auf die der Pointer `help` zeigt, als Hexadezimalwert ausgegeben. Zeigt ``help` nicht auf einen der beiden Pointer, die im Array `help_message` liegen, erfolgt statt der Ausgabe des Hilfetextes die Adresse, worauf `help` zeigt. Die Methode `print_help` wird genau dann aufgerufen, wenn nach der Abfrage des gewünschten Befehls (getreal3.c, Z. 95 ff.) weder p noch q noch r eingetippt wurde. 

Wurde hingegen l eingetippt, wird der aktuelle Hilfstext auf `help_message[i]` gesetzt. Da in C keine Arraygrenzenprüfung durchgeführt wird, kann so der Pointer auch auf `help_message[-1]` gesetzt werden, wo sich ein Pointer befindet, der auf sich selbst zeigt und relativ zum Beginn der .data-Section der Binary immer die gleiche Distanz hat. Auch wenn PIE und ASLR aktiviert sind, werden die Abstände zum Beginn der Binary nicht randomisiert, wodurch die Adressen der Symbole durch Nutzung der geleakten Adresse von `help_message[-1]` auch zur Laufzeit berechnet werden können. Somit stehen alle Symbole aus der Binary selbst für mögliche ROP-Angriffe zur Verfügung. 

An den Symbolen wie `got.puts` sind Pointer zu der jeweils entsprechenden Funktion aus libc gespeichert. Da die Symbole in der Binary liegen, können deren Positionen auch berechnet werden. Mit dem Abstand zwischen den Symbolen zu `help_msg` kann, nach Eingabe von l als gewünschten Befehl, der Pointer `help` auf eine beliebige Stelle im Binary gesetzt werden. Die benötigte Zahl ist 1/8 des Abstands zwischen `help_msg`, was ein Array vom Typ `char*` ist, und der gewünschten zu leakenden Stelle der Binary, da die Array-Indizierung `help_msg[i]` von der Adresse her `array[0] + 8*i` ist und Pointer auf x64 immer 8 Bytes groß sind. So kann die Adresse einer libc-Funktion geleakt werden, da jede libc-Funktion relativ zum Beginn von libc bei jeder Ausführung den gleichen Abstand hat.

Mit dem Terminal-Befehl `readelf -s --wide /usr/lib/x86_64-linux-gnu/libc.so.6 | grep "FUNC *GLOBAL *DEFAULT" >> libc_function_list.txt` kann die Liste aller libc-Funktionen, die von außerhalb von libc aufgerufen werden können in einer Textdatei gespeichert werden. Die zweite Spalte der so entstandenen Textdatei zeigt als Hexadezimalzahl den Abstand der jeweiligen Funktion zum Beginn von libc an, beispielsweise liegt der Beginn der Funktion `puts` 0x80E50 (dezimal 527952) Bytes nach dem Beginn von libc (s. auch /2_piereal/notes/libc_function_list.txt Z. 998). Mit dem gefundenen Offset lässt sich die Startadresse von libc immer ausrechnen, obwohl PIE und ASLR aktiviert sind.


## 2.2 Identifizieren nützliche ROP-Gadgets z. B. in dem Programm oder der libc. Erklären Sie welche ROP-Gadgets Sie verwendet haben.
Da unabhängig von PIE und ASLR die Startadressen der Binary und von libc geleakt werden, steht die gesamte Binary sowie libc zur Findung von Gadgets zur Verfügung. Da DEP/NX auch aktiviert ist, beschränkt sich die Suche von Gadgets auf die ausführbaren Bereiche der Binary und libc:
* BEGIN_OF_BINARY + 0x1000 bis BEGIN_OF_BINARY + 0x1FFF
* BEGIN_OF_LIBC + 0x28000 bis BEGIN_OF_LIBC + 0x1BCFFF
Um den Inhalt von secret.log auszugeben, wird so in der ROP-Chain vorgegangen: Mit Gadgets aus der Binary werden die Register passend gesetzt, um die libc-Funktionen aufzurufen.

Der ausführbare Teil des Binary wird aufgeteilt in Bereiche, die mit einem C3-Byte enden. C3 ist unter x64 der Opcode für RET. Von allen RET-Instruktionen werden alle möglichen ROP-Gadgets rückwärts disassembliert. Erst wird nur das RET disassembliert, dann werden solange von links Bytes zum Disassemblieren hinzugefügt, bis das vorige RET oder der Beginn des ausführbaren Teils des Binarys erreicht ist. Unter allen Kandidaten von ROP-Gadgets werden diejenigen rausgefiltert, die länger als 25 Bytes sind. Dies hängt damit zusammen, dass ROP-Gadgets i. A. kurz sind. Außerdem werden die Gadget-Kandidaten herausgefiltert, deren Disassembly nicht mit einer RET-Instruktion endet, sondern das C3-Byte am Ende als Teil einer anderen Instruktion interpretiert worden wären. Das Ergebnis ist in `./notes/possible_rop_gadgets.txt` vermerkt, erwähnenswerte Kandidaten sind (Adressen sind relativ zum Beginn der Binary bzw. libc):

Aus der Binary
```
Von 0x1286 bis 0x1287
2 Bytes vom RET entfernt
0x00001286:	5e                              pop	rsi
0x00001287:	c3                              ret	

Von 0x12f0 bis 0x12f1
2 Bytes vom RET entfernt
0x000012f0:	5b                              pop	rbx
0x000012f1:	c3                              ret	

Von 0x1666 bis 0x1667
2 Bytes vom RET entfernt
0x00001666:	59                              pop	rcx
0x00001667:	c3                              ret	
```

Aus libc:
```
Von 0x4dd53 bis 0x4dd54
2 Bytes vom RET entfernt
0x0004dd53:	5f                              pop	rdi
0x0004dd54:	c3                              ret	

Von 0x904a8 bis 0x904ab
4 Bytes vom RET entfernt
0x000904a8:	58                              pop	rax
0x000904a9:	5a                              pop	rdx
0x000904aa:	5b                              pop	rbx
0x000904ab:	c3                              ret	

Von 0xf0e5c bis 0xf0e64
9 Bytes vom RET entfernt
0x000f0e5c:	41 5c                           pop	r12
0x000f0e5e:	41 5d                           pop	r13
0x000f0e60:	41 5e                           pop	r14
0x000f0e62:	41 5f                           pop	r15
0x000f0e64:	c3                              ret	

Von 0x121e0a bis 0x121e11
8 Bytes vom RET entfernt
0x00121e0a:	49 89 d8                        mov	r8, rbx
0x00121e0d:	4c 89 c0                        mov	rax, r8
0x00121e10:	5b                              pop	rbx
0x00121e11:	c3                              ret	

Von 0x779b3 bis 0x779bf
13 Bytes vom RET entfernt
0x000779b3:	49 89 c1                        mov	r9, rax
0x000779b6:	41 5c                           pop	r12
0x000779b8:	41 5d                           pop	r13
0x000779ba:	4c 89 c8                        mov	rax, r9
0x000779bd:	41 5e                           pop	r14
0x000779bf:	c3                              ret	
```


In der Methode `load_real` (getreal3.c, Z. 77 ff.) wird in den 64 Byte großen Buffer `password` mit `fgets(buf, 640, stdin)` vom Benutzer eine bis zu 640 Byte lange Eingabe eingelesen. Da das Passwort höchstwahrscheinlich falsch sein wird, gelangt das Programm zur Anweisung `printf("ACCESS DENIED: your input:\n%s", buf);` (getreal3.c, Z. 77 ff.). Die `printf()`-Funktion reagiert auf `%s` wie folgt: Es beginnt am Beginn von buf zu lesen, bis ein \0-Byte kommt. Wenn die ersten 64 Bytes kein \0-Byte enthalten, so können weitere Bytes bis zum ersten \0-Byte aus dem Speicher gelesen werden.
