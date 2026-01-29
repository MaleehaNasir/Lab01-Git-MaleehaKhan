.text
.globl main
main:
    li x10, 0x100
    li x11, 0x200

    li x4, 'A'
    sb x5, 0(x11)
    li x5, 'M'
    sb x5, 1(x11)
    li x5, 0
    sb x5, 2(x11)

    jal x1, strcpy
    li x10, 10
    ecall
strcpy:
    li x4, 0 #i=0
while:
    add x6, x3, x4
    lb x5, 0(x6) #y[i]
    add x7, x2, x4
    sb x5, 0(x7) #x[i]=y[i]

    beq x5, x0, exit

    addi x4, x4, 1 #i++
    beq x0, x0, while
exit:

    