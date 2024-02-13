include "src/utils/hardware.inc"

SECTION "GameVariables", WRAM0

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db
wGameState:: db

SECTION "Header", ROM0[$100]
	jp EntryPoint
	ds $150 - @, 0

EntryPoint:
  ; Shut down audio circuitry
  ld a, 0
  ld [rNR52], a

  ld a, 0
  ld [wGameState], a

  ; Wait for the vertical blank phase before initiating the library
  call WaitForOneVBlank

  ; from: https://github.com/eievui5/gb-sprobj-lib
  ; The library is relatively simple to get set up. First, put the following in your initialization code:
  ; Initilize Sprite Object Library.
  call InitSprObjLibWrapper

  ; Turn the LCD off
  ld a, 0
  ld [rLCDC], a

  ; Load our common text font into VRAM
  call LoadTextFontIntoVRAM

  ; Turn the LCD on
  ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
  ld [rLCDC], a

  ; During the first (blank) frame, initialize display registers
  ld a, %11100100
  ld [rBGP], a
  ld a, %11100100
  ld [rOBP0], a


NextGameState::
  ; Don't turn off LCD outside of VBlank
  call WaitForOneVBlank

  call ClearBackground

  ; turn off LCD
  ld a, 0
  ld [rLCDC], a

  ld a, 0
  ld [rSCX], a
  ld [rSCY], a
  ld [rWX], a
  ld [rWY], a

  ; disable interrupts
  call DisableInterrupts

  ; Clear all sprites
  call ClearAllSprites

  ; Initiate next game state
  ld a, [wGameState]
  cp a, 2 ; 2 = Gameplay
  call z, InitGameplayState
  ld a, [wGameState]
  cp a, 1 ; 1 = Story
  call z, InitStoryState
  ld a, [wGameState]
  cp a, 0 ; 0 = Menu
  call z, InitTitleScreenState

  ; Update the next state
  ld a, [wGameState]
  cp a, 2 ; 2 = Gameplay
  jp z, UpdateGameplayState
  cp a, 1 ; 1 = Story
  jp z, UpdateStoryState
  jp UpdateTitleScreenState
