# Übungsblatt 5 - Control Flow Integrity und Data-oriented attacks

# 1. Bending Control-Flow Integrity

## 1.1
Im String-Objekt befinden sich neben dem String von 32 Bytes auch folgende Pointer zu Funktionen (aufsteigend sortitert nach Adressen), die im Normalfall wie folgt zeigen: 

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