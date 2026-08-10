#include <snes-hirom.h>
#include <stdint.h>

SNES_HIROM_BANK(0) const uint8_t bank0_data[] = {0x01, 0x23, 0x45, 0x67};
SNES_HIROM_BANK(1) const uint8_t bank1_data[] = {0x11, 0x22, 0x33, 0x44};
SNES_HIROM_BANK(3) const uint8_t bank3_data[] = {0xaa, 0xbb, 0xcc, 0xdd};

int main(void) {
  if (snes_hirom_read8(SNES_HIROM_ADDRESS(0, bank0_data)) != 0x01) {
    return 1;
  }
  if (snes_hirom_read8(SNES_HIROM_ADDRESS(1, bank1_data)) != 0x11) {
    return 1;
  }
  if (snes_hirom_read8(SNES_HIROM_ADDRESS(3, bank3_data)) != 0xaa) {
    return 1;
  }
  return 0;
}
