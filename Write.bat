::Folders
set projectFolder=%cd%
set toolsFolder=%projectFolder%\tools
set spiroFolder=%toolsFolder%\spiro
set armipsFolder=%toolsFolder%\armips
set diskToolFolder=%toolsFolder%\d88-manager
set asmFolder=%projectFolder%\asm

set baseStreamLinedFolder1=%projectFolder%\diskImageStreamlined1
set baseStreamLinedFolder2=%projectFolder%\diskImageStreamlined2

set basicCodeFolder=%projectFolder%\code
set basicCodeOriginalFolder=%basicCodeFolder%\orginal (assembled)
set basicCodeOriginalDisasmFolder=%basicCodeFolder%\original (disassembled)
set basicCodeNewFolder=%basicCodeFolder%\new (assembled)
set basicCodeNewDisasmFolder=%basicCodeFolder%\new (disassembled)

set decryptionTool=%toolsFolder%\protection\moon-princess-protection.exe

::Roms
set baseStreamLinedImage1=%baseStreamLinedFolder1%\streamlined.bin
set baseStreamLinedImage2=%baseStreamLinedFolder2%\streamlined.bin

set baseImage1=%projectFolder%\diskImages\Shin Taketori Monogatari (Disk 1) {V1 mode}.d88
set baseImage2=%projectFolder%\diskImages\Shin Taketori Monogatari (Disk 2) {V1 mode}.d88

set newImage1=%projectFolder%\diskImages\Shin Taketori Monogatari (Disk 1) (NEW).d88
set newImage2=%projectFolder%\diskImages\Shin Taketori Monogatari (Disk 2) (NEW).d88

::Other
set biosTableFile=%basicCodeFolder%\JISx201 - Original.tbl
set assemblerTool=%toolsFolder%\n88-basic\N88Basic.exe
set findReplaceTool=%toolsFolder%\replacer\Replace.exe

:::::::::::::::::::::::::::::::
::Streamline disk image
:::::::::::::::::::::::::::::::
"%diskToolFolder%\KaguyaPC88File.exe" "Dump" "%baseImage1%" "%baseStreamLinedFolder1%"
"%diskToolFolder%\KaguyaPC88File.exe" "Dump" "%baseImage2%" "%baseStreamLinedFolder2%"

::Transfer disassembled files of interest
set mylist=intro,fork,forkTree,rightPath1,rightPath2,rightPath3,leftPath1,leftPath2,leftPath3,rightPathMaze,meadow,town1,town2,town3,bank1,bank2,river1,river2,river3,river4,river5,bamboo,ending

for %%i in (%mylist%) do (
	copy "%basicCodeOriginalDisasmFolder%\%%i.txt" "%basicCodeNewDisasmFolder%"
)

::Find and replace strings
"%findReplaceTool%" "%basicCodeFolder%\findReplaceIntro.txt" 		"%basicCodeNewDisasmFolder%\intro.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceBank1.txt" 		"%basicCodeNewDisasmFolder%\bank1.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceBank2.txt" 		"%basicCodeNewDisasmFolder%\bank2.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceMeadow.txt" 		"%basicCodeNewDisasmFolder%\meadow.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceLeftPath3.txt" 	"%basicCodeNewDisasmFolder%\leftPath3.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceTown3.txt" 		"%basicCodeNewDisasmFolder%\town3.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceRiver1.txt" 		"%basicCodeNewDisasmFolder%\river1.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceRiver4.txt" 		"%basicCodeNewDisasmFolder%\river4.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceEnding.txt" 		"%basicCodeNewDisasmFolder%\ending.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceRightPath1.txt" 	"%basicCodeNewDisasmFolder%\rightPath1.txt"
"%findReplaceTool%" "%basicCodeFolder%\findReplaceLeftPath1.txt" 	"%basicCodeNewDisasmFolder%\leftPath1.txt"

"%findReplaceTool%" "%basicCodeFolder%\findReplaceGlobal.txt" "%basicCodeNewDisasmFolder%"

for %%i in (%mylist%) do (
	"%assemblerTool%" "Write" "%biosTableFile%" "%basicCodeNewDisasmFolder%\%%i.txt" "%basicCodeNewFolder%\%%i.bin"
)

:::::::::::::::::::::::::::::::
::Write script
:::::::::::::::::::::::::::::::
"%SpiroFolder%\Spiro.exe" /ProjectDirectory "%projectFolder%" /Write
@pause
:::::::::::::::::::::::::::::::
::ASM scripts
:::::::::::::::::::::::::::::::
"%armipsFolder%\armips.exe" "%projectFolder%\asm\main.asm"

