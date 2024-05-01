.data
mensajeSolicitud: .asciiz "Ingrese base y exponente: "
    
.text
.globl main

main:
    # imprimir el mensaje de solicitud
    li $v0, 4
    la $a0, mensajeSolicitud
    syscall

    # leer la base
    li $v0, 5
    syscall
    move $a0, $v0

    # leer el exponente
    li $v0, 5
    syscall
    move $a1, $v0

    # llamar a la función calcularPotencia
    jal calcularPotencia

    # imprimir el resultado
    move $a0, $v0
    li $v0, 1
    syscall

    # salir
    li $v0, 10
    syscall

calcularPotencia:
    # guardar los registros en la pila
    subu $sp, $sp, 8
    sw $ra, 4($sp)
    sw $fp, 0($sp)
    addu $fp, $sp, 8

    # verificar si el exponente es cero
    beqz $a1, fin

    # inicializar el resultado a 1
    li $v0, 1

bucle:
    # multiplicar el resultado por la base
    mul $v0, $v0, $a0

    # decrementar el exponente
    subu $a1, $a1, 1

    # verificar si el exponente es cero
    bnez $a1, bucle

fin:
    # restaurar los registros de la pila
    lw $ra, 4($sp)
    lw $fp, 0($sp)
    addu $sp, $sp, 8

    # retornar
    jr $ra
