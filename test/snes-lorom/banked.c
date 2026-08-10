#include <snes-lorom.h>
#include <stdint.h>

SNES_LOROM_BANK(1) const uint8_t bank1_data[] = {0x11, 0x22, 0x33, 0x44};
SNES_LOROM_BANK(3) const uint8_t bank3_data[] = {0xaa, 0xbb, 0xcc, 0xdd};

int main(void) {
  if (snes_lorom_read8(SNES_LOROM_ADDRESS(1, bank1_data)) != 0x11) {
    return 1;
  }
  if (snes_lorom_read8(SNES_LOROM_ADDRESS(3, bank3_data)) != 0xaa) {
    return 1;
  }
  return 0;
}
