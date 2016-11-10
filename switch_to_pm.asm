; Moment of truth. Pull ourselves up to protected mode.
switch_to_pm:

  cli                   ; Turn off interrupts.

  lgdt [gdt_descriptor] ; Load GDT

  mov eax, cr0          ; Set the first bit in control register 0 to
  or eax, 0x1           ; officially make the switch to protected mode.
  mov cr0, eax

  jmp CODE_SEG:init_pm  ; Make a far jump to the 32-bit code. A far
                        ; jump also flushes pre-fetched, already decoded,
                        ; real-mode instructions.

[bits 32]

; Initialise registers and the stack once in PM.
init_pm:
  
  mov ax, DATA_SEG      ; Point all segment registers to the new data seg.
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000      ; Setup stack
  mov esp, ebp


  call BEGIN_PM

