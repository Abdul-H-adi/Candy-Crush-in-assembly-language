dosseg
.model small
.stack 100h

.data        
    rows            db 24          ; Number of rows (24 for standard text mode)
    cols            db 80          ; Number of columns (80 for standard text mode)
    cursor_x        db ?           ; Current cursor position X
    cursor_y        db ?           ; Current cursor position Y
    tnameprompt     db 10,13, "                               Enter your name: $"
    tname           db 20 dup('$')
    tname_size      db 20
    saved_video_mode db ? 
    newline         db 10, 13, '$'
    count db 0
    count2 db 0
     mouseX1 dw 0
    mouseY1 dw 0
    mouseX2 dw 0
    mouseY2 dw 0
    val1 db 0
    val2 db 0
    cellSize dw 20  
    ;game rules
    rules db "HOW TO PLAY:", 10, 13, 10, 13, \
       "Welcome to Candy Crush!", 10, 13, 10, 13, \
       "1) Swap adjacent candies to make rows or columns of 3 or more matching candies.", 10, 13, 10, 13, \
       "2) Use arrow keys to move and Enter to swap candies.", 10, 13, 10, 13, \
       "3) Matched candies disappear, making space for new ones to fall.", 10, 13, 10, 13, \
       "4) Plan moves to create combos and earn high scores.", 10, 13, 10, 13, \
       "5) Beware of the color bomb - it destroys all candies of its color.", 10, 13, 10, 13, \
       "6) Complete each level by reaching the target score within the moves limit.", 10, 13, 10, 13, \
       "7) Good luck and enjoy the game!", 10, 13, 10, 13, "$"

    ;game intro
    intro_line db "===================================================================" , 10, 13, "$"
          game_intro db  "           ____                _          ____                _     ", 10 ,13, \
    " / ___|__ _ _ __   __| |_   _   / ___|_ __ _   _ ___| |__  ", 10 , 13, \
      "| |   / _` | '_ \ / _` | | | | | |   | '__| | | / __| '_ \ ", 10 ,13 , \
     "| |__| (_| | | | | (_| | |_| | | |___| |  | |_| \__ \ | | |", 10 ,13 ,\
     " \____\__,_|_| |_|\__,_|\__, |  \____|_|   \__,_|___/_| |_|",10,13,\
     "                        |___/                              ",10,13,\
               " Welcome to Candy Crush:  $", \
                "$"
         game_intro2 db      "======================================================================$", 10, 13, \
               "$"
     welcome db "Welcome to Candy Crush:  $"
     moves db 24
    pressprompt db "Press any key to continue...$"
     board db 42 dup(?) ; 7x7 board
     gOmsg1  db"_____                         ____                          ",10,13, \
 "  / ____|                       / __ \                         ",10,13,\
" | |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __          ",10,13,\
" | | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__|         ",10,13,\
" | |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |            ",10,13,\
 "  \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|            ",10,13,\
 "                                                               ",10,13,\
 "$"

    randomnum db ? 
    temp db ?
    one db 10,13, "Name:$"
    two db  " Score:$"
    matchcount db 0
    score db 0
    three db " Moves:$"
    four db 10,13, "four is printed$"
    x dw 55     ; initial x-coordinate
