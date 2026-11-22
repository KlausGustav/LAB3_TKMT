.data
msg:    .asciiz "Ket qua: "
.text
.globl main
main:
        li    $a0, 5            # x = 5
        jal   outer             # v0 = outer(5)
        move  $s0, $v0
        li    $v0, 4
        la    $a0, msg
        syscall
        move  $a0, $s0
        li    $v0, 1
        syscall
        li    $v0, 10
        syscall
# outer: a0=x; v0=2*x+1; dung v0,ra,sp; luu va phuc hoi ra,sp.
outer:
        addiu $sp, $sp, -4
        sw    $ra, 0($sp)
        jal   inner
        addi  $v0, $v0, 1
        lw    $ra, 0($sp)
        addiu $sp, $sp, 4
        jr    $ra
# inner: a0=x; v0=2*x; dung v0; thu tuc la, khong can khung.
inner:
        add   $v0, $a0, $a0
        jr    $ra
	