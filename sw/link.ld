OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
    imem (rx) : ORIGIN = 0x00000000, LENGTH = 4K
    dmem (rw) : ORIGIN = 0x00001000, LENGTH = 4K
}

SECTIONS
{
    .text : {
        *(.text.init)  /* Force startup code to the very top */
        *(.text*)      /* All other C code */
    } > imem

    .data : {
        *(.data*)      /* Initialized variables */
        *(.srodata*)   /* Read-only data */
        *(.rodata*)
        *(.sdata*)
    } > dmem
    
    .bss : {
        *(.bss*)       /* Uninitialized variables */
        *(.sbss*)
    } > dmem
}