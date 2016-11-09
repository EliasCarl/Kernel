; Read some sectors from the boot disk using the disk_read function.
[org 0x7c00]

  mov [BOOT_DRIVE], dl  ; Save boot drive from dl.
  
  mov bp, 0x8000        ; Set up stack.
  mov sp, bp

  mov bx, 0x9000        ; Load 5 sectors to 0x0000:0x9000 (es:bx)
  mov dh, 2             ; from the boot disk.
  mov dl, [BOOT_DRIVE]
  call disk_load

  mov dx, [0x9000]      ; Print the first loaded word, which we have
  call print_hex        ; set below. Should be 0xdada.

  mov dx, [0x9000 + 512] ; Print the first loaded word from the second
  call print_hex         ; sector. Should be 0xface.

  jmp $     

%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

; Global variables
BOOT_DRIVE: db 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

; This is now past the boot sector. We fill this next sector with
; some values to print to make sure the load worked.

times 512 dw 0xdada
times 512 dw 0xface
