# TODO: P59
# Generate sources
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	bochs -f bochsrc -q

# OS Image - Combine boot sector binary and kernel binary.
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os.img

# We explicitly set the entry symbol to 0x1000 since this is where
# the boot sector loads our kernel binary. Note that the linker knows
# about the order of its arguments, so we can be sure that the kernel
# entry will be at the very beginning of the kernel binary, followed
# by the actual kernel.
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -e 0x1000 $^ --oformat binary

# -c to compile but not link. -ffrestanding to compile without
#  standard library.
%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

# Apparently the loader outputs in elf64 (x86-64) format and will
# complain if given an elf32 input. So we explicitly set elf64.
%.o: %.asm
	nasm $< -f elf64 -o $@

%.bin: %.asm
	nasm $< -f bin -I "boot/" -o $@

clean:
	rm -fr *.bin *.dis *.o os.img *.map
	rm -fr kernel/*.o boot/*.bin drivers/*.o
