;
; A simple boot sector that invokes 0x10 "Video Services" interrupt
; with ah set to 0x0e "Write Character in TTY Mode".
;

;
; Tell the assembler where this code will be loaded in memory.
;
[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

mov dx, 0x1fb6
call print_hex

jmp $ ; Hang

%include "print_string.asm"
%include "print_hex.asm"

; Data
HELLO_MSG:
  db "Hello, world!", 0

GOODBYE_MSG:
  db "Goodbye!", 0

;
; Padding and magic number.
;

times 510-($-$$) db 0
dw 0xaa55

