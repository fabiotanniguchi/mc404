#!/bin/sh 
arm-none-eabi-gdb -ex "target ext localhost:3333" $1

chmod a+x gdb.sh

