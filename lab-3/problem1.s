lui x5, 65536     
addi x5, x5, 0
addi x6, x0, 8   
addi x11, x0, 1500
sw x11, 0(x5)


lb x7, 0(x5)
lb x8, 1(x5)
lb x9, 2(x5)
lb x10, 3(x5)

sb x10, 0(x5)
sb x9, 1(x5)
sb x8, 2(x5)
sb x7, 3(x5)

addi x5, x5, 4
addi x6, x6, -1
bne x6, x0, -40     

addi x17, x0, 93
ecall