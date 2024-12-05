.model small
.stack

.data
    menu db 0
    ; 0 - Menu
    ; 1 - Setor
    ; 2 - Jogo
    ; 3 - Game Over
    screen db 0
    sector db 1
    time dw 0
    score dw 0

    ; Re-renders
    rerender_allies db 1
    rerender_score db 1

    ; Strings para o título e botões
    string  db 7 dup(" ")," _  __   ___ _            ",13,10
            db 7 dup(" "),"| |/ /__/ __| |_ __ _ _ _ ",13,10
            db 7 dup(" "),"| ' <___\__ \  _/ _` | '_|",13,10
            db 7 dup(" "),"|_|\_\  |___/\__\__,_|_|  ",13,10
            db 7 dup(" "),"| _ \__ _| |_ _ _ ___| |  ",13,10
            db 7 dup(" "),"|  _/ _` |  _| '_/ _ \ |  ",13,10
            db 7 dup(" "),"|_| \__,_|\__|_| \___/_|  ",13,10

    string_length equ $-string
    
    score_str db "SCORE:"
    score_str_len equ $-score_str
    
    time_str db "TEMPO:"
    time_str_len equ $-time_str

    sector_one  db 5 dup(" "), " ___       _              _    ",13,10
                db 5 dup(" "), "/ __| ___ | |_ ___ _ _   / |   ",13,10
                db 5 dup(" "), "\__ \/ -_)|  _/ _ \ '_|  | |   ",13,10
                db 5 dup(" "), "|___/\___\ \__\___/_|    |_|   ",13,10

    sector_two  db 5 dup(" "), " ___       _              ___  ",13,10
                db 5 dup(" "), "/ __| ___ | |_ ___ _ _   |_  ) ",13,10
                db 5 dup(" "), "\__ \/ -_)|  _/ _ \ '_|   / /  ",13,10
                db 5 dup(" "), "|___/\___\ \__\___/_|    /___| ",13,10

    sector_three    db 5 dup(" "), " ___       _              ____ ",13,10
                    db 5 dup(" "), "/ __| ___ | |_ ___ _ _   |__ / ",13,10
                    db 5 dup(" "), "\__ \/ -_)|  _/ _ \ '_|   |_ \ ",13,10
                    db 5 dup(" "), "|___/\___\ \__\___/_|    |___/ ",13,10

    sector_len equ $-sector_three

    sector_vec dw offset sector_one, offset sector_two, offset sector_three

    btn_iniciar db  14 dup(" "),218,196,196,196,196,196,196,196,196,196,191,13,10
                 db 14 dup(" "),179," INICIAR ",179,10,13
                 db 14 dup(" "),192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_iniciar_length equ $-btn_iniciar

    btn_sair db  14 dup(" "),218,196,196,196,196,196,196,196,196,196,191,13,10
              db 14 dup(" "),179,"  SAIR   ",179,10,13
              db 14 dup(" "),192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_sair_length equ $-btn_sair

    ship        db 15,15,15,15,15,15,15,15,15,15,15,15,0,0,0
                db 0,0,15,15,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,15,15,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,15,15,15,15,15,15,15,15,15
                db 0,0,15,15,15,15,15,15,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,0,0,0,0,0,0,0,0,0,0,0
                db 15,15,15,15,15,15,15,15,15,15,15,15,0,0,0

    ship_pos dw 0
    ship_color db 0FH
    
    allies_pos_vec dw 320 * 20, 320 * 40, 320 * 60, 320 * 80, 320 * 100, 320 * 120, 320 * 140, 320 * 160
    
    ; Least significant nibble represents the color, most significant nibble represents dead/alive (1/0)
    allies_attr_vec db 15H, 16H, 19H, 1AH, 1BH, 1CH, 1DH, 1EH

    alien_ship  db 0,0,0,0,0,0,0,0,9,9,9,9,9,9,9
                db 0,0,0,0,0,0,0,0,9,9,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,9,9,9,9,0,0,0,0,0,0,0
                db 9,9,9,9,9,9,9,9,9,9,9,9,0,0,0
                db 0,0,0,0,9,9,9,9,0,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,9,9,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,9,9,9,9,9,9,9

    alien_ship_pos dw 0

    shot_nave    db 15,15,15,15,15,15,15,15,15,0,0,0,0,0,0
                db 15 dup (0)
                db 15 dup (0)
                db 15 dup (0)
                db 0,0,0,0,0,0,15,15,15,15,15,15,15,15,15
                db 15 dup (0)
                db 15 dup (0)
                db 15 dup (0)
                db 15,15,15,15,15,15,15,15,15,0,0,0,0,0,0

