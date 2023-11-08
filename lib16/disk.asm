; loadSector(dest: [*]u8, amount: usize) void
readSectors:
    push cx

    mov ah, 0x02
    mov al, cl
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    int 0x13
    ;jc .sectorReadError

    pop cx
    ;cmp al, cl
    ;jne .sectorAmountError
    ret

; Too lazy to do error handling
; If you see something weird, it's your problem
;.sectorReadError:
;.sectorAmountError:
