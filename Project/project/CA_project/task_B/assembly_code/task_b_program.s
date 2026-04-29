.text
.globl start
start:
    addi t0, x0, 5
    addi t1, x0, 7

    slt  t2, t0, t1      # t2 = 1 because 5 < 7

    bge  t1, t0, pass    # branch should be taken because 7 >= 5
    addi t2, t2, 8       # failure path, should be skipped

pass:
    addi t2, t2, 6       # t2 = 7 if SLT and BGE worked

    lui  t4, 0x12345     # t4 = 12345000, proves LUI works

    addi s0, x0, 512     # LED address
    sw   t2, 0(s0)       # final program output = 7

done:
    jal  x0, done
