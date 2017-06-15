.syntax unified
.align 
.text
.global main
main:
    push {ip, lr}
    ldr r0, =Hellomessage
    bl printf
    mov r0, #0
    pop {ip, pc}
Hellomessage: .asciz "Hello World!\n"