y dw 15     ; initial y-coordinate
board2 db 2,3,4,5,6,7,8 ; 7x7 board

    sprite_data   DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ;  0
        DB 0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ;  1
        DB 0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh     ;  2
        DB 0Bh,0Bh,0Bh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch     ;  3
        DB 0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Dh,0Dh,0Dh     ;  4
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh     ;  5
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch     ;  6
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ;  7
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ;  8
        DB 0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ;  9
        DB 0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh     ; 10
        DB 0Bh,0Bh,0Bh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch     ; 11
        DB 0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch     ; 12
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch     ; 13
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh     ; 14
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ; 15
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ; 16
        DB 0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ; 17
        DB 0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch     ; 18
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh     ; 19
        DB 0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ; 20
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch     ; 21
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh     ; 22
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ; 23
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ; 24
        DB 0Dh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 25
        DB 0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh     ; 26
        DB 0Dh,0Dh,0Dh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch     ; 27
        DB 0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Bh,0Bh,0Bh     ; 28
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh     ; 29
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch     ; 30
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ; 31
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ; 32
        DB 0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 33
        DB 0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh     ; 34
        DB 0Dh,0Dh,0Dh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch     ; 35
        DB 0Ch,0Ch,0Ch,0Ch,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Bh,0Bh,0Bh     ; 36
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Dh,0Dh     ; 37
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh
    flower   DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah     ;  0
        DB 0Ah,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ;  1
        DB 0Bh,0Bh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Bh,0Bh,0Bh,0Bh,0Bh     ;  2
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ah,0Ah,0Ah,0Ah     ;  3
        DB 0Ah,0Ah,0Ah,0Ah,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ;  4
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Bh,0Bh     ;  5
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ah     ;  6
        DB 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ;  7
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah     ;  8
        DB 0Ah,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ;  9
        DB 0Bh,0Bh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Bh,0Bh,0Bh,0Bh,0Bh     ; 10
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ah,0Ah,0Ah,0Ah     ; 11
        DB 0Ah,0Ah,0Ah,0Ah,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Dh,0Dh,0Dh     ; 12
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,09h,09h     ; 13
        DB 09h,09h,09h,09h,09h,09h,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Eh     ; 14
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,09h,09h,09h,09h,09h,09h,09h,09h     ; 15
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh     ; 16
        DB 0Eh,09h,09h,09h,09h,09h,09h,09h,09h,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ; 17
        DB 0Dh,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,09h,09h,09h,09h,09h     ; 18
        DB 09h,09h,09h,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Eh,0Eh,0Eh,0Eh     ; 19
        DB 0Eh,0Eh,0Eh,0Eh,09h,09h,09h,09h,09h,09h,09h,09h,0Dh,0Dh,0Dh     ; 20
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,09h,09h     ; 21
        DB 09h,09h,09h,09h,09h,09h,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Eh     ; 22
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,09h,09h,09h,09h,09h,09h,09h,09h     ; 23
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh     ; 24
        DB 0Eh,09h,09h,09h,09h,09h,09h,09h,09h,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 25
        DB 0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh     ; 26
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch     ; 27
        DB 0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 28
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh     ; 29
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch     ; 30
        DB 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 31
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch     ; 32
        DB 0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 33
        DB 0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh     ; 34
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch     ; 35
        DB 0Ch,0Ch,0Ch,0Ch,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh,0Bh     ; 36
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Bh,0Bh     ; 37
        DB 0Bh,0Bh,0Bh,0Bh,0Bh,0Bh
        kittykat DB 00h,00h,00h,00h,00h,00h,00h,00h,09h,09h,09h,09h,09h,09h,09h     ;  0
        DB 09h,09h,09h,09h,09h,09h,09h,09h,09h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h     ;  2
        DB 09h,09h,09h,00h,00h,00h,00h,00h,00h,00h,00h,0Dh,0Dh,0Dh,0Dh     ;  3
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h     ;  5
        DB 09h,09h,09h,09h,09h,09h,00h,00h,00h,00h,00h,00h,00h,00h,09h     ;  6
        DB 09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h     ;  7
        DB 00h,00h,00h,00h,00h,00h,00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh     ;  8
        DB 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,0Ah,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,10h,10h,10h     ; 10
        DB 10h,10h,10h,00h,00h,00h,00h,00h,00h,00h,00h,10h,0Ah,0Ah,0Ah     ; 11
        DB 10h,10h,0Ah,10h,10h,10h,0Ah,10h,10h,10h,10h,10h,00h,00h,00h     ; 12
        DB 00h,00h,00h,00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,00h,00h,10h,10h     ; 13
        DB 10h,0Ah,10h,10h,10h,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,10h     ; 14
        DB 10h,10h,10h,10h,0Ah,10h,10h,10h,10h,10h,10h,0Ah,0Ah,10h,10h     ; 15
        DB 00h,00h,00h,00h,00h,00h,00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh     ; 16
        DB 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,00h,00h,00h,00h     ; 17
        DB 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh     ; 18
        DB 0Fh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,09h,09h,09h,09h     ; 19
        DB 09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ; 21
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,00h,00h,00h,00h,00h,00h,00h,00h,09h     ; 22
        DB 09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h     ; 23
        DB 00h,00h,00h,00h,00h,00h,00h,00h,09h,09h,09h,09h,09h,09h,09h     ; 24
        DB 09h,09h,09h,09h,09h,09h,09h,09h,09h

        drinky DB 00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h     ;  0
        DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ;  2
        DB 06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh     ;  3
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh     ;  5
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,06h     ;  6
        DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ;  7
        DB 00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h     ;  8
        DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ; 10
        DB 06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h     ; 11
        DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h     ; 12
        DB 00h,00h,00h,00h,00h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h     ; 13
        DB 05h,05h,05h,05h,05h,05h,00h,00h,00h,00h,00h,00h,00h,00h,05h     ; 14
        DB 05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h     ; 15
        DB 00h,00h,00h,00h,00h,00h,00h,00h,05h,05h,05h,05h,05h,05h,05h     ; 16
        DB 05h,05h,05h,05h,05h,05h,05h,05h,05h,00h,00h,00h,00h,00h,00h     ; 17
        DB 00h,00h,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh     ; 18
        DB 0Dh,0Dh,0Dh,00h,00h,00h,00h,00h,00h,00h,00h,0Dh,0Dh,0Dh,0Dh     ; 19
        DB 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h     ; 21
        DB 05h,05h,05h,05h,05h,05h,00h,00h,00h,00h,00h,00h,00h,00h,05h     ; 22
        DB 05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h     ; 23
        DB 00h,00h,00h,00h,00h,00h,00h,00h,05h,05h,05h,05h,05h,05h,05h     ; 24
        DB 05h,05h,05h,05h,05h,05h,05h,05h,05h,00h,00h,00h,00h,00h,00h     ; 25
        DB 00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ; 26
        DB 06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h     ; 27
        DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h     ; 28
        DB 00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ; 29
        DB 06h,06h,06h,06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh     ; 30
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh     ; 31
        DB 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh     ; 32
        DB 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h     ; 33
        DB 00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ; 34
        DB 06h,06h,06h,00h,00h,00h,00h,00h,00h,00h,00h,06h,06h,06h,06h     ; 35
        DB 06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h,00h,00h,00h     ; 36
        DB 00h,00h,00h,00h,00h,06h,06h,06h,06h,06h,06h,06h,06h,06h,06h     ; 37
        DB 06h,06h,06h,06h,06h,06h
