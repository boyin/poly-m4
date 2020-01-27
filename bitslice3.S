#ifndef __thumb__	
	.macro	cbz, reg, label
	cmp	reg, #0
	beq	label
	.endm

	.macro	cbnz, reg, label
	cmp	reg, #0
	bne	label
	.endm
#endif

	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bitslice3_8
	.type		bitslice3_8, %function

	// void bitslice3_8(int *f, char *g, int c);
bitslice3_8:
	push	{r4-r11,lr}	
	and	r12, r2, #31
	bics	r14, r2, #31
	beq	bitslice3_8_1
bitslice3_8_0:	
	ldm	r1!, {r2-r9}
	sbfx	r10, r9, #24, #1
	sbfx	r11, r9, #31, #1
	teq	r0, r9, LSR #17
	adc	r10, r10, r10
	teq	r0, r9, LSR #24
	adc	r11, r11, r11
	teq	r0, r9, LSR #9
	adc	r10, r10, r10
	teq	r0, r9, LSR #16
	adc	r11, r11, r11
	teq	r0, r9, LSR #1
	adc	r10, r10, r10
	teq	r0, r9, LSR #8
	adc	r11, r11, r11
	teq	r0, r8, LSR #25
	adc	r10, r10, r10
	teq	r0, r8, LSR #32
	adc	r11, r11, r11
	teq	r0, r8, LSR #17
	adc	r10, r10, r10
	teq	r0, r8, LSR #24
	adc	r11, r11, r11
	teq	r0, r8, LSR #9
	adc	r10, r10, r10
	teq	r0, r8, LSR #16
	adc	r11, r11, r11
	teq	r0, r8, LSR #1
	adc	r10, r10, r10
	teq	r0, r8, LSR #8
	adc	r11, r11, r11
	teq	r0, r7, LSR #25
	adc	r10, r10, r10
	teq	r0, r7, LSR #32
	adc	r11, r11, r11
	teq	r0, r7, LSR #17
	adc	r10, r10, r10
	teq	r0, r7, LSR #24
	adc	r11, r11, r11
	teq	r0, r7, LSR #9
	adc	r10, r10, r10
	teq	r0, r7, LSR #16
	adc	r11, r11, r11
	teq	r0, r7, LSR #1
	adc	r10, r10, r10
	teq	r0, r7, LSR #8
	adc	r11, r11, r11
	teq	r0, r6, LSR #25
	adc	r10, r10, r10
	teq	r0, r6, LSR #32
	adc	r11, r11, r11
	teq	r0, r6, LSR #17
	adc	r10, r10, r10
	teq	r0, r6, LSR #24
	adc	r11, r11, r11
	teq	r0, r6, LSR #9
	adc	r10, r10, r10
	teq	r0, r6, LSR #16
	adc	r11, r11, r11
	teq	r0, r6, LSR #1
	adc	r10, r10, r10
	teq	r0, r6, LSR #8
	adc	r11, r11, r11
	teq	r0, r5, LSR #25
	adc	r10, r10, r10
	teq	r0, r5, LSR #32
	adc	r11, r11, r11
	teq	r0, r5, LSR #17
	adc	r10, r10, r10
	teq	r0, r5, LSR #24
	adc	r11, r11, r11
	teq	r0, r5, LSR #9
	adc	r10, r10, r10
	teq	r0, r5, LSR #16
	adc	r11, r11, r11
	teq	r0, r5, LSR #1
	adc	r10, r10, r10
	teq	r0, r5, LSR #8
	adc	r11, r11, r11
	teq	r0, r4, LSR #25
	adc	r10, r10, r10
	teq	r0, r4, LSR #32
	adc	r11, r11, r11
	teq	r0, r4, LSR #17
	adc	r10, r10, r10
	teq	r0, r4, LSR #24
	adc	r11, r11, r11
	teq	r0, r4, LSR #9
	adc	r10, r10, r10
	teq	r0, r4, LSR #16
	adc	r11, r11, r11
	teq	r0, r4, LSR #1
	adc	r10, r10, r10
	teq	r0, r4, LSR #8
	adc	r11, r11, r11
	teq	r0, r3, LSR #25
	adc	r10, r10, r10
	teq	r0, r3, LSR #32
	adc	r11, r11, r11
	teq	r0, r3, LSR #17
	adc	r10, r10, r10
	teq	r0, r3, LSR #24
	adc	r11, r11, r11
	teq	r0, r3, LSR #9
	adc	r10, r10, r10
	teq	r0, r3, LSR #16
	adc	r11, r11, r11
	teq	r0, r3, LSR #1
	adc	r10, r10, r10
	teq	r0, r3, LSR #8
	adc	r11, r11, r11
	teq	r0, r2, LSR #25
	adc	r10, r10, r10
	teq	r0, r2, LSR #32
	adc	r11, r11, r11
	teq	r0, r2, LSR #17
	adc	r10, r10, r10
	teq	r0, r2, LSR #24
	adc	r11, r11, r11
	teq	r0, r2, LSR #9
	adc	r10, r10, r10
	teq	r0, r2, LSR #16
	adc	r11, r11, r11
	teq	r0, r2, LSR #1
	adc	r10, r10, r10
	teq	r0, r2, LSR #8
	adc	r11, r11, r11
	strd	r10, r11, [r0], #+8
	subs	r14, r14, #32
	bne	bitslice3_8_0
bitslice3_8_1:
	cmp	r12, #0
	beq	bitslice3_8_3
	mov	r10, #0
	mov	r11, #0
	add	r1, r1, r12
bitslice3_8_2:
	ldrsb	r2, [r1, #-1]!
	teq	r0, r2, LSR #1
	adc	r10, r10, r10
	teq	r0, r2, LSR #8
	adc	r11, r11, r11
	subs	r12, #1
	bne	bitslice3_8_2
	strd	r10, r11, [r0], #8
bitslice3_8_3:
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
	//unbitslice functions	
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	unbitslice3_8
	.type		unbitslice3_8, %function

	// void unbitslice3_8(char *f, int *g, int c);
unbitslice3_8:
	push	{r4-r11,lr}	
	subs	r14, r2, #32
	bcc	unbitslice3_8_1
unbitslice3_8_0:
	ldrd	r10, r11, [r1], #8
	sbfx	r12, r11, #31, #1
	teq	r10, r10, LSR #32
	adc	r12, r12, r12
	bfi	r9, r12, #24, #8
	sbfx	r12, r11, #30, #1
	teq	r10, r10, LSR #31
	adc	r12, r12, r12
	bfi	r9, r12, #16, #8
	sbfx	r12, r11, #29, #1
	teq	r10, r10, LSR #30
	adc	r12, r12, r12
	bfi	r9, r12, #8, #8
	sbfx	r12, r11, #28, #1
	teq	r10, r10, LSR #29
	adc	r12, r12, r12
	bfi	r9, r12, #0, #8
	sbfx	r12, r11, #27, #1
	teq	r10, r10, LSR #28
	adc	r12, r12, r12
	bfi	r8, r12, #24, #8
	sbfx	r12, r11, #26, #1
	teq	r10, r10, LSR #27
	adc	r12, r12, r12
	bfi	r8, r12, #16, #8
	sbfx	r12, r11, #25, #1
	teq	r10, r10, LSR #26
	adc	r12, r12, r12
	bfi	r8, r12, #8, #8
	sbfx	r12, r11, #24, #1
	teq	r10, r10, LSR #25
	adc	r12, r12, r12
	bfi	r8, r12, #0, #8
	sbfx	r12, r11, #23, #1
	teq	r10, r10, LSR #24
	adc	r12, r12, r12
	bfi	r7, r12, #24, #8
	sbfx	r12, r11, #22, #1
	teq	r10, r10, LSR #23
	adc	r12, r12, r12
	bfi	r7, r12, #16, #8
	sbfx	r12, r11, #21, #1
	teq	r10, r10, LSR #22
	adc	r12, r12, r12
	bfi	r7, r12, #8, #8
	sbfx	r12, r11, #20, #1
	teq	r10, r10, LSR #21
	adc	r12, r12, r12
	bfi	r7, r12, #0, #8
	sbfx	r12, r11, #19, #1
	teq	r10, r10, LSR #20
	adc	r12, r12, r12
	bfi	r6, r12, #24, #8
	sbfx	r12, r11, #18, #1
	teq	r10, r10, LSR #19
	adc	r12, r12, r12
	bfi	r6, r12, #16, #8
	sbfx	r12, r11, #17, #1
	teq	r10, r10, LSR #18
	adc	r12, r12, r12
	bfi	r6, r12, #8, #8
	sbfx	r12, r11, #16, #1
	teq	r10, r10, LSR #17
	adc	r12, r12, r12
	bfi	r6, r12, #0, #8
	sbfx	r12, r11, #15, #1
	teq	r10, r10, LSR #16
	adc	r12, r12, r12
	bfi	r5, r12, #24, #8
	sbfx	r12, r11, #14, #1
	teq	r10, r10, LSR #15
	adc	r12, r12, r12
	bfi	r5, r12, #16, #8
	sbfx	r12, r11, #13, #1
	teq	r10, r10, LSR #14
	adc	r12, r12, r12
	bfi	r5, r12, #8, #8
	sbfx	r12, r11, #12, #1
	teq	r10, r10, LSR #13
	adc	r12, r12, r12
	bfi	r5, r12, #0, #8
	sbfx	r12, r11, #11, #1
	teq	r10, r10, LSR #12
	adc	r12, r12, r12
	bfi	r4, r12, #24, #8
	sbfx	r12, r11, #10, #1
	teq	r10, r10, LSR #11
	adc	r12, r12, r12
	bfi	r4, r12, #16, #8
	sbfx	r12, r11, #9, #1
	teq	r10, r10, LSR #10
	adc	r12, r12, r12
	bfi	r4, r12, #8, #8
	sbfx	r12, r11, #8, #1
	teq	r10, r10, LSR #9
	adc	r12, r12, r12
	bfi	r4, r12, #0, #8
	sbfx	r12, r11, #7, #1
	teq	r10, r10, LSR #8
	adc	r12, r12, r12
	bfi	r3, r12, #24, #8
	sbfx	r12, r11, #6, #1
	teq	r10, r10, LSR #7
	adc	r12, r12, r12
	bfi	r3, r12, #16, #8
	sbfx	r12, r11, #5, #1
	teq	r10, r10, LSR #6
	adc	r12, r12, r12
	bfi	r3, r12, #8, #8
	sbfx	r12, r11, #4, #1
	teq	r10, r10, LSR #5
	adc	r12, r12, r12
	bfi	r3, r12, #0, #8
	sbfx	r12, r11, #3, #1
	teq	r10, r10, LSR #4
	adc	r12, r12, r12
	bfi	r2, r12, #24, #8
	sbfx	r12, r11, #2, #1
	teq	r10, r10, LSR #3
	adc	r12, r12, r12
	bfi	r2, r12, #16, #8
	sbfx	r12, r11, #1, #1
	teq	r10, r10, LSR #2
	adc	r12, r12, r12
	bfi	r2, r12, #8, #8
	sbfx	r12, r11, #0, #1
	teq	r10, r10, LSR #1
	adc	r12, r12, r12
	bfi	r2, r12, #0, #8

	stm	r0!, {r2-r9}	
	subs	r14, r14, #32
	bcs	unbitslice3_8_0
unbitslice3_8_1:
	adds	r14, r14, #32
	beq	unbitslice3_8_3
	ldrd	r10, r11, [r1], #8	
unbitslice3_8_2:
	sbfx	r12, r11, #0, #1
	lsr	r11, r11, #1
	bfi	r12, r10, #0, #1
	lsr	r10, r10, #1
	strb	r12, [r0], #1
	subs	r14, r14, #1
	bne	unbitslice3_8_2
unbitslice3_8_3:
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
