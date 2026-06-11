# Lab 4 - RISC-V Decoder and LED CPU Core

Original lab date: April 30, 2025

This lab contains two hardware description exercises: a small LED CPU core and a RISC-V decoder/control module.

## Contents

| File | Description |
| --- | --- |
| `LedCPUcore.v` | Simple CPU-style module that reads encoded LED pattern/timing data and drives `outPattern`. |
| `design.sv` | RISC-V instruction decoder that extracts fields and produces control signals. |

## Main Ideas

- Sequential state update with `clk` and `rst`.
- Instruction field extraction: opcode, `rd`, `rs1`, `rs2`, `funct3`, `funct7`, immediates.
- Control generation for load, store, R-type, branch, I-type ALU, and jump instructions.
- Immediate construction for S-type, branch, and jump formats.

## Notes

These files are HDL source files intended for simulation or integration in a larger CPU design environment. No generated waveform or simulator output files are included in this archive.
