

 	.macro	mr_hi, res32, qq, neg_qqinv, scr
	smulbb	\scr, \res32, \neg_qqinv
	smlabb	\res32, \qq, \scr, \res32
	.endm
	
	.macro	mr_16x2, r0, r1, qq, neg_qqinv, scr, res
	mr_hi	\r0, \qq, \neg_qqinv, \scr
	mr_hi	\r1, \qq, \neg_qqinv, \scr
    	.ifb	\res
	pkhtb	\r0, \r1, \r0, ASR #16
	.else	
	pkhtb	\res, \r1, \r0, ASR #16
	.endif
	.endm

	.macro	br_lo, res, mq, q32inv, _2p15, scr
	smlawb	\scr, \res, \q32inv, \_2p15
	smlatb	\res, \mq, \scr, \res
	.endm
	// note that high half of res is undefined
	// must save with strh

	.macro	br_16x2, res, mq, q32inv, _2p15, scr1, scr2, newres
	smlawb	\scr1, \q32inv, \res, \_2p15
	smlatb	\scr2, \scr1, \mq, \res
	smlawt	\scr1, \q32inv, \res, \_2p15
	smultb	\scr1, \scr1, \mq
	add	\scr1, \res, \scr1, LSL #16 
	.ifb	\newres
	pkhbt	\res, \scr2, \scr1
	.else	
	pkhbt	\newres, \scr2, \scr1
	.endif
	.endm	

// N=32 requires 864=8x108 storage

#include "polymul_32x32_aux.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_32x32_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_32x32_divR
	.type	gf_polymul_32x32_divR, %function
gf_polymul_32x32_divR:
	push	{r4-r11,lr}
	//vpush	{s16-s31}
	ldr	r12, =216	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 864 = 8M
		// ff=[sp], gg=[sp,#216], hh=[sp,#432]
	vmov	s0, r0	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+216(=2M)
	vmov	s1, r12	// save 2M
	vmov	s2, r0	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+216(=2M)
	vmov	s3, r14	// save h
	ldr	r14, =KA_exp_ov_32
	vmov	s4, r14	// save ov pointer
	movw	r12, #4591
	vmov	s5, r12	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	vmov	s6, r14	// save qinv
	rsb	r12, r12, #0		// -q
	vmov	s8, r12	// save -q
	movw	r14, #18015
	movt	r14, #14
	vmov	s7, r14	// save q32inv
	mov	r14, #64
KA32_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA32_mv_loop
KA32_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	vmov	r12, s1  // reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #32		// N0 = r2 = N
	vmov	r3, s4  // load list to reduce
KA32_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA32_exp_end1
KA32_exp_reduce:		// reduce ff[], gg[]
	ldrsh	r4, [r3], #2	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA32_exp_adds	// only if -1 end
	vmov	r6, s8  // load -q
	vmov	r7, s7  // load q32inv
	mov	r10, #32768	// load 2^15
KA32_exp_red1:
	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]
KA32_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA32_exp_red2	// loop (r4)
	ldrsh	r4, [r3], #2	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA32_exp_red1
KA32_exp_adds:
/*
  for (j=0; j<N1/2/W; j+=N0/2/W) {
    for (k=0; k<N0/2/W; k++) {
     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);
     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);
    }
*/
	ldrsh	r4, [r3], #2		// load N1/W/2
	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W
	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W
	add	r0, r0, r2		// r0 = ff + N0/2/W
	add	r1, r1, r2		// r1 = gg + N0/2/W
	rsb	r2, r2, #0			// r2 = -N0
KA32_exp_adds1:
	ldr	r8, [r0, r2]
	ldr	r10, [r0], #4
	ldr	r9, [r0, r2]
	ldr	r11, [r0], #4
	sadd16	r8, r8, r10
	sadd16	r9, r9, r11
	strd	r8, r9, [r5], #8
	ldr	r8, [r1, r2]
	ldr	r10, [r1], #4
	ldr	r9, [r1, r2]
	ldr	r11, [r1], #4
	sadd16	r8, r8, r10
	sadd16	r9, r9, r11
	strd	r8, r9, [r6], #8
	subs	r4, r4, #2
	beq	KA32_exp_end
	bics	r7, r4, r2, ASR #2
	subeq	r0, r0, r2
	subeq	r1, r1, r2
	b	KA32_exp_adds1
KA32_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	vmov	r1, s2  // reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA32_exp_loop1	// loop
KA32_exp_end1:

KA32_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA32_muls:
	ldrsh	r14, [r3], #2	// r14 = N1/B
	vmov	s4, r3	// save overflow list pointer
	vmov	r2, s3  // load r2 = hh
