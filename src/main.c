#include "imxrt1062.h"

int main()
{
    // Configure GPIO B0_03 (PIN 13) for output
    IOMUXC_SW_MUX_CTL_PAD_GPIO_B0_03 = 5;
    IOMUXC_SW_PAD_CTL_PAD_GPIO_B0_03 = IOMUXC_PAD_DSE(7);
    IOMUXC_GPR_GPR27 = 0xFFFFFFFF;
    GPIO7_GDIR |= (1 << 3);

    for(;;) {
        volatile unsigned int i = 0;

        // Set PIN 13 HIGH
        GPIO7_DR_SET = (1 << 3);

        // Poor man's delay
        while(i < 10000000) {
            i++;
        }

        i = 0;

        // Set PIN 13 LOW
        GPIO7_DR_CLEAR = (1 << 3);

        // Poor man's delay
        while(i < 10000000) {
            i++;
        }
    }
}
