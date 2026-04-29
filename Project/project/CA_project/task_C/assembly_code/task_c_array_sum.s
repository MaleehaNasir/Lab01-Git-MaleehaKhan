.text
.globl start

start:
    # Task B instruction: LUI
    # This gives a visible 32-bit ALU output: 0x12345000.
    lui  t4, 0x12345

    # Store array [2, 4, 6, 8] in data memory.
    # Data memory addresses 0, 4, 8, and 12 are used.
    addi t0, x0, 0

    addi t1, x0, 2
    sw   t1, 0(t0)

    addi t1, x0, 4
    sw   t1, 4(t0)

    addi t1, x0, 6
    sw   t1, 8(t0)

    addi t1, x0, 8
    sw   t1, 12(t0)

    # Loop setup.
    addi s0, x0, 0      # sum = 0
    addi s1, x0, 0      # i = 0
    addi s2, x0, 4      # length = 4
    addi t0, x0, 0      # pointer = array base

loop:
    # Task B instruction: SLT
    slt  t3, s1, s2     # t3 = 1 while i < length
    beq  t3, x0, done

    lw   t2, 0(t0)      # t2 = array[i]
    add  s0, s0, t2     # sum += array[i]

    addi t0, t0, 4      # pointer += 4
    addi s1, s1, 1      # i++

    # Task B instruction: BGE
    bge  s1, s2, done   # exit if i >= length
    jal  x0, loop

done:
    addi t5, x0, 512    # LED output address
    sw   s0, 0(t5)      # LEDs should show 20 decimal = 0x0014

halt:
    jal  x0, halt
