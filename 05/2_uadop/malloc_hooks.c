/************************************
 * Lecture Secure Software Systems
 * University of Duisburg-Essen
 *
 * https://www.syssec.wiwi.uni-due.de
 ************************************/


/**
 * Hook calls to `malloc` etc. to print out parameters
 *
 * (similar to `ltrace -e 'malloc,realloc,free'`)
 */

#include <stdbool.h>
#include <stdio.h>

bool disable_hooks = false;

void* __libc_malloc(size_t size);
void* malloc(size_t size)
{
  void* result;
  result = __libc_malloc(size);
  if (!disable_hooks) {
    disable_hooks = true;
    printf("\n[DEBUG] malloc(%u) = %p\n", (unsigned int)size, result);
    disable_hooks = false;
  }
  return result;
}

void __libc_free(void* ptr);
void free(void* ptr)
{
  if (!disable_hooks) {
    disable_hooks = true;
    printf("\n[DEBUG] free(%p)\n", ptr);
    disable_hooks = false;
  }
  __libc_free(ptr);
}

void* __libc_realloc(void* ptr, size_t sz);
void* realloc(void* ptr, size_t size)
{
  void* result;
  result = __libc_realloc(ptr, size);
  if (!disable_hooks) {
    disable_hooks = true;
    printf("\n[DEBUG] realloc(%p, %zd) = %p\n", ptr, size, result);
    disable_hooks = false;
  }
  return result;
}
