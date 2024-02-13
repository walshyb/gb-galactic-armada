include "src/main/utils/hardware.inc"
include "src/main/utils/macros/text-macros.inc"

SECTION "TitleScreenState", ROM0

wPressPlayText:: db "press a to play", 255

titleScreenTileData: INCBIN "src/generated/backgrounds/title-screen.2bpp"
titleScreenTileDataEnd:

titleScreenTileMap: INCBIN "src/generated/backgrounds/title-screen.tilemap"
titleScreenTileMapEnd:

InitTitleScreenState::
  call DrawTitleScreen

  ; Draw the press play text

  ; call function that draws text onto background/window tiles
  ld de, $99C3 ; VRAM address to write to. This is the start of the tilemap for the press play text
  ld hl, wPressPlayText
  call DrawTextTilesLoop ; Will start drawing at $99C3

  ; Turn LCD on
  ld a, LCDCF_ON |  LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a

  ret;

DrawTextTilesLoop::
  ; Check for the end of string character 255
  ld a, [hl]
  cp 255
  ret z

  ; WRite current char (in hl) to the address
  ; on the tilemap (in de)
  ld a, [hl] ; TODO: why can't we hli
  ld [de], a

  inc hl
  inc de

  ; move to next character and next background tile
  jp DrawTextTilesLoop
