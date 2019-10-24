#include "imxrt1062.h"

extern unsigned long _stextload;
extern unsigned long _stext;
extern unsigned long _etext;
extern unsigned long _sdataload;
extern unsigned long _sdata;
extern unsigned long _edata;
extern unsigned long _sbss;
extern unsigned long _ebss;
extern unsigned long _flexram_bank_config;
extern unsigned long _estack;

static void memory_copy(uint32_t *dest, const uint32_t *src, uint32_t *dest_end);
static void memory_clear(uint32_t *dest, uint32_t *dest_end);

void main();

__attribute__((section(".startup"), optimize("no-tree-loop-distribute-patterns"), naked))
void startup()
{
    // FlexRAM bank configuration
    IOMUXC_GPR_GPR17 = (uint32_t)&_flexram_bank_config;
    IOMUXC_GPR_GPR16 = 0x00000007;
    IOMUXC_GPR_GPR14 = 0x00AA0000;
    __asm__ volatile("mov sp, %0" : : "r" ((uint32_t)&_estack) : );

    // Initialize memory
    memory_copy(&_stext, &_stextload, &_etext);
    memory_copy(&_sdata, &_sdataload, &_edata);
    memory_clear(&_sbss, &_ebss);

    // enable FPU
    // SCB_CPACR = 0x00F00000;

    // Call the `main()` function defined in `main.c`.
    main();
}

__attribute__((section(".startup"), optimize("no-tree-loop-distribute-patterns")))
static void memory_copy(uint32_t *dest, const uint32_t *src, uint32_t *dest_end)
{
    if (dest == src)
        return;
    while (dest < dest_end)
    {
        *dest++ = *src++;
    }
}

__attribute__((section(".startup"), optimize("no-tree-loop-distribute-patterns")))
static void memory_clear(uint32_t *dest, uint32_t *dest_end)
{
    while (dest < dest_end)
    {
        *dest++ = 0;
    }
}