nigga db 0
mouse_x dw 0
mouse_y dw 0
mouse_x1 dw 0
mouse_y1 dw 0
box1 db 0
box2 db 0
row db 0
col db 0
doitTemp db 0
doitTemp2 db 0
doitCount db 0
checkTemp db 0 
checkTemp2 db 0
checkCount db 0
checkTemp3 db 0 
checkTemp4 db 0
random db 0
.code
updateboard proc
lea si , board

ret 
updateboard endp
doit proc
    ;box1 store
    mov si,0
    mov doitCount,0
    lea si, board      ; Point SI to the start of the board array
    doitLoop:
        mov bl, doitCount
        cmp bl,box1
        je exit1
        inc doitCount
        inc si    
    jmp doitLoop
    exit1:
    mov byte ptr al, [si] ; Load the value at index box1
    mov doitTemp, al

    ;box2 store
    mov doitCount,0
    mov si,0
    lea si,board
    doitLoop2:
        mov bl, doitCount
        cmp bl,box2
        je exit2
        inc doitCount
        inc si
    jmp doitLoop2
    exit2:
    mov byte ptr al, [si] ; Load the value at index box2
    mov doitTemp2,al

    ;now swap values
    mov doitCount,0
    mov si,0
    lea si,board
    doitloop3:
        mov bl, doitCount
        cmp bl,box2
        jge exit3
        inc doitCount
        inc si
    jmp doitloop3
    exit3:
    mov al, doitTemp
    mov byte ptr [si], al

    mov doitCount,0
    mov si,0
    lea si,board
    doitloop4:
        mov bl, doitCount
        cmp bl,box1
        jge exit4
        inc doitCount
        inc si
    jmp doitloop4
    exit4:
    mov al, doitTemp2
    mov byte ptr [si], al
    ret 
   
