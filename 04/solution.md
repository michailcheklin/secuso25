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
In der Methode `load_real` (getreal3.c, Z. 77 ff.) wird in den 64 Byte großen Buffer `password` mit `fgets(buf, 640, stdin)` vom Benutzer eine bis zu 640 Byte lange Eingabe eingelesen. Da das Passwort höchstwahrscheinlich falsch sein wird, gelangt das Programm zur Anweisung `printf("ACCESS DENIED: your input:\n%s", buf);` (getreal3.c, Z. 77 ff.). Die `printf()`-Funktion reagiert auf `%s` wie folgt: Es beginnt am Beginn von buf zu lesen, bis ein \0-Byte kommt. Wenn die ersten 64 Bytes kein \0-Byte enthalten, so können weitere Bytes bis zum ersten \0-Byte aus dem Speicher gelesen werden.
