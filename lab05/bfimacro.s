@ bfimacro.s - Macro para emular a instrução bfi
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 05

.syntax unified

.data
.align 2

palavra:	.word 0xaabbccdd
outputmsg:	.asciz "%08x\n"

.equ s0, 0
.equ s4, 4
.equ s8, 8
.equ s12, 12
.equ s16, 16
.equ s20, 20
.equ s24, 24

.align 2
.text
.global	main

.macro bfimacro addr, field, sbit, nbits
	lsl \field, \sbit

	@ (32-\nbits)
	mov r8, 32
	sub r8, \nbits

	@ (32-\nbits-\sbit)
	mov r9, 32
	sub r9, \nbits
	sub r9, \sbit

	ldr r6, =0xffffffff	@ mask para palavra
	lsr r6, \sbit
	lsl r6, r8
	lsr r6, r9

	mov r7, r6		@ mask para campo
	and \field, r7

	ldr r12, =0xffffffff
	eor r6, r12		@ inverte a mascara
	and \addr, r6

	orr \addr, \field	@ insere campo na palavra
.endm

main:
    	push {lr}

	ldr r5, =palavra

	@ ------------------------------
	@ addr em r1
	@ sbit em r2
	@ nbits em r3
	@ field em r4
	@ ------------------------------

	ldr r1, [r5]
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s0
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s4
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s8
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s12
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s16
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s20
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

	ldr r1, [r5]
	mov r2, s24
	mov r3, 8
	ldr r4, =0x9abcdf33
	bfimacro r1, r4, r2, r3
	ldr r0, =outputmsg
	bl printf

exit: 	pop {pc}

.end

