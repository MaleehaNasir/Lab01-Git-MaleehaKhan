.text
.globl 

main:
    addi x10, x0, 3
    jal x1, ntri

    addi x11, x10, 0
    li x10, 1
    ecall 
    j exit

ntri:
    addi sp, sp, -8

    sw x1, 4(sp)
    sw x10, 0(sp)

    #base case check
    addi x5, x10, -1 #x5 = num - 1 
    blt x10, x0, ntri_base


ntri_recursive:
    addi x10, x10, -1      
    jal x1, ntri #recursive call       
    addi x6, x10, 0

    lw x10, 0(sp)
    lw x1, 4(sp)         
    addi sp, sp, 8
    
    add x10, x10, x6
    jalr x0, 0(x1)

ntri_base:
    addi x10, x0, 0
    addi sp, sp, 4
    jalr x0, 0(x1)

exit:
    j exit

    



