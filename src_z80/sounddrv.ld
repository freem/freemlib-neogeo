/* vlink linker script for freemlib sound driver */

MEMORY
{
	start:   ORIGIN = 0x0000, LENGTH = 0x0038
	delay1:  ORIGIN = 0x0008, LENGTH = 0x0003
	delay2:  ORIGIN = 0x0010, LENGTH = 0x0003
	write45: ORIGIN = 0x0018, LENGTH = 0x0003
	write67: ORIGIN = 0x0020, LENGTH = 0x0003
	ymwait:  ORIGIN = 0x0028, LENGTH = 0x0006
	IRQ:     ORIGIN = 0x0038, LENGTH = 0x0024
	idstr:   ORIGIN = 0x0040, LENGTH = 0x0020
	NMI:     ORIGIN = 0x0066, LENGTH = 0x002B
	rom:     ORIGIN = 0x00A0, LENGTH = 0xF760
	ram:     ORIGIN = 0xF800, LENGTH = 0x0800
}

SECTIONS
{
	.start : { *(start) } > start
	.delay1 : { *(delay1) } > delay1
	.delay2 : { *(delay2) } > delay2
	.write45 : { *(write45) } > write45
	.write67 : { *(write67) } > write67
	.ymwait : { *(ymwait) } > ymwait
	.IRQ : { *(IRQ) } > IRQ
	.idstr : { *(idstr) } > idstr
	.NMI : { *(NMI) } > NMI
	.code : { *(code) } > rom
	.bss (NOLOAD) : { *(bss) } > ram
}
