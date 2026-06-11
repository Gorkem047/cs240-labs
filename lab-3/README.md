# Lab 3 - RISC-V Assembler

Original lab date: April 10, 2025

This lab implements a C-based assembler for a subset of RISC-V instructions and uses it to generate `.hex` and little-endian `.bin` outputs from assembly programs.

## Contents

| File | Description |
| --- | --- |
| `assembler.c` | Custom RISC-V assembler implementation. |
| `Makefile` | Builds the assembler executable. |
| `loop.s` | Small input assembly example. |
| `problem1.s` | Endian conversion assembly exercise. |
| `problem1.asm` | Assembly/disassembly artifact for problem 1. |
| `problem1.hex` | Hex output for problem 1. |
| `problem2.s` | Fibonacci assembly exercise. |
| `problem2.asm` | Assembly/disassembly artifact for problem 2. |
| `problem2.hex` | Hex output for problem 2. |
| `myLinkScript.ld` | Linker script used for executable generation. |
| `ldoptions.txt` | Linker options used in the original lab. |
| `lab3.txt` | Original lab report notes. |

## Main Ideas

- Parse RISC-V assembly with C string handling.
- Classify R, I, S, SB, U, UJ, and system call instructions.
- Encode instructions into 32-bit machine code.
- Write `.hex` text output and little-endian binary output.
- Validate assembly exercises with Spike.

## Build

```bash
make
```

## Run

```bash
./assembler problem1.s
./assembler problem2.s
```

Problem 1 converts memory words between endian formats. Problem 2 computes a Fibonacci value using branch offsets rather than labels.
