#ifndef LLVM_MOS_SNES_HIROM_H
#define LLVM_MOS_SNES_HIROM_H

#include <snes.h>

/*
 * Place ROM data at a mapper-specific 64 KiB HiROM bank index. Bank zero's
 * upper half shares space with normal program code; banks 1-63 are entirely
 * available to explicitly placed data when __rom_size (in KiB) is large
 * enough. Explicitly placed assets are retained even if otherwise unreachable.
 * Invalid bank sections are rejected by the linker.
 */
#define SNES_HIROM_STRINGIFY_IMPL(value) #value
#define SNES_HIROM_STRINGIFY(value) SNES_HIROM_STRINGIFY_IMPL(value)
#define SNES_HIROM_BANK(bank)                                                 \
  __attribute__((used, section(".rom_bank" SNES_HIROM_STRINGIFY(bank))))

/* Pair bank 0-63 with an object's 16-bit bank-local address. */
#define SNES_HIROM_ADDRESS(bank, object)                                      \
  snes_make_rom_address((bank), (uint16_t)(object))

/** Read one byte using HiROM bank 0-63 and any 16-bit bank-local address. */
uint8_t snes_hirom_read8_impl(uint8_t bank, uint16_t address);
static inline uint8_t snes_hirom_read8(snes_rom_address_t source) {
  return snes_hirom_read8_impl(source.bank, source.address);
}

#endif
