/* Section commands for DPCM. These are kept separate, since they should come
 * very late in the ROM. */

/* .dpcm must begin at whatever is still free in c_readonly, rounded up to the
 * 64-byte granularity of the APU's DPCM sample address register, and never
 * below 0xc000, the CPU window samples are fetched through.
 *
 * The obvious way to write "whatever is still free in c_readonly" is the
 * location counter, and this file used to do exactly that:
 *
 *   .dpcm (ABSOLUTE(.) < 0xc000 ? 0xc000 : ALIGN(64)) : { ... } >c_readonly
 *
 * That is wrong. `.` is a single global value and is never rebased onto a
 * section's memory region, so in an output section's *address expression* it
 * holds the end of whichever output section was laid out last -- for a banked
 * ROM, typically a .prg_rom_N in an unrelated region, tens of KiB away.  It
 * only appeared to work because lld used to overwrite `.` with the region's
 * next free address before evaluating the expression; that was an lld-ism, and
 * llvm/llvm-project#197293 removed it to match GNU ld, which has always
 * behaved this way.  See the release note under "Breaking changes" for LLD 24.
 *
 * Inside an output section's *body* `.` does start at the address the section
 * was handed by its region, since that is simply the section's own address.  So
 * an empty section allocated to c_readonly records the region's next free
 * address, which .dpcm can then use.  .dpcm_pos holds no data and contributes
 * no bytes to the ROM; it exists only to be a place where `.` means what is
 * needed here.  It survives lld's empty-section pruning because it defines a
 * symbol.
 *
 * Aligning before clamping is safe in either order: 0xc000 is itself a multiple
 * of 64, so the result is 64-byte aligned no matter which term wins. */
SECTIONS {
  .dpcm_pos : { __dpcm_pos = .; } >c_readonly

  .dpcm MAX(ALIGN(__dpcm_pos, 64), 0xc000) : {
       __dpcm_start = .;
       KEEP(*(.dpcm .dpcm.*))
  } >c_readonly
  PROVIDE(__dpcm_offset = (__dpcm_start - 0xc000) >> 6);
}
