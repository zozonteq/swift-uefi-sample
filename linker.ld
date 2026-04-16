OUTPUT_FORMAT(elf64-x86-64)
ENTRY(efi_main)

SECTIONS {
    . = 0x400000;
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }
    /DISCARD/ : { *(.comment*) *(.note*) }
}
