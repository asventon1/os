C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	qemu-system-x86_64 -fda os-image

os-image: boot/boot_sect.bin kernel.bin 
	cat $^ > os-image

boot_sect.bin: boot_sect.asm disk_load.asm print_string.asm print_string_pm.asm switch_to_pm.asm gdt.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

%.o : %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

%.o : %.asm
	nasm $< -f elf64 -o $@

%.bin : %.asm
	nasm $< -f bin -I 'boot' -o $@

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drives/*.o
