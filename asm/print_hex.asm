;
; Print an ascii representation of a 16 bit value in dx.
;

print_hex:
  pusha

  mov di, HEX_OUT       ; Put address of HEX_OUT in di.
  add di, 2             ; Skip "0x"
  mov cl, 4             ; Loop counter.
  
  P1:
    rol dx, 4           ; Rotate high byte from dh to dl.
    mov bl, dl          ; Put it into bl for convenience.
    and bl, 0x0F        ; Isolate low nibble of highest byte.
    add bl, 0x30        ; Bump it up to ascii numbers range.
    cmp bl, 0x39        ; Did it go above 9 (not a number)? 
    jna P2              ; If not jump to P2.
    add bl, 7           ; Else bump it up to letter range.

  P2:
    mov [di], bl        ; Put the char in HEX_OUT.
    inc di              ; Increment di to point to next char in HEX_OUT.
    dec cl              ; Decrement loop count.
    jnz P1              ; If we have more space process more chars.

  mov bx, HEX_OUT
  call print_string

  popa
  ret

; global variables
HEX_OUT: db "0x0000", 0
