.globl main
main:

       lui x3, 0x10000
       addi x5, x0, 1
       j Loop1
       addi x10, x10, 240
       ori x0, x0, 0
       addi x5, x0, 100
       ecall
       Loop1: bne x0, x0, Branch1
       ori x0, x0, 0
       addi x6, x0, 255
       beq x0, x0, Branch2
       ori x0, x0, 0
       addi x30, x0, 255
       Branch1: addi x31, x0, 255
       Branch2: addi x17, x0, 93
       ecall 
