.text
.globl main
main:
    li x10,0x100
    li x6,7
    addi sp,sp,-4
    sw x1,0(sp)
    li x3,2
    li x4,1
    sw x3,0(x10)
    sw x4,4(x10)
    beq x6,x0, done_L0
    li x7,1
    beq x6,x7,done_L1
    li x5,2
    jal x1,loop
    j finish

done_L0:
    addi x11,x3,0
    j finish

done_L1:
    addi x11,x4,0
    j finish

loop:
    add x11, x3, x4
    add x8, x5, x5
    add x8, x8, x8
    add x9, x10, x8
    sw x11, 0(x9)
    addi x3, x4, 0
    addi x4, x11, 0
    addi x5, x5, 1
    ble x5, x6, loop
    jalr x0, 0(x1)

finish:
    lw x1,0(sp)
    addi sp,sp,4

exit:
    j exit