.text
.globl start
start:
    addi sp, x0, 500      # initialize sp to address 500 (top of data memory)
    
    addi t1, x0, 512
    sw x0, 0(t1)

loop1:
    addi t1, x0, 768
    lw t0, 0(t1)
    beq t0, x0, loop1
    addi a0, t0, 0

    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)

    jal ra, countdown

    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    jal x0, start

countdown:
    addi s0, a0, 0

loop2:
    addi t1, x0, 512
    sw s0, 0(t1)

    addi t1, x0, 768
    lw t0, 0(t1)
    beq t0, x0, reset

    addi s0, s0, -1
    blt x0, s0, loop2

    jalr x0, 0(ra)

reset:
    addi t1, x0, 512
    sw x0, 0(t1)
    jalr x0, 0(ra)