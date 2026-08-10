__attribute__((used, section(".rom_bankbanana")))
const unsigned char malformed_bank[] = {1};
int main(void) { return malformed_bank[0]; }
