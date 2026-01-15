.text
.globl main
main:
    # li x20, 3 
    # li x21, 1
    # li x22, 2
    # li x23, 1

    # add x5, x20, x21
    # add x6, x22, x23
    # sub x19, x5, x6

    # addi x22, x22, 4

    # li x20, 5 #a=5
    # li x18, 5 #just to store 5
    # li x19, 0
    # li x17, 32
    # add x21, x19, x19 #b = 0+0
    # add x20, x21, x17 #a=b+32
    # add x23, x20, x21 #newvar1=a+b
    # sub x24, x23, x18 #newvar2=newvar1-5 (=d)

    # sub x26, x20, x24 #newvar3=a-d
    # sub x27, x21, x20 #newvar4=b-a
    # add x28, x27, x26 #newvar5= newvar3+newvar4
    # add x29, x28, x24 # added d to newvar5
    # add x30, x20, x21 #nv=a+b
    # add x29, x29, x24 #nv2=d+e
    # add x29, x29, x30 

    # li x10, 0x78786464
    # li x11,  0xA8A81919
    
    # li x5, 0x100 #temp reg
    # lhu x12, 0(x5)

    # li x6, 0x1F0
    # lh x13, 0(x6)

    # li x7, 0x1F0
    # lb x14, 0(x7)


    #i=0
    li x10, 0x100
    lb x20, 0(x10)

    li x11, 0x200
    lh x21, 0(x11)

    li x12, 0x300

    add x22, x20, x21
    sw x22, 0(x12)

    #i=1
    lb x20, 1(x10)

    lh x21, 2(x11)

    add x22, x20, x21
    sw x22, 4(x12)

    #i=2
    lb x20, 2(x10)

    lh x21, 4(x11)

    add x22, x20, x21
    sw x22, 8(x12)

    #i=3
    lb x20, 3(x10)

    lh x21, 6(x11)

    add x22, x20, x21
    sw x22, 12(x12)







end:
    j end