#/bin/sh
arm-none-eabi-linux-as $1.s -o $1.elf
jarm -d devices.txt -l $1.elf
