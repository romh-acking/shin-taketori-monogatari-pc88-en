.z80

// Cusom variables
DTEMin				equ 0x60
DTEMax				equ 0xDF

DTETableLoc 		equ 0x0000F1C0
DTETablePointer		equ 0x0000C0F1

CodePayloadLoc 		equ 0x0000f0D0
CodePayloadPointer 	equ 0x0000D0F0

CodePayloadHeader	equ 0x63

CursorY				equ 0xef86
CursorX				equ 0xef87

hlTemp				equ CodePayloadLoc+0xE0
deTemp				equ hlTemp+0x2
hlTableTemp			equ deTemp+0x2
DTETableLoaded		equ hlTableTemp+0x2

// This RAM address is later added to ef87 to append menu prompts and other text strings
// I'm repurposing it for this DTE routine.
CharacterCount		equ 0xCF81

// Add new entries to the track table
// so we can utilize unused tracks on the floppy disk
.org 0x0000E60A
.headersize 0xDF0A-0x0000E60A
	db 0x34 // 0x3a700
	db 0x44
	
	db 0x34 // 0x3a800
	db 0x45

.headersize 0x0
.org 0x0000D5C1
	.fill 0x13+0x12+0x4+0x3+0x6+0x1+0x36
.org 0x0000D5C1
.headersize 0x0000CEC1-0x0000D5C1
	ld a,0xff
	ld hl,0xCF89
	ld (0xCF7B),hl
	ld a,(CursorX)
	ld (0xCF87),a
	ld a,(0xCF8B)
	ld b,a
	ld hl,0xCF8B
	ld a,0x01
	ld (0xCF89),a
	ld a,0x00
	ld (CharacterCount),a

	DialoguePrint:
	push hl
	push bc

	// Load the DTE payload
	// Make sure it's been already loaded
	// If we're on disk 2, this prevents loading garbage disk 2 data.
	ld a, (CodePayloadLoc)
	cp CodePayloadHeader
	jr z,PayloadTrackAlreadyLoaded

	// Set where to write data
	ld hl,CodePayloadPointer
	ld (0xDD04),hl
	
	// Point to where in track table to read.
	// Table starts @ DE98
	ld hl,0xDF0A
	ld a,(hl)
	ld (0xDD02),a
	inc hl
	ld a,(hl)
	ld (0xDD03),a
	
	// A is used later in this function
	call 0xDDFC
	
	PayloadTrackAlreadyLoaded:
	pop bc
	pop hl
	
	jp WriteTextLoop
	
	WriteTextLoopFinish:
	
	// old:
	// ld a,(0xCF87)
	// ld (CursorX),a
	
	// CF87 is temporarily used to store the old cursor position as CursorX is used for text printing here
	ld a,(0xCF87)
	ld (CursorX),a
	ret
	
.headersize 0x0

.org 0x3a700
.headersize CodePayloadLoc-0x3a700
	db CodePayloadHeader

	.macro PrintChar
		push hl
		push bc
		ld   a,(CursorX)
		inc  a
		ld   (CursorX),a
		ld   hl,0xCF78
		ld   (0xC000),hl
		call 0xCA06
		
		ld a,(CharacterCount)
		inc a
		ld (CharacterCount),a
	.endmacro
	
	.macro LoadDTETable
		ld a,(DTETableLoaded)
		or a
		jr nz,DTETrackAlreadyLoaded
		
		push hl
		push de
		push bc
		
		// Set where to write data
		ld hl,DTETablePointer 
		ld (0xDD04),hl
		
		// Point to where in track table to read.
		// Table starts @ DE98
		ld hl,0xDF0C
		ld a,(hl)
		ld (0xDD02),a
		inc hl
		ld a,(hl)
		ld (0xDD03),a
		call 0xDDFC
		
		pop bc
		pop de
		pop hl
		
		ld a,0x1
		ld (DTETableLoaded),a
		
		DTETrackAlreadyLoaded:
	.endmacro
	
	WriteTextLoop:
		inc hl
		
		jp FuncDTE
		
		FuncDTEFinish:
		
		pop  bc
		pop  hl

		djnz WriteTextLoop
		
		jp WriteTextLoopFinish
		
	FuncDTE:
		LoadDTETable
		
		ld a,(hl)

		cp DTEMin
		jr c,LessThan
		cp DTEMax+1
		jp nc,GreaterThan
		
		ld (hlTemp),hl
		ld (deTemp),de
				
		// Setup indexer
		sub DTEMin
		add a,a
		push af
		pop hl
		ld l,h
		ld h,0x0
		ld de,DTETableLoc
		add hl,de
		
		// Write DTE chars
		ld a,(hl)
		ld (0xCF8A),a
		ld (hlTableTemp),hl
		
		ld hl,(hlTemp)
		ld de,(deTemp)
		
		PrintChar
		call 0xCDD3
		
		pop bc
		pop hl

		ld hl,(hlTableTemp)
		inc hl
		ld a,(hl)
		ld (0xCF8A),a
		
		ld hl,(hlTemp)
		ld de,(deTemp)
		
		PrintChar
		
		jp Out
		
	GreaterThan:
	LessThan:
		ld (0xCF8A),a
		PrintChar
	
	Out:
		ld a,(0xCFFD)
		or a
		jr z,IsNewLine
		
		ld a,(0xCFFE)
		jr z,DontPlaySound
		
		call 0xCF6B
			
		DontPlaySound:
			jr BranchA

		IsNewLine:
			// Blank out our custom cursor
			ld a,0x0
			ld (CharacterCount),a
			
			call 0xCF55
			BranchA:
			call 0xCDD3
			
			jp FuncDTEFinish
		
.headersize 0x0

// Adjust "Do what?" cursor placement
.org 0x00050F68
	ld a,0xA

// Adjust "What?" cursor placement
.org 0x00050F2C
	ld a,0x6

// Adjust "To whom?" cursor placement
.org 0x00050F74
	ld a,0x9

// Adjust "For whom?" cursor placement
.org 0x00050F6E
	ld a,0xA

// Text printing adjust for LOOK MATCH
// 700e 3e12    		LD   A,12H
// 7010 328ed0  		LD   (0D08EH),A
.org 0x0000A70E
	ld a,0x12

.org 0x00051CC4
	db 0x20

// Adjust look coin text
.org 0x0000A651
	ld a,0x9