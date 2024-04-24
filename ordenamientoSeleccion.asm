# Inicializa el arreglo A con los elementos [4, 3, 0, 5, 6, 3, 6]
.data
A: .word 4, 3, 0, 5, 6, 3, 6
.text
main:
    # Inicializa i = 0
    li $t0, 0

outer_loop:
    # Verifica si i >= len(A)
    bge $t0, 7, end_outer_loop

    # Inicializa min_idx = i
    move $t1, $t0

    # Inicializa j = i + 1
    addi $t2, $t0, 1

inner_loop:
    # Verifica si j >= len(A)
    bge $t2, 7, end_inner_loop

    # Carga A[min_idx]
    lw $t3, 0($t1)

    # Carga A[j]
    lw $t4, 0($t2)

    # Compara A[min_idx] > A[j]
    bgt $t3, $t4, update_min_idx

    # Si no es mayor, continúa con la siguiente iteración
    addi $t2, $t2, 1
    j inner_loop

update_min_idx:
    # Actualiza min_idx = j
    move $t1, $t2

    # Continúa con la siguiente iteración
    addi $t2, $t2, 1
    j inner_loop

end_inner_loop:
    # Intercambia A[i] y A[min_idx]
    lw $t3, A($t0)
    lw $t4, A($t1)
    sw $t4, A($t0)
    sw $t3, A($t1)

    # Continúa con la siguiente iteración
    addi $t0, $t0, 1
    j outer_loop

end_outer_loop:
    # Finaliza el programa
    li $v0, 10
    syscall
