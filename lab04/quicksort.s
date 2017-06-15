@ quicksort.s - Traducao do QuickSort para Assembly
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 04

.syntax unified

.data
.align 2

randomnumber	.req r0
number2print	.req r1
temp		.req r2
temp2		.req r3
array		.req r4
l		.req r5
r 		.req r6
i		.req r7
j		.req r8
w		.req r9
x		.req r10
y	 	.req r11
z		.req r12

.equ N, 32

vetor:
	.rept N
		.word 0
	.endr
	.word 0
fimvetor:

output_msg:	.asciz "%08x\n"
pula_linha:	.asciz "\n"

.align 2
.text
.global	main

main:
    	push {lr}

	ldr array, =vetor

	mov i, 0
preenchevetor:					@ for (0..31)
	add i, 1
	bl  rand
	str randomnumber, [array], 4		@ array[i] = rand()
	cmp i, N
	blt preenchevetor

	ldr array, =vetor			@ restabelece o apontador para o inicio do vetor

	mov l, 1
	mov r, N
	bl  sort				@ sort(1,N,array)

	bl  showarray				@ showarray(array)

exit: 	pop {pc}

@********************************************************************
sort:
	@ realiza o quicksort
	@ limites left e right devem estar em l e r

	push {lr}

	mov i, l		@ i = l
	mov j, r		@ j = r

	mov y, 2
	add x, l, r
	udiv x, y

	mov y, 4
	mul y, x
	sub y, 4
	ldr x, [array, y]	@ x = a[ (l + r) / 2 ]

dowhile:	@ marcacao do inicio do do-while

while1:
	mov y, 4
	mul y, i
	sub y, 4
	ldr z, [array, y]
	cmp z, x
	bge while2		@ while (a[i] < x)

	add i, 1		@ i++
	b   while1

while2:
	mov y, 4
	mul y, j
	sub y, 4
	ldr z, [array, y]
	cmp x, z
	bge if1			@ while (x < a[j])

	sub j, 1		@ j--
	b   while2

if1:
	cmp i, j
	bgt fimif1		@ if (i<=j)

	@ troca a[i] com a[j]
	mov y, 4
	mul y, i
	sub y, 4
	ldr temp, [array, y]

	mov z, 4
	mul z, j
	sub z, 4
	ldr temp2, [array, z]

	str temp2, [array, y]	@ a[i] = a[j]
	str temp,  [array, z]	@ a[j] = a[i]

	add i, 1		@ i++
	sub j, 1		@ j--

fimif1:
	cmp i, j		@ do-while( i <= j )
	ble dowhile
	
ifexterno1:
	push {l, r, i, j}	@ guardo l, r, i, j para reutilizar na proxima chamada recursiva
	cmp l, j		@ if (l < j)
	bge ifexterno2

	mov r, j
	bl  sort		@ sort(l, j, a)

ifexterno2:
	pop {l, r, i, j}	@ recupero l, r, i, j
	cmp i, r		@ if (i < r)
	bge fimsort

	mov l, i
	bl  sort		@ sort(i, r, a)

fimsort:
	pop {pc}

@********************************************************************
showarray:
	@ exibe o array de N valores

	push {lr}

	mov j, 0
loop:					@ for(1..32)
	add j, 1
	ldr r0, =output_msg
	ldr number2print, [array], 4
	bl  printf			@ printf("%08x\n",a[i])
	cmp j, N
	blt loop

	ldr r0, =pula_linha		@ pula linha ao final para passar no SuSy
	bl printf

	pop {pc}

@********************************************************************

.end

