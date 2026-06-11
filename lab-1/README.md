# Lab 1 - RISC-V Toolchain and GCD

Original lab date: February 23, 2025

This lab explores the RISC-V compilation flow using a simple greatest common divisor program. The C implementation is compiled for RISC-V, inspected as an ELF file, disassembled, and run with Spike.

## Contents

| File | Description |
| --- | --- |
| `GCD.c` | C implementation of the Euclidean GCD algorithm. |
| `GCD.S` | RISC-V assembly generated from the C source. |
| `lab1.txt` | Original lab notes describing compilation, ELF inspection, objdump, and Spike execution. |

## Main Ideas

- Compile a C program with the RISC-V toolchain.
- Inspect the resulting ELF executable with `file`, `readelf`, and `objdump`.
- Generate assembly from C using `riscv32-unknown-elf-gcc -S`.
- Assemble and link manually.
- Run the program on Spike with the proxy kernel.

## Example Commands

```bash
riscv32-unknown-elf-gcc -S GCD.c -o GCD.S
riscv32-unknown-elf-as GCD.S -o GCD.o
spike --isa=rv32i pk GCD
```

The original test case computes the GCD of `64` and `16`, producing `16`.
