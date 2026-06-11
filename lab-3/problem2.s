# Başlangıç değerleri
addi x1, x0, 2      # i = 2
addi x2, x0, 0      # fib(0)
addi x3, x0, 1      # fib(1)
addi x5, x0, 10     # n = 10

# Döngü başlangıcı (etiketsiz, direkt offset ile)
add x4, x2, x3      # x4 = fib(i) = fib(i-1) + fib(i-2)
add x2, x0, x3      # x2 = fib(i-1)
add x3, x0, x4      # x3 = fib(i)
addi x1, x1, 1      # i++
blt x1, x5, -16     # i < n ? dön (4 instruction x 4 byte = 16)

# Sonuç x6’ya yaz
add x6, x0, x3    #fib(9) (34 founded)

# Programı bitir
addi x17, x0, 93
ecall