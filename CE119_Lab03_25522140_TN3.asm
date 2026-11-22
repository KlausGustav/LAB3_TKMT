# TN3 - MSSV 25522140; delayed branching OFF
# Doi word n de do tung dau vao; doi duy nhat jal fib_rec thanh jal fib_iter.
.data
n: .word 11
prefix: .asciiz "F(n) = "
nl: .asciiz "\n"
.text
.globl main
# main: doc n tu .data, goi fib, in ket qua, thoat; dung a0,v0,s0,ra.
main:
    lw $a0, n
    jal fib_rec
    move $s0, $v0
    li $v0, 4
    la $a0, prefix
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, nl
    syscall
    li $v0, 10
    syscall
# fib_rec: a0=n>=0; v0=F(n); dung s0,s1,t0,a0,v0,ra,sp.
# Khung 12 byte o MOI lan goi: 0=s1,4=s0,8=ra; phuc hoi day du.
fib_rec:
    addiu $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    move $s0, $a0
    slti $t0, $s0, 2
    beq $t0, $zero, fib_recurse
fib_base:
    move $v0, $s0
    j fib_end
fib_recurse:
    addiu $a0, $s0, -1
    jal fib_rec
    move $s1, $v0
    addiu $a0, $s0, -2
    jal fib_rec
    addu $v0, $s1, $v0
fib_end:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addiu $sp, $sp, 12
    jr $ra
# fib_iter: tinh F(n) bang vong lap
# Tham so : $a0 = n    Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
        move  $v0, $zero        # a = F(0)
        li    $t0, 1            # b = F(1)
        move  $t1, $zero        # i = 0
fi_loop:
        slt   $t2, $t1, $a0
        beq   $t2, $zero, fi_done
        addu  $t3, $v0, $t0     # a + b
        move  $v0, $t0
        move  $t0, $t3
        addiu $t1, $t1, 1
        j     fi_loop
fi_done:
        jr    $ra
