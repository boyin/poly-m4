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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	stm	r0!, {r8-r11}
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_mul32s
	.type		bs3_mul32s, %function
	// void bs3_mul32s(int *h, int *f, int *g);
bs3_mul32s:
	push	{r4-r11,lr}
	ldr	r4, [r1], #4
	ldr	r5, [r1], #4
	ldr	r6, [r2], #4
	ldr	r7, [r2], #4
	and	r8, r4, r6, ASR #31
	eor	r9, r5, r7, ASR #31
	and	r9, r9, r8
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	lsls	r8, r8, #1
	adc	r9, r9, r9
	lsls	r10, r10, #1
	adc	r11, r11, r11
	stm	r0!, {r8-r11}
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_mul32_negc
	.type		bs3_mul32_negc, %function
	// void bs3_mul32_negc(int *h, int *f, int *g);
bs3_mul32_negc:
	push	{r4-r11,lr}
	ldr	r4, [r1], #4
	ldr	r5, [r1], #4
	ldr	r6, [r2], #4
	ldr	r7, [r2], #4
	and	r8, r4, r6, ASR #31
	eor	r9, r5, r7, ASR #31
	and	r9, r9, r8
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	rors	r6, r6, #31
	rors	r7, r7, #31
	ands	r11, r8, #(1<<31)
	eors	r9, r9, r11
	ands	r10, r4, r6, ASR #31
	eors	r11, r5, r7, ASR #31
	ands	r11, r11, r10
	eor	r9, r10, r9, ROR #31
	eor	r10, r10, r8, ROR #31
	eor	r8, r11, r8, ROR #31
	eors	r11, r11, r9
	ands	r9, r9, r8
	orrs	r8, r10, r11
	strd	r8, r9, [r0], #8
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_mul64_negc
	.type		bs3_mul64_negc, %function
	// void bs3_mul64_negc(int *h, int *f, int *g);
bs3_mul64_negc:
	push	{r4-r11,lr}
	ldr	r4, [r1]
	ldr	r5, [r1, #4]
	ldr	r6, [r2]
	ldr	r7, [r2, #4]
	ldr	r8, [r1, #8]
	ldr	r9, [r1, #12]
	ldr	r10, [r2, #8]
	ldr	r11, [r2, #12]
	eor	r5, r5, r8	// (a1^b0)
	eor	r8, r8, r4	// (a0^b0)
	eor	r4, r4, r9	// (a0^b1)
	eor	r9, r9, r5	// (b1^(a1^b0))
	and	r5, r5, r4	// c1=(a1^b0)&(a0^b1)
	orr	r4, r8, r9	// c0=(a0^b0)|(b1^(a1^b0))
	eor	r7, r7, r10	// (a1^b0)
	eor	r10, r10, r6	// (a0^b0)
	eor	r6, r6, r11	// (a0^b1)
	eor	r11, r11, r7	// (b1^(a1^b0))
	and	r7, r7, r6	// c1=(a1^b0)&(a0^b1)
	orr	r6, r10, r11	// c0=(a0^b0)|(b1^(a1^b0))
	and	r8, r4, r6, ASR #31
	eor	r9, r5, r7, ASR #31
	and	r9, r9, r8
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	vmov	s0, r8		// save c01l0
	vmov	s1, r9		// save c01l1
	vmov	s2, r10		// save c01h0
	vmov	s3, r11		// save c01h1
	ldr	r4, [r1, #8]
	ldr	r5, [r1, #12]
	ldr	r6, [r2, #8]
	ldr	r7, [r2, #12]
	and	r8, r4, r6, ASR #31
	eor	r9, r5, r7, ASR #31
	and	r9, r9, r8
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	vmov	s4, r8		// save c1l0
	vmov	s5, r9		// save c1l1
	vmov	s6, r10		// save c1h0
	vmov	s7, r11		// save c1h1
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #16
	ldr	r7, [r2, #4]
	ldr	r6, [r2], #16
	and	r8, r4, r6, ASR #31
	eor	r9, r5, r7, ASR #31
	and	r9, r9, r8
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	rors	r6, r6, #31
	rors	r7, r7, #31
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
	vmov	r4, s4		// load c1l0
	vmov	r5, s5		// load c1l1
	vmov	r6, s6		// load c1h0
	vmov	r7, s7		// load c1h1
	eor	r9, r9, r6	// (a1^b0)
	eor	r6, r6, r8	// (a0^b0)
	eor	r8, r8, r7	// (a0^b1)
	eor	r7, r7, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r6, r7	// c0=(a0^b0)|(b1^(a1^b0))
	eors	r10, r10, r4	// (a0^b0)
	eors	r4, r4, r11	// (a1^b0)
	eors	r11, r11, r5	// (a1^b1)
	eors	r5, r5, r10	// (b1^(a0^b0))
	orrs	r10, r10, r11	// c0=(a0^b0)|(a1^b1)
	and	r11, r4, r5	// c1=(a1^b0)&(b1^(a0^b0))
	eor	r6, r10, r8	// (a0^b0)
	eor	r7, r8, r11	// (a1^b0)
	eor	r8, r11, r9	// (a1^b1)
	eor	r11, r10, r9	// (a0^b1)
	eor	r10, r9, r7	// (b1^(a1^b0))
	eor	r9, r9, r6	// (b1^(a0^b0))
	orr	r10, r10, r6	// c0=(a0^b0)|(b1^(a1^b0))
	and	r11, r11, r7	// c1=(a1^b0)&(a0^b1)
	orr	r8, r8, r6	// d0=(a0^b0)|(a1^b1)
	and	r9, r9, r7	// d1=(a1^b0)&(b1^(a0^b0))
	vmov	r4, s0		// load c01l0
	vmov	r5, s1		// load c01l1
	vmov	r6, s2		// load c01h0
	vmov	r7, s3		// load c01h1
	eor	r9, r9, r4	// (a1^b0)
	eor	r4, r4, r8	// (a0^b0)
	eor	r8, r8, r5	// (a0^b1)
	eor	r5, r5, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r4, r5	// c0=(a0^b0)|(b1^(a1^b0))
	eors	r10, r10, r6	// (a0^b0)
	eors	r6, r6, r11	// (a1^b0)
	eors	r11, r11, r7	// (a1^b1)
	eors	r7, r7, r10	// (b1^(a0^b0))
	orrs	r10, r10, r11	// c0=(a0^b0)|(a1^b1)
	and	r11, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	str	r10, [r0], #4
	str	r11, [r0], #4
	str	r8, [r0], #4
	str	r9, [r0], #4
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
