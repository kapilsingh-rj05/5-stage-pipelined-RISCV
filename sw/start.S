.global _start

.section .text.init
_start:
    # Initialize stack pointer to the TOP of the 4KB data memory.
    # 0x1000 (Base) + 0x1000 (4KB Size) = 0x2000
    li sp, 0x00002000 
    
    # Jump to main function in C
    jal ra, main

    # Infinite loop to catch the program when main() returns
end_loop:
    j end_loop