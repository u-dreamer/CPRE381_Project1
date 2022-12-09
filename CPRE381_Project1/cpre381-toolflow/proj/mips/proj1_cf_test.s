.data

.text
	lui $sp, 0x7FFF
	ori $sp, $sp, 0xEFFC
	lui $gp, 0x1000
	ori $gp, $gp, 0x8000

main:
	li $sp, 0x10011000
	addi	$a0, $zero, 0x0
	addi	$a1, $zero, 0x1
	addi	$a2, $zero, 0x2
	jal	stackframe
	addi	$s0, $v0, 0
	j	exit

stackframe:
	addi	$sp, $sp, -16
	slti	$t4, $a2, 0xF00
	beq	$t4, 0, done
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	addi	$v0, $v0, 1
	j	loop
	
loop:
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	add	$t1, $t1, $t0
	add	$t2, $t2, $t1
	addi	$t0, $t0, 1
	addi	$a2, $t2, 0
	addi	$a1, $t1, 0
	addi	$a0, $t0, 0
	j	stackframe
done:
	addi	$sp, $sp, 16
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	add	$t1, $t1, $t0
	add	$t2, $t2, $t1
	add	$v1, $v1, $t2
	bne	$t0, 1, done
	lw	$ra, 0($sp)
	jr	$ra
	
exit:
	halt
