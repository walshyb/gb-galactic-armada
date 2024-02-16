include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"

SECTION "Enemy Variables", WRAM0

wCurrentEnemyX:: db
wCurrentEnemyY:: db

wSpawnCounter: db
wNextEnemyXPosition: db
wActiveEnemyCounter::db
wUpdateEnemiesCounter:db
wUpdateEnemiesCurrentEnemyAddress::dw

; Bytes: active, x , y (low), y (high), speed, health
wEnemies:: ds MAX_ENEMY_COUNT*PER_ENEMY_BYTES_COUNT

SECTION "Enemies", ROM0

enemyShipTileData:: INCBIN "src/generated/sprites/enemy-ship.2bpp"
enemyShipTileDataEnd::

enemyShipMetasprite::
  .metasprite1   db 0,0,4,0
  .metasprite2   db 0,8,6,0
  .metaspriteEnd db 128


