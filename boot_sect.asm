;
; A simple boot sector that invokes 0x10 "Video Services" interrupt
; with ah set to 0x0e "Write Character in TTY Mode".
;

mov ah, 0x0e

mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

jmp $ ; Hang

;
; Padding and magic number.
;

times 510-($-$$) db 0
dw 0xaa55
