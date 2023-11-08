org 0x8000
jmp kmain

include "lib/string.asm"
include "lib32/vga.asm"
;include "lib32/graphics.asm"

kmain:
    ;putS 0, 0, 4
    ;drawPixel 20, 30, 2
    ;putS 0x8000, 0x0f

    putS msg1, 0x1f
    putS msg2, 0x2f
    putH 0xdeadbeef, 0x3f

    mov ebx, 0x20
    mov ecx, 0x28
    call picRemap
    call idtInit

    mov ebx, token_buffer
    mov ecx, input
    mov edx, input.len
    call tokenize

    mov ebx, token_buffer
    mov ecx, eax
    call printTokens

    ;prlop:
    ;    putS msg1, 0x3f
    ;    jmp prlop

    hang:
        hlt
        jmp hang

; printTokens(token: [*]const Token, len: u32) void
printTokens:
    cmp ecx, 0
    je .end

    push ebx
    push ecx

    call printToken

    pop ecx
    pop ebx

    add ebx, TOKEN_SIZE
    dec ecx
    jmp printTokens
.end:
    ret

; printToken(token: *const Token) void
printToken:
    cmp byte [ebx], TOKEN_IDENTIFIER
    je .identifier
    cmp byte [ebx], TOKEN_PLUS
    je .plus
    cmp byte [ebx], TOKEN_MINUS
    je .minus
    cmp byte [ebx], TOKEN_STAR
    je .star
    cmp byte [ebx], TOKEN_SLASH
    je .slash

.unknown:
    putS tokenMsg.unknown, 0x4f
    jmp .end
.identifier:
    push ebx
    putS tokenMsg.identifier, 0x2f
    pop ebx
    ;mov eax, SYS_WRITE
    ;mov ecx, dword [ebx+1]
    ;mov edx, dword [ebx+5]
    ;mov ebx, 1
    ;int 80h
    jmp .end
.plus:
    putS tokenMsg.plus, 0x2f
    jmp .end
.minus:
    putS tokenMsg.minus, 0x2f
    jmp .end
.star:
    putS tokenMsg.star, 0x2f
    jmp .end
.slash:
    putS tokenMsg.slash, 0x2f
    jmp .end
.end:
    ret

errorHandle:
.token:
    putS errorMsg.token, 0x2f
    jmp hang

msg1 strDef "Hello, "
msg2 strDef "World"
msgException strDef "Exception Occurred"
msgInterrupt strDef "Interrupt Occurred: "
msgTimer strDef "Timer!"

input strDef "+ a b - c d * e f / g h"
token_buffer = 0x18000

errorMsg:
.token strDef "[error] Couldn't tokenize"

tokenMsg:
.unknown strDef "[token] Unknown"
.identifier strDef "[token] Identifier:"
.plus strDef "[token] Plus"
.minus strDef "[token] Minus"
.star strDef "[token] Star"
.slash strDef "[token] Slash"

include "lib32/pic.asm"
include "lib32/idt.asm"
include "lib32/keyboard.asm"
include "compiler/token.asm"
