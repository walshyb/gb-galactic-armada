INCLUDE "src/main/utils/hardware.inc"

SECTION "Interrupts", ROM0

DisableInterrupts::
  ld a, 0
  ldh [rSTAT], a
  di
  ret

InitStatInterrupts::
  ld a, IEF_STAT
  ldh [rIE], a
  xor a, a ; equivalent to ld a, 0
  ldh [rIF], a
  ei

  ; Makes our stat interrupts occur when
  ; current scaline is equal to the rLYC register
  ld a, STATF_LYC
  ldh [rSTAT], a

  ; We'll start with the first scanline
  ; the first stat interrupt will call the next time rLY = 0
  ld a, 0
  ldh [rLYC], a
  ret

; define new section and hard-code it to be at $0048
SECTION "Stat Interrupt", ROM0[$0048]
StatInterrupt:
  push af

  ; Check if we're on first scanline
  ldh a, [rLYC]
  cp 0
  jp z, LYCEqualsZero

LYCEquals8:
  ; don't call next interrupt until scanline 0
  ld a, 0
  ldh [rLYC], a
  
  ; Turn the LCD on including sprites. But no window
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINOFF | LCDCF_WIN9C00
  ldh [rLCDC], a

	jp EndStatInterrupts

LYCEqualsZero:
  ; don't call next stat interrupt until scanline 8
  ld a, 8
  ldh [rLYC], a


  ; Turn the LCD on including the window. But no sprites
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJOFF | LCDCF_OBJ16| LCDCF_WINON | LCDCF_WIN9C00
  ldh [rLCDC], a

EndStatInterrupts:
  pop af
  reti
