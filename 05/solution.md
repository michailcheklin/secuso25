# Übungsblatt 5 - Control Flow Integrity und Data-oriented attacks

# 1. Bending Control-Flow Integrity

## 1.1 Welchen Input müssen Sie schicken, um den Funktionspointer print im Objekt String zu überschreiben? Überschreiben Sie den Funktionspointer print mit dem Wert von system und bringen Sie das Programm dazu, diesen zu verwenden. Schreiben Sie das Kommando, also den ersten Parameter für system, in den Buffer des String Objektes. Erklären Sie, wieso system dann einen validen Parameter übergeben bekommt. Erweitern Sie das Exploit Template exploit_normal.py zu einem funktionierenden Exploit,der über system und die entsprechenden Kommandos die Datei flag.txt ausliest. Im String-Objekt befinden sich neben dem String von 32 Bytes auch folgende Pointer zu Funktionen (aufsteigend sortitert nach Adressen), die im Normalfall wie folgt zeigen: 

[table]
[tr]
    [th]Adresse[/th]
    [th]Pointer[/th]
    [th]Funktion, auf die der Pointer im Normalfall zeigt[/th]
    [th]Zeile im Quellcode bend.c[/th]
[/tr]
[tr]
    [td]str+32[/td]
    [td]append[/td]
    [td]string_append[/td]
    [td]61[/td]
[/tr]
[tr]
    [td]str+40[/td]
    [td]print[/td]
    [td]_print_to_stdout[/td]
    [td]34[/td]
[/tr]
[tr]
    [td]str+48[/td]
    [td]set[/td]
    [td]string_set[/td]
    [td]63[/td]
[/tr]
[tr]
    [td]str+56[/td]
    [td]terminate[/td]
    [td]exit_func[/td]
    [td]55[/td]
[/tr]
[/table]

Mit der Methode `string_set` (bend.c, Z. 63) können die 32 Bytes des str->buf Buffer selbst gesetzt werden. In der Methode `string_append` (bend.c, Z. 61) wird `strcat` aufgerufen, welche ohne die Prüfung der Grenzen von `str->buf` das erste Argument an das letzte Byte vor dem ersten \0-Byte nach dem Beginn von `str->buf` anfügt. So kann auch über `str->buf` hinaus geschrieben werden. Es ist zu beachten, dass `strcat` beim ersten \0-Byte des 2. Arguments aufhört, das 2. Argument einzulesen.

Der Pointer `str->print` wird wie folgt auf `system`aus libc umgeleitet. Nach Eingabe des Kommandos a an das Programm, werden 8 Bytes Text gefolgt von der Adresse von `system` aus libc eingegeben. Da das Ziel ist, `str->print` zu überschreiben, werden die Bytes bis `str->print` mit Text beschrieben, denn sonst hätte `strcat` beim ersten \0-Byte gestoppt, den zusätzlichen Text einzulesen. 

Sobald im nächsten Durchlauf p als Kommando an das Programm eingegeben wird, wird, da der Funktionspointer `str->print` nun umgeleitet wurde, `system` aufgerufen, wobei das 1. Argument ab dem Beginn von `str->buf` eingelesen wird. Da `str->print` ein Pointer zu einer Funktion, die genau ein Argument des Typs *String (Pointer zu einem String-Objekt) annimmt, und in bend.c, Z. 131 mit dem Pointer zum String-Objekt selbst aufgerufen wird, ist in der Assembly der Pointer zu str kurz vor dem Funktionsaufruf bereits im Register RDI. Da der Funktionspointer auf `system` zeigt, wird als erstes Argument das verwendet, was ab dem Beginn des String-Objekts bis zum ersten \0-Byte, maximal aber sizeof(String) Bytes danach im Speicher steht.

