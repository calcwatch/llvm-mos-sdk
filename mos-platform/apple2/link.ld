/* Apple II ProDOS 8 system-program linker script.
 *
 * ProDOS loads SYS ($ff) files at $2000. The largest system program the
 * ProDOS 8 Technical Reference permits is $8f00 bytes. The remaining memory
 * below ProDOS's $bf00 global page is used for the LLVM-MOS software stack.
 */

/*
 * ProDOS and its disk drivers use $3a-$4e, but leave $00-$1f available to
 * system programs.  Keep the rest of the compiler-allocated zero page at
 * $60 so it also remains clear of the Monitor workspace.
 */
__rc0 = 0x00;
INCLUDE imag-regs.ld
ASSERT(__rc31 == 0x1f, "Inconsistent zero page map.")

MEMORY {
    zp : ORIGIN = 0x60, LENGTH = 0xa0
    ram (rw) : ORIGIN = 0x2000, LENGTH = 0x8f00
}

REGION_ALIAS("c_readonly", ram)
REGION_ALIAS("c_writeable", ram)

/*
 * A SYS file has no header or entry-point field: ProDOS jumps directly to
 * $2000. Keep the three-byte entry stub first in the load image, followed by
 * the normal C sections. In particular, initialized zero-page data must not
 * precede the entry stub in the output file.
 */
SECTIONS {
    .sys_entry : { KEEP(*(.sys_entry)) } >ram
    INCLUDE text.ld
    INCLUDE rodata.ld
    INCLUDE data.ld
    INCLUDE zp.ld
    INCLUDE bss.ld
    INCLUDE noinit.ld
}
ASSERT(ADDR(.sys_entry) == ORIGIN(ram),
       "ProDOS SYS entry point must be $2000.")
ASSERT(SIZEOF(.sys_entry) == 3,
       "ProDOS SYS entry must be a three-byte JMP.")

/* The soft stack grows down through the $af00-$beff area. */
__stack = 0xbf00;

OUTPUT_FORMAT { TRIM(ram) }