doit endp

 printersprite proc
    mov al, [count]
    mov dl, al          ; Store original count in DX for later comparison
    add dl, 30h
    

    ; Check if count is a multiple of 7
    cmp dl , '1'
    je setup_draw_sprite
    cmp dl, '7'
    je multiple_of_seven ; Jump if there's no remainder
    cmp dl, '='
    je multiple_of_seven ; Jump if there's no remainder
     cmp dl, 'C'
    je multiple_of_seven ; Jump if there's no remainder
    cmp dl, 'I'
    je multiple_of_seven ; Jump if there's no remainder
     cmp dl, 'O'
    je multiple_of_seven ; Jump if there's no remainder

increment_loop:
    ; Increment [x] and [y]
    add [x], 0
    add [y], 30
    jmp setup_draw_sprite

multiple_of_seven:
    ; If count is a multiple of 7
    add [x], 40         ; Add 20 to [x]
    mov [y], 15         ; Set [y] to 15
    jmp setup_draw_sprite
   

setup_draw_sprite:
    ; Determine which sprite to use
    mov dl, count2
    cmp dl, '0'
    je first
    cmp dl, '1'
    je second
    cmp dl, '2'
    je third
    cmp dl, '3'
    je fourth
    cmp dl, '4'
    ret

first:
    lea si, flower
    jmp actual
second:
    lea si, sprite_data
    jmp actual
third:
    lea si, drinky
    jmp actual
fourth:
    lea si, kittykat
    jmp actual

actual:
    mov ax, 0A000h
    mov es, ax

    mov ax, [y]        ; Load y-coordinate
    mov bx, 320         ; Load screen width
    mul bx              ; ax = y * screen width
    add ax, [x]        ; Add x-coordinate to the result
    mov di, ax          ; Set DI to the initial offset
   
    ; Draw the sprite
    mov cx, 24          ; Height of the sprite
draw_sprite:
    push cx             ; Save row count    ; Point SI to the start of sprite data
    mov cx, 24          ; Width of the sprite (each row)
    rep movsb           ; Copy a row of sprite to video memory
    pop cx              ; Restore row count
    add di, 296         ; Advance DI to the start of the next line (320 - 24)
    loop draw_sprite    ; Decrement CX and repeat if not zero

   
ret
printersprite endp
rowncoloum proc 
     mov ah, 0
    mov al, 13h
    int 10h

     MOV CX,0; start;R0Woumn
    MOV DX,0; fix height
    BACK0:
    MOV AH,0CH
    MOV AL,14
    INT 10H
    INC CX
    CMP CX,320; end height 
    JNZ BACK0
    JZ yes
    yes:
    MOV CX,0; start;R0Woumn
    INC DX
    cmp dx, 200
    jnz BACK0

    MOV CX,30; start;R0Woumn
    MOV DX,5; fix height
    BACK33:
    MOV AH,0CH
    MOV AL,11
    INT 10H
    INC CX
    CMP CX,310; end height 
    JNZ BACK33
    JZ yess
    yess:
    MOV CX,30; start;R0Woumn
    INC DX
    cmp dx, 195
    jnz BACK33

  
   
