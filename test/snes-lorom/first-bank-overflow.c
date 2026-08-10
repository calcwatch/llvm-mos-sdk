#include <snes-lorom.h>
SNES_LOROM_BANK(0) const unsigned char too_large[0x7fb1] = {1};
int main(void) { return too_large[0]; }
