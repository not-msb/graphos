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

    ;prlop:
    ;    putS msg1, 0x3f
    ;    jmp prlop

    hang:
        hlt
        jmp hang

msg1 strDef "Hello, "
msg2 strDef "World"
msgException strDef "Exception Occurred"
msgInterrupt strDef "Interrupt Occurred: "
msgTimer strDef "Timer!"

include "lib32/pic.asm"
include "lib32/idt.asm"
include "lib32/keyboard.asm"
