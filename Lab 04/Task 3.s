.text
.globl

main:
    li x10, 0x200
    #populate the array
    li x5, 8
    sw x5, 0(x10)
    li x5, 20
    sw x5, 4(x10)
    li x5, 15
    sw x5, 8(x10)
    li x5, 3
    sw x5, 12(x10)
    li x5, 9
    sw x5, 16(x10)

    jal x1, bubble_sort #call bubble sort

bubble_sort:
    #allocatian of stack
    addi sp, sp, -8
    sw x8,8(sp)
    sw x9, 4(sp)

    #bubble sort Loqic
    li x7, 0 #i
    li x9, 4

outer_loop:
    bge x7, x9, exit
    li x8, 0 #j=0
    li x6, 0 #swapped = false
    sub x9, x9, x7 #Limit of j = n-i-1

inner_loop:
    bge x8, x9, check_flag

    # Load a[j] and a[j+1]
    slli x5, x8, 2
    add x5, x10, x5
    lw x20, 0(x5)
    lw x21, 4(x5)

    ble x28, x21, no_swap

    # swap
    sw x21, 0(x5)
    sw x20, 4(x5)
    li x6, 1

no_swap:
    addi x8, x8, 1
    j inner_loop

check_flag:
    beq x6, x0, exit
    addi x7, x7, 1
    j outer_loop

exit:
    j exit