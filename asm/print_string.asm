;
; A print function. Assumes bx contains address to null terminated string.
;

print_string:
  pusha
  mov ah, 0x0e      ; Set service to 0x0e "Write Character in TTY Mode"

  loop:
    cmp byte [bx], 0
    je exit 
    mov al, [bx]
    int 0x10        ; Call BIOS interrupt 0x10 "Video Services"
    inc bx
    jmp loop

  exit:
    popa
    ret
