; SNES native-mode startup for the LLVM-MOS 65816 ABI.

.section .init.10,"ax",@progbits
  sei
  clc
  xce             ; Enter 65C816 native mode.

  rep #$30        ; Temporarily select 16-bit A, X, and Y.
  ; LLVM's integrated assembler does not track REP/SEP register widths, so
  ; spell the two 16-bit immediate instructions explicitly.
  .byte $a9, $00, $00 ; lda #$0000
  tcd             ; LLVM-MOS imaginary registers occupy direct page zero.
  .byte $a2, $ff, $1f ; ldx #$1fff
  txs             ; The 65816 hardware stack grows down from $1FFF.
                  ; The common CRT initializes LLVM-MOS's software stack.

  sep #$30        ; LLVM-MOS currently expects 8-bit A, X, and Y.
  lda #$00
  pha
  plb             ; Data bank zero: MMIO and the low WRAM mirror are addressable.
  cld

  stz $4200       ; Disable NMI, joypad auto-read, and H/V IRQs.
  lda #$80
  sta $2100       ; Force blank while C initializes the PPU.

.text
.weak nmi
nmi:
  rti

.weak irq
irq:
  rti

.weak cop
cop:
  rti

.weak brk
brk:
  rti

.weak abort
abort:
  rti
