test: os-image
	qemu-system-x86_64 -fda os-image

os-image: kernel.bin boot_sect.bin
	cat boot_sect.bin kernel.bin > os-image

boot_sect.bin: boot_sect.asm disk_load.asm print_string.asm print_string_pm.asm switch_to_pm.asm gdt.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

kernel.bin: kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary

kernel.o: kernel.c
	gcc -ffreestanding -c kernel.c -o kernel.o