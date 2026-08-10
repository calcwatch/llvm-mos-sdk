#include <snes.h>
#include <stdint.h>

int main(void) {
  uint16_t color = 0;

  *SNES_CGADD = 0;
  *SNES_CGDATA = 0;
  *SNES_CGDATA = 0;
  *SNES_INIDISP = 0x0f;

  for (;;) {
    while (!(*SNES_RDNMI & SNES_RDNMI_NMI_FLAG)) {
    }
    ++color;
    *SNES_CGADD = 0;
    *SNES_CGDATA = color;
    *SNES_CGDATA = color >> 8;
  }
}
