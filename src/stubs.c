#include <stddef.h>
#include <stdint.h>

void* gBootServices = 0;

int posix_memalign(void** memptr, size_t alignment, size_t size) {
    if (!gBootServices) return 12;
    
    typedef uint64_t (*AllocatePoolFn)(uint64_t, uint64_t, void**);
    AllocatePoolFn allocate = *(AllocatePoolFn*)((char*)gBootServices + 0x40);
    uint64_t status = allocate(2, (uint64_t)size, memptr);
    return (status == 0) ? 0 : 12;
}

void free(void* ptr) {
    if (!gBootServices || !ptr) return;
    typedef uint64_t (*FreePoolFn)(void*);
    FreePoolFn freepool = *(FreePoolFn*)((char*)gBootServices + 0x48);
    freepool(ptr);
}

void* memmove(void* dst, const void* src, size_t n) {
    unsigned char* d = dst;
    const unsigned char* s = src;
    if (d < s) {
        for (size_t i = 0; i < n; i++) d[i] = s[i];
    } else {
        for (size_t i = n; i > 0; i--) d[i-1] = s[i-1];
    }
    return dst;
}

void* memset(void* s, int c, size_t n) {
    unsigned char* p = s;
    for (size_t i = 0; i < n; i++) p[i] = (unsigned char)c;
    return s;
}

int putchar(int c) { return c; }

unsigned long long __security_cookie = 0x0;
void __security_check_cookie(unsigned long long cookie) {}


extern void* gBootServices;

void init_allocator(void* boot_services) {
    gBootServices = boot_services;
}
