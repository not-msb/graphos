VRAM equ 0xA0000

macro putp x, y, color {
    index = x + 320 * y
    mov byte [VRAM + index], color
}

; drawRow(x: u8, y: u8, color: u8) void
macro drawPixel x, y, color {
    mov ebx, x
    mov ecx, y
    mov edx, color
    call drawPixelEntry
}

drawPixelEntry:
    imul ecx, 320
    mov byte [VRAM+ebx+ecx], dl
    ret
