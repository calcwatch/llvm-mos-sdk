#include <snes-hirom.h>
#include <stdint.h>

SNES_HIROM_BANK(0) const uint8_t bank0_data[] = {0x00, 0x10, 0x20, 0x30};
SNES_HIROM_BANK(1) const uint8_t bank1_data[] = {0x01, 0x11, 0x21, 0x31};
SNES_HIROM_BANK(63) const uint8_t bank63_data[] = {0x3f, 0x12, 0x34, 0x56};

int main(void) { return bank0_data[0]; }
