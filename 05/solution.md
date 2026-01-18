# Übungsblatt 5 - Control Flow Integrity und Data-oriented attacks

# 1. Bending Control-Flow Integrity

## 1.1 Welchen Input müssen Sie schicken, um den Funktionspointer print im Objekt String zu überschreiben? Überschreiben Sie den Funktionspointer print mit dem Wert von system und bringen Sie das Programm dazu, diesen zu verwenden. Schreiben Sie das Kommando, also den ersten Parameter für system, in den Buffer des String Objektes. Erklären Sie, wieso system dann einen validen Parameter übergeben bekommt. Erweitern Sie das Exploit Template exploit_normal.py zu einem funktionierenden Exploit,der über system und die entsprechenden Kommandos die Datei flag.txt ausliest. 

Im String-Objekt befinden sich neben dem String von 32 Bytes auch folgende Pointer zu Funktionen (aufsteigend sortitert nach Adressen), die im Normalfall wie folgt zeigen: 

| Adresse          | Pointer   | Funktion, auf die der Pointer im Normalfall zeigt | Zeile im Quellcode bend.c |
|------------------|-----------|---------------------------------------------------|---------------------------|
| str+32           | append    | string_append                                     | 61                        |
| str+40           | print     | _print_to_stdout                                  | 34                        |
| str+48           | set       | string_set                                         | 63                        |
| str+56           | terminate | exit_func                                          | 55                        |


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
Durch die Nutzung der Eigenschaften, wie Structs und Pointer im Speicher liegen, wird nach dem Ausführen des indirect calls, aber vor dem Return geprüft, ob die Argumenttypen und -anzahl, sowie der Rückgabetyp der Funktion noch korrekt sind. Bei den Typen wird auch geprüft, ob diese mit `const` markiert sind oder nicht. 

## 1.3 In dem Programm befinden sich noch weitere Funktionspointer, die Sie überschreiben können. Analysieren sie die verfügbaren Funktionen und die Funktionspointer. Finden Sie einen Funktionspointer, den Sie überschreiben können, und eine Zielfunktion, welche die Datei flag.txt ausliest. Kopieren sie ihren bisherigen Exploit und modifizieren Sie exploit_cfi.py so, dass der Exploit wieder funktioniert.
Der Custom String Struct hat neben dem `print`-Funktionspointer noch den `append`-Funktionspointer. `append` erwartet eine Funktion, die als erstes Argument einen Pointer zu einer Instanz des Custom String Struct und als zweites Argument einen String (`char*`) nimmt und nichts zurückgibt (`void`). Außer `string_append` hat der Quellcode noch die Funktionen `string_set` und `_set_from_file`. Die Funktion `_set_from_file` liest einen String aus der welcome-Datei ein und wird normalerweise nur beim Initialisieren benutzt. Diese Funktion kann wie folgt genutzt werden, um stattdessen aus der `flag.txt`-Datei zu lesen: Zuerst wird nach Eingabe von r als gewünschte Aktion der Buffer so gefüllt, dass dieser mit einem String-Terminator (\0) endet. Hierzu sind 31 Zeichen nötig. Danach muss man nach Eingabe von a als gewünschte Aktion, ein Byte, das kein Zeilenumbruch und kein String-Terminator ist, gefolgt von der Adresse der `set_from_file`-Funktion eingegeben werden. Nur so kann die Konkatenation die Bytes so positionieren, dass die Umleitung des Funktions-Pointers danach korrekt ausgeführt werden. Anschließend wird, indem als gewünschte Aktion nochmal a eingegeben wird, der Aufruf der `set_from_file`-Funktion vorbereitet. Es wird `set_from_file` und nicht mehr `string_append` aufgerufen, da der Funktionspointer umgeleitet wurde. Diese Änderung wird von CFI nicht bemerkt, da die Funktionssignaturen weiterhin stimmen. Als Argument wird über die Konsole `./flag.txt` eingegeben. Dies führt dazu, dass der Inhalt aus der Datei `./flag.txt` in den normalen String-Buffer des Custom String Struct übertragen wird. Nun wird nur noch p als gewünschte Aktion eingegeben, um den Inhalt des String-Buffers des Custom String Struct, der vorher der Datei `./flag.txt` entnommen wurde, auf der Konsole auszugeben.

# 2. Von Use-After-Free zu Arbitrary Read/Write

# 2.1 Wo befindet sich die Schwachstelle in diesem Programm? Was ist das Problem? In welcher Reihenfolge müssen Sie welche Aktionen durchführen, damit ein dangling pointer von dem Programm verwendet wird? Wie könnte man die Schwachstelle einfach beheben?
Im Programm wird free() innerhalb der Methode delete_user() (uadop.c, Z. 142) und innerhalb der Methode string_clear() (uadop.c, Z. 71) benutzt. Die Nutzung von free() markiert nur den entsprechenden Speicherbereich als "frei", damit dieser vom nächsten malloc() wieder verwendet werden kann. An der Speicheradresse, auf die der Pointer, worauf free() angewendet wurden bestehen die Daten weiterhin. Auch der Pointer selbst zeigt weiterhin auf den gleichen Bereich. 

