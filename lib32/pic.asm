PIC1_COMMAND equ 0x20
PIC1_DATA    equ 0x21
PIC2_COMMAND equ 0xA0
PIC2_DATA    equ 0xA1
PIC_EOI equ 0x20

KEY_DATA equ 0x60
KEY_COMMAND equ 0x64

ICW1_ICW4       equ 0x01
ICW1_SINGLE     equ 0x02
ICW1_INTERVAL4  equ 0x04
ICW1_LEVEL      equ 0x08
ICW1_INIT       equ 0x10
ICW4_8086       equ 0x01
ICW4_AUTO       equ 0x02
ICW4_BUF_SLAVE  equ 0x08
ICW4_BUF_MASTER equ 0x0C
ICW4_SFNM       equ 0x10

macro ioWait {
    xor al, al
    out 0x80, al
}

; picSendEOI(irq: u8) void
picSendEOI:
    mov al, PIC_EOI
    cmp bl, 8
    jl .skip
    out PIC2_COMMAND, al
.skip:
    out PIC1_COMMAND, al
    ret

; https://wiki.osdev.org/PIC#Initialisation
; If anything weird happens and it leads you to this,
; add the ioWait calls in the document above

; picRemap(offset1: usize, offset2: usize) void
picRemap:
    mov al, bh
    in al, PIC1_DATA
    mov bh, al
    mov al, dh
    in al, PIC2_DATA
    mov dh, al

    mov al, ICW1_INIT or ICW1_ICW4
    out PIC1_COMMAND, al
    out PIC2_COMMAND, al
    mov al, bl
    out PIC1_DATA, al
    mov al, cl
    out PIC2_DATA, al
    mov al, 4
    out PIC1_DATA, al
    mov al, 2
    out PIC2_DATA, al

    mov al, ICW4_8086
    out PIC1_DATA, al
    out PIC2_DATA, al

    mov al, bh
    out PIC1_DATA, al
    mov al, dh
    out PIC2_DATA, al

    ret
