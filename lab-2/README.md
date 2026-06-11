# Lab 2 - RV32 Disassembler and Simulator

Original lab date: March 20, 2025

This lab extends an `ozu-riscv32` simulator by implementing instruction disassembly and instruction execution for a subset of RISC-V RV32 instructions.

## Contents

| Path | Description |
| --- | --- |
| `src/ozu-riscv32.c` | Main disassembler and simulator implementation. |
| `src/ozu-riscv32.h` | Simulator definitions, state, and memory structures. |
| `src/Makefile` | Build file for the simulator. |
| `input/test1.hex` | Test program input. |
| `input/test2.hex` | Test program input. |
| `input/test3.hex` | Test program with branch and jump behavior. |
| `test/testAssembly.s` | RISC-V assembly used for Spike comparison. |
| `test/myLinkScript.ld` | Linker script for test assembly. |
| `test/ldoptions.txt` | Linker options used in the original lab. |
| `lab2.txt` | Original lab notes and command history. |

## Implemented Work

- Disassembles hex instructions into readable RISC-V assembly.
- Simulates instruction execution and updates register state.
- Supports register dump, memory dump, program printing, reset, and step/run commands.
- Includes branch and jump label work for later test cases.
- Compares simulator behavior against Spike.

## Build

```bash
cd src
make
```

## Run

```bash
./ozu-riscv32 ../input/test1.hex
```

Useful simulator commands:

```text
p       print loaded program
s       simulate program to completion
rdump   dump register values
run n   run n instructions
reset   reload program and reset state
quit    exit
```
