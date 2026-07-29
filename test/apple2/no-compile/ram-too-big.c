// ExpectFailure: ld.lld: error: section '.data' will not fit in region 'ram'

#include <stdint.h>

uint8_t ram_too_big0[30 * 1024] = {0x55};
uint8_t ram_too_big1[10 * 1024] = {0xaa};

int main(void) {
  asm volatile("" : : "r"(ram_too_big0));
  asm volatile("" : : "r"(ram_too_big1));
}
