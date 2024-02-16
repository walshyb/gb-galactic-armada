include "src/main/utils/hardware.inc"
include "src/main/utils/macros/text-macros.inc"

SECTION "StoryState", ROM0

; Need to wait 3 vertical blanks per letter
; why??
Story:
  .Line1 db "the galatic empire", 255
  .Line2 db "rules the galaxy", 255
  .Line3 db "with an iron", 255
  .Line4 db "fist.", 255
  .Line5 db "the rebel force", 255
  .Line6 db "remain hopeful of", 255
  .Line7 db "freedoms light", 255

InitStoryState::
  ; Turn on LCD
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a
  ret

UpdateStoryState::
  ; Load the first story page
  ; Call Our function that typewrites text onto background/window tiles
  ld de, $9821
  ld hl, Story.Line1
  call DrawText_WithTypewriterEffect

  ; Call Our function that typewrites text onto background/window tiles
  ld de, $9861
  ld hl, Story.Line2
  call DrawText_WithTypewriterEffect


  ; Call Our function that typewrites text onto background/window tiles
  ld de, $98A1
  ld hl, Story.Line3
  call DrawText_WithTypewriterEffect


  ; Call Our function that typewrites text onto background/window tiles
  ld de, $98E1
  ld hl, Story.Line4
  call DrawText_WithTypewriterEffect

  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Wait for A

  ; Save passed value into the variable: mWaitKey
  ; The WaitForKeyFunction always checks agianst this variable
  ld a, PADF_A
  ld [mWaitKey], a

  call WaitForKeyFunction
  ;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; Load the second story page
  call ClearBackground

  ; Call Our function that typewrites text onto background/window tiles
  ld de, $9821
  ld hl, Story.Line5
  call DrawText_WithTypewriterEffect

  ; Call Our function that typewrites text onto background/window tiles
  ld de, $9861
  ld hl, Story.Line6
  call DrawText_WithTypewriterEffect


  ; Call Our function that typewrites text onto background/window tiles
  ld de, $98A1
  ld hl, Story.Line7
  call DrawText_WithTypewriterEffect

  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Wait for A

  ; Save passed value into the variable: mWaitKey
  ; The WaitForKeyFunction always checks agianst this variable
  ld a, PADF_A
  ld [mWaitKey], a

  call WaitForKeyFunction
  ;;;;;;;;;;;;;;;;;;;;;;;;;;


  ld a, 2
  ld [wGameState], a

  jp NextGameState
