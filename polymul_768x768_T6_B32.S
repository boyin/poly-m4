#include "red-asm.h"
// N,l=128,6 requires 25344=8x11x288 storage

#include "polymul_768x768_T6_B32_aux.h"
	.p2align	2,,3	
// void gf_polymul_768x768_divR (int32_t *h, int32_t *f, int32_t *g);
	.syntax		unified
	.text
	.global gf_polymul_768x768_divR
	.type	gf_polymul_768x768_divR, %function
gf_polymul_768x768_divR:
	push	{r4-r11,lr}
	vpush	{s16-s31}
T128x6_saves:
	vmov	s0, r0	// // save h
	vmov	s11, r1	// // save f
	vmov	s12, r2	// // save g
	movw	r12, #6336	// r12=2M
	sub	sp, sp, #96	// 4*2*l hwords
	mov	r3, sp
	vmov	s10, r3	// save pointer to temp space
	sub	sp, sp, r12, LSL #2	// subtract 25344 = 8M
		// ff=[sp], gg=[sp,#6336], hh=[sp,#12672]
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+6336(=2M)
	vmov	s1, r12	// save 2M
	vmov	s2, r0	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+6336(=2M)
	vmov	s3, r14	// save h
	movw	r14, #:lower16:T_exp_ov_128
	movt	r14, #:upper16:T_exp_ov_128
	movw	r11, #:lower16:T6_Mat2
	movt	r11, #:upper16:T6_Mat2
	movw	r12, #:lower16:T6_Mat1
	movt	r12, #:upper16:T6_Mat1
	vmov	s4, r14	// save ov pointer
	vmov	s15, r12	// save Matrix 1
	vmov	s16, r11	// save Matrix 2
	movw	r12, #4591
	movw	r14, #15631
	vmov	s6, r14	// save qinv
	rsb	r12, r12, #0		// -q
	vmov	s8, r12	// save -q
	movw	r14, #18015
	movt	r14, #14
	vmov	s7, r14	// save q32inv
T128x6_begin:
	mov	r14, #256
T128x6_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x6_mv_loop
	// r1 = f+N/W, r2 = g+N/W, r3 = ff+N/W, r0 = gg+N/W
	add	r1, #1024		// r1=f+(l-2)N/W
	add	r2, #1024		// r2=g+(l-2)N/W
	mov	r14, #256
T128x6_mv_loop1:
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x6_mv_loop1
	// r3 = ff+2*N/W, r0 = gg+2*N/W
	b	T128x6_split

T128x6_split_sub:	// use twice, r0 = src, r1 = dst
	vmov	s13, r14	// first, save link to scratch
	add	r1, r1, #512
	mov	r12, #256	// counter
	vmov	r11, s7	// load round(2^32/q)
	vmov	r7, s8	// load -q
T128x6_split_sub1:
	mov	r14, #0
	vmov	r9, s10	// pointer to X array
	mov	r5, #0
	mov	r6, #0
T128x6_split_sub2:
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #0]	// save to temp array
	sadd16	r5, r5, r8
	add	r14, r14, #256	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #4]	// save to temp array
	sadd16	r6, r6, r8
	add	r14, r14, #256	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #8]	// save to temp array
	sadd16	r5, r5, r8
	add	r14, r14, #256	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #12]	// save to temp array
	sadd16	r6, r6, r8
	add	r14, r14, #256	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #16]	// save to temp array
	sadd16	r5, r5, r8
	add	r14, r14, #256	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #20]	// save to temp array
	sadd16	r6, r6, r8
	sadd16	r4, r5, r6
	ssub16	r5, r5, r6
	mov	r3, #32768
	br_16x2	r4, r7, r11, r3, r6, r10
	br_16x2	r5, r7, r11, r3, r6, r10
	vmov	r10, s15	// load T6 matrix 1
	str	r4, [r1]
	mov	r2, #256		// counter j
	str	r5, [r1, r2]
	add	r2, r2, #256	// counter j
