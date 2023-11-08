TOKEN_SIZE = 9
TOKEN_IDENTIFIER = 0
TOKEN_PLUS = 1
TOKEN_MINUS = 2
TOKEN_STAR = 3
TOKEN_SLASH = 4

; tokenize(output: [*]Token, input: [*]const u8, input_len: u32) u32
tokenize:
    push ebp
    mov ebp, esp
    xor eax, eax

.loop:
    cmp edx, 0
    je .end

    ; whitespace = { ' ', '\t', '\n', vt, ff, '\r' }
    .whitespaceCheck:
        cmp byte [ecx], 32
        je .whitespace
        cmp byte [ecx], 9
        jl .whitespaceCheckEnd
        cmp byte [ecx], 13
        jg .whitespaceCheckEnd
        jmp .whitespace
    .whitespaceCheckEnd:

    .alphaCheck:
        push eax
        mov al, byte [ecx]
        call isAlpha
        cmp eax, 0
        pop eax
        je .alphaCheckEnd
        jmp .identifier
    .alphaCheckEnd:

    cmp byte [ecx], 43
    je .plus
    cmp byte [ecx], 45
    je .minus
    cmp byte [ecx], 42
    je .star
    cmp byte [ecx], 47
    je .slash

    jmp errorHandle.token

.loopRet:
    inc ecx
    dec edx
    jmp .loop

.whitespace:
    jmp .loopRet

.identifier:
    push edx
    push ecx
    push eax
    push ebx

    mov ebx, isAlpha
    call takeWhile
    cmp eax, 0
    je .identifierFalse

    pop ebx
    pop eax

.identifierTrue:
    inc eax
    mov byte [ebx], TOKEN_IDENTIFIER
    pop dword [ebx+1]
    pop dword [ebx+5]
    sub dword [ebx+5], edx
    add ebx, TOKEN_SIZE
    jmp .loopRet
.identifierFalse:
    pop dword [ebx+1]
    pop dword [ebx+5]
    jmp .loopRet

.plus:
    inc eax
    mov byte [ebx], TOKEN_PLUS
    add ebx, TOKEN_SIZE
    jmp .loopRet

.minus:
    inc eax
    mov byte [ebx], TOKEN_MINUS
    add ebx, TOKEN_SIZE
    jmp .loopRet

.star:
    inc eax
    mov byte [ebx], TOKEN_STAR
    add ebx, TOKEN_SIZE
    jmp .loopRet

.slash:
    inc eax
    mov byte [ebx], TOKEN_SLASH
    add ebx, TOKEN_SIZE
    jmp .loopRet

.end:
    pop ebp
    ret

; isAlpha(c: u8) bool
; al
isAlpha:
    or al, 0x20
    sub al, 'a'
    cmp al, 'z'-'a'
    ja .end

    mov al, 1
    ret
.end:
    mov al, 0
    ret

; takeWhile(f: fn(u8) bool, input: [*]const u8, input_len: u32) u32
takeWhile:
    push ebp
    mov ebp, esp
    push edx
    jmp .body
.loop:
    inc ecx
    dec edx
.body:
    cmp edx, 0
    je .end

    mov al, byte [ecx]
    call ebx
    cmp al, 0
    je .end
    jmp .loop
.end:
    pop eax
    sub eax, edx
    pop ebp
    ret
