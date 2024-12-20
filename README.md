# anti-antivirus-1994
Code for 1994 anti-antivirus in ms-dos or Win 3.1

# Retrovirus Assembly Code

This is a sample assembly code implementation of a retrovirus, as described in the 1994 Virus Bulletin paper "Retroviruses - how viruses fight back".
[Link to the original paper](https://ia801306.us.archive.org/3/items/Mikko_Retroviruses_1994_06/retro.pdf)


## Compiling and Running

The code is written for 16-bit x86 architectures, targeting MS-DOS or Windows 3.1 operating systems.

To compile the code, you'll need an assembler like MASM or TASM (or nasm in GNU/LINUX using mode -t). For example, to compile using TASM:
```
tasm /zi retrovirus.asm
tlink /t retrovirus.obj

```

This will generate an executable file named `retrovirus.exe`.

To run the retrovirus:

1. Ensure that the target anti-virus program (`SCANPROG.EXE`) is running on the system.
2. Execute the `retrovirus.exe` file.

The retrovirus will attempt to bypass the anti-virus program using the following techniques:

1. Modifying the command-line parameters passed to the anti-virus program to skip certain files.
2. Altering the output of the anti-virus program to hide detected viruses.
3. Making the infected file appear as a packed executable to bypass scanning.
4. Patching the INT 21h handler to bypass anti-virus checks.

After executing the retrovirus, the original program should run as expected, but the anti-virus program will be unable to detect the virus.

**Note:** This code is provided for educational and research purposes only. Do not use it to create or distribute malware, as that would be illegal.
