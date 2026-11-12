# Compiler and tools
CC = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy

# Compilation flags for RV32IM bare-metal
CFLAGS = -march=rv32im -mabi=ilp32 -nostdlib -nostartfiles -ffreestanding -O0 -msmall-data-limit=0 -mno-relax
LDFLAGS = -T link.ld

# Default target
all: instructions.hex data.hex

# Step 1: Compile Assembly and C into an ELF binary
firmware.elf: start.S main.c
	$(CC) $(CFLAGS) $(LDFLAGS) start.S main.c -o firmware.elf

# Step 2: Extract .text for Instruction Memory
instructions.hex: firmware.elf
	$(OBJCOPY) -O binary -j .text firmware.elf inst.bin
	od -v -t x4 -An inst.bin | tr -s ' ' '\n' | awk 'NF' > instructions.hex
	cp instructions.hex ../tb/instructions.hex

# Step 3: Extract .data/.rodata for Data Memory
data.hex: firmware.elf
	$(OBJCOPY) -O binary -j .data -j .rodata -j .sdata -j .srodata firmware.elf data.bin
	od -v -t x4 -An data.bin | tr -s ' ' '\n' | awk 'NF' > data.hex
	cp data.hex ../tb/data.hex

# Cleanup generated files
clean:
	rm -f *.elf *.bin *.hex