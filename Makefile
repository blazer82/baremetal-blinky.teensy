prog: build/firmware.elf
	arm-none-eabi-objcopy -O ihex -R .eeprom build/firmware.elf build/firmware.hex

build/firmware.elf: build/main.o build/startup.o build/bootdata.o
	arm-none-eabi-ld -Tteensy/imxrt1062.ld -o build/firmware.elf build/bootdata.o build/startup.o build/main.o

build/main.o: main.c
	arm-none-eabi-gcc -O0 -c -g -mcpu=cortex-m3 -mthumb -o build/main.o main.c

build/startup.o: teensy/startup.c
	arm-none-eabi-gcc -O0 -c -g -mcpu=cortex-m3 -mthumb -o build/startup.o teensy/startup.c

build/bootdata.o: teensy/bootdata.c
	arm-none-eabi-gcc -O0 -c -g -mcpu=cortex-m3 -mthumb -o build/bootdata.o teensy/bootdata.c

asm:
	arm-none-eabi-gcc -S -mcpu=cortex-m3 -mthumb main.c && more main.s

clean:
	rm -rf build/*

flash:
	teensy_loader_cli --mcu=TEENSY40 -w -v build/firmware.hex
