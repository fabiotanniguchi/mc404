@ test.s - Relogio digital/cronometro integrado a um simulador jarm
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 07

@ modos de interrupção no registrador de status
	.set IRQ_MODE,0x12
	.set USER_MODE,0x10

@ flag para habilitar interrupções externas no registrador de status
	.set IRQ, 0x80

@enderecos dispositivos
	.set TIMER,       0x90008

	.set DISPLAY,	   0x90000	@ dezena de hora
	.set DISPLAY2,     0x90010	@ unidade de hora
	.set DISPLAY3,     0x90020	@ separador
	.set DISPLAY4,     0x90030	@ dezena de minuto
	.set DISPLAY5,     0x90040	@ unidade de minuto
	.set DISPLAY6,     0x90050	@ separador
	.set DISPLAY7,     0x90060	@ dezena de segundo
	.set DISPLAY8,     0x90070	@ unidade de segundo

	.set BTN_ON_OFF,  0x90004	@ botao on-off
	.set BTN_RESTART,  0x90084	@ botao de reset
@ constantes
	.set INTERVAL,1000
	.set BIT_READY,1
	
@ vetor de interrupções
	.org  7*4               @ preenche apenas uma posição do vetor,
	                        @ correspondente ao tipo 6
	b       tratador_timer

	.org 0x1000
_start:
	mov	sp,#0x400	@ seta pilha do modo supervisor
	mov	r0,#IRQ_MODE	@ coloca processador no modo IRQ (interrupção externa)
	msr	cpsr,r0		@ processador agora no modo IRQ
	mov	sp,#0x300	@ seta pilha de interrupção IRQ
	mov	r0,#USER_MODE	@ coloca processador no modo usuário
	bic     r0,r0,#IRQ      @ interrupções IRQ habilitadas
	msr	cpsr,r0		@ processador agora no modo usuário
	mov	sp,#0x10000	@ pilha do usuário no final da memória 

	bl	troca_display	@ seta a hora inicial

loop_off:
	ldr	r1,=BTN_RESTART
	ldr	r0,[r1]         @ verifica botao reset
	cmp	r0,#BIT_READY   @ foi pressionado?
	beq	restart
	ldr	r1,=BTN_ON_OFF
	ldr	r0,[r1]         @ verifica botao liga
	cmp	r0,#BIT_READY   @ foi pressionado?
	bne	loop_off        @ se nao foi, continua
liga:	
	ldr	r0,=INTERVAL    @ liga timer
	ldr	r6,=TIMER
	str  	r0,[r6]		@ seta timer
loop_on:
	ldr	r1,=BTN_RESTART
	ldr	r0,[r1]         @ verifica botao reset
	cmp	r0,#BIT_READY   @ foi pressionado?
	beq	restart
	ldr	r1,=BTN_ON_OFF
	ldr	r0,[r1]         @ verifica botao liga
	cmp	r0,#BIT_READY   @ foi desligado?
	bne     desliga
	ldr	r1,=flag        @ continua ligado, verifica flag
	ldr	r0,[r1]
	cmp	r0,#0           @ timer ligou a flag?
	beq	loop_on         @ nao, entao continua
	mov	r0,#0		@ reseta flag
	str	r0,[r1]
	@ aqui conta
	bl	soma1		@ soma 1 a hora
	bl	troca_display	@ aplica o novo horario aos displays
	b	loop_on
desliga:	
	mov	r0,#0           @ desliga timer
	ldr	r6,=TIMER
	str  	r0,[r6]		@ seta timer 
	b       loop_off

flag:
     .word 0
status:
     .word 0
digitos:
     .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b

@ hora inicial do relogio "23:59:48"
hora_inicial:	.word 	50,51,58,53,57,58,52,56,0

printdigito:	.asciz	"%d\n"

@********************************************************************

@ tratador da interrupcao	
@ aqui quando timer expirou
	.align 4
tratador_timer:
	ldr	r7,=flag	@ apenas liga a flag
	mov	r8,#1
	str	r8,[r7]
	movs	pc,lr		@ e retorna


@********************************************************************

