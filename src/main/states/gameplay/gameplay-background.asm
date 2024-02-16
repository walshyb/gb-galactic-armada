include "src/main/utils/hardware.inc"
include "src/main/utils/macros/text-macros.inc"

SECTION "BackgroundVariables", WRAM0

mBackgroundScroll:: dw

SECTION "GameplayBackgroundSection", ROM0

starFieldMap: INCBIN "src/generated/ackgrounds/star-field.tilemap"
starFieldMapEnd:

starFieldTileData: INCBIN "src/generated/ackgrounds/star-field.2bpp"
starFieldTileDataEnd:

InitializeBackground:
  ld de, starFieldTileData
  ld hl, $9340
  ld bc, starFieldTileDataEnd - starFieldTileData
  call CopyDEintoMemoryAtHL

  ld de, starFieldMap
  ld hl, $9800
  ld bc, starFieldMapEnd - starFieldMap
  call CopyDEintoMemoryAtHL

  ld a, 0
  ld [mBackgroundScroll+0], a

  ; Do we need to reload 0 into a?
  ld a, 0
  ld [mBackgroundScroll+1], a

  ret

; To scroll the background in a gameboy game,
; we simply need to gradually change the SCX or SCX registers. 
; This is called during gameplay state every frame
UpdateBackground::
  ; Increase scaled integer by 5
  ; Get our true (non-scaled) value, and save it for later usage in bc
  ld a, [mBackgroundScroll+0]
  add a, 5
  ld b, a
  ld [mBackgroundScroll+0], a
  ld a, [mBackgroundScroll+1]
  ; the adc a, 0 instruction will set the carry flag if the addition
  ; overflows, so we can use that to check if we need to increment
  ; the following code is equivalent to:
  adc a, 0
  ld c, a
  ld [mBackgroundScroll+1], a
  
  ; We won’t directly draw the background using this value.
  ; De-scaling a scaled integer simulates having a (more precise and 
  ; useful for smooth movement) floating-point number. The value we 
  ; draw our background at will be the de-scaled version of that 16-bit integer. 
  ; To get that non-scaled version, we’ll simply shift all of it’s bit 
  ; rightward 4 places. The final result will saved for when we update 
  ; our background’s y position.
  ; Descale our scaled integer 
  ; shift bits to the right 4 spaces
  srl c
  rr b
  srl c
  rr b
  srl c
  rr b
  srl c
  rr b

  ; Use the de-scaled low byte as the background's position
  ld a, b
  ld [rSCY], a
  ret



