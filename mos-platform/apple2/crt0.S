.include "apple2.inc"
.include "imag.inc"

; ProDOS loads a system program at $2000 and jumps directly to it.
.section .sys_entry,"ax",@progbits
  jmp _start

; Establish the state required of a ProDOS system program.
.section .init.050,"ax",@progbits
  ; ProDOS recommends a fresh hardware stack at the warm-start entry point.
  ldx #$ff
  txs

  ; Claim $2000-$beff in ProDOS's system bitmap. This includes the linked
  ; image and the software stack.
  lda #$ff
  ldx #$13
1:
  sta PRODOS_SYSTEM_BITMAP + 4,x
  dex
  bpl 1b

  ; This platform ABI is version zero for now.
  lda #$00
  sta PRODOS_SYSTEM_VERSION

  ; Restore the Monitor ROM's keyboard and 40-column display links (the
  ; firmware equivalents of IN#0 and PR#0) before using RDKEY or COUT.
  jsr APPLE2_SETKBD
  jsr APPLE2_SETVID

  ; Control-Reset should leave the program through ProDOS, not return to an
  ; interrupted C context. The power-up byte validates the vector high byte.
  lda #mos16lo(__apple2_reset)
  sta APPLE2_RESET_VECTOR
  lda #mos16hi(__apple2_reset)
  sta APPLE2_RESET_VECTOR + 1
  eor #$a5
  sta APPLE2_POWERUP_BYTE

.section .text.__apple2_reset,"ax",@progbits
__apple2_reset:
  ldx #$ff
  txs
  jmp _Exit
