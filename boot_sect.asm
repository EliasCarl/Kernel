;
; A simple boot sector program that loops forver.
;

loop:
    
  jmp loop

; Pad with 0 until 510th byte
times 510-($-$$) db 0

; Last two bytes is the magic number
dw 0xaa55
