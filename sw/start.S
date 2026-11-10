.global _start

.section .text.init
_start:
    # Initialize stack pointer to the top of your data memory.
    # Adjust 0x00001000 to match the size/address of your data memory module.
    li sp, 0x00001000 
    
    # Jump to main function in C
    jal ra, main

    # Infinite loop to catch the program when main() returns
end_loop:
    j end_loop