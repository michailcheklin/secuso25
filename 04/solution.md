# Übungsblatt 4 - Praktische Übung Randomisation
 
# 1 Arbitrary Read

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

# 2 Bypassing Full ASLR

## 2.1 Finden Sie eine Möglichkeit ASLR zu umgehen. Identifizieren Sie dazu einen Information Leak Bug, mit dem es möglich ist, Adressen auszulesen. Erklären Sie den Bug und wie Sie ihn dazu nutzen können, um die Adressen der Gadgets zu berechnen.
In der Methode `print_help` (getreal3.c, Z. 38 ff.) wird die Adresse, auf die der Pointer `help` zeigt, als Hexadezimalwert ausgegeben. Zeigt ``help` nicht auf einen der beiden Pointer, die im Array `help_message` liegen, erfolgt statt der Ausgabe des Hilfetextes die Adresse, worauf `help` zeigt. Die Methode `print_help` wird genau dann aufgerufen, wenn nach der Abfrage des gewünschten Befehls (getreal3.c, Z. 95 ff.) weder p noch q noch r eingetippt wurde. 

### Startadresse der Binary leaken
Wurde hingegen l eingetippt, wird der aktuelle Hilfstext auf `help_message[i]` gesetzt. Da in C keine Arraygrenzenprüfung durchgeführt wird, kann so der Pointer auch auf `help_message[-1]` gesetzt werden, wo sich ein Pointer befindet, der auf sich selbst zeigt und relativ zum Beginn der .data-Section der Binary immer die gleiche Distanz hat. Auch wenn PIE und ASLR aktiviert sind, werden die Abstände zum Beginn der Binary nicht randomisiert, wodurch die Adressen der Symbole durch Nutzung der geleakten Adresse von `help_message[-1]` auch zur Laufzeit berechnet werden können. Somit stehen alle Symbole aus der Binary selbst für mögliche ROP-Angriffe zur Verfügung. 

### Startadresse von libc leaken
Mit dem Abstand zwischen den Symbolen aus der Binary zu `help_msg` kann, nach Eingabe von l als gewünschten Befehl, der Pointer `help` auf eine beliebige Stelle im Binary gesetzt werden. Die benötigte Zahl ist 1/8 des Abstands zwischen `help_msg`, was ein Array vom Typ `char*` ist, und der gewünschten zu leakenden Stelle der Binary, da die Array-Indizierung `help_msg[i]` von der Adresse her `array[0] + 8*i` ist und Pointer auf x64 immer 8 Bytes groß sind. In der Binary sind an den Symbolen wie `got.puts` Pointer zu der jeweils namentlich entsprechenden Funktion aus libc gespeichert. So kann die Adresse einer libc-Funktion geleakt werden, und da jede libc-Funktion relativ zum Beginn von libc bei jeder Ausführung den gleichen Abstand hat sind alle Adressen aus libc.

Mit dem Terminal-Befehl `readelf -s --wide /usr/lib/x86_64-linux-gnu/libc.so.6 | grep "FUNC *GLOBAL *DEFAULT" >> libc_function_list.txt` kann die Liste aller libc-Funktionen in einer Textdatei gespeichert werden. `FUNC GLOBAL DEFAULT` im Listeneintrag bedeutet, dass die Funktion sicher von außerhalb von libc aufgerufen werden kann; durch den `grep`-Filter werden nur solche Funktionen aufgezählt. Die zweite Spalte der so entstandenen Textdatei zeigt als Hexadezimalzahl den Abstand der jeweiligen Funktion zum Beginn von libc an, beispielsweise liegt der Beginn der Funktion `puts` 0x80E50 (dezimal 527952) Bytes nach dem Beginn von libc (s. auch /2_piereal/notes/libc_function_list.txt Z. 998). Mit dem gefundenen Offset lässt sich die Startadresse von libc immer ausrechnen, obwohl PIE und ASLR aktiviert sind.

### Startadresse von ld-linux leaken
Ein zweiter großer Bereich im Prozessspeicher ist `ld-linux`. Dieser Bereich ist dafür verantwortlich, `libc` mit dem ausgeführten Programm zu verbinden. Da sich die Startadresse von libc ausrechnen lässt, kann auch die Adresse des Objekts `__nptl_rtld_global` zur Laufzeit berechnet werden. In diesem Objekt ist immer ein Pointer beinhaltet, der in den Speicherbereich `ld-linux` zeigt, um die Verbindung zwischen `libc` und `ld-linux` herzustellen.  Mit der Eingabe von l als gewünschten Befehl und danach den errechneten Abstand zwischen `help_msg`und `libc+0x21b878` geteilt durch 8, kann eine Adresse des `ld-linux`-Bereichs geleakt werden. Da diese Adresse immer 0x3a040 Bytes nach dem Beginn von `ld-linux` ist, kann trotz aktiviertem ASLR und PIE auch die Startadresse von `ld-linux` und somit alle Adressen aus `ld-linux` geleakt werden.


### Stack leaken
In `ld-linux` befindet sich das Objekt `__libc_stack_end` zeigt, was, wie der Name sagt, die Adresse des obersten Elements aller Funktionsstacks enthält. Da `ld-linux` geleakt ist, kann auch die Adresse von `__libc_stack_end` zur Laufzeit berechnet werden. Mit dem Vorgehen, bei der Abfrage des gewünschten Befehls l einzugeben und dann wie bei den vorhergehenden Leaks den berechneten Abstand zur geleakten `ld-linux`-Adresse einzugeben, wird der Wert von `__libc_stack_end` geleakt. Wird die gleiche Abfolge von Eingaben in die Konsole getätigt, werden immer die gleichen Funktionen nacheinander aufgerufen, wodurch die Struktur des Call-Stacks innerhalb des Stacks gleich bleibt. So bleibt über jede Programmausführung hinweg bleibt Abstand zwischen `__libc_stack_end` und dem Wert des RBP-Registers gleich, wodurch auch RBP immer berechnet werden kann. Somit ist auch das Wert des RBP-Registers der Stack geleakt.

### Heap leaken
Da im C-Code kein Speicher alloziiert wird (z. B. über malloc oder calloc), und das Ziel ist, den Inhalt einer Datei auf der Konsole auszugeben, ist es nicht notwendig, den Heap zu leaken. Da schon Binary, `libc`, `ld-linux` und der Stack bei jeder Ausführung des Programms geleakt sind, ist auch hier schon gezeigt, dass ASLR gegen Informations-Leaks wirkungslos ist.


## 2.2 Identifizieren nützliche ROP-Gadgets z. B. in dem Programm oder der libc. Erklären Sie welche ROP-Gadgets Sie verwendet haben.
An dem Punkt, kurz nachdem die Startadressen der Binary, der libc, ld-linux-Bibliotheken und des Stacks geleakt werden konnten, sieht der Speicher wie folgt aus:

```
RBP-0x60: buf[0...7]
RBP-0x55: buf[8...15]
RBP-0x50: buf[16...23]
RBP-0x48: buf[24...31]
RBP-0x40: buf[32...39]
RBP-0x38: buf[40...47]
RBP-0x30: buf[48...55]
RBP-0x28: buf[56...63]
RBP-0x20: (ptr -> stdin) 
RBP-0x18: RETURN-Adresse: (ptr -> real_main+101, kurz vor explicit_bzero)
```


Durch die Info-Leaks steht die gesamte Binary sowie `libc` und `ld-linux` zur Findung von Gadgets zur Verfügung. Da DEP/NX auch aktiviert ist, beschränkt sich die Suche von Gadgets auf die ausführbaren Bereiche der vorher genannten Adressräume und Offset-Bereiche:
* Binary: 0x1000 bis 0x1FFFF
* libc: 0x28000 bis 0x1BCFFF
* ld-linux: 0x2000 bis 0x2BFFF


Zur Suche nach Gadgets werden in den genannten Adressräumen alle Bereiche betrachtet, die max. 15 Bytes vor einer Return-Instruktion sind. Von allen RET-Instruktionen werden alle möglichen ROP-Gadgets rückwärts disassembliert bis max. 15 Bytes vor der RET-Instruktion. Erst wird nur das RET disassembliert, dann werden solange von links Bytes zum Disassemblieren hinzugefügt, bis der Abstand von 15 Bytes vor dem RET, das vorige RET, oder der Beginn des Adressbereichs erreicht ist. Kein Gadget soll länger als 15 Bytes lang sein, weil ROP-Gadgets i. A. kurz sind. Am Ende eines Gadgets steht ein C3-Byte, denn C3 ist unter x64 der Opcode für RET.Es werden die Gadget-Kandidaten herausgefiltert, deren Disassembly nicht mit einer RET-Instruktion endet, weil das C3-Byte am Ende als Teil einer anderen Instruktion interpretiert worden wäre. Das Ergebnis ist in den Textdateien aus dem Ordner `./notes/rop_gadgets/` vermerkt. Erwähnenswerte Kandidaten sind:

Aus `libc` wurden folgende Gadgets ausgewählt:
```
G0:
0x00042759:	0f 05                           syscall	

