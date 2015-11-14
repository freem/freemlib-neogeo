@echo off
rem This script creates a 64KB M1 driver. You may need it to be larger. I don't know.

vasmz80 -Fbin -nosym -o sounddrv.m1 sounddrv.asm
pad sounddrv.m1 65536