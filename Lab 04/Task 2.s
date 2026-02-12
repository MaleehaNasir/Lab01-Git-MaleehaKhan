.text
.globl main
ntri:
    li x10, 1 #i=0
    li x11, 0 #sum start
    li x12, 6 #end of loop loop runs x12's value -1 times

loop1:
    beq x10, x12, exit
    add x11, x11, x10
    addi x10, x10, 1
    j loop1

exit:
    j exit

