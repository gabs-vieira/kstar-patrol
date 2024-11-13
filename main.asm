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

    botao_iniciar db "                                  ",218,196,196,196,196,196,196,196,196,196,191,10,13
                 db "                                  ",179," INICIAR ",179,10,13
                 db "                                  ",192,196,196,196,196,196,196,196,196,196,217,10,13,"$"

    botao_sair db "                                  ",218,196,196,196,196,196,196,196,196,196,191,10,13
              db "                                  ",179,"  SAIR   ",179,10,13
              db "                                  ",192,196,196,196,196,196,196,196,196,196,217,10,13,"$"

.code

; Procedimento para navegação no menu usando as setas
NAVIGATE proc
    cmp ah, 72H    ; Código para seta para cima
    je ARROW_UP
    cmp ah, 80H    ; Código para seta para baixo
    je ARROW_DOWN
    jmp FIM_NAVIGATE

ARROW_UP:
    ; Código para navegar para cima
    jmp FIM_NAVIGATE

ARROW_DOWN:
    ; Código para navegar para baixo
    jmp FIM_NAVIGATE

FIM_NAVIGATE:
    ret
NAVIGATE endp

PRINT_TITLE_MENU proc
    ; Posiciona o cursor e exibe o título
    ; mov dl, 0      ; Coluna
    ; mov dh, 2      ; Linha
    ; mov ah, 2h
    ; int 10h


    ; mov bl,0ah

    ; ; Exibe o título na tela
    ; mov dx, offset string
    ; mov ah, 9H
    ; int 21h

    mov BP, OFFSET string
    mov CX, string_length ; tamanho
    mov BL, 0AH ; cor
    mov DL, 2 ;coluna
    mov DH, 2 ; linha

    call print_string

    ret
PRINT_TITLE_MENU endp

print_string PROC
    push AX
    push BX
    push CX
    push DX
    push SI
    push BP

    mov AH, 13h
    mov AL, 01h
    xor BH, BH
    int 10h

    pop Bp
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
print_string ENDP


; Procedimento para exibir os botões INICIAR e SAIR
PRINT_BUTTONS proc
    ; Exibe o botão INICIAR
    mov dl, 0
    mov dh, 16
    mov ah, 2h
    int 10h
    mov dx, offset botao_iniciar
    mov ah, 9H
    int 21h

    ; Exibe o botão SAIR
    mov dh, 18
    mov dx, offset botao_sair
    mov ah, 9H
    int 21h
    ret
PRINT_BUTTONS endp

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
    cmp al, 'q'
    je INICIA_JOGO

    ; Retorno ao loop do menu
    mov ah, 0H
    int 16H
    jmp LACO_MENU

INICIA_JOGO:
    ; Código para iniciar o jogo

    ; Encerra o programa
    mov ah, 4ch
    mov al, 0
    int 21h
    ret
main endp

end main