.code
; Procedimento para navegação no menu usando as setas
HANDLE_INPUT PROC
    cmp ah, 48H
    je ARROW_UP

    cmp ah, 50H
    je ARROW_DOWN

    jmp END_HANDLE

ARROW_UP:
    xor ah, ah
    mov menu, ah

    jmp RENDER_BUTTONS

ARROW_DOWN:
    mov ah, 1
    mov menu, ah

RENDER_BUTTONS:
    mov al, screen
    cmp al, 0
    jne END_HANDLE
    call PRINT_BUTTONS

END_HANDLE:
    ret
ENDP



; Proc para controle da nave
HANDLE_CONTROLS proc
    push si
    push ax
    push bx

    mov al, 1
    mov si, offset ship_pos
    mov bx, 4

    cmp ah, 48H
    je MOVE_UP

    cmp ah, 50H
    je MOVE_DOWN

    jmp END_CONTROLS

MOVE_UP:
    mov di, [si]
    call CLEAR_SPRITE

    mov ah, 1
    call MOVE_SPRITE
    jmp END_CONTROLS

MOVE_DOWN:
    mov di, [si]
    call CLEAR_SPRITE

    xor ah, ah
    call MOVE_SPRITE

END_CONTROLS:
    pop bx
    pop ax
    pop si
    ret
endp

PRINT_TITLE_MENU proc
    mov ax, ds 
    mov es, ax

    mov bp, offset string
    mov cx, string_length ; tamanho
    mov bl, 02H ; Cor verde (se bit 1 de AL estiver limpo, usamos BL)
    xor dx, dx ;linha / coluna
    call PRINT_STRING

    ret
endp

; AL = axis (0 is X, 1 is Y)
; AH = direction (0 is positive, 1 is negative)
; SI = position pointer
; BX = increment
MOVE_SPRITE proc
    push si
    push ax
    push bx

    mov cx, [si]
    cmp al, 0
    jne MOVE_Y_AXIS
    jmp CHECK_DIRECTION

MOVE_Y_AXIS:
    push ax
    mov ax, 320
    mul bx
    mov bx, ax
    pop ax

CHECK_DIRECTION:
    cmp ah, 0
    jne MOVE_NEGATIVE
    add cx, bx
    jmp SAVE_POS

MOVE_NEGATIVE:
    sub cx, bx

SAVE_POS:
    mov [si], cx

    pop bx
    pop ax
    pop si
    ret
endp

PRINT_STRING PROC
    push AX
    push BX
    push DS
    push ES
    push SI
    push BP

    ; Configura os parâmetros para a função 13h
    mov ah, 13h         ; Função para escrever string com atributos de cor
    mov al, 1           ; Modo: atualiza cursor após a escrita
                        ; AL = 1 -> modo de atualização de cursor
    xor bh, bh           ; Página de vídeo 0
    int 10h             ; Chamada de interrupção para exibir a string

    pop BP
    pop SI
    pop ES
    pop DS
    pop BX
    pop AX
    ret
ENDP

; SI = sprite pointer
; BL = color
CHANGE_SPRITE_COLOR proc
    push ax
    push bx
    push cx
    push si

    mov cx, 15*9

PIXEL_LOOP:
    mov al, [si]
    cmp al, 0
    jz SKIP_REPLACE
    mov [si], bl

SKIP_REPLACE:
    inc si
    loop PIXEL_LOOP

    pop si
    pop cx
    pop bx
    pop ax
    ret
endp

CLEAR_SPRITE proc
    push ax
    push cx
    push di
    push es
    
    mov ax, 0A000H
    mov es, ax
    mov cx, 9

