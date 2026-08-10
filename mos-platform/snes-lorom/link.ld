/* SNES slow-ROM LoROM cartridge linker script. */

__rc0 = 0x0000;
INCLUDE imag-regs.ld
ASSERT(__rc31 == 0x001f, "Inconsistent direct-page map.")

PROVIDE(__rom_region = 1); /* North America / NTSC */
PROVIDE(__rom_version = 0);
PROVIDE(__rom_size = 32);  /* ROM image size in KiB. */
ASSERT(__rom_size >= 32 && __rom_size <= 4096,
       "SNES LoROM size must be between 32 and 4096 KiB.")
ASSERT(__rom_size == 1 << LOG2CEIL(__rom_size),
       "SNES LoROM size must be a power of two.")

MEMORY {
  zp (rw)       : ORIGIN = __rc31 + 1, LENGTH = 0x0100 - (__rc31 + 1)
  ram (rw)      : ORIGIN = 0x0200, LENGTH = 0x1e00
  rom (rx)      : ORIGIN = 0x8000, LENGTH = 0x7fb0
  header (r)    : ORIGIN = 0xffb0, LENGTH = 0x0030
  vectors (r)   : ORIGIN = 0xffe0, LENGTH = 0x0020
}

/*
 * Physical LoROM bank 0 is the first 32 KiB of the file. Ordinary code,
 * explicitly placed bank-0 data, the cartridge header, and vectors occupy
 * separate regions within its $00:8000-$00:FFFF CPU-bank mirror. The explicit
 * regions ensure banked data cannot consume the header or vectors.
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

  .rom_bank0 : { KEEP(*(.rom_bank0 .rom_bank0.*)) } >rom

  .header : {
    QUAD(0) QUAD(0)
    BYTE(0x4c) BYTE(0x4c) BYTE(0x56) BYTE(0x4d) BYTE(0x2d)
    BYTE(0x4d) BYTE(0x4f) BYTE(0x53) BYTE(0x20) BYTE(0x53)
    BYTE(0x4e) BYTE(0x45) BYTE(0x53) BYTE(0x20) BYTE(0x4c)
    BYTE(0x4f) BYTE(0x52) BYTE(0x4f) BYTE(0x4d) BYTE(0x20) BYTE(0x20)
    BYTE(0x20)                  /* SlowROM LoROM mapping. */
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

  /* Any bank outside 0-127 remains unmatched until here and is an error. */
  .rom_bank_invalid : { KEEP(*(.rom_bank*)) } >rom
  ASSERT(SIZEOF(.rom_bank_invalid) == 0,
         "Invalid SNES LoROM bank section; valid banks are 0-127.")
}

__stack = 0x2000;

OUTPUT_FORMAT {
  FULL(rom)
  FULL(header)
  FULL(vectors)
  INCLUDE banked-output.ld
}
