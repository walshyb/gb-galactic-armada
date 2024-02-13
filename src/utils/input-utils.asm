SECTION "InputUtilsVariables", WRAM0

mWaitKey:: db

SECTION "InputUtils", ROM0

WaitForKeyFunction::
  ; Save original value
  push bc

WaitForKeyFunction_Loop::
  ; save the keys last frame
  ld a, [wCurKeys]
  ld [wLastKeys], a

  ; From input lib
  call Input

  ld a, [mWaitKey]
  ld b, a
  ld a, [wCurKeys]
  and a, b
  jp z, WaitForKeyFunction_NotPressed

  ld a, [wLastKeys]
  and a, b
  jp nz, WaitForKeyFunction_NotPressed

  ; restore original value
  pop bc

  ret

WaitForKeyFunction_NotPressed:
  ; Wait small amount of time
  ; Save our count in this variable
  ld a, 1
  ld [wVBlankCount], a

  ; Call our func that performs the code
  call WaitForVBlankFunction

  jp WaitForKeyFunction_Loop
