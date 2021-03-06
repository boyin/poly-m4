
// N=256 requires 864 storage
	.p2align	2,,3
	.syntax		unified
	.text
KA_256:
	.word	256
	.word	384
	.word	576
	.word	864
	.p2align	2,,3	
	.syntax		unified
	.text
// void bs3_mul256 (int32_t *h, int32_t *f, int32_t *g);
	.global bs3_mul256
	.type	bs3_mul256, %function
bs3_mul256:
	push	{r4-r11,lr}
	sub	sp, sp, #864	// subtract M
		// ff=[sp], gg=[sp,#216], hh=[sp,#432]
	vmov	s0, r0		// save h
	add	r3, sp, #0	// load ff pointer
	add	r0, sp, #216	// load gg pointer
	mov	r14, #256
KA256_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #128
	bne	KA256_mv_loop
KA256_exp:	// ff @ sp, gg @ sp + M/4, M/4 @ r12
	add	r0, sp, #0	// load ff
	add	r1, sp, #216	// load gg
	ldr	r3, =KA_256
	vmov	s1, r3		// save list of multiplication sizes pointer
	mov	r2, #32		// N0/8 = r2 = N/8
KA256_exp_loop1:		// loop on N0(/8)
	cmp	r2, #4		// while (N0>B)
	beq	KA256_exp_end1
KA256_exp_adds:
/*
  for (j=0; j<N1; j+=N0) {
    for (k=0; k<N0/2; k+=32) {
     add3(ff+(j+k+N1)/4,ff+(2*j+k)/4,ff+(2*j+k+N0/2)/4);
     add3(gg+(j+k+N1)/4,gg+(2*j+k)/4,gg+(2*j+k+N0/2)/4);
    }
*/
	ldr	r4, [r3], #4		// load N1=KA_terms(N,N0)
	add	r5, r0, r4, LSR #2	// r5 = ff + N1/4
	add	r6, r1, r4, LSR #2	// r6 = gg + N1/4
	add	r0, r0, r2		// r0 = ff + N0/8
	add	r1, r1, r2		// r1 = gg + N0/8
	rsb	r2, r2, #0		// r2 = -N0/8
	mov	r12, r2
KA256_exp_adds1:
	ldr	r8, [r0, r2]
	ldr	r10, [r0], #4
	ldr	r9, [r0, r2]
	ldr	r11, [r0], #4
	eor	r9, r9, r10	// (a1^b0)
	eor	r10, r10, r8	// (a0^b0)
	eor	r8, r8, r11	// (a0^b1)
	eor	r11, r11, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r10, r11	// c0=(a0^b0)|(b1^(a1^b0))
	strd	r8, r9, [r5], #8
	ldr	r8, [r1, r2]
	ldr	r10, [r1], #4
	ldr	r9, [r1, r2]
	ldr	r11, [r1], #4
	eor	r9, r9, r10	// (a1^b0)
	eor	r10, r10, r8	// (a0^b0)
	eor	r8, r8, r11	// (a0^b1)
	eor	r11, r11, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r10, r11	// c0=(a0^b0)|(b1^(a1^b0))
	strd	r8, r9, [r6], #8
	subs	r4, r4, #64	// total of N1/64 pairs
	beq	KA256_exp_end
	adds	r12, r12, #8	// from N0/8 each time 8
	ittt	eq		// divisible by N0/2?
	subeq	r0, r0, r2	// then add N0/8!
	subeq	r1, r1, r2	// then add N0/8!
	moveq	r12, r2		// reload with N0/8
	b	KA256_exp_adds1
KA256_exp_end:
	rsb	r2, r2, #0	// back to + N0/8
	add	r0, sp, #0	// reload ff
	add	r1, sp, #216	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA256_exp_loop1	// loop
KA256_exp_end1:

KA256_mul:
	vmov	s1, r3		// save N1 list pointer
	ldr	r3, [r3]	// r3 = N1
	add	r2, sp, #432	// load r2 = hh
KA256_muls1:
	ldr	r4, [r0], #4
	ldr	r5, [r0], #4
	ldr	r6, [r1], #4
	ldr	r7, [r1], #4
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
	stm	r2!, {r8-r11}
	subs	r3, #32
	bne	KA256_muls1
KA256_collect:
	add	r2, sp, #432	// reload hh
