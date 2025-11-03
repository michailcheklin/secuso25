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
Hierbei werden 140+32 Zeichen nach einen 140 Zeichen langen Buffer gelesen. Um über die Grenzen des Buffers hinaus zu schreiben und einen Buffer-Overflow auszulösen, muss man mindestens 141 Zeichen senden.


## 1.2 Überschreiben Sie die Return-Adresse zuerst mit dem Wert 0x41414141 (ASCII „AAAA“) um zu demonstrieren, dass Sie den Instruction Pointer kontrollieren können.
157 A bei der Eingabe am Terminal überschreiben die Return Adresse mit 0x41414141, da der Stack Frame so aussieht:
8 Bytes für die Return Address
8 Bytes für den Saved Base Pointer 
140 Bytes für den Buffer




