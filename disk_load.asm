; load DH sectors to es:bx from drive DL
disk_load:
  push dx           ; Store dx on stack so later we can recall
                    ; how many sectors were request to be read,
                    ; even if it is altered in the meantime.

  mov ah, 0x02      ; BIOS read sector service.
  mov al, dh        ; Read dh number of sectors.
  mov ch, 0x00      ; Select cylinder 0.
  mov dh, 0x00      ; Select head 0.
  mov cl, 0x02      ; Start reading from second sector, which
                    ; is the one after the boot sector.

  int 0x13          ; BIOS interrupt "low level disk services".
  
  jc disk_error     ; BIOS sets carry flag if read error.

  pop dx            ; Restore dx from the stack.
  cmp dh, al        ; If the sectors read (al) != sectors expected (dh)
  jne disk_error    ; display error message.
  ret

disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $             ; Hang

; Variables
DISK_ERROR_MSG db "Disk read error!", 0
