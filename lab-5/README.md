# Lab 5 - Multi-Cycle RISC-V Core

Original lab date: May 15, 2025

This lab implements a multi-cycle RISC-V core in Verilog. The core uses fetch, decode, execute/memory, and writeback states and connects to an external memory interface.

## Contents

| File | Description |
| --- | --- |
| `core.v` | Multi-cycle RISC-V core implementation. |

## Main Ideas

- Four-state control flow:
  - `FETCH_STATE`
  - `DECODE_STATE`
  - `EXMEM_STATE`
  - `WB_STATE`
- Program counter and instruction register management.
- Register file with writeback control.
- Memory interface with address, data, write enable, and byte mask signals.
- Arithmetic and logical execution for R-type and I-type instructions.
- Load/store support with byte, halfword, and word masks.
- Branch and jump handling for control-flow instructions.
- Integration with a RISC-V decoder module interface.

## Notes

The implementation is kept close to the original lab submission. Generated simulator outputs and build artifacts are not included.
