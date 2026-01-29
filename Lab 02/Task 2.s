#x=x20, a=x21, b=x22, c=x23

li x20, 3
li x21, 6
li x22, 7
li x23, 8

li x1, 1
li x2, 2
li x3, 3
li x4, 4

beq x20, x1, case1
beq x20, x2, case2
beq x20, x3 case3
beq x20, x4, case4

li x21, 0

case1:
add x21, x22, x23
beq x0, x0, exit

case2:
sub x21, x22, x23
beq x0, x0, exit

case3:
slli, x21, x22, 1
beq x0, x0, exit

case4:
srli, x21, x22, 1
beq x0, x0, exit

exit:


