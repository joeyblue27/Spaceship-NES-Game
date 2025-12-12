LDA controls_d
CMP #BUTTON_B
BEQ @LASER_SHOT
JMP @LASER_STOP
@LASER_SHOT:
LDA shipblu_x
CLC
ADC #$04
STA laser_x
LDA shipblu_y
STA laser_y
@LASER_STOP:

@HIDE_LASER:
LDA laser_y
CMP #$F0
BCS @HIDE_DONE
SEC 
SBC #$04
STA laser_y
@HIDE_DONE:


; --- Check collision between laser and pizzaball ---
LDA p_ball_y
CMP #$F8                   ; If pizzaball is offscreen, skip
BCS @NO_COLLISION

LDA laser_y
SEC
SBC p_ball_y
CMP #$08
BCS @NO_COLLISION_Y        ; If the laser is too far in Y, skip

LDA laser_x
SEC
SBC p_ball_x
CMP #$08
BCS @NO_COLLISION          ; If the laser is too far in X, skip

; --- Collision Detected ---
@COLLISION:
LDA #$F1
STA p_ball_y            ; Move pizzaball offscreen
LDA #$00
STA laser_active           ; Deactivate laser

JMP @UPDATE_P_BALL_OAM

@NO_COLLISION_Y:
CMP p_ball_y
SBC laser_y
CMP #$10
BCS @NO_COLLISION
JMP @COLLISION

@NO_COLLISION:


@UPDATE_P_BALL_OAM:
    LDA p_ball_timer
    BEQ @DRAW_P_BALL   ; already 0 → draw
    DEC p_ball_timer       ; count down
    BNE @HIDE_P_BALL   ; if still > 0 → hide

@DRAW_P_BALL:
    LDA p_ball_y
    STA $21C
    STA $220
    CLC
    ADC #$08
    STA $224
    STA $228
    LDA p_ball_x
    STA $21F
    STA $227
    CLC
    ADC #$08
    STA $223
    STA $22B

    JMP @AFTER_DRAW

@HIDE_P_BALL:
    LDA #$F0
    STA $21C
    STA $220
    STA $224
    STA $228
    STA $21F
    STA $227
    STA $223
    STA $22B
    STA $22C
    STA $22F

@AFTER_DRAW:

