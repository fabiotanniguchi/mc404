@ quicksort.s - Traducao do QuickSort para Assembly
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 04

.syntax unified

.data
.align 2

randomnumber	.req r0
number2print	.req r1
array		.req r6
u		.req r7
v 		.req r8
w		.req r9
x		.req r10
j		.req r11
i	 	.req r12

.equ N, 32

vetor:
	.rept N
		.word 0
	.endr
	.word 0
fimvetor:

output_msg:	.asciz "%08x\n"

.align 2
.text
.global	main

main:
    	push {lr}

	ldr array, =vetor

	@ as linhas a seguir sao equivalentes ao for do main em quicksort.c
	mov i, 0
preenchevetor:
	add i, 1
	bl  rand
	str randomnumber, [array], 4
	cmp i, N
	blt preenchevetor

	@ showarray(array);
	bl  showarray

exit: 	pop {pc}

@********************************************************************
sort:
	@ realiza o quicksort
	@ i contem o limitador left
	@ j contem o limitador right

	push {lr}

	@ x= a[(l+r)/2];
	mov u, 0
	add v, i, j
	mov x, 2
	udiv v, x
	ldr array, =vetor
percorrevetor:
	add u, 1
	ldr x, [array], 4
	bl  printf
	cmp u, v
	bne percorrevetor

dowhile:
	

while1:
	@ IMPLEMENTAR PRIMEIRO WHILE

while2:
	@ IMPLEMENTAR SEGUNDO WHILE

	sub u, j, i
	cmp u, 0
	blt fogedoif

	@ IMPLEMENTAR DENTRO DO IF

fogedoif:

	sub u, j, i
	cmp u, 0
	bgt dowhile

	pop {pc}

@********************************************************************
showarray:
	@ exibe o array de N valores

	push {lr}

	mov j, 0
	ldr array, =vetor
	mov x, 0
loop:
	add j, 1
	ldr r0, =output_msg
	ldr number2print, [array, x]
	add x, 4
	bl  printf
	cmp j, N
	blt loop

	pop {pc}
@********************************************************************

.end

