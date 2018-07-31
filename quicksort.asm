.data
    array: .word 55, 41, 59, 26, 53, 58, 97, 93
    valor_inicio: .word 0
    valor_fim: .word 8
    
.text
    .globl main

main:
    li $a1, 8  # tamanho do array
    la $a0, array
    lw $s1, valor_inicio # inicio
    lw $s2, valor_fim # fim
    subi $s2, $s2, 1
    # pivo = values[(began + end) / 2];
    add $s0, $s1, $s2
    div $s4, $s0, 2
    mflo $a3
    sll $a3, $a3, 2
    lw $s4, array($a3) # pivo
    jal quicksort
    li $v0, 10
    syscall
    
quicksort:
    # i = $t1 menor
    # j = $t2 maior
    move $t1, $1
    move $t2, $s2
    loop_inicio:                 # while(i <= j)
        blt $t1, $t2, enquanto_menor
        j fim_loop_inicio
        enquanto_menor:
            lw $t3, array($t1)
            blt $t3, $t1, incrementaMenor
            j fim_enquanto_menor
        
        incrementaMenor:
            addi $t1, $t1, 1
            j enquanto_menor 
            
        fim_enquanto_menor:
    
    fim_loop_inicio:            # se i for maior que j vem pra cá
        
                
        
         