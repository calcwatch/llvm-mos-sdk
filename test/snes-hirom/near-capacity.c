#include <snes-hirom.h>
SNES_HIROM_BANK(0) const unsigned char bank0_lower_near_capacity[0x7ff0] = {1};
__attribute__((retain)) const unsigned char program_near_capacity[0x7e00] = {2};
int main(void) { return bank0_lower_near_capacity[0] + program_near_capacity[0]; }
