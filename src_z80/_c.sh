#!/bin/sh
vasmz80 -Fbin -nosym -o sounddrv.m1 sounddrv.asm
pad sounddrv.m1 65536 0
