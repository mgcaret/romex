# ROM eX

ROM eX is a **BETA** enhancement to the enhanced Apple //e firmware ROM.

## Features

 - Upon Control+CA/Option+Reset, presents a menu allowing you to choose to enter the monitor or start the boot a specific slot.
 - Menu displays the type of card found in the slot.
 - Menu identifies Apple II workstation cards and correctly boots them by prompting to press open-apple to start the boot.
 - Delete key works like the left arrow in programs that read input lines using the monitor ROM.

## Tradeoffs/Flavors

Unlike the Apple //c firmware, there is no free space in the //e firmware.  Therefore sacrifices must be made.  With that in mind, ROM eX comes in two flavors:

 - Sacrificing the tape code ('no_tape').
   - This version has a terse menu in order to fit in the available space.
   - The diagnostics may be entered by pressing both apple keys with ctrl+reset.
 - Sacrificing the diagnostic code ('no_diags').
   - This version has a nicer menu that takes advantage of available space.

## Building

You must have Ruby and Rake installed, the CC65 suite, and probably some other things.  Review the Rakefile.  Author's development host runs MacOS X with the command line developer tools installed.

Change into the directory for your desired flavor and type 'rake' for a single ROM suitable for emulation or the later //e's CF ROM socket.  Type 'rake split" to also get ROMs suitable for the CD and EF ROM sockets on earlier //es.

## Installing

This ROM can be run in emulators that allow specifying a custom ROM image.  It is tested on Virtual ][.

Note that as of 2/7/2019, it has *NOT* been tested on actual hardware, though there is no reason it should not work.

To install in real hardware, the appropriate EPROMs must be programmed and installed in the system.  A 27SF512 may work in //es equipped with a CF ROM socket, and 'rake sf512' will generate such an image (with 4 copies of the ROM in it).