CLEAR_LINE:
    push cx
    mov cx, 15
    xor ax, ax
    rep stosb
    add di, 320-15
    pop cx
    loop CLEAR_LINE

    pop es
    pop di
    pop cx
    pop ax
    ret
endp

; AX = sprite position
; SI = sprite pointer
RENDER_SPRITE proc
    push bx
    push cx
    push dx
    push di
    push es
    push ds
    push ax

    mov ax, @data
    mov ds, ax

    mov ax, 0A000h
    mov es, ax

    pop ax
    mov di, ax
    mov dx, 9
    push ax

DRAW_LINE:
    mov cx, 15
    rep movsb
    add di, 320 - 15
    dec dx
    jnz DRAW_LINE

    pop ax
    pop ds  
    pop es
    pop di
    pop dx
    pop cx
    pop bx
ret
endp

; Procedimento para exibir os botões INICIAR e SAIR
PRINT_BUTTONS proc
    push ax
    mov bl, 0FH
    mov ah, menu
    cmp ah, 0
    jne START_BTN
    mov bl, 0CH

START_BTN:
    ; Exibe o botão INICIAR
    mov bp, offset btn_iniciar
    mov cx, btn_iniciar_length ; tamanho
    xor dl, dl ; coluna
    mov dh, 18 ; linha
    call PRINT_STRING

    mov bl, 0FH
    mov ah, menu
    cmp ah, 1
    jne EXIT_BTN
    mov bl, 0CH

EXIT_BTN:
    mov bp, offset btn_sair
    mov cx, btn_sair_length
    xor dl, dl ; coluna
    mov dh, 21 ; linha
    call PRINT_STRING

    pop ax
    ret
endp

RESET_CROSS_SHIP_POS proc
    push ax

    mov ax, 100 * 320
    mov ship_pos, ax
    add ax, 305
    mov alien_ship_pos, ax

    pop ax
    ret
endp

CROSS_SHIPS proc
    mov ax, ship_pos
    mov di, ax
    call CLEAR_SPRITE

    cmp ax, 101*320-15
    je MOVE_ALIEN_SHIP

    inc ship_pos
    inc ax
    mov si, offset ship
    call RENDER_SPRITE

    xor cx, cx
    mov dx, 0C350H
    mov ah, 86H
    int 15h
    jmp END_POS_UPDATE

MOVE_ALIEN_SHIP:
    mov ax, alien_ship_pos
    mov di, ax

    push ax
    cmp ax, 100*320
    pop ax

    je RESET_POS
    call CLEAR_SPRITE

    dec alien_ship_pos
    dec ax
    mov si, offset alien_ship
    call RENDER_SPRITE
    
    xor cx, cx
    mov dx, 0C350H
    mov ah, 86H
    int 15h
    jmp END_POS_UPDATE

RESET_POS:
    call RESET_CROSS_SHIP_POS

END_POS_UPDATE:
    ret
endp

RENDER_ALLY_SHIPS proc
    push di
    push dx
    push cx
    push bx
    push ax

    mov cx, 8
    mov bx, offset allies_pos_vec
    mov dx, offset allies_attr_vec

RENDER_SINGLE:
    mov ax, [bx]
    mov si, offset ship

    push bx
    push ax

    mov bx, dx
    mov al, [bx]
    mov bl, al
    and bl, 0FH
    and al, 0F0H
    pop ax
    jnz NO_CLEAR
    mov di, ax
    call CLEAR_SPRITE

NO_CLEAR:
    call CHANGE_SPRITE_COLOR
    call RENDER_SPRITE

    pop bx
    add bx, 2
    inc dx
    loop RENDER_SINGLE

    pop ax
    pop bx
    pop cx
    pop dx
    pop di
    ret
endp

CLEAR_SCREEN proc
    push ax
    push cx
    push es
    push di

    mov ax,0A000h
    mov es,ax
    xor di, di
    mov cx, 32000d
    cld
    xor ax, ax
    rep stosw
    
    pop di
    pop es
    pop cx
    pop ax
    ret
endp

