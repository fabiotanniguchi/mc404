@ cron.s - Implementacao de um relogio digital/cronometro
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 06

.syntax unified

.data
.align 2

.equ N, 32

@ formato de exibicao da sequencia
character:	.asciz "%c"
pula_linha:	.asciz "\n"

@ hora inicial do relogio "23:59:48"
hora_inicial:	.word 	50,51,58,53,57,58,52,56,0

.text
.align 2
.global	main

main:
    	push {lr}

	mov r2, 0
	ldr r0, =hora_inicial

loop:
	add r2, 1
	bl soma1
	bl printhora
	cmp r2, N
	blt loop

exit: 	pop {pc}


@********************************************************************

soma1:
	@ soma 1 a hora passada por parametro
	@ r0 : hora em string

	push {lr}

	ldr r3, [r0, 28]
	cmp r3, 57		@ 9 segundos
	beq somadezenasegundos
	add r3, 1
	str r3, [r0, 28]
	b   fimsoma1

somadezenasegundos:
	mov r3, 48
	str r3, [r0, 28]
	ldr r3, [r0, 24]
	cmp r3, 53		@ 59 segundos
	beq somaminutos
	add r3, 1
	str r3, [r0, 24]
	b   fimsoma1

somaminutos:
	mov r3, 48
	str r3, [r0, 24]
	ldr r3, [r0, 16]
	cmp r3, 57		@ 9 minutos
	beq somadezenaminutos
	add r3, 1
	str r3, [r0, 16]
	b   fimsoma1

somadezenaminutos:
	mov r3, 48
	str r3, [r0, 16]
	ldr r3, [r0, 12]
	cmp r3, 53		@ 59 minutos
	beq somahora
	add r3, 1
	str r3, [r0, 12]
	b   fimsoma1

somahora:
	mov r3, 48
	str r3, [r0, 12]
	ldr r3, [r0, 4]
	cmp r3, 51		@ x3 horas
	beq verificadezena

verificadezena:
	ldr r3, [r0]
	cmp r3, 50		@ 23 horas
	beq zerahora
	
	ldr r3, [r0, 4]
	cmp r3, 57		@ 19 horas
	beq somadezenahoras
	add r3, 1
	str r3, [r0, 4]
	b   fimsoma1

somadezenahoras:
	mov r3, 48
	str r3, [r0, 4]		@ coloca 0 na unidade de horas
	ldr r3, [r0]
	add r3, 1
	str r3, [r0]		@ soma 1 na dezena de horas

zerahora:
	mov r3, 48
	str r3, [r0]
	str r3, [r0, 4]

fimsoma1:
	pop {pc}

@********************************************************************

printhora:
	@ imprime a hora caracter por caracter
	@ pois nao consegui fazer funcionar
	@ o "%s\n"
	@ r0 : hora em string

	push {lr}

	push {r0-r2}	@ guarda os valores originais dos registradores

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 4]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 8]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 12]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 16]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 20]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 24]
	bl printf

	ldr r2, =hora_inicial
	ldr r0, =character
	ldr r1, [r2, 28]
	bl printf

	ldr r0, =pula_linha
	bl printf

	pop {r0-r2}	@ recupera os valores originais dos registradores

	pop {pc}

@********************************************************************

.end

