CFLAGS = -O3  -c -g -mcpu=cortex-m7 -mthumb

CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size
LOADER = teensy_loader_cli

OUTFILE = firmware

prog: build/$(OUTFILE).elf
	$(OBJCOPY) -O ihex -R .eeprom build/$(OUTFILE).elf build/$(OUTFILE).hex
	$(OBJDUMP) -d -S -C build/$(OUTFILE).elf > build/$(OUTFILE).lst
	$(OBJDUMP) -t -C build/$(OUTFILE).elf > build/$(OUTFILE).sym
	$(SIZE) build/$(OUTFILE).elf

build/$(OUTFILE).elf: build/main.o build/startup.o build/bootdata.o
	$(LD) -Tteensy/imxrt1062.ld -o build/$(OUTFILE).elf build/bootdata.o build/startup.o build/main.o

build/main.o: main.c
	$(CC) $(CFLAGS) -o build/main.o main.c

build/startup.o: teensy/startup.c
	$(CC) $(CFLAGS) -o build/startup.o teensy/startup.c

build/bootdata.o: teensy/bootdata.c
	$(CC) $(CFLAGS) -o build/bootdata.o teensy/bootdata.c

clean:
	rm -rf build/*

flash:
	$(LOADER) --mcu=TEENSY40 -w -v build/$(OUTFILE).hex
