#include <snes-lorom.h>
SNES_LOROM_BANK(128) const unsigned char invalid[] = {1};
int main(void) { return invalid[0]; }
