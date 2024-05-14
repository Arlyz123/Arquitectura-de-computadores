.data
msm_bs: .asciiz "Ingrese la base: "
msm_exp: .asciiz "Ingrese el exponente: "
msm_rpta: .asciiz "El resultado es: "

.text
.globl _main
.globl _pot  # definir etiqueta global para el procedimiento

_main:
    # guardar algunos datos en la pila
    li $t0, 101
    li $t1, 111
    li $t2, 131
    li $t3, 141
    addi $sp, $sp, -24
    sw $t0, ($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)

    # lectura de base desde la entrada estandar
    li $v0, 4             # cargar el servicio para imprimir cadena
    la $a0, msm_bs        # cargar la direccion de la cadena "Ingrese la base: "
    syscall               # llamar al servicio para imprimir la cadena
    li $v0, 5             # cargar el servicio para leer un entero
    syscall               # llamar al servicio para leer el entero
    move $a0, $v0         # mover el entero leido a $a0 (base)
    sw $a0, 16($sp)       # guardar la base en la pila
    move $t0, $a0         # almacenar la base en $t0

    # lectura de exponente desde la entrada estandar
    li $v0, 4             # cargar el servicio para imprimir cadena
    la $a0, msm_exp       # cargar la direccion de la cadena "Ingrese el exponente: "
    syscall               # llamar al servicio para imprimir la cadena
    li $v0, 5             # cargar el servicio para leer un entero
    syscall               # llamar al servicio para leer el entero
    move $a1, $v0         # mover el entero leido a $a1 (exponente)
    sw $a1, 20($sp)       # guardar el exponente en la pila
    move $t1, $a1         # almacenar el exponente en $t1

    # llamar al procedimiento para calcular la potencia (_pot)
    jal _pot               # llamar al procedimiento de potencia
    sw $v0, 24($sp)       # guardar el resultado en la pila

    # imprimir el resultado
    li $v0, 4             # cargar el servicio para imprimir cadena
    la $a0, msm_rpta       # cargar la direccion de la cadena "El resultado es: "
    syscall               # llamar al servicio para imprimir la cadena

    # restaurar los valores de la pila a sus respectivas variables
    lw $t0, ($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $a0, 16($sp)
    lw $a1, 20($sp)
    lw $v0, 24($sp)

    # liberar espacio en la pila antes de salir
    addi $sp, $sp, 24

    # imprimir el resultado final
    move $a0, $v0         # mover el resultado a $a0
    li $v0, 1             # cargar el servicio para imprimir entero
    syscall               # llamar al servicio para imprimir el resultado

    # salir del programa
    li $v0, 10            # cargar el servicio para salir del programa
    syscall               # llamar al servicio para salir

# procedimiento para calcular la potencia (_pot)
_pot:
    li $t2, 0              # inicializar contador (i)
    li $t3, 1              # inicializar el resultado (res)
loop_pot:
    bge $t2, $t1, break_loop  # salir del bucle si i >= exponente
    mul $t3, $t3, $t0         # multiplicar res por la base
    addi $t2, $t2, 1          # incrementar el contador (i)
    j loop_pot                 # volver al inicio del bucle
break_loop:
    move $v0, $t3             # mover el resultado a $v0 (valor de retorno)
    jr $ra                    # retornar al llamador (_main)
