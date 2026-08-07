/* The reset stub goes at the end of whatever is still free in prg_rom_fixed,
 * but never below 0xe000: in the banked-8 and mode-0 layouts only the topmost
 * 8 KiB of the fixed area is guaranteed to be mapped at reset.
 *
 * .reset_pos captures the region's next free address.  The location counter
 * cannot be used for this in an output section's address expression, because
 * `.` is global and is not rebased onto the section's memory region -- it holds
 * the end of the last output section laid out, whatever region that was in.  In
 * an output section *body* `.` is the section's own address, which does come
 * from the region, so an empty section allocated to prg_rom_fixed records the
 * value .reset needs.  It emits no bytes, and survives lld's empty-section
 * pruning because it defines a symbol.  See nes/dpcm.ld for the full story. */
SECTIONS {
  .reset_pos : { __reset_pos = .; } >prg_rom_fixed

  .reset MAX(__reset_pos, 0xe000) : {
    *(.reset .reset.*)
  } >prg_rom_fixed
  .vectors 0xfffa : {
    SHORT(nmi) SHORT(_reset) SHORT(irq)
  } >prg_rom_fixed
}
