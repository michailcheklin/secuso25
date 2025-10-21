# Secure Software Systems Übung - Transkript Tutorial Session

## Demo 0 - Compilation of C Programs

Um ein C Programm auf der Kommandozeile zu kompilieren kann man den C Compiler
aus der GNU Compiler Collection (gcc) verwenden.

```bash
# Kompilieren
gcc -o demo0_compile demo0_compile.c
# Ausfuehren
./demo0_compile
```

Alternativ kann auch der C Compiler des LLVM Projektes verwendet werden um C
Programm zu übersetzen. Dieser verhält sich auf der Kommandozeile ziemlich
gleich.

```bash
# Kompilieren
clang -o demo0_compile demo0_compile.c
# Ausfuehren
./demo0_compile
```

Dabei werden viele Schritte hintereinander ausgeführt und die finale lauffähige
Binärdatei zu bekommen.

```bash
# run the preprocessors
cpp -o demo0_compile.i demo0_compile.c
# run the compiler to produce assembly
gcc -S demo0_compile.i
# run the assembler
as -o demo0_compile.o demo0_compile.s
# run the linker
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o demo0_compile \
    /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/10/crtbegin.o \
    -L/usr/lib/gcc/x86_64-linux-gnu/10 -L/usr/lib64 -L/lib64 -L/usr/lib/ \
    demo0_compile.o \
    -lc -lgcc \
    /usr/lib/gcc/x86_64-linux-gnu/10/crtend.o /usr/lib/x86_64-linux-gnu/crtn.o
# alternativ auch einfach:
gcc -o demo0_compile demo0_compile.o

# run it
./demo0_compile
```

Um vor allem komplexere C Projekte zu kompilieren werden wie bei anderen
Programmiersprachen auch spezielle *build tools* eingesetzt. Traditionell wird
bei C das altbewährte build-tool `make` verwendet, z.B., so

```bash
make demo0_compile
```

## Demo 0 - String Handling and Memory Allocation in C

Strings in C sind einfach nur ein Array aus Bytes. In der C Terminologie also
`char` Arrays. Der String wird durch eine Referenz, also einen Pointer, auf das
erste Byte des Strings dargestellt (`char *`). Die Länge der Strings wird durch
eine sogenannte Nullterminierung definiert. Das letzte Byte in einem C String
hat immer den Wert `0`. Es gibt in der C library mehrere Funktionen um mit C
Strings zu arbeiten (z.B., `strlen`, `strcmp`, etc.). Hier ein Beispiel zur
Verwendung von C String Funktionen:

```C
int main(int argc, char* argv[]) {
  // argc <- is the number of command line arguments + 1 (the 0th argument is
  // always the name of the program)
  // argv <- this is an array of strings, argc is the length of this array,
  // every array entry is a string (so a char*) to the next command line
  // argument. argv[1] is the first command line argument.
  if (argc == 2) {
    // we can invoke the strcmp function to compare two strings. strcmp will
    // return 0 if the strings are equal.
    if (strcmp(argv[1], "secuso") == 0) {
      puts("Helloooo! :) Welcome back");
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", argv[1]);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
```

Wie bei anderen Programmiersprachen gibt es lokale Variable in Funktionen.
Diese haben sogenannte *automatic lifetime*, werden also am Beginn der Funktion
am Stack alloziert und am Ende der Funktion wieder freigegeben. Wir können z.B.
einen String am Stack allokieren indem wir einfach ein Array als lokale
Variable definieren. Wir können den String dann byte für byte in die lokale
Arrayvariable kopieren bis wir die Nullterminierung gefunden haben.

```c
int main(int argc, char *argv[]) {
  // we can allocate space for the string on the stack
  char name[256];
  if (argc == 2) {
    // copy the string with a loop
    for (size_t i = 0; argv[1][i] != '\0'; i++) {
      name[i] = argv[1][i];
    }
    name[i + 1] = '\0';

    // we can now modify the string, e.g., by changing the first letter to
    // upper case
    name[0] = toupper(name[0]);
    if (strcmp(argv[1], "secuso") == 0) {
      printf("Helloooo! :) Welcome back %s\n", name);
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", name);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
```

Diese Art die Länge von Strings zu bestimmen hat auch gewisse Nachteile und ist
sehr fehleranfällig (Warum lernen wir später noch in Laufe der LV). Es gibt natürlich auch eine passende C library Funktion.

```c
int main(int argc, char *argv[]) {
  // we can allocate space for the string on the stack
  char name[256];
  if (argc == 2) {
    // strncpy(char *dest, const char *src, size_t n)
    // dest <- name array
    // src <- the command line parameter
    // n <- the maximum string length, we use the size of the name array
    strncpy(name, argv[1], (sizeof name) - 1);
    // we can now modify the string, e.g., by changing the first letter to
    // upper case
    name[0] = toupper(name[0]);
    if (strcmp(argv[1], "secuso") == 0) {
      printf("Helloooo! :) Welcome back %s\n", name);
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", name);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
```

