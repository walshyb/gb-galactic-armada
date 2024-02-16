SECTION "Text", ROM0 

textFontTileData: INCBIN "src/generated/backgrounds/text-font.2bpp"
textFontTileDataEnd:

LoadTextFontIntoVRAM::
  ; Copy tile data
  ld de, textFontTileData
  ld hl, $9000
  ld bc, textFontTileDataEnd - textFontTileData
  call CopyDEintoMemoryAtHL
  ret

DrawTextTilesLoop::

    ; Check for the end of string character 255
    ld a, [hl]
    cp 255
    ret z

    ; Write the current character (in hl) to the address
    ; on the tilemap (in de)
    ld a, [hl]
    ld [de], a

    inc hl
    inc de

    ; move to the next character and next background tile
    jp DrawTextTilesLoop

DrawText_WithTypewriterEffect::
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Wait a small amount of time
  ; Save our count in this var
  ld a, 3
  ld [wVBlankCount], a

  call WaitForVBlankFunction
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; Check for end of string char 255
  ld a, [hl]
  cp 255
  ret z

  ; Write current char (in hl) to the address
  ; on the tilemap (in de)
  ld a, [hl]
  ld [de], a

  inc hl
  inc de

  jp DrawText_WithTypewriterEffect
