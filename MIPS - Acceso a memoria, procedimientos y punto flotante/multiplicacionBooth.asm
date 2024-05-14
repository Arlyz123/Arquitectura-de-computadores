.data
M:		.asciiz "\nMultiplicando: "
m:		.asciiz "\nMultiplicador: "
rpta:		.asciiz "\n\nResultado: "
.text
.globl main
main:
    # reserva espacio en la pila
    addi $sp, $sp, -56
    sw $s0, ($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $t0, 28($sp)
    sw $t1, 32($sp)
    sw $t2, 36($sp)

    # inicializacion de variables
    move $s0, $zero
    move $s3, $zero
    move $s4, $zero
    move $s5, $zero
    move $s6, $zero

    # entrada: multiplicador
    li   $v0, 4
    la   $a0, m
    syscall
    li   $v0, 5
    syscall
    move $a0, $v0
    sw   $a0, 40($sp)
    move $s1, $a0

    # entrada: multiplicando
    li   $v0, 4
    la   $a0, m
    syscall
    li   $v0, 5
    syscall
    move $a1, $v0
    sw   $a1, 44($sp)
    move $s2, $a1

_step:
    beq  $s0, 33, exit        # salir si hemos completado 32 iteraciones
    andi $t0, $s1, 1          # obtener el bit menos significativo del multiplicador
    beq  $t0, $zero, x_lsb_0  # si es 0, saltar a x_lsb_0
    j    x_lsb_1              # si es 1, saltar a x_lsb_1

x_lsb_0:
    beq  $s5, $zero, _00      # si s5 es 0, saltar a _00
    j    _01                  # si s5 es 1, saltar a _01
			
x_lsb_1:				
    beq  $s5, $zero, _10	
    j    _11			
_00:
    andi $t0, $s3, 1          # obtener el ultimo bit de la multiplicacion acumulada
    bne  $t0, $zero, v        # si es 1, saltar a v
    srl  $s4, $s4, 1          # desplazar s4 a la derecha (division por 2)
    j    shift                # saltar a shift

_01:
    beq  $s2, -2147483648, _add  # verificar si el multiplicando es -2147483648 (0x80000000)
    add  $s3, $s3, $s2        # sumar el multiplicando a la multiplicacion acumulada
    andi $s5, $s5, 0          # reiniciar s5 a 0
    andi $t0, $s3, 1          # obtener el ultimo bit de la multiplicacion acumulada
    bne  $t0, $zero, v        # si es 1, saltar a v
    srl  $s4, $s4, 1          # desplazar s4 a la derecha (division por 2)
    j    shift                # saltar a shift

_10:
    beq  $s2, -2147483648, _sub  # verificar si el multiplicando es -2147483648 (0x80000000)
    sub  $s3, $s3, $s2        # restar el multiplicando a la multiplicacion acumulada
    ori  $s5, $s5, 1          # establecer s5 a 1
    andi $t0, $s3, 1          # obtener el ultimo bit de la multiplicacion acumulada
    bne  $t0, $zero, v        # si es 1, saltar a v
    srl  $s4, $s4, 1          # desplazar s4 a la derecha (division por 2)
    j    shift                # saltar a shift

_11:
    andi $t0, $s3, 1          # obtener el ultimo bit de la multiplicacion acumulada
    bne  $t0, $zero, v        # si es 1, saltar a v
    srl  $s4, $s4, 1          # desplazar s4 a la derecha (division por 2)
    j    shift                # saltar a shift

v:
    andi $t0, $s4, 0x80000000  # verificar el bit mas significativo de s4
    bne  $t0, $zero, v_msb_1   # si es 1, saltar a v_msb_1
    srl  $s4, $s4, 1           # desplazar s4 a la derecha (division por 2)
    ori  $s4, $s4, 0x80000000  # establecer el bit mas significativo de s4 a 1
    j    shift                 # saltar a shift

v_msb_1:
    srl  $s4, $s4, 1           # desplazar s4 a la derecha (division por 2)
    ori  $s4, $s4, 0x80000000  # establecer el bit mas significativo de s4 a 1
    j    shift                 # saltar a shift

shift:
    sra  $s3, $s3, 1           # desplazar s3 a la derecha (aritmetico, mantiene el signo)
    ror  $s1, $s1, 1           # rotar el multiplicador a la derecha
    addi $s0, $s0, 1           # incrementar contador de iteraciones
    beq  $s0, 32, save         # si hemos completado 32 iteraciones, guardar resultado
    j    _step                 # volver a _step para la siguiente iteracion

save:
    add  $t1, $zero, $s3       # guardar resultado en $t1
    add  $t2, $zero, $s4       # guardar residuo en $t2
    j    _step                 # volver a _step para la siguiente iteracion

_add:
    addu $s3, $s3, $s2         # sumar el multiplicando a la multiplicacion acumulada
    ori  $s6, $s6, 1           # establecer s6 a 1 (indicando suma)
    andi $s5, $s5, 0           # reiniciar s5 a 0
    andi $t0, $s3, 1           # obtener el ultimo bit de la multiplicacion acumulada
    bne  $t0, $zero, v         # si es 1, saltar a v
    srl  $s4, $s4, 1           # desplazar s4 a la derecha (division por 2)
    j    shift_special         # saltar a shift_special

_sub:
    subu $s3, $s3, $s2         # restar el multiplicando a la multiplicacion acumulada
    andi $s6, $s6, 0           # establecer s6 a 0 (indicando resta)
    ori  $s5, $s5, 1           # establecer s5 a 1
    andi $t0, $s3, 1           # obtener el ultimo bit de la multiplicacion acumulada
    bne  $t0, $zero, v         # si es 1, saltar a v
    srl  $s4, $s4, 1           # desplazar s4 a la derecha (division por 2)
    j    shift_special         # saltar a shift_special

shift_special:
    beq  $s6, $zero, n_0       # si s6 es 0, saltar a n_0
    sra  $s3, $s3, 1           # desplazar s3 a la derecha (aritmetico, mantiene el signo)
    ror  $s1, $s1, 1           # rotar el multiplicador a la derecha
    addi $s0, $s0, 1           # incrementar contador de iteraciones
    beq  $s0, 32, save         # si hemos completado 32 iteraciones, guardar resultado
    j    _step                 # volver a _step para la siguiente iteracion

n_0:
    srl  $s3, $s3, 1           # desplazar s3 a la derecha (logico, rellena con ceros)
    ror  $s1, $s1, 1           # rotar el multiplicador a la derecha
    addi $s0, $s0, 1           # incrementar contador de iteraciones
    beq  $s0, 32, save         # si hemos completado 32 iteraciones, guardar resultado
    j    _step                 # volver a _step para la siguiente iteracion

exit:
    # impresion del resultado
    move $v0, $t1              # cargar resultado en $v0 para impresion
    sw   $v0, 48($sp)          # guardar resultado en la pila
    move $v1, $t2              # cargar residuo en $v1 para impresion
    sw   $v1, 52($sp)          # guardar residuo en la pila
    li   $v0, 4                # llamada al sistema para imprimir cadena
    la   $a0, rpta
    syscall

    # restaurar registros y liberar espacio en la pila
    lw $s0, ($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    lw $t0, 28($sp)
    lw $t1, 32($sp)
    lw $t2, 36($sp)
    lw $a0, 40($sp)
    lw $a1, 44($sp)
    addi $sp, $sp, 56          # liberar espacio en la pila

    # llamada al sistema para imprimir resultado
    li   $v0, 35
    syscall
    li   $v0, 35
    syscall

    # salida del programa
    li   $v0, 10
    syscall