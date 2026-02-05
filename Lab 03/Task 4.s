.text
.globl main
.text
.globl main
main:
    li x10, 0x100
    li x11, 0x200
    li x19, 0
    li x6, 'A'
    sb x6, 0(x11)
    li x6, 'M'
    sb x6, 4(x11)
    li x6, 'M'
    sb x6, 8(x11)
    li x6, 'K'
    sb x6, 12(x11)
    addi sp, sp, -12
    sw x11, 8(sp)
    sw x10, 4(sp)
    sw x19, 0(sp)

loop1:
    lb x17, 0(x11)
    sb x17, 0(x10)
    beq x17, x0, exit
    addi x10, x10, 4
    addi x11, x11, 4
    addi x19, x19, 1
    j loop1

exit:
    lw x11, 8(sp)
    lw x10, 4(sp)
    lw x19, 0(sp)
    addi sp, sp, 12
    