;R0W 1 
    MOV CX,50; start;R0Woumn
    MOV DX,10; fix height
    BACK:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK

    ;R0W 2
    MOV CX,50; start;R0Woumn
    MOV DX,40; fix height
    BACK1:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK1
    
    ;R0W 3
    MOV CX,50; start;R0Woumn
    MOV DX,70; fix height
    BACK3:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK3
    
    ;R0W 4
    MOV CX,50; start;R0Woumn
    MOV DX,100; fix height
    BACK4:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK4

    ;R0W 5 
    MOV CX,50; start;R0Woumn
    MOV DX,130; fix height
    BACK5:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK5

    ;R0W 6
    MOV CX,50; start;R0Woumn
    MOV DX,160; fix height
    BACK6:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK6

    ;R0W 7 
    MOV CX,50; start;R0Woumn
    MOV DX,190; fix height
    BACK7:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK7
    
    
     ;R0W 7 
    MOV CX,50; start;R0Woumn
    MOV DX,190; fix height
    BACK8:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC CX
    CMP CX,290; end height 
    JNZ BACK8
    
     ;COL 1
    MOV CX,50; start;R0Woumn
    MOV DX,10; fix height
    BACK9:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK9
    
       ;COL 1
    MOV CX,90; start coloumn
    MOV DX,10; fix height
    BACK10:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK10
    
   ;COL 1
    MOV CX,130; start coloumn
    MOV DX,10; fix height
    BACK11:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK11

       ;COL 1
    MOV CX,170; start coloumn
    MOV DX,10; fix height
    BACK12:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK12
    
       ;COL 1
    MOV CX,210; start coloumn
    MOV DX,10; fix height
    BACK13:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK13
    
       ;COL 1
    MOV CX,250; start coloumn
    MOV DX,10; fix height
    BACK14:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK14
    
       ;COL 1
    MOV CX,289; start coloumn
    MOV DX,10; fix height
    BACK15:
    MOV AH,0CH
    MOV AL,1
    INT 10H
    INC DX
    CMP DX,190; end height 
    JNZ BACK15
     
rowncoloum endp

defaultposition proc
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    ret
defaultposition endp

setcolorpage1 proc
    mov ax, 0600h       ; Clear screen function
    mov bh, 00110000b      ; Set page number and attribute (light red background, white foreground)
    mov cx, 0000h       ; Upper left corner
    mov dx, 184Fh       ; Lower right corner
    int 10h             ; Video interrupt
    ret
setcolorpage1 endp


defaultcolor proc

    mov ax, 0600h       ; Clear screen function
    mov bh, 00001111b      ; Set page number and attribute (black background, white foreground)
    mov cx, 0000h       ; Upper left corner
    mov dx, 184Fh       ; Lower right corner
    int 10h             ; Video interrupt
    ret
defaultcolor endp

    delay proc
    mov cx, 1
    startdelay:
        cmp cx, 30990
        JE enddelay
        inc cx
        jmp startdelay
enddelay:
    ret
delay endp


randomgenerator proc
; create a random number generator
    call delay
    mov ah,0h
    int 1ah

    mov ax, dx
    mov dx, 0
    mov bx, 4
    div bx
    mov randomnum, dl
    ret
randomgenerator endp

boardfiller proc
    mov cl, 0
    lea si, board

    fillme:
      mov temp, cl
        call randomgenerator
        mov al, randomnum
        mov [si], al
       
       mov al, [si]
       

        mov cl, temp 
        

        inc si
        inc cl
        cmp cl, 42
        jge endd
        jmp fillme
    endd:
    ret

boardfiller endp
gridprint proc
    mov ax, 0600h       ; Clear screen function
    mov bh, 01100001b      ; Set page number and attribute (light red background, white foreground)
    mov cx, 0000h       ; Upper left corner
    mov dx, 184Fh       ; Lower right corner
    int 10h             ; Video interrupt
    ret
    gridprint endp
printboard proc
    mov ax, 0
    mov cl, 36
    lea si, board
    mov bl, 7
    mov count2, 0
    mov count, 0
printme:
    
    mov dl, [si]
    inc count 
    add dl, 30h
    mov count2 , dl
displayer:
   
   push dx
   push cx
   push bx
   push ax
   push si
   call printersprite
   pop si
    pop ax
    pop bx
    pop cx
    pop dx
    jmp incccc
incccc:
    inc si
    dec cl
     inc nigga
     cmp cl, 0
    je endding 
    jmp printme
   
