include "src/main/utils/hardware.inc"

DEF MAX_ENEMY_COUNT EQU 10
DEF MAX_BULLET_COUNT EQU 5

DEF ENEMY_SPAWN_DELAY_MAX EQU 70

RSRESET
DEF metasprite_y RB 1
DEF metasprite_x RB 1
DEF metasprite_tile RB 1
DEF metasprite_flag RB 1
DEF METASPRITE_BYTES_COUNT RB 0

RSRESET
DEF bullet_activeByte RB 1
DEF bullet_xByte RB 1
DEF bullet_yLowByte RB 1
DEF bullet_yHighByte RB 1
DEF PER_BULLET_BYTES_COUNT RB 0


DEF PER_ENEMY_BYTES_COUNT RB 0