soma1:
	@ soma 1 a hora passada por parametro
	@ r5 : hora em string

	push {lr}

	ldr r5, =hora_inicial	

	ldr r3, [r5, #28]
	cmp r3, #57		@ 9 segundos
	beq somadezenasegundos
	add r3, #1
	str r3, [r5, #28]
	b   fimsoma1

somadezenasegundos:
	mov r3, #48
	str r3, [r5, #28]
	ldr r3, [r5, #24]
	cmp r3, #53		@ 59 segundos
	beq somaminutos
	add r3, #1
	str r3, [r5, #24]
	b   fimsoma1

somaminutos:
	mov r3, #48
	str r3, [r5, #24]
	ldr r3, [r5, #16]
	cmp r3, #57		@ 9 minutos
	beq somadezenaminutos
	add r3, #1
	str r3, [r5, #16]
	b   fimsoma1

somadezenaminutos:
	mov r3, #48
	str r3, [r5, #16]
	ldr r3, [r5, #12]
	cmp r3, #53		@ 59 minutos
	beq somahora
	add r3, #1
	str r3, [r5, #12]
	b   fimsoma1

somahora:
	mov r3, #48
	str r3, [r5, #12]
	ldr r3, [r5, #4]
	cmp r3, #51		@ x3 horas
	beq verificadezena

verificadezena:
	ldr r3, [r5]
	cmp r3, #50		@ 23 horas
	beq zerahora
	
	ldr r3, [r5, #4]
	cmp r3, #57		@ 19 horas
	beq somadezenahoras
	add r3, #1
	str r3, [r5, #4]
	b   fimsoma1

somadezenahoras:
	mov r3, #48
	str r3, [r5, #4]	@ coloca 0 na unidade de horas
	ldr r3, [r5]
	add r3, #1
	str r3, [r5]		@ soma 1 na dezena de horas

zerahora:
	mov r3, #48
	str r3, [r5]
	str r3, [r5, #4]

fimsoma1:
	pop {pc}

@********************************************************************

troca_display:
	@ troca a hora nos displays

	push {lr}

	ldr r5, =hora_inicial
	mov r10, #0x80
	ldr r11, =digitos

	ldr r6, [r5]
	sub r6, #48
	ldr r7, =DISPLAY
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r6, [r5, #4]
	sub r6, #48
	ldr r7, =DISPLAY2
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r7, =DISPLAY3
	str r10, [r7]

	ldr r6, [r5, #12]
	sub r6, #48
	ldr r7, =DISPLAY4
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r6, [r5, #16]
	sub r6, #48
	ldr r7, =DISPLAY5
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r7, =DISPLAY6
	str r10, [r7]

	ldr r6, [r5, #24]
	sub r6, #48
	ldr r7, =DISPLAY7
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r6, [r5, #28]
	sub r6, #48
	ldr r7, =DISPLAY8
	ldrb r8, [r11, r6]
	strb r8, [r7]

	pop {pc}

@********************************************************************

restart:
	@ reseta a hora e aplica nos displays

	push {lr}

	ldr r5, =hora_inicial
	mov r10, #0x80
	ldr r11, =digitos

	mov r6, #50
	str r6, [r5]
	sub r6, #48
	ldr r7, =DISPLAY
	ldrb r8, [r11, r6]
	strb r8, [r7]

	mov r6, #51
	str r6, [r5, #4]
	sub r6, #48
	ldr r7, =DISPLAY2
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r7, =DISPLAY3
	str r10, [r7]

	mov r6, #53
	str r6, [r5, #12]
	sub r6, #48
	ldr r7, =DISPLAY4
	ldrb r8, [r11, r6]
	strb r8, [r7]

	mov r6, #57
	str r6, [r5, #16]
	sub r6, #48
	ldr r7, =DISPLAY5
	ldrb r8, [r11, r6]
	strb r8, [r7]

	ldr r7, =DISPLAY6
	str r10, [r7]

	mov r6, #52
	str r6, [r5, #24]
	sub r6, #48
	ldr r7, =DISPLAY7
	ldrb r8, [r11, r6]
	strb r8, [r7]

	mov r6, #56
	str r6, [r5, #28]
	sub r6, #48
	ldr r7, =DISPLAY8
	ldrb r8, [r11, r6]
	strb r8, [r7]

	pop {pc}

@********************************************************************

