; A Global Descriptor Table is set up to extend the somewhat lacking
; segmentation used in 16-bit real mode. The GDT contains segment
; descriptors which carry some additional flags besides just the
; base and limit of the segment. The most important of these flags
; are the ones specifying privilige level and whether it is read- or
; write-only. A segment descriptor is 8-bytes.
;
; Here we start with the "basic flat model". As is seen below both
; the code and data segments cover the full 4GB of addressable memory.
; This strategy offers nothing in protection, since the segments fully
; overlap, but allow us to use the flags. The reason we don't just use
; one segment descriptor is because the type field cannot be executable
; and writable at the same time.
;
; Segment Descriptor Flags
; P   = Presentation
; DPL = Descriptor Privilege Level
; S   = Descriptor Type (1 for code or data segment, 0 for traps)
; G   = Granularity
; L   = 64-bit code segment
; AVL = Available for use by system software

;
; Typeflags
; Code
; Conforming
; Readable
; Accessed

get_start:

  ; Mandatory null descriptor. Declare two double words of zeros.
  gdt_null:
    dd 0x0
    dd 0x0

  ; Code Segment Descriptor
  ; Base:  0x0
  ; Limit: 0xfffff
  ; 1st flags  (1001b): (P) 1, (DPL) 00, (S) 1
  ; Type flags (1010b): (Code) 1, (Conforming) 0, (readable) 1, (accessed) 0
  ; 2nd flags  (1100b): (G) 1, (32-bit default) 1, (64-bit seg) 0, (AVL) 0

  gdt_code:      ; code segment descriptor
    dw 0xffff    ; Limit (bits 0-15)          
    dw 0x0       ; Base  (bits 0-15)
    db 0x0       ; Base  (bits 16-23)
    db 10011010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, Limit (bits 16-19)
    db 0x0       ; Base (bits 24-31)

  ; Data Segment Descriptor
  ; Differs only in type flags where code is 0.

  gdt_data:      ; the data segment descriptor
    dw 0xffff    ; Limit (bits 0-15)
    dw 0x0       ; Base  (bits 0-15)
    db 0x0       ; Base  (bits 16-23)
    db 10010010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, Limit (bits 16-19)
    db 0x0       ; Base (bits 24-31) 

  gdt_end:       ; So we can calculate the size of the GDT

; Pack it into a GDT Descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1    ; Size of the GDT
  dd gdt_start                  ; Start address of the GDT

; Constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
