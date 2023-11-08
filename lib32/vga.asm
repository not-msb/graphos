VGA equ 0xb8000
vga_cur dd 0

; putC(char: u8, color: u8) void
macro putC char, color {
    mov bl, char
    mov cl, color
    call putCEntry
}

putCEntry:
    mov eax, [vga_cur]
    mov byte [VGA+eax], dl
    mov byte [VGA+eax+1], cl
    add eax, 2
    cmp eax, (2 * 80 * 25)
    jne .end
    xor eax, eax
.end:
    mov [vga_cur], eax
    ret

; putS(msg: [*:0]const u8, color: u8) void
macro putS msg, color {
    mov ebx, msg
    mov ecx, color
    call putSEntry
}

putSEntry:
    mov eax, [vga_cur]
.loop:
    mov dl, byte [ebx]
    test dl, dl
    jz .end

    mov byte [VGA+eax], dl
    mov byte [VGA+eax+1], cl

    inc ebx
    add eax, 2
    cmp eax, ( 2* 80 * 25)
    jne .loop

    xor eax, eax
    jmp .loop
.end:
    mov [vga_cur], eax
    ret

; putH(hex: usize, color: u8) void
macro putH hex, color {
    mov ebx, hex
    mov ecx, color
    call putHEntry
}

; putH(hex: usize, color: u8) void
putHEntry:
    xor edx, edx
.loop:
    cmp edx, 8
    je .end

    mov eax, ebx
    and al, 0x0f
    cmp al, 10
    jl .decimal
.hex:
    sub al, 10
    add al, 65
    jmp .print
.decimal:
    add al, 48
.print:
    mov edi, hex_output + hex_output.len - 2
    sub edi, edx
    mov [edi], al
    inc edx
    shr ebx, 4
    jmp .loop
.end:
    mov ebx, hex_output
    call putSEntry
    ret

hex_output strDef "0x00000000"