KA256_col_32_add:			// KA collection
	vmov	r3, s1		// reload N1 list
	ldr	r14, [r3, #-4]!	// N1
	vmov	s1, r3		// save N1 list
	add	r12, r2, r14, LSR #1	// points into array
	mov	r1, r2		// copy of hh
	mov	r11, #32	// N0
KA256_col_32_add1:	// beginning of KA collect
	ldrd	r4, r5, [r1, #8]
	ldrd	r6, r7, [r1, #16]
	eor	r4, r4, r6	// (a0^b0)
	eor	r6, r6, r5	// (a1^b0)
	eor	r5, r5, r7	// (a1^b1)
	eor	r7, r7, r4	// (b1^(a0^b0))
	orr	r4, r4, r5	// c0=(a0^b0)|(a1^b1)
	and	r5, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r6, r7, [r1, #24]
	eor	r9, r5, r6	// (a1^b0)
	eor	r6, r6, r4	// (a0^b0)
	eor	r8, r4, r7	// (a0^b1)
	eor	r7, r7, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r6, r7	// c0=(a0^b0)|(b1^(a1^b0))
	ldrd	r6, r7, [r1]
	eor	r4, r4, r6	// (a0^b0)
	eor	r6, r6, r5	// (a1^b0)
	eor	r5, r5, r7	// (a1^b1)
	eor	r7, r7, r4	// (b1^(a0^b0))
	orr	r4, r4, r5	// c0=(a0^b0)|(a1^b1)
	and	r5, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r6, r7, [r12, #8]
	eor	r6, r6, r8	// (a0^b0)
	eor	r8, r8, r7	// (a1^b0)
	eor	r7, r7, r9	// (a1^b1)
	eor	r9, r9, r6	// (b1^(a0^b0))
	orr	r6, r6, r7	// c0=(a0^b0)|(a1^b1)
	and	r7, r8, r9	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r8, r9, [r12], #8	// shift r12
	strd	r6, r7, [r1, #16]
	eor	r5, r5, r8	// (a1^b0)
	eor	r8, r8, r4	// (a0^b0)
	eor	r4, r4, r9	// (a0^b1)
	eor	r9, r9, r5	// (b1^(a1^b0))
	and	r5, r5, r4	// c1=(a1^b0)&(a0^b1)
	orr	r4, r8, r9	// c0=(a0^b0)|(b1^(a1^b0))
	strd	r4, r5, [r1, #8]
	add	r1, r1, #8
	subs	r14, r14, #64
	beq	KA256_col_32_end
	subs	r11, r11, #32
	ittt	eq	// no, then next set
	addeq	r1, r1, #24
	addeq	r12, r12, #8
	moveq	r11, #32	// N0
	b	KA256_col_32_add1
KA256_col_32_end:
KA256_col_64_add:			// KA collection
	vmov	r3, s1		// reload N1 list
	ldr	r14, [r3, #-4]!	// N1
	vmov	s1, r3		// save N1 list
	add	r12, r2, r14, LSR #1	// points into array
	mov	r1, r2		// copy of hh
	mov	r11, #64	// N0
KA256_col_64_add1:	// beginning of KA collect
	ldrd	r4, r5, [r1, #16]
	ldrd	r6, r7, [r1, #32]
	eor	r4, r4, r6	// (a0^b0)
	eor	r6, r6, r5	// (a1^b0)
	eor	r5, r5, r7	// (a1^b1)
	eor	r7, r7, r4	// (b1^(a0^b0))
	orr	r4, r4, r5	// c0=(a0^b0)|(a1^b1)
	and	r5, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r6, r7, [r1, #48]
	eor	r9, r5, r6	// (a1^b0)
	eor	r6, r6, r4	// (a0^b0)
	eor	r8, r4, r7	// (a0^b1)
	eor	r7, r7, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r6, r7	// c0=(a0^b0)|(b1^(a1^b0))
	ldrd	r6, r7, [r1]
	eor	r4, r4, r6	// (a0^b0)
	eor	r6, r6, r5	// (a1^b0)
	eor	r5, r5, r7	// (a1^b1)
	eor	r7, r7, r4	// (b1^(a0^b0))
	orr	r4, r4, r5	// c0=(a0^b0)|(a1^b1)
	and	r5, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r6, r7, [r12, #16]
	eor	r6, r6, r8	// (a0^b0)
	eor	r8, r8, r7	// (a1^b0)
	eor	r7, r7, r9	// (a1^b1)
	eor	r9, r9, r6	// (b1^(a0^b0))
	orr	r6, r6, r7	// c0=(a0^b0)|(a1^b1)
	and	r7, r8, r9	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r8, r9, [r12], #8	// shift r12
	strd	r6, r7, [r1, #32]
	eor	r5, r5, r8	// (a1^b0)
	eor	r8, r8, r4	// (a0^b0)
	eor	r4, r4, r9	// (a0^b1)
	eor	r9, r9, r5	// (b1^(a1^b0))
	and	r5, r5, r4	// c1=(a1^b0)&(a0^b1)
	orr	r4, r8, r9	// c0=(a0^b0)|(b1^(a1^b0))
	strd	r4, r5, [r1, #16]
	add	r1, r1, #8
	subs	r14, r14, #64
	beq	KA256_col_64_end
	subs	r11, r11, #32
	ittt	eq	// no, then next set
	addeq	r1, r1, #48
	addeq	r12, r12, #16
	moveq	r11, #64	// N0
	b	KA256_col_64_add1
KA256_col_64_end:
KA256_col_128_add:			// KA collection
	vmov	r3, s1		// reload N1 list
	ldr	r14, [r3, #-4]!	// N1
	vmov	s1, r3		// save N1 list
	add	r12, r2, r14, LSR #1	// points into array
	mov	r1, r2		// copy of hh
	mov	r11, #128	// N0
KA256_col_128_add1:	// beginning of KA collect
	ldrd	r4, r5, [r1, #32]
	ldrd	r6, r7, [r1, #64]
	eor	r4, r4, r6	// (a0^b0)
	eor	r6, r6, r5	// (a1^b0)
	eor	r5, r5, r7	// (a1^b1)
	eor	r7, r7, r4	// (b1^(a0^b0))
	orr	r4, r4, r5	// c0=(a0^b0)|(a1^b1)
	and	r5, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r6, r7, [r1, #96]
	eor	r9, r5, r6	// (a1^b0)
	eor	r6, r6, r4	// (a0^b0)
	eor	r8, r4, r7	// (a0^b1)
	eor	r7, r7, r9	// (b1^(a1^b0))
	and	r9, r9, r8	// c1=(a1^b0)&(a0^b1)
	orr	r8, r6, r7	// c0=(a0^b0)|(b1^(a1^b0))
	ldrd	r6, r7, [r1]
	eor	r4, r4, r6	// (a0^b0)
	eor	r6, r6, r5	// (a1^b0)
	eor	r5, r5, r7	// (a1^b1)
	eor	r7, r7, r4	// (b1^(a0^b0))
	orr	r4, r4, r5	// c0=(a0^b0)|(a1^b1)
	and	r5, r6, r7	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r6, r7, [r12, #32]
	eor	r6, r6, r8	// (a0^b0)
	eor	r8, r8, r7	// (a1^b0)
	eor	r7, r7, r9	// (a1^b1)
	eor	r9, r9, r6	// (b1^(a0^b0))
	orr	r6, r6, r7	// c0=(a0^b0)|(a1^b1)
	and	r7, r8, r9	// c1=(a1^b0)&(b1^(a0^b0))
	ldrd	r8, r9, [r12], #8	// shift r12
	strd	r6, r7, [r1, #64]
	eor	r5, r5, r8	// (a1^b0)
	eor	r8, r8, r4	// (a0^b0)
	eor	r4, r4, r9	// (a0^b1)
	eor	r9, r9, r5	// (b1^(a1^b0))
	and	r5, r5, r4	// c1=(a1^b0)&(a0^b1)
	orr	r4, r8, r9	// c0=(a0^b0)|(b1^(a1^b0))
	strd	r4, r5, [r1, #32]
	add	r1, r1, #8
	subs	r14, r14, #64
	beq	KA256_col_128_end
	subs	r11, r11, #32
	ittt	eq	// no, then next set
	addeq	r1, r1, #96
	addeq	r12, r12, #32
	moveq	r11, #128	// N0
	b	KA256_col_128_add1
KA256_col_128_end:
KA256_mv_back:			// hh still =r2
	vmov	r0, s0		// reload h
	mov	r14, #256
KA256_mv_back_loop:
	ldm	r2!, {r4-r11}	// 4 pairs = 128 trits
	stm	r0!, {r4-r11}
	subs	r14, #64
	bne	KA256_mv_back_loop
KA256_end:
	add	sp, sp, #864
	pop	{r4-r11,lr}
	bx	lr

