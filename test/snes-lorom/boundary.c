#include <snes-lorom.h>
#include <stdint.h>

SNES_LOROM_BANK(0) const uint8_t bank0_data[] = {0x00, 0x10, 0x20, 0x30};
SNES_LOROM_BANK(1) const uint8_t bank1_data[] = {0x01, 0x11, 0x21, 0x31};
SNES_LOROM_BANK(126) const uint8_t bank126_data[] = {0x7e, 0x12, 0x34, 0x56};
SNES_LOROM_BANK(127) const uint8_t bank127_data[] = {0x7f, 0x12, 0x34, 0x56};

int main(void) { return bank0_data[0]; }
