.data
.text
.globl start
start:
    li t1, 512  #led address (0x200)
    sw x0, 0(t1) #0 to all leds

loop1:
    li t1,768 #switch address (0x300)
    lw t0,0(t1)
    beq t0,x0,loop1 #keep looping 
    addi a0, t0, 0  #a0=initial count value

    addi sp,sp,-8 
    sw ra, 4(sp) #save return address
    sw s0, 0(sp) #save initial count value

    jal ra, countdown

    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    j start
countdown:
    addi s0,a0,0
loop2:
    li t1,512
    sw s0,0(t1)

    li t1,768
    lw t0,0(t1)
    beq t0,x0, reset
    jal ra, delay 

    addi s0, s0, -1
    bgt s0, x0, loop2

    ret
reset:
    li t1,512 #led address
    sw x0,0(t1) #reset leds to 0
    ret
delay:
    li t2, 2000000 #delay count value for 1 second
loop3:
    addi t2, t2, -1
    bne t2, x0, loop3 #wait until delay count value is 0
    ret