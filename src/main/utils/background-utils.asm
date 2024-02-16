include "src/main/utils/hardware.inc"

SECTION "Background", ROM0

ClearBackground::
  ld a, 0
  ld [rLCDC], a

  ld bc, 1024
  ld hl, $9800

ClearBackgroundLoop:
  ld a, 0
  ld [hli], a

  dec bc
  ld a, b
  or a, c

  jp nz, ClearBackgroundLoop

  ; Turn on LCD
  ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a

  ret
