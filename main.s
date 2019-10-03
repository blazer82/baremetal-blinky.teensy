	.cpu cortex-m3
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L2
	movs	r2, #5
	str	r2, [r3, #328]
	ldr	r3, .L2
	movs	r2, #56
	str	r2, [r3, #824]
	ldr	r3, .L2+4
	mov	r2, #-1
	str	r2, [r3, #108]
	ldr	r3, .L2+8
	ldr	r3, [r3, #4]
	ldr	r2, .L2+8
	orr	r3, r3, #8
	str	r3, [r2, #4]
	ldr	r3, .L2+8
	movs	r2, #8
	str	r2, [r3, #132]
	nop
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L3:
	.align	2
.L2:
	.word	1075806208
	.word	1074446336
	.word	1107312640
	.size	main, .-main
	.ident	"GCC: (GNU Tools for Arm Embedded Processors 7-2017-q4-major) 7.2.1 20170904 (release) [ARM/embedded-7-branch revision 255204]"