Um den Inhalt von flag.txt auszugeben, muss als Argument für die `system`-Funktion folgender Wert übergeben werden: `cat ./flag.txt;#`. Das ;# schließt den cat-Befehl ab und sorgt dafür, dass der Rest des String-Objekts von der Shell ignoriert wird. Das Argument muss vor dem Umleiten des `str->print`-Pointers über die Eingabe des Kommandos r an das Programm, gefolgt vom gewünschten Shell-Befehl, übermittelt werden, da sonst der Pointer zu `string_append` zerstört ist. Erst danach darf der Pointer umgeleitet werden.

## 1.2 Kopieren Sie Ihren Code aus der vorherigen Teilaufgabe in die Datei exploit_cfi.py. Stellen Sie sicher, dass das richtige Programm, bend.cfi, ausgeführt wird. Ihr Exploit wird nun aufgrund von aktiviertem CFI nicht mehr funktionieren. Erklären Sie welche CFI Policy umgesetzt wird und warum diese Ihren Exploit verhindert. Analysieren Sie den CFI Check mittels Cutter oder gdb und erklären Sie die relevanten Assembly Instruktionen.
Würde man den gleichen Input aus der Aufgabe 1.1 an die Binary mit aktiviertem CFI zu senden, erscheint folgende Fehlermeldung: `bend.c:131:7: runtime error: control flow integrity check for type 'void (struct _String *)' failed during indirect function call`. Dies bedeutet, dass der Funktionspointer nicht mehr zu einer Funktion, deren 1. Argument vom Typ `_String *` (Pointer zu einem Custom String-Struct) ist und nichts zurückgibt zeigt. Der Versuch, die `system`-Funktion aus der Standardbibliothek aufzurufen schlug fehl, da `system` als 1. Argument einen C-String (`char*` ) erwartet und einen Integer (int) zurückgibt, was nicht mit der erwarteten Signatur übereinstimmt. Der CFI-Mechanismus prüft hier nur, ob die Signatur der Funktion (Argumentliste und Rückgabetyp) korrekt ist.

In der Assembly sieht die Überprüfung wie folgt aus:
```
   0x000000000042db02 <+898>:	call   rax; _print_to_stdout umgeleitet nach jetzt system
   0x000000000042db04 <+900>:	jmp    0x42dc10 <main+1168>
   0x000000000042db09 <+905>:	mov    rax,QWORD PTR ds:0xd86a20
   0x000000000042db11 <+913>:	mov    rcx,QWORD PTR [rax+0x28]
   0x000000000042db15 <+917>:	mov    QWORD PTR [rbp-0x68],rcx
   0x000000000042db19 <+921>:	mov    QWORD PTR [rbp-0x60],rcx
   0x000000000042db1d <+925>:	movabs rax,0x42dc40 ; _print_to_stdout
   0x000000000042db27 <+935>:	sub    rcx,rax
   0x000000000042db2a <+938>:	mov    rax,rcx
   0x000000000042db2d <+941>:	shr    rax,0x3; Teilen durch 8 (Pointer sind 8 Bytes lang)
   0x000000000042db31 <+945>:	shl    rcx,0x3d
   0x000000000042db35 <+949>:	or     rax,rcx; Bitweise Summe
   0x000000000042db38 <+952>:	cmp    rax,0x1; Prüfung, ob genau ein Pointerargument gegeben wurde
   0x000000000042db3c <+956>:	jbe    0x42db51 <main+977>; Falls nicht genau ein Pointerargument angegeben wurde, melde eine CFI Violation und breche das Programm ab
   0x000000000042db3e <+958>:	mov    rsi,QWORD PTR [rbp-0x60]
   0x000000000042db42 <+962>:	movabs rdi,0x445aa0
   0x000000000042db4c <+972>:	call   0x42c530 <__ubsan_handle_cfi_check_fail_abort>
   
```
Durch die Nutzung der Eigenschaften, wie Structs und Pointer im Speicher liegen, wird nach dem Ausführen des indirect calls, aber vor dem Return geprüft, ob die Argumenttypen und -anzahl der Funktion noch korrekt sind.