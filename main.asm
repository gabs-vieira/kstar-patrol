.model small
.stack

.data
    menu db 0H

    ; Strings para o título e botões
    string db "                                                                   ",13,10
           db "                  ____  __.           _________ __                 ",13,10
           db "                 |    |/ _|          /   _____//  |______ _______  ",13,10
           db "                 |      <    ______  \_____  \\   __\__  \\_  __ \ ",13,10
           db "                 |    |  \  /_____/  /        \|  |  / __ \|  | \/ ",13,10
           db "                 |____|__ \         /_______  /|__| (____  /__|    ",13,10
           db "                 __________        __       \/       .__ \/        ",13,10
           db "                 \______   \____ _/  |________  ____ |  |          ",13,10
           db "                  |     ___|__  \\   __\_  __ \/  _ \|  |          ",13,10
           db "                  |    |    / __ \|  |  |  | \(  <_> )  |__        ",13,10
           db "                  |____|   (____  /__|  |__|   \____/|____/        ",13,10
           db "                                \/                                 ",13,10
           db "                                                                   ",13,10

    string_length equ $-string

    btn_iniciar db "                                  ",218,196,196,196,196,196,196,196,196,196,191,13,10
                 db "                                  ",179," INICIAR ",179,10,13
                 db "                                  ",192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_iniciar_length equ $-btn_iniciar

    btn_sair db "                                  ",218,196,196,196,196,196,196,196,196,196,191,13,10
              db "                                  ",179,"  SAIR   ",179,10,13
              db "                                  ",192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_sair_length equ $-btn_sair


    Ship        db 15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0
                db 0,0,15,15,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,15,15,0,0,0,0,0,0
                db 0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15
                db 0,0,15,15,15,15,15,15,0,0,0,0,0,0
                db 0,0,15,15,15,15,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,0,0,0,0,0,0,0,0,0,0,0,0
                db 15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0
    
    AlienShip   db 0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9
                db 0,0,0,0,0,0,0,0,9,9,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,9,9,9,9,0,0,0,0,0,0,0,0
                db 9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0
                db 0,0,0,0,9,9,9,9,0,0,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,9,9,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9


    ShotNave    db 15,15,15,15,15,15,15,15,15,0,0,0,0,0,0
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
NAVIGATE PROC
    cmp ah, 48H    ; Código para seta para cima
    je CHANGE_SELECTION
    cmp ah, 50H    ; Código para seta para baixo
    je CHANGE_SELECTION
    jmp FIM_NAVIGATE

CHANGE_SELECTION:
    push ax
    push bx
    ; Código para navegar
    mov ah, menu
    xor ah, 1
    mov bx, offset menu
    mov byte ptr [bx], ah
    pop bx
    pop ax
    call PRINT_BUTTONS
FIM_NAVIGATE:
    ret
ENDP

PRINT_TITLE_MENU proc
    mov AX, DS 
    mov ES, AX

    mov BP, OFFSET string
    mov CX, string_length ; tamanho
    mov BL, 02H ; Cor verde (se bit 1 de AL estiver limpo, usamos BL)
    mov DL, 2 ;coluna
    mov DH, 2 ; linha
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
    mov DH, 16 ; linha
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
    mov DH, 19 ; linha
    call PRINT_STRING

    pop ax
    ret
endp

; Procedimento principal
main proc
    mov AX, @data
    mov DS, AX

    ; Define o modo texto
    mov al, 3h
    mov ah, 0h
    int 10h

    ; Exibe título e botões do menu
    call PRINT_TITLE_MENU
    call PRINT_BUTTONS

LACO_MENU:
    ; Espera por entrada do usuário
    mov ah, 1H
    int 16H
    jz LACO_MENU

    ; Chama a função de navegação
    call NAVIGATE

    ; Condição para iniciar o jogo
    cmp ah, 1CH
    je CONFIRMA_SELECAO

    ; Retorno ao loop do menu
    mov ah, 0H
    int 16H
    jmp LACO_MENU

CONFIRMA_SELECAO:
    mov ah, 0H
    int 16H
    ; Código para iniciar o jogo

ENCERRA:
    ; Encerra o programa
    mov ah, 4ch
    mov al, 0
    int 21h
    ret
main endp

end main