:::::::::::::::::::::::::::::::
::Encrypt Code (Disk #1)
:::::::::::::::::::::::::::::::
"%decryptionTool%" "Write" "0x00026C00*8,0x00026400*8,0x00024C00*8,0x00024400*4"				"%baseStreamLinedImage1%" "%basicCodeNewFolder%/intro.bin"
"%decryptionTool%" "Write" "0x00027400*8,0x00025C00*8,0x00025400*4"								"%baseStreamLinedImage1%" "%basicCodeNewFolder%/fork.bin"
"%decryptionTool%" "Write" "0x00023C00*8,0x00022C00*8,0x00022400*8,0x00020C00*4"				"%baseStreamLinedImage1%" "%basicCodeNewFolder%/forkTree.bin"
"%decryptionTool%" "Write" "0x00023400*8,0x00021C00*8,0x00020400*8,0x0001EC00*8,0x0001E400*4"	"%baseStreamLinedImage1%" "%basicCodeNewFolder%/rightPath1.bin"
"%decryptionTool%" "Write" "0x0001D400*8,0x0001C400*8,0x0001AC00*8,0x0001A400*8,0x00018C00*3"	"%baseStreamLinedImage1%" "%basicCodeNewFolder%/rightPath2.bin"
"%decryptionTool%" "Write" "0x00021400*8,0x0001FC00*8,0x0001F400*8,0x0001DC00*8,0x0001CC00*4"	"%baseStreamLinedImage1%" "%basicCodeNewFolder%/rightPath3.bin"
"%decryptionTool%" "Write" "0x0001BC00*8,0x0001B400*8,0x00019C00*8,0x00018400*8,0x00016C00*2"	"%baseStreamLinedImage1%" "%basicCodeNewFolder%/leftPath1.bin"
"%decryptionTool%" "Write" "0x00019400*8,0x00017C00*8,0x00016400*8,0x00014C00*8"				"%baseStreamLinedImage1%" "%basicCodeNewFolder%/leftPath2.bin"
"%decryptionTool%" "Write" "0x00011400*8,0x00010C00*8,0x00014400*4"								"%baseStreamLinedImage1%" "%basicCodeNewFolder%/leftPath3.bin"
"%decryptionTool%" "Write" "0x00015400*3"														"%baseStreamLinedImage1%" "%basicCodeNewFolder%/rightPathMaze.bin"
"%decryptionTool%" "Write" "0x00017400*8,0x00015C00*8,0x00014400*8,0x00012C00*8,0x00012400*4"	"%baseStreamLinedImage1%" "%basicCodeNewFolder%/meadow.bin"

:::::::::::::::::::::::::::::::
::Encrypt Code (Disk #2)
:::::::::::::::::::::::::::::::
"%decryptionTool%" "Write" "0x00024000*8,0x00023800*8,0x00022000*8,0x00021800*8,0x00020000*5"	"%baseStreamLinedImage2%" "%basicCodeNewFolder%/town1.bin"
"%decryptionTool%" "Write" "0x00024800*8,0x00023000*8,0x00022800*8,0x00021000*8,0x0001F800*2"	"%baseStreamLinedImage2%" "%basicCodeNewFolder%/town2.bin"
"%decryptionTool%" "Write" "0x00010800*8,0x0000F000*8"											"%baseStreamLinedImage2%" "%basicCodeNewFolder%/town3.bin"
"%decryptionTool%" "Write" "0x00020800*8,0x0001F000*8,0x0001E000*8,0x0001D800*8,0x0001C000*5"	"%baseStreamLinedImage2%" "%basicCodeNewFolder%/bank1.bin"
"%decryptionTool%" "Write" "0x0001E800*8,0x0001D000*8"											"%baseStreamLinedImage2%" "%basicCodeNewFolder%/bank2.bin"
"%decryptionTool%" "Write" "0x0001C800*8,0x0001B800*8,0x0001A000*8,0x00019800*8,0x00018000*2"	"%baseStreamLinedImage2%" "%basicCodeNewFolder%/river1.bin"
"%decryptionTool%" "Write" "0x0001B000*8,0x0001A800*8"											"%baseStreamLinedImage2%" "%basicCodeNewFolder%/river2.bin"
"%decryptionTool%" "Write" "0x00013000*8,0x00012800*8,0x00011000*8,0x0000F800*3"				"%baseStreamLinedImage2%" "%basicCodeNewFolder%/river3.bin"
"%decryptionTool%" "Write" "0x0000E800*8,0x0000E000*8"											"%baseStreamLinedImage2%" "%basicCodeNewFolder%/river4.bin"
"%decryptionTool%" "Write" "0x00019000*8,0x00017800*8,0x00016000*8,0x00015800*8,0x00014000*8"	"%baseStreamLinedImage2%" "%basicCodeNewFolder%/river5.bin"
"%decryptionTool%" "Write" "0x00018800*8,0x00017000*8,0x00016800*8,0x00015000*8" 				"%baseStreamLinedImage2%" "%basicCodeNewFolder%/bamboo.bin"
"%decryptionTool%" "Write" "0x00014800*8,0x00013800*8,0x00012000*8,0x00011800*8,0x00010000*8"	"%baseStreamLinedImage2%" "%basicCodeNewFolder%/ending.bin"

:::::::::::::::::::::::::::::::
::Compile disk image
:::::::::::::::::::::::::::::::

"%diskToolFolder%\KaguyaPC88File.exe" "Write" "%baseImage1%" "%newImage1%" "%baseStreamLinedFolder1%"
"%diskToolFolder%\KaguyaPC88File.exe" "Write" "%baseImage2%" "%newImage2%" "%baseStreamLinedFolder2%"

@pause
