.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data
    output db "DIGITE UM INTEIRO: ", 0ah, 0h
    outputHandle dd 0 ; Variavel para armazenar o handle de saida
    write_count dd 0; Variavel para armazenar caracteres escritos na console

    output2 db "O NUMERO EH PRIMO", 0ah, 0h
    outputHandle2 dd 0 ; Variavel para armazenar o handle de saida
    write_count2 dd 0; Variavel para armazenar caracteres escritos na console

    output3 db "O NUMERO NAO EH PRIMO", 0ah, 0h
    outputHandle3 dd 0 ; Variavel para armazenar o handle de saida
    write_count3 dd 0; Variavel para armazenar caracteres escritos na console

    output4 db "DESEJA INFORMAR UM NOVO NUMERO PARA SER VERIFICADO? SE SIM DIGITE 1 SE NAO DIGITE 0", 0ah, 0h
    outputHandle4 dd 0 ; Variavel para armazenar o handle de saida
    write_count4 dd 0; Variavel para armazenar caracteres escritos na console

    inputString db 50 dup(0)
    inputHandle dd 0 ; Variavel para armazenar o handle de entrada
    ; outputHandle dd 0 ; Variavel para armazenar o handle de saida
    console_count dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
    tamanho_string dd 0 ; Variavel para armazenar tamanho de string terminada em 0


.code
    aa dword -99

; FUNCAO QUE DEFINE SE NUMERO EH PRIMO OU NAO
MeuProc:
    push ebp
    mov ebp, esp
    sub esp, 8
    mov DWORD PTR [ebp-4], 2
    mov eax, DWORD PTR [ebp+8]
    mov DWORD PTR [ebp-8], eax
    cmp eax, 2 ; DEFINE EXCECAO PARA ALGORITMO
    je eprimo
    cmp eax, 3 ; DEFINE EXCECAO PARA ALGORITMO
    je eprimo
detectarprimo:
    ; DETECTA SE EH PRIMO OU NAO ENCAMINHANDO PARA EPRIMO OU NAOPRIMO
    printf(" ")
    mov eax, 0 
    mov edi, DWORD PTR [ebp-4]
    mov esi, DWORD PTR [ebp-8]
    mov eax, DWORD PTR [ebp-8]
    div edi
    cmp edx, 0
    je naoprimo
    add DWORD PTR [ebp-4], 1
    mov edi, DWORD PTR [ebp-4]
    mov ecx, edi
    add ecx, 1
    cmp ecx, esi 
    jle detectarprimo 
eprimo:
    ; DEFINE RETORNO PARA 1 SE FOR PRIMO
    mov eax, 1
    jmp fimfuncao
naoprimo:
    ; DEFINE RETORNO PARA 0 SE NAO FOR PRIMO
    mov eax, 0
fimfuncao:
    ; TERMINA FUNCAO
    mov esp, ebp
    pop ebp
    ret 4

start:
    push STD_OUTPUT_HANDLE
    call GetStdHandle ;
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr output, sizeof output, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax

    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL
    invoke StrLen, addr inputString
    mov tamanho_string, eax

    mov esi, offset inputString ; 
    proximo:
        mov al, [esi] ; Mover caracter atual para al
        inc esi ; Apontar para o proximo caracter
        cmp al, 48 ; Verificar se menor que ASCII 48 - FINALIZAR
        jl terminar
        cmp al, 58 ; Verificar se menor que ASCII 58 - CONTINUAR
        jl proximo
    terminar:
        dec esi ; 
        xor al, al ; 
        mov [esi], al ; 

    invoke atodw, addr inputString
    ; mov aa, eax

    push eax
    call MeuProc ; INICIA FUNCAO QUE DEFINE SE NUMERO EH PRIMO OU NAO
    cmp eax, 0
    je naoeprimo
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov outputHandle2, eax
    invoke WriteConsole, outputHandle2, addr output2, sizeof output2, addr write_count2, NULL
    jmp final
naoeprimo:
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov outputHandle3, eax
    invoke WriteConsole, outputHandle3, addr output3, sizeof output3, addr write_count3, NULL
final:
    ;PARTE FINAL NA QUAL SERA ENCAMINHADO A UMA NOVA TENTATIVA OU NAO
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov outputHandle4, eax
    invoke WriteConsole, outputHandle4, addr output4, sizeof output4, addr write_count4, NULL
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax

    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL
    invoke StrLen, addr inputString
    mov tamanho_string, eax

    mov esi, offset inputString ; Armazenar apontador da string em esi
    proximo2:
        mov al, [esi] ; Mover caracter atual para al
        inc esi ; Apontar para o proximo caracter
        cmp al, 48 ; Verificar se menor que ASCII 48 - FINALIZAR
        jl terminar2
        cmp al, 58 ; Verificar se menor que ASCII 58 - CONTINUAR
        jl proximo2
    terminar2:
        dec esi ; Apontar para caracter anterior
        xor al, al ; 0 ou NULL
        mov [esi], al ; Inserir NULL logo apos o termino do numero

    invoke atodw, addr inputString

    cmp eax, 0
    je terminarfinal
    jmp start
terminarfinal:
    invoke ExitProcess, 0
end start