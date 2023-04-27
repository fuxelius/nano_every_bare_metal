# Name:   Makefile
# Author: Hans-Henrik Fuxelius
# Date:   2023-04-21

# https://makefiletutorial.com

# DEVICE ....... The AVR device you compile for
# CLOCK ........ Target AVR clock rate in Hertz
# OBJECTS ...... The object files created from your source files. This list is
#                usually the same as the list of source files with suffix ".o".
# PROGRAMMER ... Options to avrdude which define the hardware you use for
#                uploading to the AVR and the interface where this hardware
#                is connected.
# FUSES ........ Parameters for avrdude to flash the fuses appropriately.

TARGET      = at4809_uart
DEVICE      = atmega4809
DEVICE_ID   = m4809
CLOCK       = 2666666

TOOLCHAIN   = ~/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino5/bin

AVR_GCC     = $(TOOLCHAIN)/avr-gcc
AVR_OBJCOPY = $(TOOLCHAIN)/avr-objcopy
AVR_SIZE    = $(TOOLCHAIN)/avr-size

AVR_DUDE    = avrdude

SERIAL_PORT = $(shell find /dev/cu.usbmodem* | head -n 1) 
PROGRAMMER  = -c jtag2updi -P $(SERIAL_PORT) -b115200 -p $(DEVICE_ID)

SOURCES   := $(shell find * -type f -name "*.c")
TODAY     := $(shell date +%Y%m%d_%H%M%S)
OBJDIR    := .objects
DEPLOYDIR := .deploy
OBJECTS   := $(addprefix $(OBJDIR)/,$(SOURCES:.c=.o))
FUSES      = -U fuse2:w:0x01:m -U fuse5:w:0xC9:m -U fuse8:w:0x00:m 
SIZE       = $(AVR_SIZE) --format=avr --mcu=$(DEVICE) $(TARGET).elf

######################################################################################

AVRDUDE = $(AVR_DUDE) $(PROGRAMMER)

COMPILE = $(AVR_GCC) -Wall -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -Og -std=gnu99 \
		  -I"avr_haxx/include" -B"avr_haxx/devices/$(DEVICE)" \
		  -ffunction-sections -MD -MP -fdata-sections -fpack-struct -fshort-enums -g2 

######################################################################################
# symbolic targets:
all: $(TARGET).hex

$(TARGET).hex: $(TARGET).elf
	$(AVR_OBJCOPY) -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(TARGET).elf $(TARGET).hex
	$(AVR_OBJCOPY) -j .eeprom  --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0  --no-change-warnings -O ihex $(TARGET).elf $(TARGET).eep || exit 0
	$(AVR_OBJCOPY) -h -S $(TARGET).elf > $(TARGET).lss
	$(AVR_OBJCOPY) -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(TARGET).elf $(TARGET).srec

# file targets:
$(TARGET).elf: $(OBJECTS)
	$(COMPILE) $^ -o $@
	$(SIZE)

$(OBJECTS): $(OBJDIR)/%.o: %.c
	mkdir -p $(@D)
	$(COMPILE) -c $< -o $@

-include $(OBJECTS:.o=.d)

deploy:
	mkdir -p $(DEPLOYDIR)
	cp $(TARGET).hex $(DEPLOYDIR)/$(TARGET)_$(TODAY).hex
	md5sum $(DEPLOYDIR)/$(TARGET)_$(TODAY).hex > $(DEPLOYDIR)/$(TARGET)_$(TODAY).md5

flash:	all
	. avr_haxx/reset_wait 				
	$(AVRDUDE) -U flash:w:$(TARGET).hex:i

fuse:
	. avr_haxx/reset_wait 
	$(AVRDUDE) $(FUSES)

install: flash fuse

serial:
	tio $(SERIAL_PORT) -b 9600 -d 8 -p none -s 1

clean:
	rm -f $(TARGET).elf $(TARGET).hex $(TARGET).eep $(TARGET).lss $(TARGET).srec $(TARGET)_cipher.hex $(OBJECTS)