Bei den beiden Methoden selbst werden die Pointer, die auf die Datenbereiche zeigen, die mit free() als "frei" für das nächste malloc() markiert wurden, nicht durch Zuweisung von NULL deaktiviert. Die Methode string_clear() wird nur von der Methode delete_user() aufgerufen. Die Methode delete_user() wird von den folgenden Methoden aufgerufen: delete_user_at() und, sofern bei der Nutzung von edit_user() ein Fehler aufgetreten ist, auch von edit_user_at(). Von den beiden Methoden, die delete_user() aufrufen, deaktiviert nur delete_user_at() den Pointer zum gerade gelöschten Benutzer. Somit besteht innerhalb der Methode edit_user_at() eine Use-After-Free-Schwachstelle. 

Um in edit_user_at() die Methode delete_user() ohne Deaktivierung des Pointers zum gelöschten Benutzer aufzurufen, muss bei edit_user() ein Fehler geschehen sein. Ein Fehler bei edit_user() geschieht, wenn versucht wird, als Geburtsjahr, -monat oder -tag einen Buchstaben zu nehmen. Dies muss bei einem bereits vorher erstellten Benutzer, der versucht wird zu bearbeiten, geschehen, da bei der Neuerstellung des Nutzers (im Code in der Methode new_user_at()) stattdessen die delete_user_at()-Methode, die den Pointer zum gelöschten Nutzer auch deaktiviert, verwendet wird.

Um die Use-After-Free-Schwachstelle komplett zu beheben, muss man die an delete_user() und in clear_string() übergebenen Pointer noch innerhalb dieser Funktionen durch Zuweisung von NULL deaktivieren.

# 2.2 Bei der Use-After-Free Schwachstelle verwendet das Programm ein Objekt U , welches allerdings schon freigegeben wurde. Wie können Sie ein anderes Objekt (z.B. einen String) an derselben Stelle wie U anlegen? Wie sieht ein Objekt vom Typ user_t im Speicher aus? Welche Aktionen mit welchem Input werden benötigt, um das freigegebene User Objekt U mit Angreifer kontrollierten Werten zu überschreiben?
Der users-Array, über dem die Benutzer zentral verwaltet werden, besteht aus Pointern zu user_t-Objekten. Jedes user_t-Objekt ist wie folgt aufgebaut:

| **Offset** | **Größe** | **Feld**        | **Typ**  | **Beschreibung**                            |
|------------|-----------|-----------------|----------|---------------------------------------------|
| 0          | 8         | id              | user_idt | Die Benutzer-ID, die ein 64 Bit Integer ist |
| 8          | 8         | firstname->sz   | size_t   | Länge des Vornamens                         |
| 16         | 8         | firstname->s    | char*    | Der Vorname selbst                          |
| 24         | 8         | lastname->sz    | size_t   | Länge des Nachnamens                        |
| 32         | 8         | lastname->s     | char*    | Der Nachname selbst                         |
| 40         | 8         | birthday->year  | int32_t  | Geburtsjahr                                 |
| 41         | 1         | birthday->month | uint8_t  | Monat                                       |
| 42         | 1         | birthday->day   | uint8__t | Tag                                         |
| 43         | 6         | ---             | ---      | (Heap Alignment Wiederhersteller)           |

Insgesamt belegt ein user_t-Objekt 48 Bytes im Speicher, gefolgt von einem 16-Byte-Trenner im Heap. Werden die Benutzer direkt hintereinander angelegt, folgen die beiden Strings für den Vor- und Nachnamen direkt nach dem user_t-Objekt. Die Länge der beiden Strings wird auf das nächsthöhere Vielfache von 16 aufgerundet, um das Heap Alignment, welches in x64 erforderlich ist, zu reparieren. Die Trenner nach den Strings sind dazu da, zu erkennen, wann realloc() aufgerufen werden muss, falls sich die Länge des Strings ändert. 

Angenommen, es werden 3 Nutzer, deren Vor- und Nachname jeweils exakt 48 Bytes lang sind, angelegt. Wenn dann bei allen 3 Benutzern in umgekehrter Reihenfolge bei der edit-Menüaktion der Tag des Geburtstags auf einen ungültigen Wert gesetzt wird, werden die Speicherbereiche aller Nutzerobjekte als "frei" markiert. 

