	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_mul32
	.type		bs3_mul32, %function
	// void bs3_mul32(int *h, int *f, int *g); 
bs3_mul32:
	push	{r4-r11,lr}
	ldr	r4, [r1], #4
	ldr	r5, [r1], #4
	ldr	r6, [r2], #4
	ldr	r7, [r2], #4
	and	r8, r4, r6, ASR #31
	eor	r9, r5, r7, ASR #31
	and	r9, r9, r8
	lsls	r6, r6, #1
	lsls	r7, r7, #1
	ubfx	r10, r8, #31, #1
	ubfx	r11, r9, #31, #1
	and	r12, r4, r6, ASR #31
	eor	r14, r5, r7, ASR #31
	ands	r14, r14, r12
	eor	r9, r12, r9, LSL #1
	eor	r12, r12, r8, LSL #1
	eor	r8, r14, r8, LSL #1
	eors	r14, r14, r9
	ands	r9, r9, r8
	orrs	r8, r12, r14
	mov	r3, #30
bs3_mul32_0:
	lsls	r6, r6, #1
	lsls	r7, r7, #1
	ands	r12, r4, r6, ASR #31
	eors	r14, r5, r7, ASR #31
	ands	r14, r14, r12
	eors	r9, r12, r9, LSL #1
	adc	r11, r11, r11	// RLX
	eors	r12, r12, r8, LSL #1
	adc	r10, r10, r10	// RLX
	eor	r8, r14, r8, LSL #1
	eors	r14, r14, r9
	ands	r9, r9, r8
	orrs	r8, r12, r14
	subs	r3, #1
	bne	bs3_mul32_0
	stm	r0!, {r8-r11}
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
