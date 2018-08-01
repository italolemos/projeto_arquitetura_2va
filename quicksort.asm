.data 
INF: 	.word 0
SUP: 	.word 9
T:	.word 12, 3, 6, 18, 7, 15, 10, 9, 0, 4
LF:	.asciiz "\n"
TAB:	.asciiz "\t"

	.text
main:
	la $a0, T                  # carrega vetor
	lw $a1, INF                # valor menor
	lw $a2, SUP                # valor maior
	jal afficherEtat		#afficherEtat(T, INF, SUP)
	
	la $a0, T
	lw $a1, INF
	lw $a2, SUP
	jal quickSort
	
	la $a0, T
	lw $a1, INF
	lw $a2, SUP
	jal afficherEtat		#afficherEtat(T, INF, SUP)
	
	li $v0, 10			#exit()
	syscall	

afficherEtat:
	move $t0, $a0
loop:
	#if($a2 < $a1) break;
	slt $t1, $a2, $a1		#$t1 = $a2 < $a1
	bne $t1, $zero, endAfficherEtat	#if($t1) break;
	mul $t1, $a1, 4
	add $t1, $t0, $t1		#$t1 = $t0 + 4*$a1
	ori $v0, $zero, 1		#print_int(Mem[$t1])
	lw $a0, ($t1)
	syscall
	li $v0, 4			#print_string(TAB)
	la $a0, TAB
	syscall
	addi $a1, $a1, 1		#++$a1
	j loop
endAfficherEtat:
	li $v0, 4			#print_string(LF)
	la $a0, LF
	syscall
	jr $ra
	
quickSort:
	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)			#empile les arguments + ra
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	slt $t0, $a1, $a2		#$t0 = Bas < Haut
	beq $t0, $zero, endQuickSort	#if(Bas < Haut)
	
	jal partage			#partage(T, Bas, Haut)
	or $s0, $zero, $v0		#$s0 = partage(T, Bas, Haut)
	
	or $s1, $zero, $a2		#$s1 = Haut
	
	addi $a2, $s0, -1		#$a2 = $s0 - 1
	jal quickSort			#quickSort(T, Bas, $a2)
	
	addi $a1, $s0, 1		#$a1 = $s0 + 1
	or $a2, $zero, $s1		#$a2 = Haut
	jal quickSort			#quickSort(T, $a1, Haut)
endQuickSort:				#end if
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	addi $sp, $sp, 20		#dépile args + ra
	jr $ra
		
partage:
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)			#empile les arguments + ra
	mul $s0, $a1, 4			#$s0 = $a1 * 4
	add $s0, $s0, $a0		#$s0 += $a0
	lw $s0, ($s0)			#$s0 = Mem[$s0] -> $s0 = T[$a1 * 4]
forLoop:
	while:
		mul $t1, $a2, 4			#$t1 = $a2 * 4
		add $t1, $t1, $a0		#$t1 += $a0
		lw $t1, ($t1)			#$t1 = T[$a2 * 4] -> T[Haut]
	
		slt $t2, $a1, $a2	#$t2 = $a1 < $a2 -> $t2 = Bas < Haut
		beq $t2, $zero, endWhile#if(Bas >= Haut) break;
		slt $t2, $t1, $s0	#$t2 = $t1 < $s0 -> T[Haut] < ElementChoisi
		bne $t2, $zero, endWhile#if(T[Haut] < ElementChoisi) break;
		addi $a2, $a2, -1	#--$a2 -> --Haut
		j while
	endWhile:
	
	slt $t2, $a1, $a2		#$t2 = $a1 < $a2 -> $t1 = Bas < Haut
	beq $t2, $zero, endForLoop	#if(!$t2) break; -> if(Bas >= Haut) break;
	
	mul $t0, $a1, 4			#$t0 = $a1 * 4
	add $t0, $t0, $a0		#$t0 += $a0
	sw $t1, ($t0)			#T[Bas] = T[Haut]
	addi $a1, $a1, 1		#++$a1 -> ++Bas
	
	while2:
		mul $t1, $a1, 4		#$t1 = $a1 * 4
		add $t1, $t1, $a0	#$t1 += $a0
		lw $t1, ($t1)		#$t1 = T[$a1 * 4] -> T[Bas]
		
		slt $t2, $a1, $a2	 #$t2 = $a1 < $a2 -> $t2 = Bas < Haut
		beq $t2, $zero, endWhile2#if(Bas >= Haut) break;
		slt $t2, $s0, $t1	 #$t2 = $s0 < $t1 -> ElementChoisi < T[Bas]
		bne $t2, $zero, endWhile2#if(ElementChoisi < T[Bas]) break;
		addi $a1, $a1, 1	 #++$a1 -> ++Bas
		j while2
	endWhile2:
	
	slt $t2, $a1, $a2		#$t2 = $a1 < $a2 -> $t1 = Bas < Haut
	beq $t2, $zero, endForLoop	#if(!$t2) break; -> if(Bas >= Haut) break;
	
	mul $t0, $a2, 4			#$t0 = $a2 * 4
	add $t0, $t0, $a0		#$t0 += $a0
	sw $t1, ($t0)			#T[Haut] = T[Bas]
	addi $a2, $a2, -1		#--$a2 -> --Haut
j forLoop
endForLoop:
	mul $t0, $a2, 4			#$t0 = Haut * 4
	add $t0, $t0, $a0		#$t0 += Haut + T
	sw $s0, ($t0)			#T[Haut] = ElementChoisi
	lw $ra, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12		#dépile args + ra
	or $v0, $a2, $zero		#$v0 = Haut
	jr $ra				#return Haut