endding:
    mov nigga, 0 
    mov count, 0
    mov count2, 0
    mov [x], 55
    mov [y], 15

    ret
printboard endp



    presstocontinue proc
        lea dx,pressprompt
        mov ah, 9
        int 21h
        mov ah, 0
        int 16h
        ret
    presstocontinue endp

    nextline proc
        mov dl, 10
        mov ah, 2h
        int 21h
        ret
    nextline endp

    clearScr proc
        ; Save current video mode settings
        mov ah, 15         ; Function to get current video mode
        int 10h             ; Call BIOS video interrupt
        mov [saved_video_mode], al  ; Save the current video mode

   

        ; Clear the screen
        mov ah, 0            ; Set AH to 0 (scroll window up)
        mov al, 0            ; Clear entire screen
        mov bh, 07h          ; Text attribute (default is white on black)
        mov cx, 0            ; Upper left corner X coordinate
        mov dx, 0            ; Upper left corner Y coordinate
        int 10h              ; Call BIOS video interrupt to clear the screen

        ; Set cursor position to (0,0)
        mov ah, 02h          ; Set AH to 2 (set cursor position)
        xor bh, bh           ; Video page number
        xor dh, dh           ; Row (Y)
        xor dl, dl           ; Column (X)
        int 10h              ; Call BIOS video interrupt to set cursor position

        ; Restore original video mode settings
        mov ah, 0            ; Set AH to 0 (set video mode)
        mov al, 7  ; Restore the saved video mode
        int 10h              ; Call BIOS video interrupt to restore video mode

        ret
    clearScr endp

    inputName proc
        lea dx, tnameprompt ; Display prompt
        mov ah, 09h               ; Function to display a string
        int 21h

        lea si, tname
        inputloop:
            mov ah, 1h           ; Read input character from keyboard
            int 21h
            cmp al, 13           ; Check if Enter key is pressed
            je exit               ; If Enter key is pressed, jump to exit

            mov [si], al          ; Store the input character in the array
            inc si
        jmp inputloop

        exit:
        ret
    inputName endp

    displayName proc
        lea dx, tname ; Display the entered name
        mov ah, 09h
        int 21h
        ret
    displayName endp

    displayRules proc
        lea dx, rules
        mov ah, 09h
        int 21h
        ret
    displayRules endp

    displayTitle proc
        lea dx, intro_line
        mov ah, 09h
        int 21h

        lea dx, game_intro
        mov ah, 09h
        int 21h

        call displayName
        call nextline

        lea dx, game_intro2
        mov ah, 09h
        int 21h

        ret
    displayTitle endp
     displayend proc
        lea dx, gOmsg1
        mov ah, 09h
        int 21h

      
      


        ret
    displayend endp

    get_mouse_coordinates proc
        call set_mouse
        ; Wait for the left mouse button to be pressed
        input_again:
            mov ax, 3
            int 33h
            test bx, 1      ; Test if left button is down (bit 0 of BX)
            jz input_again  ; Jump if zero (button not pressed)

        ; Mouse button was pressed, get coordinates
        mov [mouse_x], cx
        mov [mouse_y], dx
        call set_mouse

        input_again1:
            mov ax, 3
            int 33h
            test bx, 1      ; Test if left button is down (bit 0 of BX)
            jz input_again1  ; Jump if zero (button not pressed)

        mov [mouse_x1], cx
        mov [mouse_y1], dx
        ret
    get_mouse_coordinates endp

    set_mouse proc
        ; Initialize mouse
        mov ax, 0
        int 33h
        ; Show mouse cursor
        mov ax, 1
        int 33h
        ; Set horizontal range for mouse
        mov cx, 100       ; Minimum x-coordinate
        mov dx, 580       ; Maximum x-coordinate
        mov ax, 7
        int 33h
        ; Set vertical range for mouse
        mov cx, 10        ; Minimum y-coordinate
        mov dx, 180       ; Maximum y-coordinate
        mov ax, 8
        int 33h
        ret
    set_mouse endp
    swappy1 proc
        mov ax, 0
        mov si, offset board
        mov dl, 1

        ; Determine row based on y-coordinate
        cmp [mouse_y1], 40
        jbe col11
        inc dl
        cmp [mouse_y1], 70
        jbe col11
        inc dl
        cmp [mouse_y1], 100
        jbe col11
        inc dl
        cmp [mouse_y1], 130
        jbe col11
        inc dl
        cmp [mouse_y1], 150
        jbe col11
        inc dl
        cmp [mouse_y1], 180
        jbe col11
        col11:
        mov row, dl

        ; Determine column based on x-coordinate
        mov dl, 1
        cmp [mouse_x1], 180
        jbe set1
        inc dl
        cmp [mouse_x1], 260
        jbe set1
        inc dl
        cmp [mouse_x1], 340
        jbe set1
        inc dl
        cmp [mouse_x1], 420
        jbe set1
        inc dl
        cmp [mouse_x1], 500
        jbe set1
        inc dl
        cmp [mouse_x1], 580
        jbe set1
        set1:
        mov col, dl
        call set_boxer
    
        

        
        return:
        ret
    swappy1 endp
    set_boxer proc
        mov al, col


        sub al, 1
        mov bl, 6
        mul bl              ; AL = (Row - 1) * 6
        mov bl, row
    

        add al, bl          ; AL = ((Row - 1) * 6) + Column

        ; Convert numeric result to ASCII (for single digit numbers)
            ; Convert the number in AL to its ASCII character equivalent

        ; Print the result as a character
        mov dl, al
        dec dl
        mov box2, dl
        
        ret
    set_boxer endp



    swappy proc
        mov ax, 0
        mov si, offset board
        mov dl, 1

        ; Determine row based on y-coordinate
        cmp [mouse_y], 40
        jbe col1
        inc dl
        cmp [mouse_y], 70
        jbe col1
        inc dl
        cmp [mouse_y], 100
        jbe col1
        inc dl
        cmp [mouse_y], 130
        jbe col1
        inc dl
        cmp [mouse_y], 150
        jbe col1
        inc dl
        cmp [mouse_y], 180
        jbe col1
        col1:
        mov row, dl

        ; Determine column based on x-coordinate
        mov dl, 1
        cmp [mouse_x], 180
        jbe set
        inc dl
        cmp [mouse_x], 260
        jbe set
        inc dl
        cmp [mouse_x], 340
        jbe set
        inc dl
        cmp [mouse_x], 420
        jbe set
        inc dl
        cmp [mouse_x], 500
        jbe set
        inc dl
        cmp [mouse_x], 580
        jbe set
        set:
        mov col, dl
        call set_box

        return1:
        ret
    swappy endp

    set_box proc
        mov al, col


        sub al, 1
        mov bl, 6
        mul bl              ; AL = (Row - 1) * 6
        mov bl, row
    

        add al, bl          ; AL = ((Row - 1) * 6) + Column

        ; Convert numeric result to ASCII (for single digit numbers)
            ; Convert the number in AL to its ASCII character equivalent

        ; Print the result as a character
        mov dl, al
        dec dl 
        mov box1, dl
        
        ret
        
    set_box endp

    candyPop proc
            boardWidth equ 6
            rowSize equ boardWidth - 2 ; Maximum starting index for a set of three

            mov bx, 0 ; Row index
            lea si, board ; Pointer to the start of the board

        rowLoop:
            mov di, si ; Current starting point in the row
            mov cx, 0 ; Column index within the row

        rowCheckLoop:
            ; Load the three consecutive candies in the row into registers
            mov al, [di] ; First candy
            mov ah, [di + 1] ; Second candy
            mov dl, [di + 2] ; Third candy

            ; Compare the three candies
            cmp al, ah
            jne skipPop
            cmp ah, dl
            jne skipPop

            ; If all three candies match, pop them (set to zero or some identifier)
             call randomgenerator
                        mov al, randomnum
            mov [di], al
             call randomgenerator
                        mov al, randomnum
            mov [di + 1], al
             call randomgenerator
                        mov al, randomnum
            mov [di + 2], al
            inc score

        skipPop:
            add di, 1 ; Move to the next set in the same row
            inc cx
            cmp cx, rowSize
            jl rowCheckLoop

            ; Move to the next row
            add si, boardWidth
            inc bx
            cmp bx, boardWidth ; Assuming a square board
            jl rowLoop

            ret
        candyPop endp
        
        candyPopHorizontal proc

                rowCheck:
                    mov si,0
                    mov bl,0
                    lea si, board
                    rowCheckL1:
                        mov al, byte ptr [si]
                        mov checkTemp, al
                        mov al, byte ptr [si+6]
                        mov checkTemp2, al
                        mov al, byte ptr [si+12]
                        cmp al, checkTemp2
                        jne exitcheck1
                        cmp al, checkTemp
                        jne exitcheck1 
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+6], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+12], al
                        inc score
                        exitcheck1:
                        inc bl
                        inc si  
                        cmp bl,6
                    jne rowCheckL1

                    lea si,board
                    mov bl,0
                    add si,6
                    rowCheckL2: 
                        mov al, byte ptr [si]
                        mov checkTemp, al
                        mov al, byte ptr [si+6]
                        mov checkTemp2,al
                        mov al, byte ptr [si+12]
                        cmp al, checkTemp2
                        jne exitcheck2
                        cmp al, checkTemp
                        jne exitcheck2
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+6], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+12], al
                        inc score
                        exitcheck2:
                        inc si 
                        inc bl 
                        cmp bl,6
                    jne rowCheckL2

                    mov si,0
                    lea si,board
                    mov bl,0
                    add si,12
                    rowCheckL3: 
                        mov al, byte ptr [si]
                        mov checkTemp, al
                        mov al, byte ptr [si+6]
                        mov checkTemp2,al
                        mov al, byte ptr [si+12]
                        cmp al, checkTemp2
                        jne exitcheck3
                        cmp al, checkTemp
                        jne exitcheck3
                        call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+6], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+12], al
                        inc score
                        exitcheck3:
                        inc si 
                        inc bl 
                        cmp bl,6
                    jne rowCheckL3

                    mov si,0
                    lea si,board
                    mov bl,0
                    add si,18
                    rowCheckL4: 
                        mov al, byte ptr [si]
                        mov checkTemp, al
                        mov al, byte ptr [si+6]
                        mov checkTemp2,al
                        mov al, byte ptr [si+12]
                        cmp al, checkTemp2
                        jne exitcheck4
                        cmp al, checkTemp
                        jne exitcheck4
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+6], al
                         call randomgenerator
                        mov al, randomnum
                        mov byte ptr [si+12], al
                        inc score
                        exitcheck4:
                        inc si 
                        inc bl 
                        cmp bl,6
                    jne rowCheckL4

            ret
        candyPopHorizontal endp
            

    main proc

        mov ax, @data
        mov ds, ax

        call clearScr
        call inputName 
        call clearscr
        call setcolorpage1
        call defaultposition
        call displayTitle

        call nextline
        call presstocontinue

        
        call defaultcolor
        call defaultposition
        call clearScr
        call displayRules

        call presstocontinue
        call clearScr
           call boardfiller
        start:
        cmp score, 14
        jg endgame
        cmp moves, 0
        je endgame
        dec moves
        call rowncoloum
         call printboard
         call defaultposition
         mov dx, offset one
         mov ah, 9
         int 21h
         call displayName
         mov dx, offset two
            mov ah, 9  
            int 21h
        mov dl, score
        add dl, 30h
        mov ah, 02h
        int 21h
         mov dx, offset three
            mov ah, 9  
            int 21h
        mov dl, moves
        add dl, 30h
        mov ah, 02h
        int 21h
         call get_mouse_coordinates
         call swappy
         call swappy1 
         call doit
         call candyPop
         call candyPopHorizontal
         jmp start
        
      
      
       endgame:
        call clearScr
        call defaultcolor
        call defaultposition
        call displayend
        

        mov ah, 4Ch
        int 21h
    main endp

end main