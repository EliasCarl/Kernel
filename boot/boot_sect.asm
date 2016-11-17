; A boot sector that boots a C kernel in 32-bit PM.
[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ; This is where we load the kernel

  mov [BOOT_DRIVE], dl      ; BIOS put our boot drive in data register dl

  mov bp, 0x9000            ; Set up stack
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call load_kernel          

  call switch_to_pm         ; Switch to PM, never return.

  jmp $     

%include "disk_load.asm"
%include "print_string.asm"
%include "print_hex.asm"
%include "print_string_video.asm"
%include "switch_to_pm.asm"
%include "define_gdt.asm"

[bits 16]
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET     ; Load the 15 sectors after boot sector
  mov dh, 15                ; from boot disk to [BOOT_DRIVE]. 
  mov dl, [BOOT_DRIVE]      ; See disk_load.asm for details.
  call disk_load
  ret

[bits 32]
BEGIN_PM:                   ; switch_to_pm lands here.
  
  mov ebx, MSG_PROT_MODE
  call print_string_pm

  call KERNEL_OFFSET        ; Blindly jump to the loaded kernel code.
  
  jmp $     

; Globals
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