Es entsteht eine Use-After-Free-Schwachstelle bei allen 3 Benutzerobjekten, da die Pointer im users-Array nicht deaktiviert wurden. Nach dem free() ist das Heap-Layout wie folgt (\[F] am Anfang heißt, dass der Speicher mit free() freigegeben wurde)

```
[F] User A [0..15]
[F] User A [16..31]
[F] User A [32..47]
(Trenner)
[F] A.firstname [0..15]
[F] A.firstname [16..31]
[F] A.firstname [32..47]
(Trenner)
[F] A.lastname [0..15]
[F] A.lastname [16..31]
[F] A.lastname [32..47]
(Trenner)
[F] User B [0..15]
[F] User B [16..31]
[F] User B [32..47]
(Trenner)
[F] B.firstname [0..15]
[F] B.firstname [16..31]
[F] B.firstname [32..47]
(Trenner)
[F] B.lastname [0..15]
[F] B.lastname [16..31]
[F] B.lastname [32..47]
(Trenner)
[F] User C [0..15]
[F] User C [16..31]
[F] User C [32..47]
(Trenner)
[F] C.firstname [0..15]
[F] C.firstname [16..31]
[F] C.firstname [32..47]
(Trenner)
[F] C.lastname [0..15]
[F] C.lastname [16..31]
[F] C.lastname [32..47]
(Trenner)
```

 

Mittels Heap Feng Shui wird ein vierter Benutzer D angelegt, wobei der Vorname 64 Bytes lang sein wird. Dies führt zu folgenden Effekten:

* Da kein Speicherbereich, wo früher Vornamen waren, groß genug ist, wird der zu lange Vorname im Heap nach allen vorher erstellten Benutzern geschrieben. 
* Da die Stelle, wo das user_t-Objekt des Benutzers A angelegt wurde, als "frei" markiert wurde, wird das user_t-Objekt des Benutzers D am Anfang des Heaps sein. 
* Weil der frühere Benutzer A nicht vollständig verwendet werden konnte, landet der Nachname des neuen Benutzers D dort, wo früher das user_t-Objekt des Benutzers B war. 

Somit hätten spätere Änderungen von D.lastname über den Menü-Befehl edit und Eingabe des entsprechenden Indexes von Benutzer D einen Einfluss darauf, was das user_t-Objekt des früheren Benutzers B ist 

So entsteht folgendes Heap-Layout (Die Notation (Neue Daten) \[F] (Alte Daten) für diese und folgende Aufgaben bedeutet, dass der Speicher aktuell von (Neue Daten) verwendet wird, aber diese auch von (Alte Daten) referenziert werden):
```
User D [0..15] [F] User A [0..15]
User D [16..31] [F] User A [16..31]
User D [32..47] [F] User A [32..47]
(Trenner)
[F] A.firstname [0..15]
[F] A.firstname [16..31]
[F] A.firstname [32..47]
(Trenner)
[F] A.lastname [0..15]
[F] A.lastname [16..31]
[F] A.lastname [32..47]
(Trenner)
D.lastname [0..15] [F] User B [0..15]
D.lastname [16..31] [F] User B [16..31]
D.lastname [32..47] [F] User B [32..47]
(Trenner)
[F] B.firstname [0..15]
[F] B.firstname [16..31]
[F] B.firstname [32..47]
(Trenner)
[F] B.lastname [0..15]
[F] B.lastname [16..31]
[F] B.lastname [32..47]
(Trenner)
[F] User C [0..15]
[F] User C [16..31]
[F] User C [32..47]
(Trenner)
[F] C.firstname [0..15]
[F] C.firstname [16..31]
[F] C.firstname [32..47]
(Trenner)
[F] C.lastname [0..15]
[F] C.lastname [16..31]
[F] C.lastname [32..47]
(Trenner)
D.firstname [0..15]
D.firstname [16..31]
D.firstname [32..47]
D.firstname [48..63]
```

# 2.3 Verwenden Sie die Use-After-Free Schwachstelle, um ein Arbitrary Read/Write zu erhalten. Wie können Sie die Schwachstelle nutzen, um das Admin Passwort auszulesen? Wie können Sie die Schwachstelle nutzen, um das Admin Menü zu aktivieren, also auf die Variable admin_enabled zu schreiben? Erweitern Sie das Exploit-Template zu einem funktionierenden Angriff.
Um einen vollständigen Angriff durchzuführen, braucht man zwei Arbitrary Read/Write-Primitive: Eines, um den Flag admin_enabled zu aktivieren, damit bei Eingabe des Menübefehls a überhaupt eine Passwortabfrage kommt und eines, um das Admin-Passwort für die Passwortabfrage auszulesen und dann in der Passwortabfrage einzugeben.

Mit den Aktionen, die in 2.2 zur Vorbereitung eines Arbitrary Read/Write-Primitivs durchgeführt wurden, entstand folgendes Heap-Layout:

