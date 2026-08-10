.include "imag.inc"

; Internal implementation for snes_hirom_read8().
; The LLVM-MOS W65816 C ABI passes bank in A, address low in X, and address
; high in __rc2.
.text
.globl snes_hirom_read8_impl
snes_hirom_read8_impl:
  cmp #$40
  bcs .Linvalid
  phb
  ora #$c0       ; Mapper bank indices are mapped linearly at CPU $C0-$FF.
  pha
  plb
  stx __rc18
  lda __rc2
  sta __rc19
  lda (__rc18)
  plb
  rts
.Linvalid:
  lda #$00
  rts
