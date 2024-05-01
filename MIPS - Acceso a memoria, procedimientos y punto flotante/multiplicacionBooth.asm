.data
mensajeBase: .asciiz "Ingrese la base: "
mensajeExponente: .asciiz "Ingrese el exponente: "
mensajeError: .asciiz "Error: La base no puede ser negativa.\n"

.text
.globl main

main:
    # imprimir el mensaje de solicitud para la base
    li $v0, 4
    la $a0, mensajeBase
    syscall

    # leer la base
    li $v0, 5
    syscall
    move $t0, $v0   # guardar la base en $t0

    # verificar si la base es negativa
    bltz $t0, errorBase

    # imprimir el mensaje de solicitud para el exponente
    li $v0, 4
    la $a0, mensajeExponente
    syscall

    # leer el exponente
    li $v0, 5
    syscall
    move $t1, $v0   # guardar el exponente en $t1

    # llamar a la función para calcular la potencia
    jal calcularPotencia

    # imprimir el resultado
    move $a0, $v0
    li $v0, 1
    syscall

    # salir del programa
    li $v0, 10
    syscall

errorBase:
    # imprimir el mensaje de error
    li $v0, 4
    la $a0, mensajeError
    syscall

    # salir del programa con error
    li $v0, 10
    syscall

calcularPotencia:
    # inicializar el resultado a 1
    li $v0, 1       # $v0 = resultado inicial (1)

    # multiplicar la base por sí misma según el exponente
    move $t2, $t0   # $t2 = base ($t0)
    move $t3, $t1   # $t3 = exponente ($t1)

    buclePotencia:
        beqz $t3, finBucle   # salir del bucle si exponente es 0
        mul $v0, $v0, $t2    # multiplicar resultado por la base
        subu $t3, $t3, 1     # decrementar el exponente
        j buclePotencia

    finBucle:
        jr $ra   # retornar

