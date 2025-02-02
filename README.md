# Currency Converter in ARM32 Assembly Language!

This is a (harder than it looks) implementation of a currency converter in ARM Assembly (for now!).

## Background
As someone who's been fascinated by currencies, one historic system particularly strikes me.

The pre-1971 British (and colonial) currency system was a bit of a mess. It was based on the pound, which was divided into 20 shillings, each of which was divided into 12 pence. This meant that there were 240 pence to the pound. There is a sense of nostalgia about this system, but it makes for some odd and difficult calculations. 

This program allows you to convert between present-day metric currency and the old British currency system, and vice versa.

> The currency system was changed in 1971 to a decimal system, where 100 pence make a pound.


## Configuration
The conversion rates are hardcoded into the program. You can change them by changing the values of the constants in the code, towards the top.

During execution, you will be asked from which currency system you want to convert from and it will then ask you for the amount. The program will then automatically convert the amount to the other currency system.



## Assembling and Running
As this is written in ARM Assembly, you will need (1) an ARM emulator if you are running this on a non-ARM machine, and (2) an ARM assembler to compile the code into machine code.

I use the "kmd" (or Komodo) assembler, made by Manchester University after following an online course on ARM assembly. You can find it here. To output it, follow the steps:

- Download and run the kmd assembler.
- Clone the repo INTO A LINUX MACHINE (kmd doesn't work on Windows) or copy the converter-assembly.s file.
- Open a terminal and run kmd -e & to open KoMoDo.
- In Komodo, in the top right, press "Browse", navigate to the folder where your converter-assembly.s file is, and click OK.
- Press "Compile" and then "Load".
- Press "Features" to open the output window (used for SWI calls - kmd interprets these as print statements).
- Press "Run".
- Follow the instructions on the screen to convert between the two currency systems!

## Files
- converter-assembly.s is the main file with the currency conversion code.
- converter-assembly.kmd is the output file from the assembler and also the raw hexadecimal instructions for the ARM CPU.
- converter.c is a C program that does the same thing, but in C. It is included for comparison - the logic is fairly similar and fascinating to compare!

### Note
This does NOT abide by APCS - the Arm Procedure Call Standard. If you wish to implement this in a larger project, you will need to follow the standard by using instructions like:

```arm
someFunction    ; ... code here
                BL      someOtherFunction ; go to another function
                SWI     2 ; end of program

someOtherFunction
                STMFD SP!, {R4-R8, R14}
                ; ... some more code that may corrupt R4-R8 here
                LDMFD SP!, {R4-R8, PC}
                MOV     PC, R14 ; set the program counter to the return address
```

... and also change the SWI calls to your print or system calls.

## Prerequisites
- A Linux machine or VM
- kmd assembler

## Future Work
I am currently also working on an interactive web version of this program, which will be available soon! It is a very simple and clean implementation of the same program, but (mostly) in JavaScript with a focus on the UI - as (admittedly) ARM Assembly is not the best language for UIs!

## License
Public Domain.