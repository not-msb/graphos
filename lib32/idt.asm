IDT equ 0xc800

; exceptionHandler() void
exceptionHandler:
    putS msgException, 0x4f
    cli
    hlt

; interruptHandler(irq: usize) void
interruptHandler:
    mov edi, ebx
    putS msgInterrupt, 0x4f
    putH edi, 0x4f
    cli
    hlt

; idtSetEntry(index: usize, isr: *const isr, attributes: u8) void
idtSetEntry:
    imul ebx, 8
    add ebx, IDT
    mov word [ebx], cx
    mov word [ebx+2], CODE_SEG
    mov byte [ebx+4], 0
    mov byte [ebx+5], dl
    shr ecx, 16
    mov word [ebx+6], cx
    ret

; idtInit() void
idtInit:
    mov [idtr.base], IDT
    mov [idtr.limit], 8 * 256 - 1 ; sizeof(idtEntryT) * IDT_MAX_DESCRIPTORS - 1

    ; Attributes
    mov edx, 0x8E

    rept 32 i:0 {
        mov ebx, i
        mov ecx, isrStub
        call idtSetEntry
    }

    ; Timer
    mov ebx, 32
    mov ecx, irqTimer
    call idtSetEntry

    ; Keyboard
    mov ebx, 33
    mov ecx, irqKeyboard
    call idtSetEntry

    rept 14 i:2 {
        mov ebx, i + 32
        mov ecx, irqStub
        call idtSetEntry
    }

    lidt [idtr]
    sti

    ret

isrStub:
    call exceptionHandler
    iret

irqStub:
    mov ebx, 0xdeadbeef
    call interruptHandler
    iret

irqTimer:
    ;putS msgTimer, 0x4f
    mov ebx, 32
    call picSendEOI
    iret

irqKeyboard:
    xor eax, eax
    in al, KEY_DATA
    mov ebx, eax
    call putKey
    mov ebx, 33
    call picSendEOI
    iret

idtr:
    .limit dw 0
    .base dd 0
