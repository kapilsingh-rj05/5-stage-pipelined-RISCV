# Compiler and tools
CC = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy

# Compilation flags for RV32IM bare-metal
CFLAGS = -march=rv32im -mabi=ilp32 -nostdlib -nostartfiles -ffreestanding -O0
LDFLAGS = -T link.ld

# Default target
all: instructions.hex

# Step 1: Compile Assembly and C into an ELF binary
firmware.elf: start.S main.c
	$(CC) $(CFLAGS) $(LDFLAGS) start.S main.c -o firmware.elf

# Step 2: Convert ELF to Binary, then format to 32-bit Hex words
instructions.hex: firmware.elf
	$(OBJCOPY) -O binary firmware.elf firmware.bin
	od -v -t x4 -An firmware.bin | tr -s ' ' '\n' | awk 'NF' > instructions.hex
	cp instructions.hex ../tb/instructions.hex
	@echo "Successfully compiled and copied instructions.hex to ../tb/"

# Cleanup generated files
clean:
	rm -f *.elf *.bin *.hex