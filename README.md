# Bare metal C-development on the Arduino Nano Every board
	By Hans-Henrik Fuxelius, 2023-04-27

<img src="doc/pic/TheNano.png"  width="600">

The [Arduino Nano Every](https://store.arduino.cc/products/arduino-nano-every) board is equipped with the ATmega4809 microcontroller that came to market in 2018. It is a modern replacement of the 20 year old ATmega328p with being better in almost everything save EEPROM that is just a quarter of the previous. It has an 8-bit AVR processor developed by Microchip/Atmel that can run up to 20MHz on an internal clock crystal. It comes with 6KB of SRAM, 48KB of flash, and 256 bytes of EEPROM. The chip features the latest technologies like flexible and efficient-power architecture, including Event System and Sleepwalking, precious analog features, and advanced peripherals.

The Arduino Nano Every differentiate itself somewhat from other Arduino boards with an Atmel processor. Usually an bootloader is present in EEPROM for uploading software to the microcontroller. The Nano Every does not use an bootloader but is programmed directly by the Unified Program and Debug Interface (UDPI) protocol. The  UPDI is a Microchip proprietary interface for external programming and on-chip debugging of a device. This programming can be done directly with harware tools ([Atmel-ICE Debugger](https://onlinedocs.microchip.com/pr/GUID-DDB0017E-84E3-4E77-AAE9-7AC4290E5E8B-en-US-4/index.html?GUID-9B349315-2842-4189-B88C-49F4E1055D7F)) or by software ([jtag2udpi](https://github.com/ElTangas/jtag2updi#)) in an embedded processor. In this case the ATSAMD11D14A ARM Cortex M0+ processor acts as a bridge between USB and the main ATmega4809 microcontroller. The upside of not using a bootloader is obvious. You have the entire memory space for your own project and can also develop your own bootloaders without have to worry about bricking it. UDPI is also much quicker than using a bootloader, usually just a few seconds.

For those of us who are used to develop with standard C (C99) in UNIX for Apple Silicon, Ubuntu or Fedora and want to get started there are fewer alternatives than in Windows that is standard for electronics and microcontroller development.

<img src="doc/pic/ms_code.png"  width="600">

https://makefiletutorial.com

<img src="doc/pic/make.png"  width="600">

<img src="doc/pic/tio.png"  width="600">