```
User D [0..15] [F] User A [0..15]
User D [16..31] [F] User A [16..31]
User D [32..47] [F] User A [32..47]
(Trenner)
[F] A.firstname [0..15]
[F] A.firstname [16..31]
[F] A.firstname [32..47]
(Trenner)
[F] A.lastname [0..15]
[F] A.lastname [16..31]
[F] A.lastname [32..47]
(Trenner)
D.lastname [0..15] [F] User B [0..15]
D.lastname [16..31] [F] User B [16..31]
D.lastname [32..47] [F] User B [32..47]
(Trenner)
[F] B.firstname [0..15]
[F] B.firstname [16..31]
[F] B.firstname [32..47]
(Trenner)
[F] B.lastname [0..15]
[F] B.lastname [16..31]
[F] B.lastname [32..47]
(Trenner)
[F] User C [0..15]
[F] User C [16..31]
[F] User C [32..47]
(Trenner)
[F] C.firstname [0..15]
[F] C.firstname [16..31]
[F] C.firstname [32..47]
(Trenner)
[F] C.lastname [0..15]
[F] C.lastname [16..31]
[F] C.lastname [32..47]
(Trenner)
D.firstname [0..15]
D.firstname [16..31]
D.firstname [32..47]
D.firstname [48..63]
```

Um ein zweites Arbitrary Read/Write-Primitiv zu erhalten, muss ein neuer Benutzer E erstellt werden, wobei Vor- und Nachname jeweils 48 Bytes lang sind. Dies hat folgende Effekte:

* Da bei der Erstellung des Benutzers D nicht der ganze Speicherplatz des früheren Benutzers A verwendet wurde, wird ab dem früheren Vorname des Benutzers B nach als "frei" markierten Speicherplatz gesucht, um das user_t-Objekt, und die beiden Strings des Benutzers E abzulegen. 
* Da genügend als frei markierter Speicher ab der Adresse, wo die Suche begonnen wurde, zur Verfügung steht, können alle Daten des Benutzers E hintereinander abgelegt werden.

Somit sieht der Heap nun so aus:  

```
User D [0..15] [F] User A [0..15]
User D [16..31] [F] User A [16..31]
User D [32..47] [F] User A [32..47]
(Trenner)
[F] A.firstname [0..15]
[F] A.firstname [16..31]
[F] A.firstname [32..47]
(Trenner)
[F] A.lastname [0..15]
[F] A.lastname [16..31]
[F] A.lastname [32..47]
(Trenner)
D.lastname [0..15] [F] User B [0..15]
D.lastname [16..31] [F] User B [16..31]
D.lastname [32..47] [F] User B [32..47]
(Trenner)
User E [0..15] [F] B.firstname [0..15]
User E [16..31] [F] B.firstname [16..31]
User E [32..47] [F] B.firstname [32..47]
(Trenner)
E.firstname [0..15] [F] B.lastname [0..15]
E.firstname [16..31] [F] B.lastname [16..31]
E.firstname [32..47] [F] B.lastname [32..47]
(Trenner)
E.lastname [0..15] [F] User C [0..15]
E.lastname [16..31] [F] User C [16..31]
E.lastname [32..47] [F] User C [32..47]
(Trenner)
[F] C.firstname [0..15]
[F] C.firstname [16..31]
[F] C.firstname [32..47]
(Trenner)
[F] C.lastname [0..15]
[F] C.lastname [16..31]
[F] C.lastname [32..47]
(Trenner)
D.firstname [0..15]
D.firstname [16..31]
D.firstname [32..47]
D.firstname [48..63]
```

Da die Referenz zu Benutzer B noch besteht, kann nun indem der Nachname von Benutzer D bearbeitet wird, das user_t-Objekt des Benutzers B manipuliert werden. Mit dem Wissen über den Aufbau des user_t-Objekts werden deren beide String-Pointer auf die Adresse des admin-enabled-Flags gesetzt. Würde man nur einen String-Pointer setzen, würde die edit-Operation zu einem Segfault führen, denn es werden beide String-Pointer dereferenziert. Die Strings werden auf den Wert "\x01" gesetzt, damit der admin-enabled-Flag zu true evaluiert wird. 

Da die Referenz zu Benutzer C noch besteht, kann nun indem der Nachname von Benutzer E bearbeitet wird, das user_t-Objekt des Benutzers C manipuliert werden. Mit dem Wissen über den Aufbau des user_t-Objekts werden deren beide String-Pointer auf die Adresse des Admin-Passworts gesetzt. Würde man nur einen String-Pointer setzen, würde die print-Operation zu einem Segfault führen, denn es werden bei der print-Operation beide String-Pointer dereferenziert.

Sobald der admin-enabled-Flag auf 1 gesetzt wurde und das Admin-Passwort geleakt wurde, wird das Admin-Menü aufgerufen.