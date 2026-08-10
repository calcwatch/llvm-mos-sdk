#ifndef LLVM_MOS_SNES_H
#define LLVM_MOS_SNES_H

#include <stdint.h>

#define SNES_INIDISP ((volatile uint8_t *)0x2100)
#define SNES_OBSEL   ((volatile uint8_t *)0x2101)
#define SNES_OAMADDL ((volatile uint8_t *)0x2102)
#define SNES_OAMADDH ((volatile uint8_t *)0x2103)
#define SNES_OAMDATA ((volatile uint8_t *)0x2104)
#define SNES_BGMODE  ((volatile uint8_t *)0x2105)
#define SNES_MOSAIC  ((volatile uint8_t *)0x2106)
#define SNES_BG1SC   ((volatile uint8_t *)0x2107)
#define SNES_BG12NBA ((volatile uint8_t *)0x210b)
#define SNES_BG1HOFS ((volatile uint8_t *)0x210d)
#define SNES_BG1VOFS ((volatile uint8_t *)0x210e)
#define SNES_VMAIN   ((volatile uint8_t *)0x2115)
#define SNES_VMADDL  ((volatile uint8_t *)0x2116)
#define SNES_VMADDH  ((volatile uint8_t *)0x2117)
#define SNES_VMDATAL ((volatile uint8_t *)0x2118)
#define SNES_VMDATAH ((volatile uint8_t *)0x2119)
#define SNES_CGADD   ((volatile uint8_t *)0x2121)
#define SNES_CGDATA  ((volatile uint8_t *)0x2122)
#define SNES_TM      ((volatile uint8_t *)0x212c)
#define SNES_TS      ((volatile uint8_t *)0x212d)
#define SNES_CGWSEL  ((volatile uint8_t *)0x2130)
#define SNES_CGADSUB ((volatile uint8_t *)0x2131)
#define SNES_SETINI  ((volatile uint8_t *)0x2133)

#define SNES_NMITIMEN ((volatile uint8_t *)0x4200)
#define SNES_WRIO     ((volatile uint8_t *)0x4201)
#define SNES_MDMAEN   ((volatile uint8_t *)0x420b)
#define SNES_HDMAEN   ((volatile uint8_t *)0x420c)
#define SNES_MEMSEL   ((volatile uint8_t *)0x420d)
#define SNES_RDNMI    ((volatile uint8_t *)0x4210)
#define SNES_HVBJOY   ((volatile uint8_t *)0x4212)
#define SNES_JOY1L    ((volatile uint8_t *)0x4218)
#define SNES_JOY1H    ((volatile uint8_t *)0x4219)

#define SNES_DMAP0 ((volatile uint8_t *)0x4300)
#define SNES_BBAD0 ((volatile uint8_t *)0x4301)
#define SNES_A1T0L ((volatile uint8_t *)0x4302)
#define SNES_A1T0H ((volatile uint8_t *)0x4303)
#define SNES_A1B0  ((volatile uint8_t *)0x4304)
#define SNES_DAS0L ((volatile uint8_t *)0x4305)
#define SNES_DAS0H ((volatile uint8_t *)0x4306)

#define SNES_INIDISP_FORCE_BLANK 0x80
#define SNES_NMITIMEN_NMI_ENABLE 0x80
#define SNES_NMITIMEN_JOYPAD_ENABLE 0x01

#define SNES_RDNMI_NMI_FLAG 0x80

/* Mapper-specific ROM bank index plus a 16-bit bank-local address. */
typedef struct {
  uint8_t bank;
  uint16_t address;
} snes_rom_address_t;

/*
 * Low-level constructor. Mapping-specific range validation occurs when an
 * address is consumed; LoROM and HiROM have different valid local addresses.
 */
static inline snes_rom_address_t snes_make_rom_address(uint8_t bank,
                                                        uint16_t address) {
  snes_rom_address_t result = {bank, address};
  return result;
}

/*
 * Cartridge vectors use these weak default handlers. C overrides must retain
 * the interrupt ABI so the compiler emits RTI rather than an ordinary RTS.
 */
__attribute__((interrupt)) void nmi(void);
__attribute__((interrupt)) void irq(void);
__attribute__((interrupt)) void cop(void);
__attribute__((interrupt)) void brk(void);
__attribute__((interrupt)) void abort(void);

/*
 * Cartridge-mapping declarations are provided by <snes-lorom.h> and
 * <snes-hirom.h>.
 */
#endif
