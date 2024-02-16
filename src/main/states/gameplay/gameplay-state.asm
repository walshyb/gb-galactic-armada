include "src/main/utils/hardware.inc"
include "src/main/utils/macros/text-macros.inc"


SECTION "GameplayVariables", WRAM0

wScore:: ds 6
wLives:: db

SECTION "GameplayState", ROM0
wScoreText:: db "score", 255
wLivesText:: db "lives", 255

InitGameplayState::
  ld a, 3
  ld [wLives+0], a

  ld a, 0
  ld [wScore+0], a
  ld [wScore+1], a
  ld [wScore+2], a
  ld [wScore+3], a
  ld [wScore+4], a
  ld [wScore+5], a

  call InitializeBackground
  ;call InitializePlayer
  ;call InitializeBullets
  ;call InitializeEnemies

  call InitStatInterrupts

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; call func that draws text onto background/window tiles
  ld de, $9c00
  ld hl, wScoreText
  call DrawTextTilesLoop

  ld de, $9c0D
  ld hl, wLivesText
  call DrawTextTilesLoop

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;call DrawScore
  ;call DrawLives

  ld a, 0
  ld [rWY], a

  ld a, 7
  ld [rWX], a

  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00 | LCDCF_BG9800
  ld [rLCDC], a
  ret

UpdateGameplayState::
  ; save the keys last frame
  ld a, [wCurKeys]
  ld [wLastKeys], a

  call Input

  call ResetShadowOAM
  call ResetOAMSpriteAddress

  ;call UpdatePlayer
  ;call UpdateEnemies
  ;call UpdateBullets
  call UpdateBackground

  call ClearRemainingSprites

  ld a, [wLives]
  cp a, 250
  jp nc, EndGameplay

  call WaitForOneVBlank

  ld a, HIGH(wShadowOAM)
  call hOAMDMA

  call WaitForOneVBlank

  jp UpdateGameplayState

EndGameplay:
  ld a, 0
  ld [wGameState], a
  jp NextGameState
