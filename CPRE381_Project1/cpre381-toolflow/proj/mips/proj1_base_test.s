.data

.text
main:
	li $sp, 0x10011000
	addi	$t0, $zero, 0x5	
	addi	$t1, $zero, 0x10
	add	$t0, $t0, $t1		
	addiu	$t0, $t0, 0x10		
	addu	$t1, $t0, 0x100000	
	and	$t2, $t0, 0x20		
	andi	$t2, $t2, 0x0		
	lui	$t3, 0x1001		
	sw	$t3, 0($sp)		
	lw	$t4, 0($sp)		
	nor	$t5, $t4, $t4		
	xor	$t5, $t5, $t4		
	xori	$t5, $t5, 0x10010000	
	or	$t6, $t5, 0		
	ori	$t6, $t6, 0x10010000	
	slt	$t7, $t5, $t6		
	slti	$t7, $t0, 0x10		
	addi	$t7, $zero, 0x1
	sll	$t8, $t7, 0x4		
	addi	$t7, $zero, 0xFFFF1234	
	srl	$t8, $t7, 0x2		
	sra	$t9, $t7, 0x2		
	addi	$t0, $zero, 0x20	
	addi	$t1, $zero, 0x40
	sub	$t2, $t1, $t0		
	subu	$t2, $t2, $t0		
	addi	$t0, $zero, 0x20
	addi	$t1, $zero, 0x19
	addi	$t9, $t9, 0xFFFFFFFF
	slt	$t2, $t0, $t1		
	beq	$t2, $zero, beqtest	
	
beqtest:
	addi	$t7, $zero, 0x4		
	addi	$t8, $t7, 0x10		
	jal	jmplnk
	slt	$t0, $t6, $t9		
	bne	$t0, 1, brnch
	beq	$t0, 1, brnch
	
jmplnk:
	add	$t9, $t7, $t8		
	add	$t6, $t7, $t8		
	jr	$ra			
	
brnch:
	addi	$t9, $zero, 1
	halt
