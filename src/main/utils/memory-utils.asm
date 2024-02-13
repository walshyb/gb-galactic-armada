SECTION "MemoryUtilsSection", ROM0

CopyDEintoMemoryAtHL::
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ; TODO what does this do
  ld a, b
  or a, c
  jp nz, CopyDEintoMemoryAtHL ; Jump to CopyTiles if the z flag is not set
  ret

CopyDEintoMemoryAtHL_With52Offset::
  ld a, [de]
  add a, 52
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or a, c
  jp nz, CopyDEintoMemoryAtHL_With52Offset
  ret

