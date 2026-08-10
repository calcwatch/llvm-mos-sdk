#include <snes-hirom.h>
SNES_HIROM_BANK(0) const unsigned char too_large[0x8001] = {1};
int main(void) { return too_large[0]; }
