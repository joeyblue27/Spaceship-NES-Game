;;;;; CONTROLLER READING

BUTTON_A       = 1 << 7
BUTTON_B       = %01000000
BUTTON_SELECT     = 1 << 5
BUTTON_START      = 1 << 4
BUTTON_UP         = 1 << 3
BUTTON_DOWN       = 1 << 2
BUTTON_LEFT       = 1 << 1
BUTTON_RIGHT      = 1 << 0

JOYPAD1           = $4016

.proc controller_poller 
    ldx #$01
    stx JOYPAD1
    dex
    stx JOYPAD1
    ldx #$08
@read_loop:
    lda JOYPAD1
    lsr
    rol temp00
    lsr
    rol temp01
    dex
    bne @read_loop
    lda temp00
    ora temp01
    sta temp00
    rts
.endproc

.proc controller_read 
    jsr controller_poller
@checksum_loop:
    ldy temp00
    jsr controller_poller
    cpy temp00
    bne @checksum_loop
    lda temp00
    tay
    eor controls
    and temp00
    sta controls_d
    sty controls
    rts
.endproc 