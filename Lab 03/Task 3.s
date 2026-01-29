.text
.globl main
main:
    li x10, 0x100 #v
    li x11, 0 #k
    li x9, 0 #temp
    
    li x6, 5 
    sw x6, 0(x10)
    li x6, 2 
    sw x6, 4(x10)

    li x11, 0
    
    jal x1, swap

    li x10, 1
    ecall

    end:
    j end

swap:  
    slli x9, x11, 2 #temp=k*4
    add x9, x10, x9 #temp=&v[k]
    lw x12, 0(x9)
    lw x13, 4(x9)
    sw x13, 0(x9)
    sw x12, 4(x9)

    addi, x11, x12, 0
    jalr x0, 0(x1)
    