T128x6_split_sub3:
	ldrsh	r14, [r10], #2	// MAT1[j][0]
	ldr	r8, [r9]		// X[0]
	smulbb	r4, r14, r8
	smulbt	r5, r14, r8
	ldrsh	r14, [r10], #2	// MAT1[j][1]
	ldr	r8, [r9, #4]		// X[1]
	smulbb	r3, r14, r8
	smulbt	r6, r14, r8
T128x6_split_sub4:
	ldrsh	r14, [r10], #2	// MAT1[j][2]
	ldr	r8, [r9, #8]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	ldrsh	r14, [r10], #2	// MAT1[j][3]
	ldr	r8, [r9, #12]	// X[k]
	smlabb	r3, r14, r8, r3
	smlabt	r6, r14, r8, r6
	ldrsh	r14, [r10], #2	// MAT1[j][4]
	ldr	r8, [r9, #16]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	ldrsh	r14, [r10], #2	// MAT1[j][5]
	ldr	r8, [r9, #20]	// X[k]
	smlabb	r3, r14, r8, r3
	smlabt	r6, r14, r8, r6
	add	r8, r4, r3	// row j
	cmp	r2, #2048
	bcs	T128x6_split_sub5
	sub	r3, r4, r3	// row j+1
	add	r4, r5, r6	// row j
	sub	r5, r5, r6	// row j+1
	br_32	r8, r7, r11, r6
	br_32	r3, r7, r11, r6
	br_32	r4, r7, r11, r6
	br_32	r5, r7, r11, r6
	pkhbt	r8, r8, r4, LSL #16
	pkhbt	r3, r3, r5, LSL #16
	str	r8, [r1, r2]
	add	r2, #256
	str	r3, [r1, r2]
	add	r2, #256
	b	T128x6_split_sub3
T128x6_split_sub5:
	add	r4, r5, r6	// row j
	br_32	r8, r7, r11, r6
	br_32	r4, r7, r11, r6
	pkhbt	r8, r8, r4, LSL #16
	str	r8, [r1, r2]
	add	r0, #4		// incr src
	add	r1, #4		// incr dst
	subs	r12, #4		// decr counter
	bne	T128x6_split_sub1
	vmov	r14, s13	// load original return addr
	bx	lr		// return

T128x6_split:
	vmov	r0, s11	// f
	mov	r1, sp		// ff
	bl	T128x6_split_sub
	vmov	r0, s12	// g
	vmov	r1, s2	// gg
	bl	T128x6_split_sub
T128x6_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	vmov	r12, s1	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #128		// N0 = r2 = N
	vmov	r3, s4	// load list to reduce
T128x6_exp_loop1:		// loop on N0
	cmp	r2, #32		// while (N0>B)
	beq	T128x6_exp_end1
T128x6_exp_reduce:		// reduce ff[], gg[]
	ldrsh	r4, [r3], #2	// list entry
	cmp	r4, #-1		// end of this list?
	beq	T128x6_exp_adds	// only if -1 end
	vmov	r6, s8	// load -q
	vmov	r7, s7	// load q32inv
	mov	r10, #32768	// load 2^15
T128x6_exp_red1:
	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]
T128x6_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	T128x6_exp_red2	// loop (r4)
	ldrsh	r4, [r3], #2	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	T128x6_exp_red1
T128x6_exp_adds:
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
	mov	r12, r2
T128x6_exp_adds1:
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
	beq	T128x6_exp_end
	adds	r12, r12, #8
	ittt	eq
	subeq	r0, r0, r2
	subeq	r1, r1, r2
	moveq	r12, r2		// reload with N0
	b	T128x6_exp_adds1
T128x6_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	vmov	r1, s2	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	T128x6_exp_loop1	// loop
T128x6_exp_end1:

T128x6_mul:
  // check multiplicative overflow (pre-mult size > q_mb=7899)
T128x6_mul_ov:
	ldrsh	r2, [r3], #2
	cmp	r2, #-1		// multiplicative overflow?
	beq	T128x6_muls
	mov	r8, #32768
	vmov	r6, s8	// load -q
	vmov	r7, s7	// load round(2^32/q)
T128x6_mul_ov1:
	ldrsh	r11, [r3], #2
T128x6_mul_ov2:
	ldr	r4, [r0, r2, LSL #2]
	ldr	r5, [r1, r2, LSL #2]
	br_16x2	r4, r6, r7, r8, r9, r10
	br_16x2 r5, r6, r7, r8, r9, r10
	str	r4, [r0, r2, LSL #2]
	str	r5, [r1, r2, LSL #2]
	add	r2, r2, #1
	cmp	r2, r11
	bls	T128x6_mul_ov2
	ldrsh	r2, [r3], #2
	cmp	r2, -1
	bne	T128x6_mul_ov1
T128x6_muls:
	ldrsh	r14, [r3], #2	// r14 = N1/B
	vmov	s4, r3	// save overflow list pointer
	vmov	r2, s3	// load r2 = hh
T128x6_muls1:
	vmov	s17, r14	// save counter to scr0
	ldr	r12, [r1]
	ldr	r14, [r1, #4]
	ldr	r3, [r0]
	ldr	r4, [r0, #4]
	// block (0,0)
	smuadx	r6, r3, r12
	smuadx	r8, r4, r12
	smladx	r8, r3, r14, r8
	smuadx	r10, r4, r14
	smulbb	r5, r3, r12
	smulbb	r7, r3, r14
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smuad	r9, r3, r14
	smlatt	r9, r4, r12, r9
	smultt	r11, r4, r14
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r5, r6, r3, r12, r4
	mr_16x2	r7, r8, r3, r12, r4
	str	r5, [r2], #4
	str	r7, [r2], #4
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	ldr	r12, [r1, #0]
	// block (1,0)
	smladx	r10, r3, r12, r10
	smuadx	r5, r4, r12
	smladx	r5, r3, r14, r5
	smuadx	r7, r4, r14
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smuad	r6, r3, r14
	smlatt	r6, r4, r12, r6
	smultt	r8, r4, r14
	// block (0,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #0]
	ldr	r4, [r0, #4]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r9, r10, r3, r12, r14
	mr_16x2	r11, r5, r3, r12, r14
	str	r9, [r2], #4
	str	r11, [r2], #4
	ldr	r3, [r0, #0]
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	// block (0,2)
	smladx	r7, r3, r12, r7
	smuadx	r9, r4, r12
	smladx	r9, r3, r14, r9
	smuadx	r11, r4, r14
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smuad	r10, r3, r14
	smlatt	r10, r4, r12, r10
	smultt	r5, r4, r14
	// block (1,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	// block (2,0)
	ldr	r12, [r1, #0]
	ldr	r14, [r1, #4]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r6, r7, r3, r12, r4
	mr_16x2	r8, r9, r3, r12, r4
	str	r6, [r2], #4
	str	r8, [r2], #4
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	ldr	r12, [r1, #0]
	// block (3,0)
	smladx	r11, r3, r12, r11
	smuadx	r6, r4, r12
	smladx	r6, r3, r14, r6
	smuadx	r8, r4, r14
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smuad	r7, r3, r14
	smlatt	r7, r4, r12, r7
	smultt	r9, r4, r14
	// block (2,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	// block (1,2)
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	// block (0,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #0]
	ldr	r4, [r0, #4]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r10, r11, r3, r12, r14
	mr_16x2	r5, r6, r3, r12, r14
	str	r10, [r2], #4
	str	r5, [r2], #4
	ldr	r3, [r0, #0]
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	// block (0,4)
	smladx	r8, r3, r12, r8
	smuadx	r10, r4, r12
	smladx	r10, r3, r14, r10
	smuadx	r5, r4, r14
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smuad	r11, r3, r14
	smlatt	r11, r4, r12, r11
	smultt	r6, r4, r14
	// block (1,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	// block (2,2)
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	// block (3,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	// block (4,0)
	ldr	r12, [r1, #0]
	ldr	r14, [r1, #4]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r7, r8, r3, r12, r4
	mr_16x2	r9, r10, r3, r12, r4
	str	r7, [r2], #4
	str	r9, [r2], #4
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	ldr	r12, [r1, #0]
	// block (5,0)
	smladx	r5, r3, r12, r5
	smuadx	r7, r4, r12
	smladx	r7, r3, r14, r7
	smuadx	r9, r4, r14
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smuad	r8, r3, r14
	smlatt	r8, r4, r12, r8
	smultt	r10, r4, r14
	// block (4,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	// block (3,2)
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	// block (2,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	// block (1,4)
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	// block (0,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #0]
	ldr	r4, [r0, #4]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r11, r5, r3, r12, r14
	mr_16x2	r6, r7, r3, r12, r14
	str	r11, [r2], #4
	str	r6, [r2], #4
	ldr	r3, [r0, #0]
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	// block (0,6)
	smladx	r9, r3, r12, r9
	smuadx	r11, r4, r12
	smladx	r11, r3, r14, r11
	smuadx	r6, r4, r14
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smuad	r5, r3, r14
	smlatt	r5, r4, r12, r5
	smultt	r7, r4, r14
	// block (1,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	// block (2,4)
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	// block (3,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	// block (4,2)
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	// block (5,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	// block (6,0)
	ldr	r12, [r1, #0]
	ldr	r14, [r1, #4]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r8, r9, r3, r12, r4
	mr_16x2	r10, r11, r3, r12, r4
	str	r8, [r2], #4
	str	r10, [r2], #4
	ldr	r3, [r0, #56]
	ldr	r4, [r0, #60]
	ldr	r12, [r1, #0]
	// block (7,0)
	smladx	r6, r3, r12, r6
	smuadx	r8, r4, r12
	smladx	r8, r3, r14, r8
	smuadx	r10, r4, r14
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smuad	r9, r3, r14
	smlatt	r9, r4, r12, r9
	smultt	r11, r4, r14
	// block (6,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	// block (5,2)
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	// block (4,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	// block (3,4)
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	// block (2,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	// block (1,6)
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	// block (0,7)
	ldr	r12, [r1, #56]
	ldr	r14, [r1, #60]
	ldr	r3, [r0, #0]
	ldr	r4, [r0, #4]
	smladx	r6, r3, r12, r6
	smladx	r8, r4, r12, r8
	smladx	r8, r3, r14, r8
	smladx	r10, r4, r14, r10
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smlad	r9, r3, r14, r9
	smlatt	r9, r4, r12, r9
	smlatt	r11, r4, r14, r11
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r5, r6, r3, r12, r4
	mr_16x2	r7, r8, r3, r12, r4
	str	r5, [r2], #4
	str	r7, [r2], #4
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	ldr	r12, [r1, #56]
	// block (1,7)
	smladx	r10, r3, r12, r10
	smuadx	r5, r4, r12
	smladx	r5, r3, r14, r5
	smuadx	r7, r4, r14
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smuad	r6, r3, r14
	smlatt	r6, r4, r12, r6
	smultt	r8, r4, r14
	// block (2,6)
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	// block (3,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	// block (4,4)
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	// block (5,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	// block (6,2)
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	// block (7,1)
	ldr	r12, [r1, #8]
	ldr	r14, [r1, #12]
	ldr	r3, [r0, #56]
	ldr	r4, [r0, #60]
	smladx	r10, r3, r12, r10
	smladx	r5, r4, r12, r5
	smladx	r5, r3, r14, r5
	smladx	r7, r4, r14, r7
	smlabb	r9, r3, r12, r9
	smlabb	r11, r3, r14, r11
	pkhtb	r3, r3, r4
	smlad	r11, r3, r12, r11
	smlad	r6, r3, r14, r6
	smlatt	r6, r4, r12, r6
	smlatt	r8, r4, r14, r8
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r9, r10, r3, r12, r14
	mr_16x2	r11, r5, r3, r12, r14
	str	r9, [r2], #4
	str	r11, [r2], #4
	ldr	r3, [r0, #56]
	ldr	r12, [r1, #16]
	ldr	r14, [r1, #20]
	// block (7,2)
	smladx	r7, r3, r12, r7
	smuadx	r9, r4, r12
	smladx	r9, r3, r14, r9
	smuadx	r11, r4, r14
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smuad	r10, r3, r14
	smlatt	r10, r4, r12, r10
	smultt	r5, r4, r14
	// block (6,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	// block (5,4)
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	// block (4,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	// block (3,6)
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	// block (2,7)
	ldr	r12, [r1, #56]
	ldr	r14, [r1, #60]
	ldr	r3, [r0, #16]
	ldr	r4, [r0, #20]
	smladx	r7, r3, r12, r7
	smladx	r9, r4, r12, r9
	smladx	r9, r3, r14, r9
	smladx	r11, r4, r14, r11
	smlabb	r6, r3, r12, r6
	smlabb	r8, r3, r14, r8
	pkhtb	r3, r3, r4
	smlad	r8, r3, r12, r8
	smlad	r10, r3, r14, r10
	smlatt	r10, r4, r12, r10
	smlatt	r5, r4, r14, r5
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r6, r7, r3, r12, r4
	mr_16x2	r8, r9, r3, r12, r4
	str	r6, [r2], #4
	str	r8, [r2], #4
	ldr	r3, [r0, #24]
	ldr	r4, [r0, #28]
	ldr	r12, [r1, #56]
	// block (3,7)
	smladx	r11, r3, r12, r11
	smuadx	r6, r4, r12
	smladx	r6, r3, r14, r6
	smuadx	r8, r4, r14
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smuad	r7, r3, r14
	smlatt	r7, r4, r12, r7
	smultt	r9, r4, r14
	// block (4,6)
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	// block (5,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	// block (6,4)
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	// block (7,3)
	ldr	r12, [r1, #24]
	ldr	r14, [r1, #28]
	ldr	r3, [r0, #56]
	ldr	r4, [r0, #60]
	smladx	r11, r3, r12, r11
	smladx	r6, r4, r12, r6
	smladx	r6, r3, r14, r6
	smladx	r8, r4, r14, r8
	smlabb	r10, r3, r12, r10
	smlabb	r5, r3, r14, r5
	pkhtb	r3, r3, r4
	smlad	r5, r3, r12, r5
	smlad	r7, r3, r14, r7
	smlatt	r7, r4, r12, r7
	smlatt	r9, r4, r14, r9
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r10, r11, r3, r12, r14
	mr_16x2	r5, r6, r3, r12, r14
	str	r10, [r2], #4
	str	r5, [r2], #4
	ldr	r3, [r0, #56]
	ldr	r12, [r1, #32]
	ldr	r14, [r1, #36]
	// block (7,4)
	smladx	r8, r3, r12, r8
	smuadx	r10, r4, r12
	smladx	r10, r3, r14, r10
	smuadx	r5, r4, r14
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smuad	r11, r3, r14
	smlatt	r11, r4, r12, r11
	smultt	r6, r4, r14
	// block (6,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	// block (5,6)
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	// block (4,7)
	ldr	r12, [r1, #56]
	ldr	r14, [r1, #60]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #36]
	smladx	r8, r3, r12, r8
	smladx	r10, r4, r12, r10
	smladx	r10, r3, r14, r10
	smladx	r5, r4, r14, r5
	smlabb	r7, r3, r12, r7
	smlabb	r9, r3, r14, r9
	pkhtb	r3, r3, r4
	smlad	r9, r3, r12, r9
	smlad	r11, r3, r14, r11
	smlatt	r11, r4, r12, r11
	smlatt	r6, r4, r14, r6
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r7, r8, r3, r12, r4
	mr_16x2	r9, r10, r3, r12, r4
	str	r7, [r2], #4
	str	r9, [r2], #4
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #44]
	ldr	r12, [r1, #56]
	// block (5,7)
	smladx	r5, r3, r12, r5
	smuadx	r7, r4, r12
	smladx	r7, r3, r14, r7
	smuadx	r9, r4, r14
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smuad	r8, r3, r14
	smlatt	r8, r4, r12, r8
	smultt	r10, r4, r14
	// block (6,6)
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	// block (7,5)
	ldr	r12, [r1, #40]
	ldr	r14, [r1, #44]
	ldr	r3, [r0, #56]
	ldr	r4, [r0, #60]
	smladx	r5, r3, r12, r5
	smladx	r7, r4, r12, r7
	smladx	r7, r3, r14, r7
	smladx	r9, r4, r14, r9
	smlabb	r11, r3, r12, r11
	smlabb	r6, r3, r14, r6
	pkhtb	r3, r3, r4
	smlad	r6, r3, r12, r6
	smlad	r8, r3, r14, r8
	smlatt	r8, r4, r12, r8
	smlatt	r10, r4, r14, r10
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r11, r5, r3, r12, r14
	mr_16x2	r6, r7, r3, r12, r14
	str	r11, [r2], #4
	str	r6, [r2], #4
	ldr	r3, [r0, #56]
	ldr	r12, [r1, #48]
	ldr	r14, [r1, #52]
	// block (7,6)
	smladx	r9, r3, r12, r9
	smuadx	r11, r4, r12
	smladx	r11, r3, r14, r11
	smuadx	r6, r4, r14
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smuad	r5, r3, r14
	smlatt	r5, r4, r12, r5
	smultt	r7, r4, r14
	// block (6,7)
	ldr	r12, [r1, #56]
	ldr	r14, [r1, #60]
	ldr	r3, [r0, #48]
	ldr	r4, [r0, #52]
	smladx	r9, r3, r12, r9
	smladx	r11, r4, r12, r11
	smladx	r11, r3, r14, r11
	smladx	r6, r4, r14, r6
	smlabb	r8, r3, r12, r8
	smlabb	r10, r3, r14, r10
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smlad	r5, r3, r14, r5
	smlatt	r5, r4, r12, r5
	smlatt	r7, r4, r14, r7
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r8, r9, r3, r12, r4
	mr_16x2	r10, r11, r3, r12, r4
	str	r8, [r2], #4
	str	r10, [r2], #4
	ldr	r3, [r0, #56]
	ldr	r4, [r0, #60]
	ldr	r12, [r1, #56]
	// block (7,7)
	smladx	r6, r3, r12, r6
	smuadx	r8, r4, r12
	smladx	r8, r3, r14, r8
	smuadx	r10, r4, r14
	smlabb	r5, r3, r12, r5
	smlabb	r7, r3, r14, r7
	pkhtb	r3, r3, r4
	smlad	r7, r3, r12, r7
	smuad	r9, r3, r14
	smlatt	r9, r4, r12, r9
	smultt	r11, r4, r14
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r5, r6, r3, r12, r4
	mr_16x2	r7, r8, r3, r12, r4
	str	r5, [r2], #4
	str	r7, [r2], #4
	mr_16x2	r9, r10, r3, r12, r4
	mr_hi	r11, r3, r12, r4
	lsr	r11, #16
	str	r9, [r2], #4
	str	r11, [r2], #4
	add	r0, #64
	add	r1, #64
	vmov	r14, s17	// counter=scr0
	subs	r14, #1
	bne	T128x6_muls1
T128x6_collect:
	vmov	r2, s3	// reload hh
	vmov	r3, s4	// reload overflow list
T128x6_col_32_ov:			// no overflow
T128x6_col_32_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r11, #32	// N0
T128x6_col_32_add1:	// begin KA collect loop
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
	beq	T128x6_col_32_end
	subs	r11, r11, #4
	ittt	eq		// then next 16 bloc
	addeq	r1, r1, #192
	addeq	r12, r12, #64
	moveq	r11, #32	// N0
	b	T128x6_col_32_add1
T128x6_col_32_end:
T128x6_col_64_ov:
	vmov	r0, s8	// load -q
	vmov	r1, s7	// load qinv32
	mov	r6, #32768
	mov	r12, 0	// pointer to data
T128x6_col_64_ov1:
	ldrsh	r4, [r3], #2	// bound
	cmp	r4, #-1
	beq	T128x6_col_64_add
	ldrsh	r11, [r3], #2	// r11 : count of a[2] entries
	ldrsh	r5, [r3], #2	// offset
	add	r12, r12, r5
	cmp	r11, #0
	bne	T128x6_col_64_ov2
	mov	r12, r4		// empty set of intervals
	b	T128x6_col_64_ov1
T128x6_col_64_ov2:
	asr	r5, r11, #1	// r5 : number of intervals
T128x6_col_64_ov3:
	ldrsh	r10, [r3], #2	// size of interval
T128x6_col_64_ov4:
	ldr	r8, [r2, r12, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r12, LSL #2]
	add	r12, r12, #1
	subs	r10, r10, #1
	bgt	T128x6_col_64_ov4
	ldrsh	r10, [r3], #2	// offset
	add	r12, r12, r10
	subs	r5, r5, #1	// last interval?
	bgt	T128x6_col_64_ov3
	cmp	r12, r4		// am I above the bound?
	bge	T128x6_col_64_ov1
	sub	r3, r3, r11, LSL #1	// roll back
	b	T128x6_col_64_ov2
T128x6_col_64_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r10, #64		// N0
	mov	r0, #128			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
T128x6_col_64_add1:	// begin KA collect loop
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
	beq	T128x6_col_64_end
	subs	r10, #2
	ittt	eq
	addeq	r1, r1, r11		//+6*N0
	addeq	r12, r12, r0		//+2*N0
	moveq	r10, #64		// N0
	b	T128x6_col_64_add1
T128x6_col_64_end:
T128x6_mv_back:
	vmov	r0, s0	// reload h
	vmov	r1, s3	// reload hh
	mov	r14, #512
T128x6_mv_back_loop:
	ldm	r1!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x6_mv_back_loop
	mov	r14, #2048
	mov	r4, #0
	mov	r5, #0
	mov	r6, #0
	mov	r7, #0
	mov	r8, #0
	mov	r9, #0
	mov	r10, #0
	mov	r11, #0
T128x6_clear_loop:
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x6_clear_loop
	mov	r14, #512
T128x6_mv_back_loop1:
	ldm	r1!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x6_mv_back_loop1
T128x6_gather:
	vmov	r0, s0	// reload h
	vmov	r1, s3	// reload hh
	add	r0, #256
	mov	r12, #512
	vmov	r11, s7	// load round(2^32/q)
	vmov	r7, s8	// load -q
T128x6_gather1:	// load X array
	vmov	r9, s10	// pointer to X array
	mov	r14, #0
T128x6_gather2:
	ldr	r8, [r1, r14]	// load next of set
	str	r8, [r9], #4	// save to temp X array, point
	add	r14, r14, #512	// add 4N size of set
	cmp	r14, #5632	// (2l-1)*4N
	bne	T128x6_gather2
	vmov	r9, s10	// X array, loaded with a set
	vmov	r10, s16	// load T6 matrix 2
	mov	r2, #0		// counter j
T128x6_gather3:
	ldr	r6, [r0, r2]
	sxth	r4, r6
	asr	r5, r6, #16
	mov	r3, #0		// counter k
T128x6_gather4:
	ldrsh	r14, [r10], #2	// MAT1[j][k]
	ldr	r8, [r9, r3, LSL #2]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	add	r3, #1
	cmp	r3, #11
	bcc	T128x6_gather4
	br_32	r4, r7, r11, r6
	br_32	r5, r7, r11, r6
	pkhbt	r4, r4, r5, LSL #16
	str	r4, [r0, r2]
	add	r2, r2, #256
	cmp	r2, #2304
	bne	T128x6_gather3
	add	r0, #4		// incr src
	add	r1, #4		// incr dst
	subs	r12, #4		// decr counter
	bne	T128x6_gather1
T128x6_end:
	vmov	r12, s1	// load 2M
	add	sp, sp, r12, LSL #2	// add back 25344 = 8M
	add	sp, sp, #96		// temp space 8*l
	vpop	{s16-s31}
	pop	{r4-r11,lr}
	bx	lr

