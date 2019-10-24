CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size
LOADER = teensy_loader_cli

OUTFILE = firmware

BUILD_DIR = ./build
SRC_DIRS ?= ./src ./teensy ./include

SRCS := $(shell find $(SRC_DIRS) -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS = -O3 -Wall -Werror -mcpu=cortex-m7 -mthumb $(INC_FLAGS)
LDFLAGS = -Wl,--gc-sections,--print-gc-sections,--print-memory-usage -nostdlib -nostartfiles -Tteensy/imxrt1062.ld

$(BUILD_DIR)/$(OUTFILE).hex: $(BUILD_DIR)/$(OUTFILE).elf
	@$(OBJCOPY) -O ihex -R .eeprom build/$(OUTFILE).elf build/$(OUTFILE).hex
	@$(OBJDUMP) -d -x build/$(OUTFILE).elf > build/$(OUTFILE).dis
	@$(OBJDUMP) -d -S -C build/$(OUTFILE).elf > build/$(OUTFILE).lst
	@$(SIZE) build/$(OUTFILE).elf

$(BUILD_DIR)/$(OUTFILE).elf: $(OBJS)
	@$(CC) $(CFLAGS) -Xlinker -Map=build/$(OUTFILE).map $(LDFLAGS) -o $@ $^

$(BUILD_DIR)/%.s.o: %.s
	@$(MKDIR_P) $(dir $@)
	@$(AS) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR)/%.c.o: %.c
	@$(MKDIR_P) $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: flash
flash: $(BUILD_DIR)/$(OUTFILE).hex
	$(LOADER) --mcu=TEENSY40 -w -v $<

.PHONY: clean
clean:
	@$(RM) -r $(BUILD_DIR)

MKDIR_P ?= mkdir -p