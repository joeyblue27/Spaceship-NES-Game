    ; controller readings

    LDA #$02 ; copy sprite data from $0200 => PPU memory for display
    STA SpriteDMA
    JSR controller_read
    STA $80
    LDA controls
    AND #BUTTON_UP
    CMP #BUTTON_UP
    BNE @DONT_UP
    LDA shipblu_y 
    SEC
    SBC #2
    CMP #$F0       
    BCS @STOP_UP
    STA shipblu_y
@DONT_UP:
@STOP_UP:

    LDA controls
    AND #BUTTON_DOWN
    CMP #BUTTON_DOWN
    BNE @DONT_DOWN
    LDA shipblu_y
    CLC
    ADC #2
    CMP #$D8        
    BCS @STOP_DOWN    
    STA shipblu_y
  @DONT_DOWN:
  @STOP_DOWN:

    LDA controls
    AND #BUTTON_LEFT
    CMP #BUTTON_LEFT
    BNE @DONT_LEFT

    LDA shipblu_x 
    SEC
    SBC #2
    STA shipblu_x
  @DONT_LEFT:
    LDA controls
    AND #BUTTON_RIGHT
    CMP #BUTTON_RIGHT
    BNE @DONT_RIGHT
    LDA shipblu_x 
    CLC
    ADC #2
    STA shipblu_x
   @DONT_RIGHT:
