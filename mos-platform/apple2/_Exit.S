.global _Exit

; Establish the state required of a ProDOS system program. Keep this in the
; same object as _Exit so archive extraction always includes it.
.section .init.050,"ax",@progbits
  ; ProDOS recommends a fresh hardware stack at the warm-start entry point.
  ldx #$ff
  txs

  ; Claim $2000-$beff in ProDOS's system bitmap. This includes the linked
  ; image and the software stack.
  lda #$ff
  ldx #$13
1:
  sta $bf58 + 4,x
  dex
  bpl 1b

  ; This platform ABI is version zero for now.
  lda #$00
  sta $bffd

  ; A system program may have been launched by another interpreter whose
  ; input/output vectors point into the program image that ProDOS just
  ; replaced. Restore the Monitor ROM's keyboard and 40-column display links
  ; (the firmware equivalents of IN#0 and PR#0) before using RDKEY or COUT.
  jsr $fe89
  jsr $fe93

.section .text._Exit,"ax",@progbits
_Exit:
  ; Invalidate the power-up byte before returning to ProDOS's dispatcher.
  inc $03f4

  ; ProDOS QUIT ($65), with the required seven-byte parameter table.
  jsr $bf00
  .byte $65
  .short quit_params

  ; QUIT does not return.
2:
  jmp 2b

.section .rodata.quit_params,"a",@progbits
quit_params:
  .byte 4, 0, 0, 0, 0, 0, 0
