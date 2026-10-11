; hw.inc - rejestry sprzętu platformy 'generic' (tylko BIOS; jądro ich nie używa)
; ---- zatrzask shadow ----
SHADOW_LATCH = $DE00    ; bit 0: 0 = ROM, 1 = RAM

; ---- konsola szeregowa ----
CON_CTRL    = $DF00     ; zapis CONTROL, odczyt STATUS
CON_DATA    = $DF01
CON_RXCOUNT = $DF02

; ---- urządzenie blokowe ----
BLK_CMD     = $DF10     ; zapis
BLK_STATUS  = $DF10     ; odczyt
BLK_LO      = $DF11
BLK_HI      = $DF12
BLK_ADDR_LO = $DF13
BLK_ADDR_HI = $DF14
BLK_SIZE_LO = $DF15
BLK_SIZE_HI = $DF16
BLK_ERR     = $DF17
BLK_UNIT    = $DF18

BLK_CMD_RESET = $00
BLK_CMD_READ  = $01
BLK_CMD_WRITE = $02
BLK_CMD_INFO  = $03

BLK_ST_BUSY    = $01
BLK_ST_ERR     = $02
BLK_ST_NOMEDIA = $04
BLK_ST_WP      = $08

; ---- kontroler I2C ----
I2C_CTRL    = $DF20
I2C_DATA    = $DF21
I2C_STAT    = $DF22

; ---- zegar systemowy ----
TMR_CTRL    = $DF30
TMR_STATUS  = $DF31
TMR_DIV     = $DF32
TMR_COUNT   = $DF33

IO_START_HI = $D8      ; początek strefy I/O (strona), obraz systemu musi kończyć się przed nią
LOAD_MIN_HI = $02
