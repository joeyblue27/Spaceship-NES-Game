



version_text: ; 
    .byte $34 + FAMISTUDIO_VERSION_MAJOR, $3e, $34 + FAMISTUDIO_VERSION_MINOR, $3e, $34 + FAMISTUDIO_VERSION_HOTFIX

play_song:
.if FAMISTUDIO_DEMO_USE_C 
    jsr _play_song
    rts

.else
    @text_ptr = p0

    lda song_index
    cmp #1
    beq @journey_to_silius
    cmp #2
    beq @shatterhand

    ; Here since both of our songs came from different FamiStudio projects, 
    ; they are actually 3 different song data, with a single song in each.
    ; For a real game, if would be preferable to export all songs together
    ; so that instruments shared across multiple songs are only exported once.
    @silver_surfer:
        lda #<song_title_silver_surfer
        sta @text_ptr+0
        lda #>song_title_silver_surfer
        sta @text_ptr+1
        ldx #.lobyte(music_data_silver_surfer_c_stephen_ruddy)
        ldy #.hibyte(music_data_silver_surfer_c_stephen_ruddy)
        jmp @play_song

    @journey_to_silius:
        lda #<song_title_jts
        sta @text_ptr+0
        lda #>song_title_jts
        sta @text_ptr+1
        ldx #.lobyte(music_data_journey_to_silius)
        ldy #.hibyte(music_data_journey_to_silius)
        jmp @play_song

    @shatterhand:
        lda #<song_title_shatterhand
        sta @text_ptr+0
        lda #>song_title_shatterhand
        sta @text_ptr+1
        ldx #.lobyte(music_data_shatterhand)
        ldy #.hibyte(music_data_shatterhand)
        jmp @play_song
    
    @play_song:
    lda #1 ; NTSC
    jsr famistudio_init
    lda #0
    jsr famistudio_music_play

    rts
.endif
