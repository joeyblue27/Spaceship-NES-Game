ca65 game_main.s -g -o game_main.o
ld65 -C nes.cfg -o game_main.nes game_main.o  --dbgfile game_main.dbg

