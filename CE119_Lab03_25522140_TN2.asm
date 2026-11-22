# TN2 - MSSV 25522140; delayed branching OFF
.data
s0: .asciiz "kien truc may tinh"
s1: .asciiz "mips"
s2: .asciiz ""
s3: .asciiz "a bc def"
sd: .asciiz "luu dia chi tro ve truoc khi goi"
bad1: .asciiz "a  bc def"
bad2: .asciiz " a bc"
bar: .asciiz "|"
newline: .asciiz "|\n"
.text
.globl main
# main: in 5 chuoi kiem thu; dung a0,v0,ra; khong cap khung.
# De xem Bang 10: dat breakpoint o rev_range, bo qua 11 lan dau
# (5 lan cua s0, 2 lan cua s1, 0 lan cua s2, 4 lan cua s3), hoac doi main de chi goi sd.
main:
    la $a0, s0
    jal reverse_words
    li $v0, 4
    la $a0, bar
    syscall
    la $a0, s0
    syscall
    la $a0, newline
    syscall
    la $a0, s1
    jal reverse_words
    li $v0, 4
    la $a0, bar
    syscall
    la $a0, s1
    syscall
    la $a0, newline
    syscall
    la $a0, s2
    jal reverse_words
    li $v0, 4
    la $a0, bar
    syscall
    la $a0, s2
    syscall
    la $a0, newline
    syscall
    la $a0, s3
    jal reverse_words
    li $v0, 4
    la $a0, bar
    syscall
    la $a0, s3
    syscall
    la $a0, newline
    syscall
    la $a0, sd
    jal reverse_words
    li $v0, 4
    la $a0, bar
    syscall
    la $a0, sd
    syscall
    la $a0, newline
    syscall
    li $v0, 10
    syscall
# strlen: a0=chuoi; v0=do dai; dung t0,t1,v0; la, khong dung stack.
strlen:
    move $t0, $a0
    move $v0, $zero
strlen_loop:
    lbu $t1, 0($t0)
    beq $t1, $zero, strlen_done
    addiu $v0, $v0, 1
    addiu $t0, $t0, 1
    j strlen_loop
strlen_done:
    jr $ra
# rev_range: a0=dau,a1=cuoi (bao gom hai dau); khong tra gia tri.
# Dung a0,a1,t0,t1,t2; so sanh dia chi khong dau; khong dung stack.
rev_range:
    sltu $t0, $a0, $a1
    beq $t0, $zero, range_done
    lbu $t1, 0($a0)
    lbu $t2, 0($a1)
    sb $t2, 0($a0)
    sb $t1, 0($a1)
    addiu $a0, $a0, 1
    addiu $a1, $a1, -1
    j rev_range
range_done:
    jr $ra
# reverse_words: a0=chuoi; dao tai cho; khong tra gia tri.
# s0=dia chi goc,s1=con tro duyet,s2=dau tu; luu s0-s2,ra.
# Dung a0,a1,v0,t0,t1; khung 16 byte; moi loi ra deu qua rw_done.
reverse_words:
    addiu $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    move $s0, $a0
    jal strlen
    beq $v0, $zero, rw_done
    move $a0, $s0
    addu $a1, $s0, $v0
    addiu $a1, $a1, -1
    jal rev_range
    move $s1, $s0
    move $s2, $s0
rw_scan:
    lbu $t0, 0($s1)
    beq $t0, $zero, rw_last
    li $t1, 32
    beq $t0, $t1, rw_word
    addiu $s1, $s1, 1
    j rw_scan
rw_word:
    beq $s1, $s2, rw_advance
    move $a0, $s2
    addiu $a1, $s1, -1
    jal rev_range
rw_advance:
    addiu $s1, $s1, 1
    move $s2, $s1
    j rw_scan
rw_last:
    beq $s1, $s2, rw_done
    move $a0, $s2
    addiu $a1, $s1, -1
    jal rev_range
rw_done:
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addiu $sp, $sp, 16
    jr $ra
