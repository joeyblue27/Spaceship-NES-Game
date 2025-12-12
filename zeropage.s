.segment "ZEROPAGE" ; LSB 0 - FF


world: .res 2
coarse_y:   .res 1   ; 0–29 (tile rows)
fine_y:     .res 1   ; 0–7  (pixels inside a tile row)
nt_y:       .res 1   ; vertical nametable bit (0 or 1)

shipblu_x:  .res 1
shipblu_y:  .res 1
laser_x: .res 1
laser_y: .res 1
laser_active: .res 1
p_ball_x: .res 1
p_ball_y: .res 1
p_ball_dir: .res 1 ; 0 = right, 1 = left
p_ball_color_index: .res 1
p_ball_timer: .res 1
p_ball_pause_timer:  .res 1
song_index: .res 1
p_ball_flicker: .res 1

wtf: .res 1                    
nmi_lockout: .res 1             
temp00: .res 1                  
temp01: .res 1                  
temp02: .res 1                  
temp03: .res 1                  
temp04: .res 1                  
temp05: .res 1                  
temp06: .res 1                  
temp07: .res 1                  
state00: .res 1                 
state01: .res 1                 
state02: .res 1                 
state03: .res 1                 
state04: .res 1                 
state05: .res 1                 
state06: .res 1                 
state07: .res 1                 
rng0: .res 1                    
oam_disable: .res 1             
controls: .res 1
controls_d: .res 1              
ppu_mask_emph: .res 1          


; General purpose temporary vars.
;r0: .res 1
;r1: .res 1
;r2: .res 1
;r3: .res 1
;r4: .res 1

; General purpose pointers.
p0: .res 2