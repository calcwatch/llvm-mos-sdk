.include "imag.inc"

; Internal implementation for snes_lorom_read8().
; The LLVM-MOS W65816 C ABI passes bank in A, address low in X, and address
; high in __rc2.
.text
.globl snes_lorom_read8_impl
snes_lorom_read8_impl:
  cmp #$80
  bcs .Linvalid
  bit __rc2       ; LoROM bank-local addresses must be $8000-$FFFF.
  bpl .Linvalid
  phb
  ora #$80       ; Use the $80-$FF LoROM mirror, avoiding WRAM banks $7E-$7F.
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
