.text
.globl main
fact:
    li x10, 0 # i = 0
    li x7, 1 #starting value of f
    li x6, 5 #eg number for loop end of loop
    li x11, 1 #product/factorial

loop1:
    beq x10, x6, exit
    mul x11, x11, x7 #f=i*f
    addi x7, x7, 1
    addi x10, x10, 1 #increment i
    j loop1

exit:
    j exit
