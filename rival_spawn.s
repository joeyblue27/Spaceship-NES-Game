LDA p_ball_pause_timer
BEQ @CHECK_MOVE       ; timer 0? move allowed
DEC p_ball_pause_timer ; still waiting
JMP @SKIP_MOVE        ; skip all movement until time’s up

@CHECK_MOVE:
; --- Laser should shoot even if pizza_timer active ---


; --- Now check pizza_timer for movement ---
LDA p_ball_timer
BNE @SKIP_MOVE        ; if pizza_timer active, skip move

; --- Movement happens only when timer = 0 ---
LDA p_ball_dir
BEQ @MOVE_RIGHT

@MOVE_LEFT:
    LDA p_ball_x
    SEC
    SBC #1
    STA p_ball_x
    LDA p_ball_y
    CLC
    ADC #2
    STA p_ball_y
    JMP @AFTER_MOVE

@MOVE_RIGHT:
    LDA p_ball_x
    CLC
    ADC #1
    STA p_ball_x
    LDA p_ball_x
    CMP #$E0          ; right boundary (224 px)
    BCC @AFTER_MOVE
    LDA #$01
    STA p_ball_dir

    LDA #120          ; reset pause timer
    STA p_ball_pause_timer

@AFTER_MOVE:
@SKIP_MOVE:
RTI