G1:
0x00045eb0:	58                              pop	rax
0x00045eb1:	c3                              ret	

G2:
0x0002a3e5:	5f                              pop	rdi
0x0002a3e6:	c3                              ret	

G3:
0x001bb217:	5e                              pop	rsi
0x001bb218:	c3                              ret	

G4:
0x0011f357:	5a                              pop	rdx
0x0011f358:	41 5c                           pop	r12
0x0011f35a:	c3                              ret	

G5:
0x0003d1ee:	59                              pop	rcx
0x0003d1ef:	c3                              ret	

G6:
0x0005a272:	48 89 c7                        mov	rdi, rax
0x0005a275:	48 39 ca                        cmp	rdx, rcx
0x0005a278:	73 e2                           jae	0x5a25c
0x0005a27a:	4c 89 c0                        mov	rax, r8
0x0005a27d:	c3                              ret	
```

Da `libc`-Funktionen wie execve, system und exit auf den entsprechenden Syscalls basieren, ist in `libc` mindestens ein Syscall enthalten. Die Bytefolge `0f 05` ist der Opcode für `SYSCALL`. Dies wird als Gadget 0 gewählt. Dann, um Syscalls auszuführen, werden als Gadgets 1 bis 4 die Gadgets gewählt, die die Register RAX, RDI, RSI und RDX befüllen, mit so wenigen Seiteneffekten wie möglich. Bei Gadget 4 muss man neben dem Wert für RDX einen weiteren, beliebigen Wert angeben, der an das nicht mehr benutzte Register R12 geschrieben wird. Um mögliche Ausgaben für Syscalls weiterverwenden zu können, wurde als Gadget 6 eines mit der Anweisung `MOV RDI, RAX` gewählt. Da dort mit `JAE 0x5a25c` ein JAE-Sprung zu einer auf jeden Fall nicht gemappten Adresse vorkommt, und RDX schon über Gadget 4 gesetzt werden kann, wird Gadget 5 genutzt, um RCX so zu setzen, dass das `JAE 0x5a25c` im Gadget 6 nicht ausgeführt wird. RAX kann später mit Gadget 1 nach Gadget 6 neu beschrieben werden.


## 2.3 Erweitern Sie exploit.py zu einem funktionierenden Angriff. Ihr Angriff soll mindestens die erste Zeile der Datei secret.log auslesen und ausgeben.
In der Methode `load_real` (getreal3.c, Z. 77 ff.) wird in den 64 Byte großen Buffer `password` mit `fgets(buf, 640, stdin)` vom Benutzer eine bis zu 640 Byte lange Eingabe eingelesen. Die Eingabe, um den Angriff auszuführen, besteht aus drei Teilen:
* 64 Bytes Text, um den Buffer zu füllen
* 8 Bytes die Adresse zu `stdin`. Diese muss intakt bleiben, da ansonsten ein Segfault auftritt und das Programm abstürzt.
* Bis zu 568 Bytes bzw. 71 Glieder à 8 Bytes ROP-Chain 

Die ROP-Chain wird wie folgt aufgebaut:

### Datei `./secret.log` öffnen
Um die Datei `./secret.log` zu öffnen, müssen die Register wie folgt gesetzt werden:
* RAX = 2 (Nummer des Open-Syscalls)
* RDI = ptr->filename
* RSI = 0 (Nummer für den 'read'-Mode)
RDI wird gesetzt, indem der String `./secret.log\0` nach der ROP-Chain auf dem Stack abgelegt wird. Da RBP geleakt ist, kann dieser String immer erreicht werden.

### Inhalt der Datei `./secret.log` in einen Buffer speichern
Um den Inhalt der Datei `./secret.log` in einen Buffer zu speichern, müssen die Register wie folgt gesetzt werden:
* RAX = 0 (Nummer des Read-Syscalls)
* RDI = File Descriptor von `./secret.log`
* RSI = ptr->password
Um den Wert von RAX auf RDI zu übertragen, wird Gadget 6 verwendet. Vor der Nutzung von Gadget 6 wird mit Gadget 5 RCX auf einen sehr hohen Wert gesetzt und mit Gadget 4 RDX auf einen sehr niedrigen Wert gesetzt, damit in Gadget 6 die Instruktion `JAE 0x5a25c` nicht ausgeführt wird. Mit Gadget 1 wird RAX neu beschrieben. Als Speicherort für die gelesenen Daten wird ein großer globaler Buffer in einem beschreibbaren Datenbereich genutzt. Hierzu eignet sich beispielsweise der Buffer `password`, da er durch den ROP-Angriff nicht mehr regulär verwendet wird. Die Adresse ist nach dem Leak der Binary-Startadresse ebenfalls zur Laufzeit bestimmbar.

### Den gespeicherten Inhalt auf der Konsole ausgeben
Um den gespeicherten Inhalt auf der Konsole auszugeben, müssen die Register wie folgt gesetzt werden:
* RAX = 1 (Nummer des Write-Syscalls)
* RDI = 1 (File-Descriptor von `stdout`)
* RSI = ptr->password
* RDX = 0x40
Die Werte aus RSI und RDX können weiterverwendet werden, weil sie sich nach dem Speichern des Inhalts in den Buffer nicht geändert haben. 

### Das Programm sauber beenden
Um das Programm sauber zu beenden, müssen zuletzt noch die folgenden Werte in den Registern sein:
* RAX = 60 (Nummer des Exit-Syscalls)
* RDI = 0 (Exit-Code)
Diese können über Gadgets 1 und 2 gesetzt werden.


# 3 Bypassing Stack Canaries

## 3.1 Erweitern Sie das Exploit-Template zu einem funktionierenden Angriff, der zu der Funktion shelly zurückspringt. Erklären Sie, wie Sie den Stack-Canary-Schutzmechanismus umgangen haben.
Da kein C-Code vorlag, wurde zunächst die Binary mit Ghidra dekompiliert. Das Ergebnis nach Bereinigung der Ausgabe von Ghidra ist in der Datei `cookie_decompiled_with_ghidra.c` vermerkt. Die Buffer-Overflow-Schwachstelle des Programms ist, dass vom Benutzer bei der Abfrage der Kekssorte, 100 Zeichen in einen 64 Bytes großen Buffer gelesen werden. Sobald eine Eingabe getätigt wird, wird die Eingabe mit dem Format Specifier %s wieder ausgegeben. Die Schwachstelle hierbei ist, dass %s den Buffer solange liest, bis ein \0-Byte kommt, unabhängig von der ursprünglichen Größe des Buffers. So können auch Informationen, die im Stack adressenweise über dem Buffer stehen, geleakt werden, darunter der Stack Canary.

Da der Stack Canary immer mit einem 00-Byte endet (Stack Canary % 256 = 0), wurde zunächst exakt so viele Zeichen eingegeben, um im Speicher den Stack Canary zu erreichen. Der Zeilenumbruch überschrieb das 00-Byte und so konnten die ersten Bytes des Stack Canary ausgegeben werden. Wurden nicht alle Bytes des Stack Canary ausgegeben, weil es ein 00-Byte in der Mitte hatte (z. B. 0xABCD00EFABCDEF00), wird erneut von der Position des letzten geleakten Byte weiter geleakt, bis alle 8 Bytes des Stack Canary geleakt sind. Diese Vorgehensweise funktioniert mehrfach, da nach der Eingabe des Leak-Payloads, durch anschließende Eingabe von y das Symbol `__stack_chk_fail` nicht erreicht wird, sondern zurück gesprungen wird und da die Methode nicht verlassen wurde, werden die lokalen Buffer nicht geleert. 

Sind alle 8 Bytes des Stack Canary geleakt, wird der Payload aufgebaut. Nach dem Befüllen des Buffers kommt der gerade geleakte Stack Canary und danach die gewünschte Return-Adresse. Die Manipulation des Stacks wird von `__stack_chk_fail` nicht bemerkt, da der Stack Canary gleich geblieben ist und somit spawnt eine Shell.