; A boot sector that enters 32-bit protected mode.
[org 0x7c00]

  mov bp, 0x9000        ; Set up stack.
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call switch_to_pm     ; Switch and never return.

  jmp $     

%include "print_string.asm"
%include "print_string_video.asm"
%include "switch_to_pm.asm"
%include "define_gdt.asm"

[bits 32]
; This is where switch_to_pm eventually lands, now in PM.
BEGIN_PM:
  
  mov ebx, MSG_PROT_MODE
  call print_string_pm
  
  jmp $     

; Globals
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
