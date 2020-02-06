	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_jump32divsteps
	.type		bs3_jump32divsteps, %function
	//normal usage is 'vmov.f32 s0, #31.0' before calling
	//int bs3_jump32divsteps(int delta, int *f, int *g, int *M, float rep+1);
bs3_jump32divsteps:
	push	{r4-r11,lr}
	vmov	s2, r3		// save result matrix ptr
	vmov	s3, r0		// save delta
	ldr	r0, [r1]
	ldr	r1, [r1, #4]
	ldr	r3, [r2, #4]
	ldr	r2, [r2]
	rbit	r0, r0
	rbit	r1, r1
	rbit	r2, r2
	rbit	r3, r3
	mov	r6, #(1<<31)
	mov	r12, #(1<<31)
	mov	r7, #0
	mov	r8, #0
	mov	r9, #0
	mov	r10, #0
	mov	r11, #0
	mov	r14, #0
	vmov.f32	s1, #1.0	// float 1.0 #112
	vcvt.f32.s32	s3, s3		// convert to float
bs3_jump32divsteps_0:		// first half
	vcmp.f32	s3, s1		// delta > 0?
	vmrs	APSR_nzcv, FPSCR	// move carry
	itttt	cs
	tstcs	r0, r2, LSL #1	// set cs by g0[0], then if cs
	movcs	r5, r0	// r0<->r2
	movcs	r0, r2
	movcs	r2, r5
	itttt	cs
	movcs	r5, r1	// r1<->r3
	movcs	r1, r3
	movcs	r3, r5
	movcs	r5, r6	// r6<->r10
	itttt	cs
	movcs	r6, r10
	movcs	r10, r5
	movcs	r5, r7	// r7<->r11
	movcs	r7, r11
	itttt	cs
	movcs	r11, r5
	movcs	r5, r8	// r8<->r12
	movcs	r8, r12
	movcs	r12, r5
	itttt	cs
	movcs	r5, r9	// r9<->r14
	movcs	r9, r14
	movcs	r14, r5
	vnegcs.f32	s3, s3
bs3_jump32divsteps_1:		// second half
	vadd.f32	s3, s3, s1	// delta++
	and	r4, r6, r2,ASR #31	// d0 = a0 & b0
	eor	r5, r7, r3,ASR #31	// d1 = a1 ^ b1
	eors	r5, r5, r1,ASR #31	// d1 = a1 ^ b1 ^ c1
	ands	r5, r5, r4	// d1 = d0&(a1^b1^c1)
	eors	r10, r10, r4	// (a0^b0)
	eors	r4, r4, r11	// (a1^b0)
	eors	r11, r11, r5	// (a1^b1)
	eors	r5, r5, r10	// (b1^(a0^b0))
	orrs	r10, r10, r11	// c0=(a0^b0)|(a1^b1)
	and	r11, r4, r5	// c1=(a1^b0)&(b1^(a0^b0))
	and	r4, r8, r2,ASR #31	// d0 = a0 & b0
	eor	r5, r9, r3,ASR #31	// d1 = a1 ^ b1
	eors	r5, r5, r1,ASR #31	// d1 = a1 ^ b1 ^ c1
	ands	r5, r5, r4	// d1 = d0&(a1^b1^c1)
	eors	r12, r12, r4	// (a0^b0)
	eors	r4, r4, r14	// (a1^b0)
	eors	r14, r14, r5	// (a1^b1)
	eors	r5, r5, r12	// (b1^(a0^b0))
	orrs	r12, r12, r14	// c0=(a0^b0)|(a1^b1)
	and	r14, r4, r5	// c1=(a1^b0)&(b1^(a0^b0))
	and	r4, r0, r2,ASR #31	// d0 = a0 & b0
	eor	r5, r1, r3,ASR #31	// d1 = a1 ^ b1
	eors	r5, r5, r1,ASR #31	// d1 = a1 ^ b1 ^ c1
	ands	r5, r5, r4	// d1 = d0&(a1^b1^c1)
	eors	r2, r2, r4	// (a0^b0)
	eors	r4, r4, r3	// (a1^b0)
	eors	r3, r3, r5	// (a1^b1)
	eors	r5, r5, r2	// (b1^(a0^b0))
	orrs	r2, r2, r3	// c0=(a0^b0)|(a1^b1)
	and	r3, r4, r5	// c1=(a1^b0)&(b1^(a0^b0))
	lsl	r2, r2, #1	// g = g/x
	lsl	r3, r3, #1
	vsub.f32	s0, s0, s1
	vcmp.f32	s0, #0.0
	vmrs	APSR_nzcv, FPSCR	// move c flag
	itttt	cs	// u = xu, v = xv if ct >= 0
	lsrcs	r6, r6, #1
	lsrcs	r7, r7, #1
	lsrcs	r8, r8, #1
	lsrcs	r9, r9, #1
	bcs	bs3_jump32divsteps_0
bs3_jump32divsteps_2:	// clean up
	rbit	r0, r0
	rbit	r1, r1
	rbit	r2, r2
	rbit	r3, r3
	rbit	r6, r6
	rbit	r7, r7
	rbit	r8, r8
	rbit	r9, r9
	rbit	r10, r10
	rbit	r11, r11
	rbit	r12, r12
	rbit	r14, r14
	vmov	r4, s2		// reload output ptr for results
	stm	r4,{r0,r1,r2,r3,r6,r7,r8,r9,r10,r11,r12,r14}
	vcvt.s32.f32	s3, s3	// back to int
	vmov	r0, s3		// restore delta

#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif
