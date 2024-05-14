.data
m:      .asciiz "\nmultiplicando: "
m:      .asciiz "\nmultiplicador: "
rpta:   .asciiz "\n\nresultado: "

.text
.globl main
main:
    # reserva espacio en la pila para almacenar registros
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

    # inicializacion de registros
    move $s0, $zero
    move $s3, $zero
    move $s4, $zero
    move $s5, $zero
    move $s6, $zero

    # solicitar y almacenar el multiplicador
    li   $v0, 4           # cargar el servicio de impresion de cadena
    la   $a0, m           # cargar la cadena "multiplicador: "
    syscall
    li   $v0, 5           # cargar el servicio de entrada de entero
    syscall
    move $a0, $v0         # almacenar el multiplicador en $a0
    sw $a0, 40($sp)       # guardar el multiplicador en la pila
    move $s1, $a0         # almacenar el multiplicador en $s1

    # solicitar y almacenar el multiplicando
    li   $v0, 4           # cargar el servicio de impresion de cadena
    la   $a0, M           # cargar la cadena "multiplicando: "
    syscall
    li   $v0, 5           # cargar el servicio de entrada de entero
    syscall
    move $a1, $v0         # almacenar el multiplicando en $a1
    sw $a1, 44($sp)       # guardar el multiplicando en la pila
    move $s2, $a1         # almacenar el multiplicando en $s2

    # bucle principal de multiplicacion
_step:
    # verificar si se han procesado todos los bits del multiplicador
    beq  $s0, 32, save    # salir del bucle si se han procesado 32 bits

    # determinar el bit menos significativo (LSB) del multiplicador
    andi $t0, $s1, 1      # obtener el LSB del multiplicador

    # logica para decidir las operaciones en funcion del LSB
    ...

    # incrementar el contador de bits procesados
    addi $s0, $s0, 1      # incrementar el contador de bits

    # volver al inicio del bucle
    j _step

save:
    # guardar el resultado en $t1 y $t2
    add  $t1, $zero, $s3  # copiar $s3 al registro $t1
    add  $t2, $zero, $s4  # copiar $s4 al registro $t2

    # mostrar el resultado final
    ...

    # recuperar registros y liberar espacio en la pila
    ...

    # salir del programa
    li   $v0, 10          # cargar el servicio de salida
    syscall
