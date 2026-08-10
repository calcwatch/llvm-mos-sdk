#include <snes-lorom.h>
SNES_LOROM_BANK(0) const unsigned char bank0_near_capacity[0x7e00] = {1};
int main(void) { return bank0_near_capacity[0]; }