Alternativ dazu gibt es auch die Möglichkeit am Heap zu speichern. Dazu gibt es
eine Reihe von Funktionen aus der Standardbibliothek (libc): `malloc`,
`calloc`, `realloc` und `free`. Im Gegensatz zu vielen modernen
Programmiersprachen ist man in C zu manueller Speicherverwaltung verpflichtet.
Daten am Heap müssen manuell vom Programmierer mittels `free` wieder
freigegeben werden.

```c
char *string_clone(char *str) {
  // first compute the length of the input string
  size_t sz = strlen(str);
  // allocate a new "object" on the heap
  char *new = malloc(sz);
  // only copy the string if the allocation did not fail, avoid nullptr
  // dereference here -> leads to crash
  if (new != NULL) {
    // memcpy(void *dest, const void *src, size_t n)
    // new <- destination
    // str <- source
    // n == sz <- length
    memcpy(new, str, sz);
  }
  return new;
}

int main(int argc, char *argv[]) {
  if (argc == 2) {
    // we invoke the clone function here, and we will receive a pointer to an
    // idential string as return value
    char *name = string_clone(argv[1]);
    name[0] = toupper(name[0]);
    if (strcmp(argv[1], "secuso") == 0) {
      printf("Helloooo! :) Welcome back %s\n", name);
    } else {
      printf("Hello Stranger! Nice to meet someone named %s.\n", name);
    }
  } else {
    puts("Hello World!");
  }
  return 0;
}
```

Mehr Informationen zu den Standard C Funktionen finden sich in den *man pages*,
die über die Kommandozeile aufgerufen werden können, z.B.

```
$ man 3 printf
$ man 3 puts
$ man 3 fgets
```

## Demo 1 - Reverse Engineering

Wir werden in dieser Übung zwei Programme verwenden um Binärcode zu
analysieren: GDB und Cutter. GDB ist der Standarddebugger auf Linux Systemen
und wird oft auch im Hintergrund von vielen GUI Debuggern verwendet. Wir
verwenden GDB mit einer speziellen Erweiterung, `pwndbg`, die auf die Analyse
von Binärcode und Exploit Development zugeschnitten ist. Damit wird `gdb` zum
Standardwerkzeug für diese Übung. Manchmal reicht der Debugger nicht aus um
eine Binärdatei zu analysieren. Dann greifen wir in dieser Übung auf das
Programm Cutter zurück.  Cutter ist ein Reverse Engineering Tool basierend auf
dem *radare2* Framework, das aus einem Disassembler, Code Analyzer, Decompiler
und vielem mehr besteht.

Weiters verwenden wir in der Übung Python und das *pwntools* Framework um
Exploits zu entwickeln. Wir werden viele verwundbare Programme besprechen und
zu jedem wird es ein Python Script geben in dem wir die Exploits entwickeln.
Dieses Framework bietet viele praktische Features wie z.B. die Interaktion mit
dem Zielprogramm, GDB Integration, Verarbeitung von Binärdaten und
Datenformaten (wie z.B. das ELF Format für Linux Programme).

### Analyse von demo1_reversing

Dieses Programm erwartet zwei Eingaben:

1. Die Adresse der Funktion `find_me`
2. Ein Passwort

Das Ziel hier ist es richtige Eingabewerte für Beides zu finden.

**Schritt 1**

* Finden der `find_me` Adresse
    * In der Cutter GUI
    * Mit `objdump -D demo1_reversing | grep find_me`
* Wie können wir den Wert jetzt eingeben?
    * Little-Endian Format des Integers
    * Eingabe mittels Python one-liner `python -c "print('\xef\xbe\xad\xde')"`
* Scripting mittels pwntools um es zu vereinfachen:
    * Verwendung der `p32` Funktion um Little Endian einzugeben

**Schritt 2**

* Finden des Passwortes?
    * Mit dem Debugger GDB (breakpoint auf `strcmp` Aufruf)
    * Statisch mit Cutter


## Demo 2 - Vulnerable Program / Buffer Overflow

Wir können die Tools verwenden um eine Schwachstelle (einen Buffer Overflow) in
einem einfachen Programm zu analysieren. In diesem Fall analysieren wir ein
Programm, welches die `scanf` Funktion verwendet mit der `%s` Formatierung.
Hier kommt es automatisch zu einem Buffer Overflow, da `scanf` die Größe des
Ziel Strings nicht kennt. Legacy-String Funktionen in C gehen davon aus, dass
genügend Platz vorhanden ist. Der String wird nicht automatisch vergrößert.

Wir können iterativ Vorgehen um die Schwachstelle zu analysieren:

* Wir schicken zuerst einen normalen Input.
* Wir schicken einen Input der größer ist als der Ziel String / Buffers.
* Wir schicken einen Input der größer ist und gezielt etwas überschreibt.
    * z.B. eine lokale Variable
    * oder die Return Adresse

...und beobachten dabei das Verhalten des Programms im Debugger.
