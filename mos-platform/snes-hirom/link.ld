/* SNES slow-ROM HiROM cartridge linker script. */

__rc0 = 0x0000;
INCLUDE imag-regs.ld
ASSERT(__rc31 == 0x001f, "Inconsistent direct-page map.")

PROVIDE(__rom_region = 1); /* North America / NTSC */
PROVIDE(__rom_version = 0);
PROVIDE(__rom_size = 64);  /* ROM image size in KiB. */
ASSERT(__rom_size >= 64 && __rom_size <= 4096,
       "SNES HiROM size must be between 64 and 4096 KiB.")
ASSERT(__rom_size == 1 << LOG2CEIL(__rom_size),
       "SNES HiROM size must be a power of two.")

MEMORY {
  zp (rw)       : ORIGIN = __rc31 + 1, LENGTH = 0x0100 - (__rc31 + 1)
  ram (rw)      : ORIGIN = 0x0200, LENGTH = 0x1e00
  rom_bank0 (r) : ORIGIN = 0xc00000, LENGTH = 0x8000
  rom (rx)      : ORIGIN = 0x8000, LENGTH = 0x7fb0
  header (r)    : ORIGIN = 0xffb0, LENGTH = 0x0030
  vectors (r)   : ORIGIN = 0xffe0, LENGTH = 0x0020
}

/*
 * HiROM physical bank 0 is deliberately assembled from two CPU address
 * ranges that are adjacent in the output file:
 *
 *   $C0:0000-$C0:7FFF  explicitly placed bank-0 ROM data
 *   $00:8000-$00:FFAF  ordinary C code/rodata through the HiROM mirror
 *   $00:FFB0-$00:FFFF  cartridge header and vectors
 *
 * Keeping these as separate regions prevents ordinary or banked data from
 * consuming the header/vector space.
 */

INCLUDE banked-rom.ld

REGION_ALIAS("c_readonly", rom)
REGION_ALIAS("c_writeable", ram)

SECTIONS {
  .text : { INCLUDE text-sections.ld } >c_readonly
  INCLUDE rodata.ld
  INCLUDE data.ld
  INCLUDE zp.ld
  INCLUDE bss.ld
  INCLUDE noinit.ld

  .rom_bank0 : { KEEP(*(.rom_bank0 .rom_bank0.*)) } >rom_bank0

  .header : {
    QUAD(0) QUAD(0)
    BYTE(0x4c) BYTE(0x4c) BYTE(0x56) BYTE(0x4d) BYTE(0x2d)
    BYTE(0x4d) BYTE(0x4f) BYTE(0x53) BYTE(0x20) BYTE(0x53)
    BYTE(0x4e) BYTE(0x45) BYTE(0x53) BYTE(0x20) BYTE(0x48)
    BYTE(0x49) BYTE(0x52) BYTE(0x4f) BYTE(0x4d) BYTE(0x20) BYTE(0x20)
    BYTE(0x21)                  /* SlowROM HiROM mapping. */
    BYTE(0x00)                  /* ROM only. */
    BYTE(LOG2CEIL(__rom_size))  /* ROM size as 2^N KiB. */
    BYTE(0x00)                  /* No cartridge RAM. */
    BYTE(__rom_region)
    BYTE(0x00)
    BYTE(__rom_version)
    SHORT(0xffff)
    SHORT(0x0000)
  } >header

  .vectors : {
    LONG(0)
    SHORT(cop) SHORT(brk) SHORT(abort) SHORT(nmi) SHORT(0) SHORT(irq)
    LONG(0)
    SHORT(cop) SHORT(0) SHORT(abort) SHORT(nmi) SHORT(_start) SHORT(irq)
  } >vectors

  /* Any bank outside 0-63 remains unmatched until here and is an error. */
  .rom_bank_invalid : { KEEP(*(.rom_bank*)) } >rom
  ASSERT(SIZEOF(.rom_bank_invalid) == 0,
         "Invalid SNES HiROM bank section; valid banks are 0-63.")
}

__stack = 0x2000;

OUTPUT_FORMAT {
  FULL(rom_bank0)
  FULL(rom)
  FULL(header)
  FULL(vectors)
  INCLUDE banked-output.ld
}
