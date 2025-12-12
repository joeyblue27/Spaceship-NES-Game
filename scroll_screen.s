     ; Start music 
    LDA #0
    STA song_index
    JSR play_song 

; Enable interrupts
    CLI

    LDA #%10010010 ; enable NMI change background to use second chr set of tiles ($1000)
    STA $2000
    
    LDA #%00011110  ; Enable background and sprites
    STA $2001
  
   
Loop:
    JMP Loop

NMI:


 JSR Update_P_Ball_Palette 

 INC wtf
 LDA wtf
 AND #1
 BEQ @scroll_done

; --- decrement vertical scroll for downward scrolling ---
LDA fine_y
BEQ @wrap_fine

    DEC fine_y
            ; just move fine_y down 1 pixel
    JMP @scroll_done

@wrap_fine:
    LDA #7
    STA fine_y        ; wrap fine_y back to 7
    LDA coarse_y
    BEQ @wrap_coarse

        DEC coarse_y  ; move down one tile row
        JMP @scroll_done

@wrap_coarse:
    LDA #29
    STA coarse_y      ; wrap coarse_y to bottom row
    LDA nt_y
    EOR #2
    STA nt_y          ; flip vertical nametable
@scroll_done:


; --- Apply scroll correctly ---
BIT $2002       ; reset latch

; write scroll X (0 in your case)
LDA #0
STA $2005

; compute full scroll Y = fine_y + (coarse_y * 8)
LDA coarse_y
ASL A           ; *2
ASL A           ; *4
ASL A           ; *8
CLC
ADC fine_y
STA $2005       ; this is the real Y scroll

; update $2000 with the vertical nametable bit
LDA #%10010000  ; base value
ORA nt_y  ; bit1 is vertical nametable select
STA $2000

