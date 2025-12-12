.proc Update_P_Ball_Palette
    ; pick frame index
    LDA p_ball_color_index
    ASL
    ASL
    TAX 
    INX
   

    ; point PPU to sprite palette 1 ($3F14–$3F16)
    LDA $2002       ; reset latch
    LDA #$3F
    STA $2006
    LDA #$14
    STA $2006
    LDY #0
@loop:
    LDA p_ball_colors,X
    STA $2007
    INX
    INY
    CPY #3
    BNE @loop

    ; advance every frame
    LDA p_ball_flicker
    AND #8 ; speed 
    BEQ @dontreset_p_ball_colors
    INC p_ball_color_index
    LDA p_ball_color_index
    CMP #4 ; how many frames in color rotation
    BNE @dontreset_p_ball_colors
    LDA #0
    STA p_ball_color_index
@dontreset_p_ball_colors:
    INC p_ball_flicker
    RTS
.endproc