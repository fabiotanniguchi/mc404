@ desafio3.s - Subrotina para inserir um campo numa palavra de 32 bits sem alterar os outros bits da palavra
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Exercicio Desafio 03

.syntax unified

.data
.align 2

@ formato de exibicao da sequencia
output_msg:	.asciz "Depois: %08X\n"
debugmsg:	.asciz "Passou\n"

.align 2
.text
.global	main

main:
    	push {lr}

	ldr r1, =0xFFFFFFF0
	ldr r2, =0xFFFFFFFF
	mov r3, 0
	mov r4, 4

	bl insinwd

	ldr r0, =output_msg
	bl printf

exit: 	pop {pc}


@********************************************************************
insinwd:
	@ insere um campo numa palavra de 32 bits sem alterar os outros bits da palavra
	@ r1 - endereco da palavra
	@ r2 - contem o campo a ser inserido
	@ r3 - bit onde começa a inserção (0-31)
	@ r4 - número de bits a serem inseridos

	push {lr}

	@ zerar em r0 os bits que serao alterados
	ldr r5, =0xFFFFFFFF	@ mascara

	mov r6, 32		@ r5 = numero de bits a deslocar para esquerda
	sub r6, r4
	sub r6, r3
	lsl r5, r4

	add r6, r3
	lsr r5, r6

	eor r5, 0xFFFFFFFF	@ inverte a mascara

	and r1, r5

	@ zerar em r1 os bits que nao participam da insercao
	eor r5, 0xFFFFFFFF	@ inverte a mascara
	and r2, r5

	@ colocar r2 em r1
	orr r1, r2

	pop {pc}
@********************************************************************

.end

