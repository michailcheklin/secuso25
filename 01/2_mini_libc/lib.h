// The followig functions are implemented in the assembler file lib.asm

typedef unsigned int size_t;

/* write() writes up to count bytes from the buffer pointed
 * buf to the file referred to by the file descriptor fd.
 */
size_t write(int fd, const void *buf, size_t count);

/* read() attempts to read up to count bytes from file
 * descriptor fd into the buffer starting at buf.
 */
size_t read(int fd, void *buf, size_t count);

/* The  strlen()  function  calculates  the  length  of the string pointed to
 * by s, excluding the terminating null byte ('\0').
 */
unsigned int strlen(const char* s);

/* Terminate the calling process with exit code n */
void exit(int n);

/* fill the buffer pointed to by s, with the byte-value of c
 * n is the length of the buffer
 */
void* memset(void* s, int c, size_t n);
