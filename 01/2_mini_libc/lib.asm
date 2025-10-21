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
  ud2 ; will crash the program, remove it

  ; -------
  ret

; size_t read(int fd, void* buf, size_t count);
read:
  ; -------
  ; TODO: Add your implementation here
  ud2 ; will crash the program, remove it

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
  ; TODO: Add your implementation of strlen here
  ud2 ; will crash the program, remove it

  ; -------
  pop ebx
  mov esp, ebp
  pop ebp
  ret
