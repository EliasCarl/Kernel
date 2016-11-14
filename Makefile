all: os-image

run: all
	bochs

# OS Image - Combine boot sector binary and kernel binary.
os-image: boot_sect.bin kernel.bin
	cat $^ > os.img

# We explicitly set the entry symbol to 0x1000 since this is where
# the boot sector loads our kernel binary. Note that the linker knows
# about the order of its arguments, so we can be sure that the kernel
# entry will be at the very beginning of the kernel binary, followed
# by the actual kernel.
kernel.bin: kernel_entry.o kernel.o
	ld -e 0x1000 -o kernel.bin $^ --oformat binary

# -c to compile but not link. -ffrestanding to compile without
#  standard library.
kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

# Apparently the loader outputs in elf64 (x86-64) format and will
# complain if given an elf32 input. So we explicitly set elf64.
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf64 -o $@

boot_sect.bin: boot_sect.asm
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.dis *.o os.img *.map
