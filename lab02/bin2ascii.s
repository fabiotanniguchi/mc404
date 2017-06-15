@ bin2ascii.s - Conversao de binario para ASCII
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 02

.syntax unified

.equ NUM, 9

.data
.align	2

@ formato de exibicao da conversao
output_msg:	.asciz "%8s\n"

@ vetor de caracteres que sera usado para exibir o resultado da conversao
res:		.word 0,0,0,0,0,0,0,0,0
		@     1,2,3,4,5,6,7,8,9


.text
.align 2
.global	main

main:
    	push {lr}

@ -----------------------------------------
@ primeiro valor: 1
	@ r1 armazena o valor a ser convertido
	ldr r1, =1

	@ r12 eh o contador para o loop
	mov r12, 0

	@ r11 armazena o valor convertido
	ldr r11,=res

	@ r10 armazena a cabeca do vetor
	mov r10, r11

loop1:
	bl conv
	bl nibble2ascii

	add r12, 1
	cmp r12, 8
	blt loop1

	@ encerra o vetor com 0
	mov r11,0
	mov r1, r10

	ldr r0, =output_msg
	bl  printf

@ -----------------------------------------
@ segundo valor: 4294967295
	@ r1 armazena o valor a ser convertido
	ldr r1, =4294967295

	@ r12 eh o contador para o loop
	mov r12, 0

	@ r11 armazena o valor convertido
	ldr r11,=res

	@ r10 armazena a cabeca do vetor
	mov r10, r11

loop2:
	bl conv
	bl nibble2ascii

	add r12, 1
	cmp r12, 8
	blt loop2

	@ encerra o vetor com 0
	mov r11,0
	mov r1, r10

	ldr r0, =output_msg
    	bl  printf

@ -----------------------------------------
@ terceiro valor: 0x89abcdef
	ldr r1, =0x89abcdef

	@ r12 eh o contador para o loop
	mov r12, 0

	@ r11 armazena o valor convertido
	ldr r11,=res

	@ r10 armazena a cabeca do vetor
	mov r10, r11

loop3:
	bl conv
	bl nibble2ascii

	add r12, 1
	cmp r12, 8
	blt loop3

	@ encerra o vetor com 0
	mov r11, 0
	mov r1, r10

	ldr r0, =output_msg
    	bl  printf

@ -----------------------------------------
@ quarto valor: 0x12345678
	ldr r1, =0x12345678

	@ r12 eh o contador para o loop
	mov r12, 0

	@ r11 armazena o valor convertido
	ldr r11,=res

	@ r10 armazena a cabeca do vetor
	mov r10, r11

loop4:
	bl conv
	bl nibble2ascii

	add r12, 1
	cmp r12, 8
	blt loop4

	@ encerra o vetor com 0
	mov r11, 0
	mov r1, r10

	ldr r0, =output_msg
    	bl  printf

exit: 	pop {pc}			@ Terminate the program


@********************************************************************
conv:
	@ pega o numero em r1 e vai deslocando os bits para separar
	@ um numero de 0 a 16

	@ coloca em r3 o numero para conversao
	lsr r3, r1, 28

	@ prepara r0 para o proximo numero
	lsl r4, r1, 4
	mov r1, r4

	mov	pc,lr

@************************************************************************
nibble2ascii:
	@ pega o numero em r3, transforma em ascii-hex e coloca no
	@ vetor localizado em r11

	cmp r3, 9
	ble menorIgual9
	add r3, 0x07
menorIgual9:
	add r3, 0x30

	strb r3,[r11], 1

	mov pc,lr
	
@************************************************************************

.end

