; x86 asm library

global exit
global memset

global write
global read
global strlen

section .text

; void exit(int);
exit:
  ; system call number
  mov eax, 0x1
  ; load first parameter
  mov ebx, [esp + 4]
  ; perform system call
  int 0x80


; size_t write(int fd, void* buf, size_t count);
write:
  ; -------
  ; TODO: Add your implementation here
  ;ud2 ; will crash the program, remove it
  MOV EAX, 0x4; Typ des System Calls auf "Schreiben" festlegen
  MOV EBX, [ESP+0x8]; 1. Argument nach EBX laden
  MOV ECX, [ESP+0xC]; 2. Argument nach ECX laden
  MOV EDX, [ESP+0x10]; 3. Argument nach EDX laden
  INT 0x80; System Call ausführen
  MOV ESP, EBP; Schiebe den Stack-Pointer zurück
  POP EBP 


  ; -------
  ret 

; size_t read(int fd, void* buf, size_t count);
read:
  ; -------
  ; TODO: Add your implementation here
  ;ud2 ; will crash the program, remove it
  MOV EAX, 0x3; Typ des System Calls auf "Lesen" festlegen
  MOV EBX, [ESP+0x8]; 1. Argument nach EBX laden
  MOV ECX, [ESP+0xC]; 2. Argument nach ECX laden
  MOV EDX, [ESP+0x10]; 3. Argument nach EDX laden
  INT 0x80; System Call ausführen
  MOV ESP, EBP; Schiebe den Stack-Pointer zurück
  POP EBP 

  ; -------
  ret


;void* memset(void* s, int c, size_t n);
memset:
  push ebp                  ; prologue
  mov ebp, esp
  mov ecx, 0                ; initialize counter ecx with 0
  mov edx, [ebp + 8]        ; load s
  mov eax, [ebp + 12]       ; load c
_memset_loop_check:
  cmp ecx, [ebp + 16]       ; compare ecx with n
  je _memset_loop_end       ; "break" if ecx == n
_memset_loop_body:
  mov byte [edx + ecx], al  ; *(s + ecx) = c
  inc ecx                   ; ecx++
  jmp _memset_loop_check    ; eval loop condition again
_memset_loop_end:
  mov eax, [ebp + 8]        ; simply return s in eax
  mov esp, ebp              ; epilogue
  pop ebp
  ret


; unsigned int strlen(char* s);
strlen:
  push ebp
  mov ebp, esp
  push ebx  ; callee-saved register, must be restored before return
  ; -------
  ; EBX ist 1. Argument, nämlich char* s, welches auf den Stack gepusht wird
  ; TODO: Add your implementation of strlen here
  ;ud2 ; will crash the program, remove it

    MOV EAX, [EBP + 8]  ;Zeiger auf das 1. Argument
    XOR ECX, ECX        ;Zähler auf 0 setzen 

  .iterate_through_string:
    CMP BYTE [EAX+ECX], 0x0; Prüfe, ob es der \0 String-Terminator war
    JE .finalize_strlen; Falls ja: Verlasse die Schleife
    INC ECX; Inkrementiere die Ausgabe um 1
    JMP .iterate_through_string; Falls am Stack Pointer kein \0 String-Terminator war, wiederhole am nächsten Zeichen
  
  .finalize_strlen:
  MOV EAX, ECX; Ausgabe des Ergebnisses der Zählung
  ; -------
  pop ebx
  mov esp, ebp
  pop ebp
  ret
