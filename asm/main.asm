.z80

//Format hex to ASM db thing
//Find: [0-9A-Z][0-9A-Z]
//Replace: ,\$$&
//Replace example: xxxxxxxxx$&xxxxxxxxx

// Remove metadata from script dump
//                   "metadata": \{\r\n.*\r\n.*\r\n.*\r\n.*\r\n                  \},*\r\n

.open ".\diskImageStreamlined1\streamlined.bin",0

	.include ".\asm\gfx.asm"
	.include ".\asm\dte.asm"

.close

.open ".\diskImageStreamlined2\streamlined.bin",0
	.org 0x0000B005
	.incbin ".\diskImageStreamlined1\streamlined.bin",0x00005C01,0x000004FF

	.org 0x00020500
	.incbin ".\diskImageStreamlined1\streamlined.bin",0x00005C01,0x00000100
	
	.org 0x00009800
	.incbin ".\diskImageStreamlined1\streamlined.bin",0x00044C00,0x00000800
	
	.org 0x0000D800
	.incbin ".\diskImageStreamlined1\streamlined.bin",0x00043400,0x00000800
.close


