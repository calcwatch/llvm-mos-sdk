#include <stdio.h>

__attribute__((always_inline, weak)) int
__from_ascii(char c, void *ctx, int (*write)(char c, void *ctx)) {
  if (c == '\n')
    return write('\r', ctx);
  return write(c, ctx);
}

void __putchar(char c) {
  /* Monitor COUT uses high-bit-set screen characters. */
  c |= 0x80;
  asm volatile("jsr $fded" : "+a"(c) : : "x", "y", "p");
}
