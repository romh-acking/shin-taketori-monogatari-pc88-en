[//]: <> (This readme is in the markdown format. Please preview in a markdown parser.)

# Shin Taketori Monogatari (PC-88): English Translation

## About
This repository contains source code for patches and tools to compile an English translation of Shin Taketori Monogatari for the PC-88.

## Folders
* `asm`
	* Contains the asm files which are to be compiled with the armips z80 fork.
* `code`
	* Folder to manage (de)compiled BASIC code. Contains file and replace files to patch the BASIC code with custom hacks.
* `diskImages`
	* Use this to store your D88 disk images
* `diskImageStreamlined1` and `diskImageStreamlined2`
	* Used in part of the process of simplifying the disk images. See information on the tool `d88-manager` for further details.

* `script`
	* Contains the dumped script and translated script.
* `tables`
	* Contains table files
* `tools`
	* `armips`
		* Applies the assembly patches
	* `cyproAce`
		* A script editor
	* [`d88-manager`](https://github.com/romh-acking/shin-taketori-monogatari-pc88-d88-manager)
		* This tool simplifies the disk images.
		* The D88 images appears to be of the NFD r1 format. There currently isn't a tool to manage this format, so I created my own tool to manage it. It's bit of a hack, but basically, I remove the sector header information and manage the data linearly with my patching tools. For the most part, the data isn't fragmented.
	* [`n88-basic`](https://github.com/romh-acking/n88-basic-de-compiler)
		* A commandline tool to decompile and compile N88 BASIC code for the PC88.
	* [`protection`](https://github.com/romh-acking/shin-taketori-monogatari-pc88-protection)
		* A commandline tool that decrypts / encrypts and extracts / inserts N88 BASIC bytccode.
	* [`replacer`](https://github.com/romh-acking/replacer-utf-8)
		* A simple tool to find and replace UTF-8 strings in .txt files 
	* `spiro`
		* Script dumper and inserter

## Manual
One of the few projects of mine to not have a manual scan. If you find a high quality manual scan, let me know.

## Instructions
The tools are coded in C#. You'll have to mess with Wine if you want them to run in Linux. You'll also have to rewrite the bat files, which aren't complicated at all.

* If you want to dump the script (the Japanese and English script are already included in this repository), you can dump it by executing the bat file `Dump.bat` by double clicking it.
    * Keep in mind this overwrites the existing `script.json`.
* To generate translated D88 disk images, execute the bat file `Write.bat` by double clicking it.

## Changelog
* 2023 December 4th: 1.0
    * Initial release

## Credits

### Main Team
* FCandChill
    * ASM work
    * Utilities
    * Localizer
    * Proofreader
* CounterDiving
    * Translation
* ppltoast
    * Tester

### Support
* Lazermutt4
    * Kanji identification
* Her-saki
    * Spot-translations

### Beta Testers
* ppltoast
* divingkxt
* marklincadet
* missilelawnchair
* witchyummy
* kanjicrt