.syntax unified

.data
.align 2

.equ NBITS, 8
.equ SBIT, 0

outputmsg:	.asciz "%08x %08x\n"

.align 2
.text
.global	main

main:
    	push {lr}

	ldr r3, =0xaabbccdd
	ldr r4, =0x9abcdf33

	lsl r4, SBIT

	ldr r1, =0xffffffff	@ mask1 para addr
	ldr r2, =0xffffffff	@ mask2 para field

	mov r8, 32
	sub r8, NBITS

	mov r9, 32
	sub r9, NBITS
	sub r9, SBIT

	lsr r1, SBIT
	lsl r1, r8	@ (32-\nbits)
	lsr r1, r9	@ (32-\nbits-\sbit)
	eor r1, 0xffffffff

	lsr r2, SBIT
	lsl r2, r8	@ (32-\nbits)
	lsr r2, r9	@ (32-\nbits-\sbit)

	and r3, r1
	and r4, r2

	mov r1, r3
	mov r2, r4

	@orr r1, r2

	ldr r0, =outputmsg
	bl printf

exit: 	pop {pc}

.end

