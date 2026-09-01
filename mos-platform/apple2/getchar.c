#include <stdio.h>

extern unsigned char __APPLE2_RDKEY(void) __attribute__((leaf));

__attribute__((always_inline, weak)) int __to_ascii(void *ctx,
                                                    int (*read)(void *ctx)) {
  int c = read(ctx);
  return c == '\r' ? '\n' : c;
}

int __getchar(void) {
  return __APPLE2_RDKEY() & 0x7f;
}