RENDER_SECTOR proc
    push ax
    push bx
    push cx
    push dx
    push bp

    call CLEAR_SCREEN

    ; Print Sector
    mov al, sector
    xor ah, ah
    dec al ; number vector index

    shl al, 1 ; multiply by 2 (since num_vec values are dw)
    mov bx, offset sector_vec ; get the vector
    add bx, ax ; add the index to the vector ptr
    mov bp, [bx] ; set BP to base address of number
    mov cx, sector_len
    xor dl, dl; line
    mov dh, 10
    mov bl, 0DH
    call PRINT_STRING

    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

RESET_SHIP proc
    mov ship_pos, 320 * 95 + 47 ; Ship stating position
    ret
endp


UPDATE_SHIP proc
    push si
    push di
    push ax
    push bx

    mov ah, 1H
    int 16H
    jz END_SHIP_UPDATE

    call HANDLE_CONTROLS
    xor ah, ah
    int 16H

    mov ax, ship_pos
    mov di, ax
    call CLEAR_SPRITE

    mov si, offset ship
    mov bl, 0FH ; white
    call CHANGE_SPRITE_COLOR
    call RENDER_SPRITE

END_SHIP_UPDATE:
    
    pop bx
    pop ax
    pop di
    pop si
    ret
endp

RENDER_SCORE proc
    push bp
    push bx
    push cx
    push dx

    mov bp, offset score_str
    mov cx, score_str_len
    mov bl, 0FH ; white
    xor dx, dx
    call PRINT_STRING

    pop dx
    pop cx
    pop bx
    pop bp
    
    ; Print value in green

    ret
endp

RENDER_TIME proc
    push bp
    push bx
    push cx
    push dx

    mov bp, offset time_str
    mov cx, time_str_len
    mov bl, 0FH ; white
    xor dh, dh
    mov dl, 25
    call PRINT_STRING

    pop dx
    pop cx
    pop bx
    pop bp
    
    ; Print value in green

    ret
endp


RESET proc ; Contains all procedures for reseting values
    call CLEAR_SCREEN
    call RESET_SHIP
    ret
endp

UPDATE proc ; Contains all procedures for updating game state
    call UPDATE_SHIP
    ret
endp

RENDER proc ; Contains all procedures for rendering game objects
    push ax
    call RENDER_TIME

SKIP_2_ALLIES: 
    ; should re-render allies?
    mov al, rerender_allies
    cmp al, 1
    jne SKIP_2_SCORE
    call RENDER_ALLY_SHIPS
    mov rerender_allies, 0

SKIP_2_SCORE:

    ; should re-render score?
    mov al, rerender_score
    cmp al, 1
    jne END_RENDER
    call RENDER_SCORE
    mov rerender_score, 0

END_RENDER:
    pop ax
    ret
endp

END_GAME proc
    ; Back to text mode
    xor ah, ah
    mov al, 3h
    int 10h

    ; Ends program
    mov ah, 4ch
    xor al, al
    int 21h
    ret
endp

MAIN proc
    mov AX, @data
    mov DS, AX
    mov AX, 0A000H
    mov ES, AX
    xor DI, DI

    ; Define o modo de video
    xor ah, ah
    xor bh, bh
    mov al, 13h
    int 10h

    ; Exibe título e botões do menu
    call PRINT_TITLE_MENU
    call PRINT_BUTTONS
    call RESET_CROSS_SHIP_POS

MENU_LOOP:
    call CROSS_SHIPS
    
    ; Recebe entrada do usuário
    mov ah, 1H
    int 16H
    jz MENU_LOOP

    ; Chama a função de navegação
    call HANDLE_INPUT

    ; Condição para iniciar o jogo
    cmp ah, 1CH
    je SELECT_OPTION

    ; Retorno ao loop do menu
    xor ah, ah
    int 16H
    jmp MENU_LOOP

SELECT_OPTION:
    xor ah, ah
    int 16H
    
    mov ah, menu
    cmp ah, 1
    je FINISH

    call RENDER_SECTOR

    ; Wait 4s
    mov cx, 3DH
    mov dx, 900H
    mov ah, 86H
    int 15h

    call RESET

GAME_LOOP:
    call UPDATE
    call RENDER

    jmp GAME_LOOP

FINISH:
    CALL END_GAME
    
    ret
endp

end MAIN
