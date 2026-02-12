.text
.globl main
main:
    li x10, 0(x100) #array base address

    li x6, 23
    sw x6, 0(x1)

    li x6, 12
    sw x6, 4(x1)

    li x6, 5
    sw x6, 8(x1)

    li x6, 44
    sw x6, 12(x1)

    li x6, 98
    sw x6, 16(x1)


    li x6, 5 #initialize size of array
    li x7, 0 #i=0

loop1:
    beq x7, x6, exit
    add x10, x7, x0 #j=i
    addi x7, x7, 1 #i++
    add 121, x7, x0 #loaded i into x10
    addi x10, x10, 3 #incremented it to get arr ofset size and all
    #so here x10 has arr[i]
    
loop2:
    beq x10, x6, loop1
    lw x11, 0(x1) #arr[i]
    addi x1, x1, 4 #increment 
    lw x12, 0(x1) #arr[j]

    



