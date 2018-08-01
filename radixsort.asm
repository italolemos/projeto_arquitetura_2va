.data
     array: .word 1, 4, 5, 6, 7, 0, 8, 2, 9, 3
     array_tamanho: .word 10

.text 
.globl main

main:
    jal imprimir_array
    
    li $v0, 10
    syscall 

imprimir_array:
    la $a1, array
    li $t1, 0      		# contador
    lw $t2, array_tamanho 	# tamanho do array
    loop:
        beq $t1, $t2, exit
        
        sll $t3, $t1, 2         # i * 4
        lw $a0, array($t3)
        li $v0, 1
        syscall
        

        addi $t1, $t1, 1	# incrementa contador
        
        j loop
    exit:
        jr $ra