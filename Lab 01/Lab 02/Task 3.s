li x1, 10 # comparison point

li x2, 0 # i

li x3, 0 # sum 

li x10, 0x200 #base address

bne x2, x1, loop1 #if i !=10, go to loop1

loop1:
bge x2, x1, loop2
sw x2, 0(x10) #stored value in array
addi x10, x10, 4 #increased memory by 4 to go to next array index
addi x2, x2, 1 #i++
j loop1

li x20, 0
loop2:
bge x20, x1, exit
lw x4, 0(x10)
add x3, x3, x4
addi x10, x10, 4 #increased memory by 4 to go to next array index
addi x20, x20, 1 #i++
j loop2

exit:






