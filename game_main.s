FAMISTUDIO_VERSION_MAJOR  = 4
FAMISTUDIO_VERSION_MINOR  = 4
FAMISTUDIO_VERSION_HOTFIX = 1

.include "demo_ca65.inc"

.ifndef FAMISTUDIO_DEMO_USE_C
FAMISTUDIO_DEMO_USE_C = 0
.endif
.if FAMISTUDIO_DEMO_USE_C
; functions that the C library expects 
.export __STARTUP__:absolute=1
; this is for the C stack and are set in the mapper file
.import __STACK_START__, __STACKSIZE__
.importzp sp
.include "zeropage.inc"

; Functions defined in C (using C decl instead of fastcall)
.import _play_song, _update, _init

; Variables and functions used in the C code must be prefixed with underscore
; so re-export the necessary ones here
.exportzp _gamepad_pressed=gamepad_pressed, _p0=p0
.export _song_title_silver_surfer=song_title_silver_surfer
.export _song_title_jts=song_title_jts
.export _song_title_shatterhand=song_title_shatterhand
.export _update_title=update_title
.endif

.segment "HEADER"
.byte "NES"
.byte $1a
.byte $02 ; 2 * 16KB PRG ROM
.byte $01 ; 1 * 8KB CHR ROM
.byte %00000000 ; mapper and mirroring
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00 ; filler bytes

.include "zeropage.s"


.segment "STARTUP"
; FamiStudio config.
FAMISTUDIO_CFG_EXTERNAL       = 1
FAMISTUDIO_CFG_DPCM_SUPPORT   = 1
FAMISTUDIO_CFG_SFX_SUPPORT    = 1 
FAMISTUDIO_CFG_SFX_STREAMS    = 2
FAMISTUDIO_CFG_EQUALIZER      = 1
FAMISTUDIO_USE_VOLUME_TRACK   = 1
FAMISTUDIO_USE_PITCH_TRACK    = 1
FAMISTUDIO_USE_SLIDE_NOTES    = 1
FAMISTUDIO_USE_VIBRATO        = 1
FAMISTUDIO_USE_ARPEGGIO       = 1
FAMISTUDIO_CFG_SMOOTH_VIBRATO = 1
FAMISTUDIO_USE_RELEASE_NOTES  = 1 
FAMISTUDIO_USE_DELTA_COUNTER  = 1
FAMISTUDIO_DPCM_OFF           = $e000

; CA65-specifc config.
.define FAMISTUDIO_CA65_ZP_SEGMENT   ZEROPAGE
.define FAMISTUDIO_CA65_RAM_SEGMENT  RAM
.define FAMISTUDIO_CA65_CODE_SEGMENT CODE

.include "../famistudio_ca65.s"

; Silver Surfer - BGM 2
song_title_silver_surfer:
    .byte $ff, $ff, $ff, $12, $22, $25, $2f, $1e, $2b, $ff, $12, $2e, $2b, $1f, $1e, $2b, $ff, $4f, $ff, $01, $06, $0c, $ff, $36, $ff, $ff, $ff, $ff

; Journey To Silius - Menu
song_title_jts:
    .byte $ff, $ff, $09, $28, $2e, $2b, $27, $1e, $32, $ff, $13, $28, $ff, $12, $22, $25, $22, $2e, $2c, $ff, $4f, $ff, $0c, $1e, $27, $2e, $ff, $ff

; Shatterhand - Final Area
song_title_shatterhand:
    .byte $ff, $ff, $12, $21, $1a, $2d, $2d, $1e, $2b, $21, $1a, $27, $1d, $ff, $4f, $ff, $05, $22, $27, $1a, $25, $ff, $00, $2b, $1e, $1a, $ff, $ff
NUM_SONGS = 3

_exit:

Reset:
    SEI ; Disables all interrupts
    CLD ; disable decimal mode

    ; Disable sound IRQ
    LDX #$40
    STX $4017

    ; Initialize the stack register
    LDX #$FF
    TXS

    INX ; #$FF + 1 => #$00
    
    :
    BIT $2002
    BPL :-

    :
    BIT $2002
    BPL :-

    ; Zero out the PPU registers
    STX $2000
    STX $2001

    STX $4010



CLEARMEM:
    STA $0000, X ; $0000 => $00FF
    STA $0100, X ; $0100 => $01FF
    STA $0300, X
    STA $0400, X
    STA $0500, X
    STA $0600, X
    STA $0700, X
    LDA #$FF
    STA $0200, X ; $0200 => $02FF
    LDA #$00
    INX
    BNE CLEARMEM    
; wait for vblank
:


.include "sprite_coordinates.s"
.include "sprite_render.s"
.include "reset_timer.s"
.include "scroll_screen.s"
.include "ship_controls.s"
.include "sprite_display.s"
.include "music_toggle.s"
.include "laser_fire.s"
.include "rival_spawn.s"
.include "music_data.s"

.include "controllers.s"
.include "rival_flicker.s"  
.include "byte_tables.s"  

.segment "SONG1"
song_silver_surfer:
.include "song_silver_surfer_ca65.s"

sfx_data:
.include "sfx_ca65.s"

.segment "SONG2"
song_journey_to_silius:
.include "song_journey_to_silius_ca65.s"

.segment "SONG3"
song_shatterhand:
.include "song_shatterhand_ca65.s"

.segment "DPCM"
.incbin "song_journey_to_silius_ca65.dmc"

.segment "VECTORS"
    .word NMI
    .word Reset
    .word 0
    
.segment "CHARS"
    .incbin "game.chr"
    