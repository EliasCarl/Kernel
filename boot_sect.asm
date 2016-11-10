; A boot sector that enters 32-bit protected mode.
[org 0x7c00]

  mov bp, 0x9000        ; Set up stack.
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call switch_to_pm     ; Switch and never return.

  jmp $     

%include "print_string.asm"
%include "switch_to_pm.asm"
%include "define_gdt.asm"

; This is where switch_to_pm eventually lands, now in PM.
BEGIN_PM:
  
  mov ebx, MSG_PROT_MODE
  ;TODO: Implement call print_string_pm
  
  jmp $     

; Globals
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

; This is now past the boot sector. We fill this next sector with
; some values to print to make sure the load worked.

times 512 dw 0xdada
times 512 dw 0xface
