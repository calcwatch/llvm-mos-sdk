#include <snes-hirom.h>
SNES_HIROM_BANK(64) const unsigned char invalid[] = {1};
int main(void) { return invalid[0]; }
