CFLAGS = -O3 -Wall -mcpu=cortex-m7 -mthumb
LDFLAGS = -Wl,--gc-sections,--print-gc-sections,--print-memory-usage -nostdlib -nostartfiles -Tteensy/imxrt1062.ld

CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size
LOADER = teensy_loader_cli

OUTFILE = firmware

C_FILES = $(wildcard teensy/*.c)
OBJ = $(C_FILES:teensy/%.c=build/%.o)

prog: build/$(OUTFILE).hex

build/$(OUTFILE).hex: build/$(OUTFILE).elf
	$(OBJCOPY) -O ihex -R .eeprom build/$(OUTFILE).elf build/$(OUTFILE).hex
	$(OBJDUMP) -d -S -C build/$(OUTFILE).elf > build/$(OUTFILE).lst
	$(SIZE) build/$(OUTFILE).elf

build/$(OUTFILE).elf: build/main.o build/startup.o build/bootdata.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

build/main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $^

build/%.o: teensy/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

flash: build/$(OUTFILE).hex
	$(LOADER) --mcu=TEENSY40 -w -v $<

clean:
	rm -rf build/*
