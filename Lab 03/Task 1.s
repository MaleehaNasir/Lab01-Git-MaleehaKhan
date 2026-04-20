# addi a0 x0 1
# addi a1 x0 42
# ecall

addi x10,x0,12
addi x11,x0,12
jal x1, sum #calls the function named sum
addi x11, x10, 0
li x10,1
ecall
j exit

sum:
add x10,x11,x10
jalr x0,0(x1)

exit: