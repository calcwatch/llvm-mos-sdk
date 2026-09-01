.include "apple2.inc"

.global _Exit

.section .text._Exit,"ax",@progbits
_Exit:
  ; Invalidate the power-up byte before returning to ProDOS's dispatcher.
  inc APPLE2_POWERUP_BYTE

  ; ProDOS QUIT ($65), with the required seven-byte parameter table.
  jsr PRODOS_MLI
  .byte $65
  .short quit_params

  ; QUIT does not return.
1:
  jmp 1b

.section .rodata.quit_params,"a",@progbits
quit_params:
  .byte 4, 0, 0, 0, 0, 0, 0
