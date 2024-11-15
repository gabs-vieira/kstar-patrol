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

    ; Strings para o título e botões
    string  db 7 dup(" ")," _  __   ___ _            ",13,10
            db 7 dup(" "),"| |/ /__/ __| |_ __ _ _ _ ",13,10
            db 7 dup(" "),"| ' <___\__ \  _/ _` | '_|",13,10
            db 7 dup(" "),"|_|\_\  |___/\__\__,_|_|  ",13,10
            db 7 dup(" "),"| _ \__ _| |_ _ _ ___| |  ",13,10
            db 7 dup(" "),"|  _/ _` |  _| '_/ _ \ |  ",13,10
            db 7 dup(" "),"|_| \__,_|\__|_| \___/_|  ",13,10

    string_length equ $-string

    btn_iniciar db  14 dup(" "),218,196,196,196,196,196,196,196,196,196,191,13,10
                 db 14 dup(" "),179," INICIAR ",179,10,13
                 db 14 dup(" "),192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_iniciar_length equ $-btn_iniciar

    btn_sair db  14 dup(" "),218,196,196,196,196,196,196,196,196,196,191,13,10
              db 14 dup(" "),179,"  SAIR   ",179,10,13
              db 14 dup(" "),192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_sair_length equ $-btn_sair

    empty_sprite    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

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
    mov ah, 0
    mov menu, ah

    jmp RENDER_BUTTONS

ARROW_DOWN:
    mov ah, 1
    mov menu, ah

RENDER_BUTTONS:
    mov al, screen
    cmp al, 0H
    jne END_HANDLE
    call PRINT_BUTTONS

END_HANDLE:
    ret
ENDP

PRINT_TITLE_MENU proc
    mov AX, DS 
    mov ES, AX

    mov BP, OFFSET string
    mov CX, string_length ; tamanho
    mov BL, 02H ; Cor verde (se bit 1 de AL estiver limpo, usamos BL)
    mov DX, 0 ;linha / coluna
    call PRINT_STRING

    ret
PRINT_TITLE_MENU endp

PRINT_STRING PROC
    push AX
    push BX
    push CX
    push DX
    push SI
    push BP

    ; Configura os parâmetros para a função 13h
    mov AH, 13h         ; Função para escrever string com atributos de cor
    mov AL, 1           ; Modo: atualiza cursor após a escrita
                        ; AL = 1 -> modo de atualização de cursor
    mov BH, 0           ; Página de vídeo 0
    int 10h             ; Chamada de interrupção para exibir a string

    pop BP
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
ENDP

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
    mov BP, OFFSET btn_iniciar
    mov CX, btn_iniciar_length ; tamanho
    mov DL, 0 ; coluna
    mov DH, 18 ; linha
    call PRINT_STRING

    mov bl, 0FH
    mov ah, menu
    cmp ah, 1
    jne EXIT_BTN
    mov bl, 0CH

EXIT_BTN:
    ; Exibe o botão SAIR
    mov BP, OFFSET btn_sair
    mov CX, btn_sair_length ; tamanho
    mov DL, 0 ; coluna
    mov DH, 21 ; linha
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
    mov si, offset empty_sprite
    
    push ax
    call RENDER_SPRITE
    pop ax

    cmp ax, 101*320-15
    je MOVE_ALIEN_SHIP

    inc ship_pos
    inc ax
    mov si, offset ship
    call RENDER_SPRITE

    xor cx, cx
    mov dx, 4000H
    mov ah, 86H
    int 15h
    jmp END_POS_UPDATE

MOVE_ALIEN_SHIP:
    mov ax, alien_ship_pos
    mov si, offset empty_sprite

    push ax
    cmp ax, 100*320
    pop ax

    je RESET_POS
    call RENDER_SPRITE

    dec alien_ship_pos
    dec ax
    mov si, offset alien_ship
    call RENDER_SPRITE
    
    xor cx, cx
    mov dx, 4000H
    mov ah, 86H
    int 15h
    jmp END_POS_UPDATE

RESET_POS:
    call RESET_CROSS_SHIP_POS

END_POS_UPDATE:
    ret
endp

; Procedimento principal
main proc; Muda modo grafico
    mov AX, @data
    mov DS, AX
    mov ES, AX

    ; Define o modo de video
    mov ah, 0h
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
    mov ah, 0H
    int 16H
    jmp MENU_LOOP

SELECT_OPTION:
    mov ah, 0H
    int 16H
    
    mov ah, menu
    cmp ah, 1
    je ENCERRA

GAME_LOOP:
    ; call PRINT_SECTOR
    mov ax, 6562
    mov si, offset ship

    ; jmp MENU_LOOP


ENCERRA:
    ; Volta para modo texto
    mov ah, 0h
    mov al, 3h
    int 10h

    ; Encerra o programa
    mov ah, 4ch
    mov al, 0
    int 21h
    ret
main endp

end main
