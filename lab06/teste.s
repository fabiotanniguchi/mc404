.syntax unified

.data
.align 2

@ formato de exibicao da sequencia
output_msg:	.asciz "%s\n"
character:	.asciz "%c"
pula_linha:	.asciz "\n"

@ hora inicial do relogio "23:59:48"
hora_inicial:	.word 	'2','3',':','5','9',':','4','8',0

.align 2
.text
.global	main

main:
    	push {lr}


	mov r11, 0

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 4]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 8]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 12]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 16]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 20]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 24]
	bl printf

	ldr r0, =character
	ldr r12, =hora_inicial
	ldr r1, [r12, 28]
	bl printf

exit: 	pop {pc}

.end

