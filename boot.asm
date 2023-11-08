kernel_entry equ 0x8000
sector_count equ 8

org 0x7c00
mov bx, kernel_entry
mov cx, sector_count
call readSectors

;xor ah, ah
;mov al, 0x13
;int 0x10

jmp enter_pm

include "lib16/disk.asm"
include "lib16/gdt.asm"
include "lib16/switch.asm"

repeat 510-($-$$)
    db 0
end repeat
dw 0xaa55

include "kernel.asm"
repeat (512*sector_count)-($-$$)
    db 0
end repeat