KA32_muls1:
	// begin polymul_4x4_divR
	ldr	r3, [r0, #2]		// r3 = f12
	ldr	r5, [r0, #4]
	ldr	r4, [r0], #8  		// r4 = f01, f5 = f23
	ldr	r7, [r1, #4]
	ldr	r6, [r1], #8  		// r6 = g01, r7 = g23
	smulbb	r8, r4, r6		// r8 = f0 g0 = h0 (32bit)
	smuadx	r9, r4, r6		// r9 = f0 g1 + f1 g0 = h1 (32bit)
	smulbb	r10, r4, r7		// r10 = f0 g2
	smuadx	r11, r4, r7		// r11 = f0 g3 + f1 g2
	smultt	r12, r5, r6		// r12 = f3 g1
	smultt	r4, r5, r7		// r4 = f3 g3 = h6 (32bit)
	smladx  r10, r3, r6, r10	// r10 += f1 g1 + f2 g0 = h2 (32bit)
	smladx  r12, r3, r7, r12	// r12 += f1 g3 + f2 g2 = h4 (32bit)
	smladx  r11, r5, r6, r11	// r11 += f2 g1 + f3 g0 = h3 (32bit)
	smuadx	r3, r5, r7		// r3 = f2 g3 + f3 g2 = h5 (32bit)
	vmov	r5, s6  // r5 = -q^{-1} mod 2^16
	vmov	r6, s5  // r6 = q
	mr_16x2	r12, r3, r6, r5, r7
	mr_hi	r4, r6, r5, r7             
	lsr	r4, #16
	mr_16x2	r8, r9, r6, r5, r7
	mr_16x2	r10, r11, r6, r5, r7
        str	r10, [r2, #4]
	str	r12, [r2, #8]
	str	r4, [r2, #12]
	str	r8, [r2], #16
	// end polymul_4x4_divR 
	subs	r14, #1
	bne	KA32_muls1
KA32_collect:
	vmov	r2, s3  // reload hh
	vmov	r3, s4  // reload overflow list
KA32_col_4_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA32_col_4_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA32_col_4_ov1:
	ldrsh	r5, [r3], #2
KA32_col_4_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA32_col_4_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA32_col_4_ov1
KA32_col_4_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA32_col_4_add1:	// beginning of KA collect
	ldrd	r4, r5, [r1, #8]
	ldrd	r6, r7, [r1, #16]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r1, #24]
	sadd16	r8, r4, r6
	sadd16	r9, r5, r7
	ldrd	r6, r7, [r1], #16
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r12, #8]
	ssub16	r8, r6, r8
	ssub16	r9, r7, r9
	strd	r8, r9, [r1], #-8
	ldrd	r6, r7, [r12], #16	// shift r12
	sadd16	r4, r4, r6
	sadd16	r5, r5, r7
	strd	r4, r5, [r1], #24
	subs	r14, #4
	bne	KA32_col_4_add1
KA32_col_4_end:
KA32_col_8_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA32_col_8_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA32_col_8_ov1:
	ldrsh	r5, [r3], #2
KA32_col_8_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA32_col_8_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA32_col_8_ov1
KA32_col_8_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA32_col_8_add1:	// begin KA collect loop
	ldrd	r4, r5, [r1, #16]
	ldrd	r6, r7, [r1, #32]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r1, #48]
	sadd16	r8, r4, r6
	sadd16	r9, r5, r7
	ldrd	r6, r7, [r1]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r12, #16]
	ssub16	r8, r6, r8
	ssub16	r9, r7, r9
	strd	r8, r9, [r1, #32]
	ldrd	r6, r7, [r12], #8	// shift r12 up 8
	sadd16	r4, r4, r6
	sadd16	r5, r5, r7
	strd	r4, r5, [r1, #16]
	add	r1, r1, #8		// shift r1 up 8
	subs	r14, r14, #4
	beq	KA32_col_8_end
	tst	r14, #7	// set bit < 8?
	addeq	r1, r1, #48
	addeq	r12, r12, #16
	b	KA32_col_8_add1
KA32_col_8_end:
KA32_col_16_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA32_col_16_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA32_col_16_ov1:
	ldrsh	r5, [r3], #2
KA32_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA32_col_16_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA32_col_16_ov1
KA32_col_16_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA32_col_16_add1:	// begin KA collect loop
	ldrd	r4, r5, [r1, #32]
	ldrd	r6, r7, [r1, #64]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r1, #96]
	sadd16	r8, r4, r6
	sadd16	r9, r5, r7
	ldrd	r6, r7, [r1]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r12, #32]
	ssub16	r8, r6, r8
	ssub16	r9, r7, r9
	strd	r8, r9, [r1, #64]
	ldrd	r6, r7, [r12], #8	// shift r12 up 8
	sadd16	r4, r4, r6
	sadd16	r5, r5, r7
	strd	r4, r5, [r1, #32]
	add	r1, r1, #8		// shift r1 up 8
	subs	r14, r14, #4
	beq	KA32_col_16_end
	tst	r14, #15	// set bit < 16?
	addeq	r1, r1, #96
	addeq	r12, r12, #32
	b	KA32_col_16_add1
KA32_col_16_end:
KA32_mv_back:			// hh=[sp,4M] still =r2
	vmov	r0, s0  // reload h
	mov	r14, #128
KA32_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA32_mv_back_loop
KA32_end:
	vmov	r12, s1  // load 2M
	add	sp, sp, r12, LSL #2	// add back 864 = 8M
	//vpop	{s16-s31}
	pop	{r4-r11,lr}
	bx	lr

