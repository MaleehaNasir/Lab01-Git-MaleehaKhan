li x5, 3
li x6, 2
li x10, 0x10000000
li x7, 0
outer_loop:
bge x7, x5, exit
li x29, 0
inner_loop:
bge x29, x6, outer_inc
add x1, x7, x29
slli x2, x1, 2
add x2, x10, x2
sw x1, 0(x2)
addi x29, x29, 1
j inner_loop
outer_inc:
addi x7, x7, 1
j outer_loop
exit: