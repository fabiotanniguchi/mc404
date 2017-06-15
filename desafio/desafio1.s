@ listcreate.s - Sequencia de Fibonacci em tempo de montagem
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 03

.syntax unified

.data
.align 2

.equ N,   47
.equ NUM,  1
.equ FIB1, 1
.equ FIB2, 1
.equ FIB3, 0

vetor:
	@ fibo(1)
	.byte NUM
	.word FIB1

	.equ NUM, NUM+1

	@ fibo(2)
	.byte NUM
	.word FIB2

	@ fibo (3...47)
	.rept N-2
		.equ NUM, NUM+1
		.equ FIB3, FIB1+FIB2

		@ guarda o indice e o fibo(NUM) no vetor
		.byte NUM
		.word FIB3

		.equ FIB1, FIB2
		.equ FIB2, FIB3
	.endr
	.word 0
fimvetor:

@ formato de exibicao da sequencia
output_msg:	.asciz "%4d %u\n"

.align 2
.text
.global	main

main:
    	push {lr}

	bl printlist

exit: 	pop {pc}


@********************************************************************
printlist:
	@ pega o vetor de numeros de Fibonacci e imprime na tela
	@ r4 : vetor
	@ r5 : contador para o loop
	@ r1 : byte com o indice do Fibonacci contido em r2
	@ r2 : word com o numero de Fibonacci de indice r1, ou seja, fibo(r1)

	push {lr}

	ldr r4, =vetor

	mov r5, 0
loop:
	add r5, 1

	ldr r0, =output_msg
	ldrb r1, [r4], 1
	ldr  r2, [r4], 4
	bl printf

	cmp r5, N
	blt loop

	pop {pc}
@********************************************************************

.end

