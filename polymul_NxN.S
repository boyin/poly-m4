#include "polymul_NxN_aux.h"
#include "red-asm.h"
// N=8 requires 96=8x12 storage

// void gf_polymul_8x8_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_8x8_divR
	.type	gf_polymul_8x8_divR, %function
gf_polymul_8x8_divR:
	push	{r4-r11,lr}
	ldr	r12, =24	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 96 = 8M
		// ff=[sp], gg=[sp,#24], hh=[sp,#48]
	str	r0, [sp,#-4]	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+24(=2M)
	str	r12, [sp,#-8]	// save 2M
	str	r0, [sp,#-12]	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+24(=2M)
	str	r14, [sp,#-16]	// save h
	movw	r14, #:lower16:KA_exp_ov_8
	movt	r14, #:upper16:KA_exp_ov_8
	str	r14, [sp,#-20]	// save ov pointer
	movw	r12, #4591
	str	r12, [sp,#-24]	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	str	r14, [sp, #-28]	// save qinv
	rsb	r12, r12, #0		// -q
	str	r12, [sp,#-36]	// save -q
	movw	r14, #18015
	movt	r14, #14
	str	r14, [sp,#-32]	// save q32inv
KA8_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r7}
	ldm	r2!, {r8-r11}
	stm	r3!, {r4-r7}
	stm	r0!, {r8-r11}
KA8_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	ldr	r12, [sp,#-8]	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #8		// N0 = r2 = N
	ldr	r3, [sp,#-20]	// load list to reduce
KA8_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA8_exp_end1
KA8_exp_reduce:		// reduce ff[], gg[]
	ldr	r4, [r3], #4	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA8_exp_adds	// only if -1 end
	ldr	r6, [sp,#-36]	// load -q
	ldr	r7, [sp,#-32]	// load q32inv
	mov	r10, #32768	// load 2^15
KA8_exp_red1:
	ldr	r5, [r3], #4	// reduce ff[r4-r5], gg[r4-r5]
KA8_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA8_exp_red2	// loop (r4)
	ldr	r4, [r3], #4	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA8_exp_red1
KA8_exp_adds:
/*
  for (j=0; j<N1/2/W; j+=N0/2/W) {
    for (k=0; k<N0/2/W; k++) {
     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);
     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);
    }
*/
	ldr	r4, [r3], #4		// load N1/W/2
	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W
	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W
	add	r0, r0, r2		// r0 = ff + N0/2/W
	add	r1, r1, r2		// r1 = gg + N0/2/W
	rsb	r2, r2, #0			// r2 = -N0
KA8_exp_adds1:
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
	beq	KA8_exp_end
	bics	r7, r4, r2, ASR #2
	bne	KA8_exp_adds1
	sub	r0, r0, r2
	sub	r1, r1, r2
	b	KA8_exp_adds1
KA8_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	ldr	r1, [sp,#-12]	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA8_exp_loop1	// loop
KA8_exp_end1:

KA8_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA8_muls:
	ldr	r14, [r3], #4	// r14 = N1/B
	str	r3, [sp,#-20]	// save overflow list pointer
	ldr	r2, [sp,#-16]	// load r2 = hh
KA8_muls1:
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
	ldr	r5, [sp, #-28]	// r5 = -q^{-1} mod 2^16
	ldr	r6, [sp,#-24]	// r6 = q
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
	bne	KA8_muls1
KA8_collect:
	ldr	r2, [sp,#-16]	// reload hh
	ldr	r3, [sp,#-20]	// reload overflow list
KA8_col_4_ov:			// no overflow
KA8_col_4_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA8_col_4_add1:	// beginning of KA collect
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
	bne	KA8_col_4_add1
KA8_col_4_end:
KA8_mv_back:			// hh=[sp,4M] still =r2
	ldr	r0, [sp,#-4]	// reload h
KA8_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
KA8_end:
	ldr	r12, [sp,#-8]
	add	sp, sp, r12, LSL #2	// add back 96 = 8M
	pop	{r4-r11,lr}
	bx	lr

// N=16 requires 288=8x36 storage

// void gf_polymul_16x16_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_16x16_divR
	.type	gf_polymul_16x16_divR, %function
gf_polymul_16x16_divR:
	push	{r4-r11,lr}
	ldr	r12, =72	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 288 = 8M
		// ff=[sp], gg=[sp,#72], hh=[sp,#144]
	str	r0, [sp,#-4]	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+72(=2M)
	str	r12, [sp,#-8]	// save 2M
	str	r0, [sp,#-12]	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+72(=2M)
	str	r14, [sp,#-16]	// save h
	movw	r14, #:lower16:KA_exp_ov_16
	movt	r14, #:upper16:KA_exp_ov_16
	str	r14, [sp,#-20]	// save ov pointer
	movw	r12, #4591
	str	r12, [sp,#-24]	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	str	r14, [sp, #-28]	// save qinv
	rsb	r12, r12, #0		// -q
	str	r12, [sp,#-36]	// save -q
	movw	r14, #18015
	movt	r14, #14
	str	r14, [sp,#-32]	// save q32inv
KA16_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
KA16_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	ldr	r12, [sp,#-8]	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #16		// N0 = r2 = N
	ldr	r3, [sp,#-20]	// load list to reduce
KA16_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA16_exp_end1
KA16_exp_reduce:		// reduce ff[], gg[]
	ldr	r4, [r3], #4	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA16_exp_adds	// only if -1 end
	ldr	r6, [sp,#-36]	// load -q
	ldr	r7, [sp,#-32]	// load q32inv
	mov	r10, #32768	// load 2^15
KA16_exp_red1:
	ldr	r5, [r3], #4	// reduce ff[r4-r5], gg[r4-r5]
KA16_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA16_exp_red2	// loop (r4)
	ldr	r4, [r3], #4	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA16_exp_red1
KA16_exp_adds:
/*
  for (j=0; j<N1/2/W; j+=N0/2/W) {
    for (k=0; k<N0/2/W; k++) {
     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);
     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);
    }
*/
	ldr	r4, [r3], #4		// load N1/W/2
	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W
	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W
	add	r0, r0, r2		// r0 = ff + N0/2/W
	add	r1, r1, r2		// r1 = gg + N0/2/W
	rsb	r2, r2, #0			// r2 = -N0
KA16_exp_adds1:
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
	beq	KA16_exp_end
	bics	r7, r4, r2, ASR #2
	bne	KA16_exp_adds1
	sub	r0, r0, r2
	sub	r1, r1, r2
	b	KA16_exp_adds1
KA16_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	ldr	r1, [sp,#-12]	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA16_exp_loop1	// loop
KA16_exp_end1:

KA16_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA16_muls:
	ldr	r14, [r3], #4	// r14 = N1/B
	str	r3, [sp,#-20]	// save overflow list pointer
	ldr	r2, [sp,#-16]	// load r2 = hh
KA16_muls1:
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
	ldr	r5, [sp, #-28]	// r5 = -q^{-1} mod 2^16
	ldr	r6, [sp,#-24]	// r6 = q
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
	bne	KA16_muls1
KA16_collect:
	ldr	r2, [sp,#-16]	// reload hh
	ldr	r3, [sp,#-20]	// reload overflow list
KA16_col_4_ov:			// no overflow
KA16_col_4_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA16_col_4_add1:	// beginning of KA collect
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
	bne	KA16_col_4_add1
KA16_col_4_end:
KA16_col_8_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA16_col_8_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA16_col_8_ov1:
	ldr	r5, [r3], #4
KA16_col_8_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA16_col_8_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA16_col_8_ov1
KA16_col_8_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA16_col_8_add1:	// begin KA collect loop
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
	beq	KA16_col_8_end
	tst	r14, #7	// set bit < 8?
	bne	KA16_col_8_add1
	add	r1, r1, #48
	add	r12, r12, #16
	b	KA16_col_8_add1
KA16_col_8_end:
KA16_mv_back:			// hh=[sp,4M] still =r2
	ldr	r0, [sp,#-4]	// reload h
	mov	r14, #64
KA16_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA16_mv_back_loop
KA16_end:
	ldr	r12, [sp,#-8]
	add	sp, sp, r12, LSL #2	// add back 288 = 8M
	pop	{r4-r11,lr}
	bx	lr

// N=32 requires 864=8x108 storage

// void gf_polymul_32x32_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_32x32_divR
	.type	gf_polymul_32x32_divR, %function
gf_polymul_32x32_divR:
	push	{r4-r11,lr}
	ldr	r12, =216	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 864 = 8M
		// ff=[sp], gg=[sp,#216], hh=[sp,#432]
	str	r0, [sp,#-4]	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+216(=2M)
	str	r12, [sp,#-8]	// save 2M
	str	r0, [sp,#-12]	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+216(=2M)
	str	r14, [sp,#-16]	// save h
	movw	r14, #:lower16:KA_exp_ov_32
	movt	r14, #:upper16:KA_exp_ov_32
	str	r14, [sp,#-20]	// save ov pointer
	movw	r12, #4591
	str	r12, [sp,#-24]	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	str	r14, [sp, #-28]	// save qinv
	rsb	r12, r12, #0		// -q
	str	r12, [sp,#-36]	// save -q
	movw	r14, #18015
	movt	r14, #14
	str	r14, [sp,#-32]	// save q32inv
	mov	r14, #64
KA32_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA32_mv_loop
KA32_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	ldr	r12, [sp,#-8]	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #32		// N0 = r2 = N
	ldr	r3, [sp,#-20]	// load list to reduce
KA32_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA32_exp_end1
KA32_exp_reduce:		// reduce ff[], gg[]
	ldr	r4, [r3], #4	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA32_exp_adds	// only if -1 end
	ldr	r6, [sp,#-36]	// load -q
	ldr	r7, [sp,#-32]	// load q32inv
	mov	r10, #32768	// load 2^15
KA32_exp_red1:
	ldr	r5, [r3], #4	// reduce ff[r4-r5], gg[r4-r5]
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
	ldr	r4, [r3], #4	// re-load list entry
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
	ldr	r4, [r3], #4		// load N1/W/2
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
	bne	KA32_exp_adds1
	sub	r0, r0, r2
	sub	r1, r1, r2
	b	KA32_exp_adds1
KA32_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	ldr	r1, [sp,#-12]	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA32_exp_loop1	// loop
KA32_exp_end1:

KA32_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA32_muls:
	ldr	r14, [r3], #4	// r14 = N1/B
	str	r3, [sp,#-20]	// save overflow list pointer
	ldr	r2, [sp,#-16]	// load r2 = hh
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
	ldr	r5, [sp, #-28]	// r5 = -q^{-1} mod 2^16
	ldr	r6, [sp,#-24]	// r6 = q
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
	ldr	r2, [sp,#-16]	// reload hh
	ldr	r3, [sp,#-20]	// reload overflow list
KA32_col_4_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA32_col_4_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA32_col_4_ov1:
	ldr	r5, [r3], #4
KA32_col_4_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA32_col_4_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA32_col_4_ov1
KA32_col_4_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
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
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA32_col_8_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA32_col_8_ov1:
	ldr	r5, [r3], #4
KA32_col_8_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA32_col_8_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA32_col_8_ov1
KA32_col_8_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
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
	bne	KA32_col_8_add1
	add	r1, r1, #48
	add	r12, r12, #16
	b	KA32_col_8_add1
KA32_col_8_end:
KA32_col_16_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA32_col_16_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA32_col_16_ov1:
	ldr	r5, [r3], #4
KA32_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA32_col_16_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA32_col_16_ov1
KA32_col_16_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
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
	bne	KA32_col_16_add1
	add	r1, r1, #96
	add	r12, r12, #32
	b	KA32_col_16_add1
KA32_col_16_end:
KA32_mv_back:			// hh=[sp,4M] still =r2
	ldr	r0, [sp,#-4]	// reload h
	mov	r14, #128
KA32_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA32_mv_back_loop
KA32_end:
	ldr	r12, [sp,#-8]
	add	sp, sp, r12, LSL #2	// add back 864 = 8M
	pop	{r4-r11,lr}
	bx	lr

// N=64 requires 2592=8x324 storage

// void gf_polymul_64x64_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_64x64_divR
	.type	gf_polymul_64x64_divR, %function
gf_polymul_64x64_divR:
	push	{r4-r11,lr}
	ldr	r12, =648	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 2592 = 8M
		// ff=[sp], gg=[sp,#648], hh=[sp,#1296]
	str	r0, [sp,#-4]	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+648(=2M)
	str	r12, [sp,#-8]	// save 2M
	str	r0, [sp,#-12]	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+648(=2M)
	str	r14, [sp,#-16]	// save h
	movw	r14, #:lower16:KA_exp_ov_64
	movt	r14, #:upper16:KA_exp_ov_64
	str	r14, [sp,#-20]	// save ov pointer
	movw	r12, #4591
	str	r12, [sp,#-24]	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	str	r14, [sp, #-28]	// save qinv
	rsb	r12, r12, #0		// -q
	str	r12, [sp,#-36]	// save -q
	movw	r14, #18015
	movt	r14, #14
	str	r14, [sp,#-32]	// save q32inv
	mov	r14, #128
KA64_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA64_mv_loop
KA64_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	ldr	r12, [sp,#-8]	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #64		// N0 = r2 = N
	ldr	r3, [sp,#-20]	// load list to reduce
KA64_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA64_exp_end1
KA64_exp_reduce:		// reduce ff[], gg[]
	ldr	r4, [r3], #4	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA64_exp_adds	// only if -1 end
	ldr	r6, [sp,#-36]	// load -q
	ldr	r7, [sp,#-32]	// load q32inv
	mov	r10, #32768	// load 2^15
KA64_exp_red1:
	ldr	r5, [r3], #4	// reduce ff[r4-r5], gg[r4-r5]
KA64_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA64_exp_red2	// loop (r4)
	ldr	r4, [r3], #4	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA64_exp_red1
KA64_exp_adds:
/*
  for (j=0; j<N1/2/W; j+=N0/2/W) {
    for (k=0; k<N0/2/W; k++) {
     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);
     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);
    }
*/
	ldr	r4, [r3], #4		// load N1/W/2
	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W
	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W
	add	r0, r0, r2		// r0 = ff + N0/2/W
	add	r1, r1, r2		// r1 = gg + N0/2/W
	rsb	r2, r2, #0			// r2 = -N0
KA64_exp_adds1:
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
	beq	KA64_exp_end
	bics	r7, r4, r2, ASR #2
	bne	KA64_exp_adds1
	sub	r0, r0, r2
	sub	r1, r1, r2
	b	KA64_exp_adds1
KA64_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	ldr	r1, [sp,#-12]	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA64_exp_loop1	// loop
KA64_exp_end1:

KA64_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA64_muls:
	ldr	r14, [r3], #4	// r14 = N1/B
	str	r3, [sp,#-20]	// save overflow list pointer
	ldr	r2, [sp,#-16]	// load r2 = hh
KA64_muls1:
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
	ldr	r5, [sp, #-28]	// r5 = -q^{-1} mod 2^16
	ldr	r6, [sp,#-24]	// r6 = q
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
	bne	KA64_muls1
KA64_collect:
	ldr	r2, [sp,#-16]	// reload hh
	ldr	r3, [sp,#-20]	// reload overflow list
KA64_col_4_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA64_col_4_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA64_col_4_ov1:
	ldr	r5, [r3], #4
KA64_col_4_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA64_col_4_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA64_col_4_ov1
KA64_col_4_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA64_col_4_add1:	// beginning of KA collect
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
	bne	KA64_col_4_add1
KA64_col_4_end:
KA64_col_8_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA64_col_8_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA64_col_8_ov1:
	ldr	r5, [r3], #4
KA64_col_8_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA64_col_8_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA64_col_8_ov1
KA64_col_8_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA64_col_8_add1:	// begin KA collect loop
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
	beq	KA64_col_8_end
	tst	r14, #7	// set bit < 8?
	bne	KA64_col_8_add1
	add	r1, r1, #48
	add	r12, r12, #16
	b	KA64_col_8_add1
KA64_col_8_end:
KA64_col_16_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA64_col_16_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA64_col_16_ov1:
	ldr	r5, [r3], #4
KA64_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA64_col_16_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA64_col_16_ov1
KA64_col_16_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA64_col_16_add1:	// begin KA collect loop
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
	beq	KA64_col_16_end
	tst	r14, #15	// set bit < 16?
	bne	KA64_col_16_add1
	add	r1, r1, #96
	add	r12, r12, #32
	b	KA64_col_16_add1
KA64_col_16_end:
KA64_col_32_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA64_col_32_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA64_col_32_ov1:
	ldr	r5, [r3], #4
KA64_col_32_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA64_col_32_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA64_col_32_ov1
KA64_col_32_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA64_col_32_add1:	// begin KA collect loop
	ldrd	r4, r5, [r1, #64]
	ldrd	r6, r7, [r1, #128]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r1, #192]
	sadd16	r8, r4, r6
	sadd16	r9, r5, r7
	ldrd	r6, r7, [r1]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r12, #64]
	ssub16	r8, r6, r8
	ssub16	r9, r7, r9
	strd	r8, r9, [r1, #128]
	ldrd	r6, r7, [r12], #8	// shift r12 up 8
	sadd16	r4, r4, r6
	sadd16	r5, r5, r7
	strd	r4, r5, [r1, #64]
	add	r1, r1, #8		// shift r1 up 8
	subs	r14, r14, #4
	beq	KA64_col_32_end
	tst	r14, #31	// set bit < 32?
	bne	KA64_col_32_add1
	add	r1, r1, #192
	add	r12, r12, #64
	b	KA64_col_32_add1
KA64_col_32_end:
KA64_mv_back:			// hh=[sp,4M] still =r2
	ldr	r0, [sp,#-4]	// reload h
	mov	r14, #256
KA64_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA64_mv_back_loop
KA64_end:
	ldr	r12, [sp,#-8]
	add	sp, sp, r12, LSL #2	// add back 2592 = 8M
	pop	{r4-r11,lr}
	bx	lr

// N=128 requires 7776=8x972 storage

// void gf_polymul_128x128_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_128x128_divR
	.type	gf_polymul_128x128_divR, %function
gf_polymul_128x128_divR:
	push	{r4-r11,lr}
	ldr	r12, =1944	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 7776 = 8M
		// ff=[sp], gg=[sp,#1944], hh=[sp,#3888]
	str	r0, [sp,#-4]	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+1944(=2M)
	str	r12, [sp,#-8]	// save 2M
	str	r0, [sp,#-12]	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+1944(=2M)
	str	r14, [sp,#-16]	// save h
	movw	r14, #:lower16:KA_exp_ov_128
	movt	r14, #:upper16:KA_exp_ov_128
	str	r14, [sp,#-20]	// save ov pointer
	movw	r12, #4591
	str	r12, [sp,#-24]	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	str	r14, [sp, #-28]	// save qinv
	rsb	r12, r12, #0		// -q
	str	r12, [sp,#-36]	// save -q
	movw	r14, #18015
	movt	r14, #14
	str	r14, [sp,#-32]	// save q32inv
	mov	r14, #256
KA128_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA128_mv_loop
KA128_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	ldr	r12, [sp,#-8]	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #128		// N0 = r2 = N
	ldr	r3, [sp,#-20]	// load list to reduce
KA128_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA128_exp_end1
KA128_exp_reduce:		// reduce ff[], gg[]
	ldr	r4, [r3], #4	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA128_exp_adds	// only if -1 end
	ldr	r6, [sp,#-36]	// load -q
	ldr	r7, [sp,#-32]	// load q32inv
	mov	r10, #32768	// load 2^15
KA128_exp_red1:
	ldr	r5, [r3], #4	// reduce ff[r4-r5], gg[r4-r5]
KA128_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA128_exp_red2	// loop (r4)
	ldr	r4, [r3], #4	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA128_exp_red1
KA128_exp_adds:
/*
  for (j=0; j<N1/2/W; j+=N0/2/W) {
    for (k=0; k<N0/2/W; k++) {
     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);
     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);
    }
*/
	ldr	r4, [r3], #4		// load N1/W/2
	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W
	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W
	add	r0, r0, r2		// r0 = ff + N0/2/W
	add	r1, r1, r2		// r1 = gg + N0/2/W
	rsb	r2, r2, #0			// r2 = -N0
KA128_exp_adds1:
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
	beq	KA128_exp_end
	bics	r7, r4, r2, ASR #2
	bne	KA128_exp_adds1
	sub	r0, r0, r2
	sub	r1, r1, r2
	b	KA128_exp_adds1
KA128_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	ldr	r1, [sp,#-12]	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA128_exp_loop1	// loop
KA128_exp_end1:

KA128_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA128_muls:
	ldr	r14, [r3], #4	// r14 = N1/B
	str	r3, [sp,#-20]	// save overflow list pointer
	ldr	r2, [sp,#-16]	// load r2 = hh
KA128_muls1:
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
	ldr	r5, [sp, #-28]	// r5 = -q^{-1} mod 2^16
	ldr	r6, [sp,#-24]	// r6 = q
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
	bne	KA128_muls1
KA128_collect:
	ldr	r2, [sp,#-16]	// reload hh
	ldr	r3, [sp,#-20]	// reload overflow list
KA128_col_4_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA128_col_4_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA128_col_4_ov1:
	ldr	r5, [r3], #4
KA128_col_4_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA128_col_4_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA128_col_4_ov1
KA128_col_4_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA128_col_4_add1:	// beginning of KA collect
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
	bne	KA128_col_4_add1
KA128_col_4_end:
KA128_col_8_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA128_col_8_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA128_col_8_ov1:
	ldr	r5, [r3], #4
KA128_col_8_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA128_col_8_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA128_col_8_ov1
KA128_col_8_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA128_col_8_add1:	// begin KA collect loop
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
	beq	KA128_col_8_end
	tst	r14, #7	// set bit < 8?
	bne	KA128_col_8_add1
	add	r1, r1, #48
	add	r12, r12, #16
	b	KA128_col_8_add1
KA128_col_8_end:
KA128_col_16_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA128_col_16_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA128_col_16_ov1:
	ldr	r5, [r3], #4
KA128_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA128_col_16_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA128_col_16_ov1
KA128_col_16_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA128_col_16_add1:	// begin KA collect loop
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
	beq	KA128_col_16_end
	tst	r14, #15	// set bit < 16?
	bne	KA128_col_16_add1
	add	r1, r1, #96
	add	r12, r12, #32
	b	KA128_col_16_add1
KA128_col_16_end:
KA128_col_32_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA128_col_32_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA128_col_32_ov1:
	ldr	r5, [r3], #4
KA128_col_32_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA128_col_32_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA128_col_32_ov1
KA128_col_32_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA128_col_32_add1:	// begin KA collect loop
	ldrd	r4, r5, [r1, #64]
	ldrd	r6, r7, [r1, #128]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r1, #192]
	sadd16	r8, r4, r6
	sadd16	r9, r5, r7
	ldrd	r6, r7, [r1]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r12, #64]
	ssub16	r8, r6, r8
	ssub16	r9, r7, r9
	strd	r8, r9, [r1, #128]
	ldrd	r6, r7, [r12], #8	// shift r12 up 8
	sadd16	r4, r4, r6
	sadd16	r5, r5, r7
	strd	r4, r5, [r1, #64]
	add	r1, r1, #8		// shift r1 up 8
	subs	r14, r14, #4
	beq	KA128_col_32_end
	tst	r14, #31	// set bit < 32?
	bne	KA128_col_32_add1
	add	r1, r1, #192
	add	r12, r12, #64
	b	KA128_col_32_add1
KA128_col_32_end:
KA128_col_64_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA128_col_64_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA128_col_64_ov1:
	ldr	r5, [r3], #4
KA128_col_64_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA128_col_64_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA128_col_64_ov1
KA128_col_64_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r0, #128			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
KA128_col_64_add1:	// begin KA collect loop
	ldr	r4, [r1, r0]		//+2*N0
	ldr	r6, [r1, r0, LSL #1]	//+4*N0
	ssub16	r4, r4, r6
	ldr	r6, [r1, r11]		//+6*N0
	sadd16	r8, r4, r6
	ldr	r6, [r1]
	ssub16	r4, r4, r6
	ldr	r6, [r12, r0]		//+2*N0
	ssub16	r8, r6, r8
	str	r8, [r1, r0, LSL #1] 	//+4*N0
	ldr	r6, [r12], #4		// shift r12 up 4
	sadd16	r4, r4, r6
	str	r4, [r1, r0]		//+2*N0
	add	r1, r1, #4		// shift r1 up 4
	subs	r14, r14, #2
	beq	KA128_col_64_end
	tst	r14, #63	// set bit < 64?
	bne	KA128_col_64_add1
	add	r1, r1, r11		//+6*N0
	add	r12, r12, r0		//+2*N0
	b	KA128_col_64_add1
KA128_col_64_end:
KA128_mv_back:			// hh=[sp,4M] still =r2
	ldr	r0, [sp,#-4]	// reload h
	mov	r14, #512
KA128_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA128_mv_back_loop
KA128_end:
	ldr	r12, [sp,#-8]
	add	sp, sp, r12, LSL #2	// add back 7776 = 8M
	pop	{r4-r11,lr}
	bx	lr

// N=256 requires 23328=8x2916 storage

// void gf_polymul_256x256_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_256x256_divR
	.type	gf_polymul_256x256_divR, %function
gf_polymul_256x256_divR:
	push	{r4-r11,lr}
	ldr	r12, =5832	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 23328 = 8M
		// ff=[sp], gg=[sp,#5832], hh=[sp,#11664]
	str	r0, [sp,#-4]	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+5832(=2M)
	str	r12, [sp,#-8]	// save 2M
	str	r0, [sp,#-12]	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+5832(=2M)
	str	r14, [sp,#-16]	// save h
	movw	r14, #:lower16:KA_exp_ov_256
	movt	r14, #:upper16:KA_exp_ov_256
	str	r14, [sp,#-20]	// save ov pointer
	movw	r12, #4591
	str	r12, [sp,#-24]	// save q
	movw	r14, #49905
	movt	r14, #65536-1
	str	r14, [sp, #-28]	// save qinv
	rsb	r12, r12, #0		// -q
	str	r12, [sp,#-36]	// save -q
	movw	r14, #18015
	movt	r14, #14
	str	r14, [sp,#-32]	// save q32inv
	mov	r14, #512
KA256_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA256_mv_loop
KA256_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	ldr	r12, [sp,#-8]	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #256		// N0 = r2 = N
	ldr	r3, [sp,#-20]	// load list to reduce
KA256_exp_loop1:		// loop on N0
	cmp	r2, #4		// while (N0>B)
	beq	KA256_exp_end1
KA256_exp_reduce:		// reduce ff[], gg[]
	ldr	r4, [r3], #4	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA256_exp_adds	// only if -1 end
	ldr	r6, [sp,#-36]	// load -q
	ldr	r7, [sp,#-32]	// load q32inv
	mov	r10, #32768	// load 2^15
KA256_exp_red1:
	ldr	r5, [r3], #4	// reduce ff[r4-r5], gg[r4-r5]
KA256_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA256_exp_red2	// loop (r4)
	ldr	r4, [r3], #4	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA256_exp_red1
KA256_exp_adds:
/*
  for (j=0; j<N1/2/W; j+=N0/2/W) {
    for (k=0; k<N0/2/W; k++) {
     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);
     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);
    }
*/
	ldr	r4, [r3], #4		// load N1/W/2
	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W
	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W
	add	r0, r0, r2		// r0 = ff + N0/2/W
	add	r1, r1, r2		// r1 = gg + N0/2/W
	rsb	r2, r2, #0			// r2 = -N0
KA256_exp_adds1:
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
	beq	KA256_exp_end
	bics	r7, r4, r2, ASR #2
	bne	KA256_exp_adds1
	sub	r0, r0, r2
	sub	r1, r1, r2
	b	KA256_exp_adds1
KA256_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	ldr	r1, [sp,#-12]	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA256_exp_loop1	// loop
KA256_exp_end1:

KA256_mul:
  // check multiplicative overflow (pre-mult size > q_mb=22343)
		// no multiplicative overflow
KA256_muls:
	ldr	r14, [r3], #4	// r14 = N1/B
	str	r3, [sp,#-20]	// save overflow list pointer
	ldr	r2, [sp,#-16]	// load r2 = hh
KA256_muls1:
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
	ldr	r5, [sp, #-28]	// r5 = -q^{-1} mod 2^16
	ldr	r6, [sp,#-24]	// r6 = q
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
	bne	KA256_muls1
KA256_collect:
	ldr	r2, [sp,#-16]	// reload hh
	ldr	r3, [sp,#-20]	// reload overflow list
KA256_col_4_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA256_col_4_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA256_col_4_ov1:
	ldr	r5, [r3], #4
KA256_col_4_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_4_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA256_col_4_ov1
KA256_col_4_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA256_col_4_add1:	// beginning of KA collect
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
	bne	KA256_col_4_add1
KA256_col_4_end:
KA256_col_8_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA256_col_8_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA256_col_8_ov1:
	ldr	r5, [r3], #4
KA256_col_8_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_8_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA256_col_8_ov1
KA256_col_8_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA256_col_8_add1:	// begin KA collect loop
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
	beq	KA256_col_8_end
	tst	r14, #7	// set bit < 8?
	bne	KA256_col_8_add1
	add	r1, r1, #48
	add	r12, r12, #16
	b	KA256_col_8_add1
KA256_col_8_end:
KA256_col_16_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA256_col_16_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA256_col_16_ov1:
	ldr	r5, [r3], #4
KA256_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_16_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA256_col_16_ov1
KA256_col_16_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA256_col_16_add1:	// begin KA collect loop
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
	beq	KA256_col_16_end
	tst	r14, #15	// set bit < 16?
	bne	KA256_col_16_add1
	add	r1, r1, #96
	add	r12, r12, #32
	b	KA256_col_16_add1
KA256_col_16_end:
KA256_col_32_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA256_col_32_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA256_col_32_ov1:
	ldr	r5, [r3], #4
KA256_col_32_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_32_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA256_col_32_ov1
KA256_col_32_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
KA256_col_32_add1:	// begin KA collect loop
	ldrd	r4, r5, [r1, #64]
	ldrd	r6, r7, [r1, #128]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r1, #192]
	sadd16	r8, r4, r6
	sadd16	r9, r5, r7
	ldrd	r6, r7, [r1]
	ssub16	r4, r4, r6
	ssub16	r5, r5, r7
	ldrd	r6, r7, [r12, #64]
	ssub16	r8, r6, r8
	ssub16	r9, r7, r9
	strd	r8, r9, [r1, #128]
	ldrd	r6, r7, [r12], #8	// shift r12 up 8
	sadd16	r4, r4, r6
	sadd16	r5, r5, r7
	strd	r4, r5, [r1, #64]
	add	r1, r1, #8		// shift r1 up 8
	subs	r14, r14, #4
	beq	KA256_col_32_end
	tst	r14, #31	// set bit < 32?
	bne	KA256_col_32_add1
	add	r1, r1, #192
	add	r12, r12, #64
	b	KA256_col_32_add1
KA256_col_32_end:
KA256_col_64_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA256_col_64_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA256_col_64_ov1:
	ldr	r5, [r3], #4
KA256_col_64_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_64_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA256_col_64_ov1
KA256_col_64_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r0, #128			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
KA256_col_64_add1:	// begin KA collect loop
	ldr	r4, [r1, r0]		//+2*N0
	ldr	r6, [r1, r0, LSL #1]	//+4*N0
	ssub16	r4, r4, r6
	ldr	r6, [r1, r11]		//+6*N0
	sadd16	r8, r4, r6
	ldr	r6, [r1]
	ssub16	r4, r4, r6
	ldr	r6, [r12, r0]		//+2*N0
	ssub16	r8, r6, r8
	str	r8, [r1, r0, LSL #1] 	//+4*N0
	ldr	r6, [r12], #4		// shift r12 up 4
	sadd16	r4, r4, r6
	str	r4, [r1, r0]		//+2*N0
	add	r1, r1, #4		// shift r1 up 4
	subs	r14, r14, #2
	beq	KA256_col_64_end
	tst	r14, #63	// set bit < 64?
	bne	KA256_col_64_add1
	add	r1, r1, r11		//+6*N0
	add	r12, r12, r0		//+2*N0
	b	KA256_col_64_add1
KA256_col_64_end:
KA256_col_128_ov:
	ldr	r4, [r3], #4
	cmp	r4, #-1
	beq	KA256_col_128_add
	ldrd	r0, r1, [sp,#-36]	// load -q, q32inv
	mov	r6,#32768
KA256_col_128_ov1:
	ldr	r5, [r3], #4
KA256_col_128_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_128_ov2
	ldr	r4, [r3], #4
	cmp	r4, #-1
	bne	KA256_col_128_ov1
KA256_col_128_add:			// KA collection
	ldr	r14, [r3], #4	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r0, #256			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
KA256_col_128_add1:	// begin KA collect loop
	ldr	r4, [r1, r0]		//+2*N0
	ldr	r6, [r1, r0, LSL #1]	//+4*N0
	ssub16	r4, r4, r6
	ldr	r6, [r1, r11]		//+6*N0
	sadd16	r8, r4, r6
	ldr	r6, [r1]
	ssub16	r4, r4, r6
	ldr	r6, [r12, r0]		//+2*N0
	ssub16	r8, r6, r8
	str	r8, [r1, r0, LSL #1] 	//+4*N0
	ldr	r6, [r12], #4		// shift r12 up 4
	sadd16	r4, r4, r6
	str	r4, [r1, r0]		//+2*N0
	add	r1, r1, #4		// shift r1 up 4
	subs	r14, r14, #2
	beq	KA256_col_128_end
	tst	r14, #127	// set bit < 128?
	bne	KA256_col_128_add1
	add	r1, r1, r11		//+6*N0
	add	r12, r12, r0		//+2*N0
	b	KA256_col_128_add1
KA256_col_128_end:
KA256_mv_back:			// hh=[sp,4M] still =r2
	ldr	r0, [sp,#-4]	// reload h
	mov	r14, #1024
KA256_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA256_mv_back_loop
KA256_end:
	ldr	r12, [sp,#-8]
	add	sp, sp, r12, LSL #2	// add back 23328 = 8M
	pop	{r4-r11,lr}
	bx	lr

