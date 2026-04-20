.text
.globl main
main:

li x10, 8 #g
li x11, 7 #h
li x12, 6 #i
li x13, 5 #j

li x20, 0 #f

addi sp, sp, -12
sw x20, 8(sp)
sw x19, 4(sp)
sw x18, 0(sp)

jal x1, sum

lw x18, 0(sp)
lw x19, 4(sp)
lw x20, 8(sp)

addi sp, sp, 12

addi x11, x10, 0
li x10, 1
ecall

end:
j end

sum:
add x18, x10, x11
add x19, x12, x13
sub x10, x18, x19

jalr x0, 0(x1)



