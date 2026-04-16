unsigned long long efi_main(unsigned long long handle, unsigned long long table);
__attribute__((ms_abi)) unsigned long long EfiMain(unsigned long long handle, unsigned long long table) { return efi_main(handle, table); }
