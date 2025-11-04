# Buffer Overflow Exploits

## 1.1 Finden Sie die Buffer Overflow Schwachstelle. Wo im Programm ist die Schwachstelle? Welchen Input müssen Sie dem Programm schicken, um den Buffer Overflow auszulösen? Wie lang ist der Input?
Die Schwachstelle im Programm ist in Zeile 19ff. in bufovf.c
```c
void vuln(void) {
  char buf[140] = {0};
  puts("exploit me!");
  read(0, buf, sizeof(buf) + 32);
}
```
Hierbei werden 172 Zeichen nach einen 140 Zeichen langen Buffer gelesen. Um über die Grenzen des Buffers hinaus zu schreiben und einen Buffer-Overflow auszulösen, muss man mindestens 141 Zeichen senden.


## 1.2 Überschreiben Sie die Return-Adresse zuerst mit dem Wert 0x41414141 (ASCII „AAAA“) um zu demonstrieren, dass Sie den Instruction Pointer kontrollieren können.
Die Eingabe lautet in Python-String ausgedrückt b"A"*152 + p32(0x41414141) (152-mal A und die little-Endian-Repräsentation vom DWORD 0x41414141).

## 1.3 Überschreiben Sie die Return-Adresse mit der Adresse der Funktion success (diese finden Sie in der Variablen retaddr im Exploit-Template).
Die Eingabe lautet in Python-String ausgedrückt b"A"*152 + p32(0x08049196) (152-mal A und die little-Endian-Repräsentation vom DWORD 0x08049196).


