/* vlink linker script for freemlib sound driver */

MEMORY
{
	start:   ORIGIN = 0x0000, LENGTH = 0x0004 /* 0x0000: entry point */
	delay1:  ORIGIN = 0x0008, LENGTH = 0x0003 /* 0x0008: port write delay (addr) */
	delay2:  ORIGIN = 0x0010, LENGTH = 0x0003 /* 0x0010: port write delay (data) */
	write45: ORIGIN = 0x0018, LENGTH = 0x0003 /* 0x0018: shortcut to write_45 */
	write67: ORIGIN = 0x0020, LENGTH = 0x0003 /* 0x0020: shortcut to write_67 */
	ymwait:  ORIGIN = 0x0028, LENGTH = 0x0006 /* 0x0028: YM2610 busy wait */
	IRQ:     ORIGIN = 0x0038, LENGTH = 0x0004 /* 0x0038: IRQ trampoline */
	idstr:   ORIGIN = 0x0040, LENGTH = 0x0020 /* 0x0040: driver identification */
	NMI:     ORIGIN = 0x0066, LENGTH = 0x004A /* 0x0066: NMI routine */
	rom:     ORIGIN = 0x00A0, LENGTH = 0xF760 /* 0x00A0: start of the rest of ROM */
	ram:     ORIGIN = 0xF800, LENGTH = 0x0800 /* RAM at 0xF800-0xFFFF */
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
