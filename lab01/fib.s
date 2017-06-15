@ fib.s - Calculo do Fibonacci ate 1000
@ Fabio Takahashi Tanniguchi - RA 145980
@ MC404C - 2s2015 - Atividade 01

.syntax unified
.align 2
.text
fib_msg:    .asciz "%10d\n"
.align 2
.global	main
main:
    	push {lr}

	@ vou imprimir os dois primeiros numeros de Fibonacci, que sao 1
	mov r1, 1
    	ldr r0, =fib_msg
    	bl  printf

	mov r1, 1
    	ldr r0, =fib_msg
    	bl  printf

	@ os dois Fibonaccis serao armazenados em r4 e r5
	mov r4, 1
	mov r5, 1
	
startfibonacci:
	@ calculo de Fibonacci, somando os dois Fibonaccis anteriores
	@ r4 = Fibo(n - 2)
	@ r5 = Fibo(n - 1)
	@ r6 = Fibo(n) = r4 + r5

	mov r6, r4
	add r6, r5

	mov r4, r5
	mov r5, r6

	@ calculo se encerra em 1000
	cmp r5, 1000
	bgt endfibonacci

	mov r1, r5
    	ldr r0, =fib_msg
    	bl  printf

	cmp r5, 1000
	ble startfibonacci
endfibonacci:

exit: 	pop {pc}			@ Terminate the program

.end			@ from here on all lines are commentaries

