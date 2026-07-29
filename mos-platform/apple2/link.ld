/* Apple II ProDOS 8 system-program linker script.
 *
 * ProDOS loads SYS ($ff) files at $2000. The largest system program the
 * ProDOS 8 Technical Reference permits is $8f00 bytes. The remaining memory
 * below ProDOS's $bf00 global page is used for the LLVM-MOS software stack.
 */

/* ProDOS reserves $00-$3f. */
__rc0 = 0x40;
INCLUDE imag-regs.ld
ASSERT(__rc31 == 0x5f, "Inconsistent zero page map.")

MEMORY {
    zp : ORIGIN = __rc31 + 1, LENGTH = 0x100 - (__rc31 + 1)
    ram (rw) : ORIGIN = 0x2000, LENGTH = 0x8f00
}

REGION_ALIAS("c_readonly", ram)
REGION_ALIAS("c_writeable", ram)

/*
 * A SYS file has no header or entry-point field: ProDOS jumps directly to
 * $2000. Keep .text first in the load image. In particular, the generic c.ld
 * order puts the load image for initialized zero-page data before .text,
 * which would make ProDOS execute that data as code.
 */
SECTIONS {
    INCLUDE text.ld
    INCLUDE rodata.ld
    INCLUDE data.ld
    INCLUDE zp.ld
    INCLUDE bss.ld
    INCLUDE noinit.ld
}
ASSERT(_start == ORIGIN(ram), "ProDOS SYS entry point must be $2000.")

/* The soft stack grows down through the $af00-$beff area. */
__stack = 0xbf00;

OUTPUT_FORMAT { TRIM(ram) }
