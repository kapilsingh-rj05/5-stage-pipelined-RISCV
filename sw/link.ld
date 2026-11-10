OUTPUT_ARCH("riscv")
ENTRY(_start)

SECTIONS
{
    /* Instruction memory starts at 0x00000000 */
    . = 0x00000000;
    
    .text : {
        *(.text.init)  /* Force startup code to the very top */
        *(.text*)      /* All other C code */
    }

    /* Data memory alignment (adjust address based on your hardware design) */
    . = ALIGN(4);
    
    .data : {
        *(.data*)      /* Initialized variables */
        *(.srodata*)   /* Read-only data */
        *(.rodata*)
    }
    
    .bss : {
        *(.bss*)       /* Uninitialized variables */
        *(.sbss*)
    }
}