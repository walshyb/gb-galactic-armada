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

  ret

DrawTitleScreen::
  ; Copy tile data
  ld de, titleScreenTileData ; de contains address where data will be copied from
  ld hl, $9340 ; hl contains address where data will be copied to
  ld bc, titleScreenTileDataEnd - titleScreenTileData ; bc contains the number of bytes to copy
  call CopyDEintoMemoryAtHL

  ; Copy tile map
  ld de, titleScreenTileMap
  ld hl, $9800
  ld bc, titleScreenTileMapEnd - titleScreenTileMap
  call CopyDEintoMemoryAtHL_With52Offset

  ret

UpdateTitleScreenState::
  ;;;;;;;;;;;;;;;;;
  ; Wait for A    ;
  ;;;;;;;;;;;;;;;;;

  ; Save passed value into variable mWaitKey
  ; The WaitForKeyFunction always checks against this variable
  ld a, PADF_A
  ld [mWaitKey], a

  call WaitForKeyFunction

  ;;;;;;;;;;;;;;;;;
  ; Load Story    ;
  ;;;;;;;;;;;;;;;;;
  ld a, 1
  ld [wGameState], a
  jp NextGameState

