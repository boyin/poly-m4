#include "red-asm.h"
// N,l=64,4 requires 12096=8x7x216 storage

#include "polymul_256x256_T4_B8_aux.h"
	.p2align	2,,3	
// void gf_polymul_256x256_divR (int32_t *h, int32_t *f, int32_t *g);
	.syntax		unified
	.text
	.global gf_polymul_256x256_divR
	.type	gf_polymul_256x256_divR, %function
gf_polymul_256x256_divR:
	push	{r4-r11,lr}
	vpush	{s16-s31}
T64x4_saves:
	vmov	s0, r0	// // save h
	vmov	s11, r1	// // save f
	vmov	s12, r2	// // save g
	movw	r12, #3024	// r12=2M
	sub	sp, sp, #64	// 4*2*l hwords
	mov	r3, sp
	vmov	s10, r3	// save pointer to temp space
	sub	sp, sp, r12, LSL #2	// subtract 12096 = 8M
		// ff=[sp], gg=[sp,#3024], hh=[sp,#6048]
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+3024(=2M)
	vmov	s1, r12	// save 2M
	vmov	s2, r0	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+3024(=2M)
	vmov	s3, r14	// save h
	ldr	r14, =T_exp_ov_64
	ldr	r11, =T4_Mat2
	ldr	r12, =T4_Mat1
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
T64x4_begin:
	mov	r14, #128
T64x4_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T64x4_mv_loop
	// r1 = f+N/W, r2 = g+N/W, r3 = ff+N/W, r0 = gg+N/W
	add	r1, #256		// r1=f+(l-2)N/W
	add	r2, #256		// r2=g+(l-2)N/W
	mov	r14, #128
T64x4_mv_loop1:
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T64x4_mv_loop1
	// r3 = ff+2*N/W, r0 = gg+2*N/W
	b	T64x4_split

T64x4_split_sub:	// use twice, r0 = src, r1 = dst
	vmov	s13, r14	// first, save link to scratch
	add	r1, r1, #256
	mov	r12, #128	// counter
	vmov	r11, s7	// load round(2^32/q)
	vmov	r7, s8	// load -q
T64x4_split_sub1:
	mov	r14, #0
	vmov	r9, s10	// pointer to X array
	mov	r5, #0
	mov	r6, #0
T64x4_split_sub2:
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #0]	// save to temp array
	sadd16	r5, r5, r8
	add	r14, r14, #128	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #4]	// save to temp array
	sadd16	r6, r6, r8
	add	r14, r14, #128	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #8]	// save to temp array
	sadd16	r5, r5, r8
	add	r14, r14, #128	// add 2N size of set
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9, #12]	// save to temp array
	sadd16	r6, r6, r8
	sadd16	r4, r5, r6
	ssub16	r5, r5, r6
	mov	r3, #32768
	br_16x2	r4, r7, r11, r3, r6, r10
	br_16x2	r5, r7, r11, r3, r6, r10
	vmov	r10, s15	// load T4 matrix 1
	str	r4, [r1]
	mov	r2, #128		// counter j
	str	r5, [r1, r2]
	add	r2, r2, #128	// counter j
T64x4_split_sub3:
	ldrsh	r14, [r10], #2	// MAT1[j][0]
	ldr	r8, [r9]		// X[0]
	smulbb	r4, r14, r8
	smulbt	r5, r14, r8
	ldrsh	r14, [r10], #2	// MAT1[j][1]
	ldr	r8, [r9, #4]		// X[1]
	smulbb	r3, r14, r8
	smulbt	r6, r14, r8
T64x4_split_sub4:
	ldrsh	r14, [r10], #2	// MAT1[j][2]
	ldr	r8, [r9, #8]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	ldrsh	r14, [r10], #2	// MAT1[j][3]
	ldr	r8, [r9, #12]	// X[k]
	smlabb	r3, r14, r8, r3
	smlabt	r6, r14, r8, r6
	add	r8, r4, r3	// row j
	cmp	r2, #512
	bcs	T64x4_split_sub5
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
	add	r2, #128
	str	r3, [r1, r2]
	add	r2, #128
	b	T64x4_split_sub3
T64x4_split_sub5:
	add	r4, r5, r6	// row j
	br_32	r8, r7, r11, r6
	br_32	r4, r7, r11, r6
	pkhbt	r8, r8, r4, LSL #16
	str	r8, [r1, r2]
	add	r0, #4		// incr src
	add	r1, #4		// incr dst
	subs	r12, #4		// decr counter
	bne	T64x4_split_sub1
	vmov	r14, s13	// load original return addr
	bx	lr		// return

T64x4_split:
	vmov	r0, s11	// f
	mov	r1, sp		// ff
	bl	T64x4_split_sub
	vmov	r0, s12	// g
	vmov	r1, s2	// gg
	bl	T64x4_split_sub
T64x4_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	vmov	r12, s1	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #64		// N0 = r2 = N
	vmov	r3, s4	// load list to reduce
T64x4_exp_loop1:		// loop on N0
	cmp	r2, #8		// while (N0>B)
	beq	T64x4_exp_end1
T64x4_exp_reduce:		// reduce ff[], gg[]
	ldrsh	r4, [r3], #2	// list entry
	cmp	r4, #-1		// end of this list?
	beq	T64x4_exp_adds	// only if -1 end
	vmov	r6, s8	// load -q
	vmov	r7, s7	// load q32inv
	mov	r10, #32768	// load 2^15
T64x4_exp_red1:
	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]
T64x4_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	T64x4_exp_red2	// loop (r4)
	ldrsh	r4, [r3], #2	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	T64x4_exp_red1
T64x4_exp_adds:
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
T64x4_exp_adds1:
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
	beq	T64x4_exp_end
	adds	r12, r12, #8
	ittt	eq
	subeq	r0, r0, r2
	subeq	r1, r1, r2
	moveq	r12, r2		// reload with N0
	b	T64x4_exp_adds1
T64x4_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	vmov	r1, s2	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	T64x4_exp_loop1	// loop
T64x4_exp_end1:

T64x4_mul:
  // check multiplicative overflow (pre-mult size > q_mb=15799)
T64x4_mul_ov:
	ldrsh	r2, [r3], #2
	cmp	r2, #-1		// multiplicative overflow?
	beq	T64x4_muls
	mov	r8, #32768
	vmov	r6, s8	// load -q
	vmov	r7, s7	// load round(2^32/q)
T64x4_mul_ov1:
	ldrsh	r11, [r3], #2
T64x4_mul_ov2:
	ldr	r4, [r0, r2, LSL #2]
	ldr	r5, [r1, r2, LSL #2]
	br_16x2	r4, r6, r7, r8, r9, r10
	br_16x2 r5, r6, r7, r8, r9, r10
	str	r4, [r0, r2, LSL #2]
	str	r5, [r1, r2, LSL #2]
	add	r2, r2, #1
	cmp	r2, r11
	bls	T64x4_mul_ov2
	ldrsh	r2, [r3], #2
	cmp	r2, -1
	bne	T64x4_mul_ov1
T64x4_muls:
	ldrsh	r14, [r3], #2	// r14 = N1/B
	vmov	s4, r3	// save overflow list pointer
	vmov	r2, s3	// load r2 = hh
T64x4_muls1:
	vmov	s17, r14	// save counter to scr0
	//generated by SCH_polymul_NxN(8,r0,r1,r2,s8,s6,0)
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
	mr_16x2	r9, r10, r3, r12, r4
	mr_16x2	r11, r5, r3, r12, r4
	str	r9, [r2], #4
	str	r11, [r2], #4
	ldr	r3, [r0, #8]
	ldr	r4, [r0, #12]
	ldr	r12, [r1, #8]
	// block (1,1)
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
	vmov	r3, s8  // load -q
	vmov	r12, s6  // load qinv
	mr_16x2	r6, r7, r3, r12, r4
	mr_16x2	r8, r9, r3, r12, r4
	str	r6, [r2], #4
	str	r8, [r2], #4
	mr_16x2	r10, r11, r3, r12, r4
	mr_hi	r5, r3, r12, r4
	lsr	r5, #16
	str	r10, [r2], #4
	str	r5, [r2], #4
	add	r0, #16
	add	r1, #16
	vmov	r14, s17	// counter=scr0
	subs	r14, #1
	bne	T64x4_muls1
T64x4_collect:
	vmov	r2, s3	// reload hh
	vmov	r3, s4	// reload overflow list
T64x4_col_8_ov:			// no overflow
T64x4_col_8_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r11, #8	// N0
T64x4_col_8_add1:	// begin KA collect loop
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
	beq	T64x4_col_8_end
	subs	r11, r11, #4
	ittt	eq		// then next 4 bloc
	addeq	r1, r1, #48
	addeq	r12, r12, #16
	moveq	r11, #8	// N0
	b	T64x4_col_8_add1
T64x4_col_8_end:
T64x4_col_16_ov:
	vmov	r0, s8	// load -q
	vmov	r1, s7	// load qinv32
	mov	r6, #32768
	mov	r12, 0	// pointer to data
T64x4_col_16_ov1:
	ldrsh	r4, [r3], #2	// bound
	cmp	r4, #-1
	beq	T64x4_col_16_add
	ldrsh	r11, [r3], #2	// r11 : count of a[2] entries
	ldrsh	r5, [r3], #2	// offset
	add	r12, r12, r5
	cmp	r11, #0
	bne	T64x4_col_16_ov2
	mov	r12, r4		// empty set of intervals
	b	T64x4_col_16_ov1
T64x4_col_16_ov2:
	asr	r5, r11, #1	// r5 : number of intervals
T64x4_col_16_ov3:
	ldrsh	r10, [r3], #2	// size of interval
T64x4_col_16_ov4:
	ldr	r8, [r2, r12, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r12, LSL #2]
	add	r12, r12, #1
	subs	r10, r10, #1
	bgt	T64x4_col_16_ov4
	ldrsh	r10, [r3], #2	// offset
	add	r12, r12, r10
	subs	r5, r5, #1	// last interval?
	bgt	T64x4_col_16_ov3
	cmp	r12, r4		// am I above the bound?
	bge	T64x4_col_16_ov1
	sub	r3, r3, r11, LSL #1	// roll back
	b	T64x4_col_16_ov2
T64x4_col_16_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r11, #16	// N0
T64x4_col_16_add1:	// begin KA collect loop
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
	beq	T64x4_col_16_end
	subs	r11, r11, #4
	ittt	eq		// then next 8 bloc
	addeq	r1, r1, #96
	addeq	r12, r12, #32
	moveq	r11, #16	// N0
	b	T64x4_col_16_add1
T64x4_col_16_end:
T64x4_col_32_ov:
	vmov	r0, s8	// load -q
	vmov	r1, s7	// load qinv32
	mov	r6, #32768
	mov	r12, 0	// pointer to data
T64x4_col_32_ov1:
	ldrsh	r4, [r3], #2	// bound
	cmp	r4, #-1
	beq	T64x4_col_32_add
	ldrsh	r11, [r3], #2	// r11 : count of a[2] entries
	ldrsh	r5, [r3], #2	// offset
	add	r12, r12, r5
	cmp	r11, #0
	bne	T64x4_col_32_ov2
	mov	r12, r4		// empty set of intervals
	b	T64x4_col_32_ov1
T64x4_col_32_ov2:
	asr	r5, r11, #1	// r5 : number of intervals
T64x4_col_32_ov3:
	ldrsh	r10, [r3], #2	// size of interval
T64x4_col_32_ov4:
	ldr	r8, [r2, r12, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r12, LSL #2]
	add	r12, r12, #1
	subs	r10, r10, #1
	bgt	T64x4_col_32_ov4
	ldrsh	r10, [r3], #2	// offset
	add	r12, r12, r10
	subs	r5, r5, #1	// last interval?
	bgt	T64x4_col_32_ov3
	cmp	r12, r4		// am I above the bound?
	bge	T64x4_col_32_ov1
	sub	r3, r3, r11, LSL #1	// roll back
	b	T64x4_col_32_ov2
T64x4_col_32_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r11, #32	// N0
T64x4_col_32_add1:	// begin KA collect loop
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
	beq	T64x4_col_32_end
	subs	r11, r11, #4
	ittt	eq		// then next 16 bloc
	addeq	r1, r1, #192
	addeq	r12, r12, #64
	moveq	r11, #32	// N0
	b	T64x4_col_32_add1
T64x4_col_32_end:
T64x4_mv_back:
	vmov	r0, s0	// reload h
	vmov	r1, s3	// reload hh
	mov	r14, #256
T64x4_mv_back_loop:
	ldm	r1!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T64x4_mv_back_loop
	mov	r14, #512
	mov	r4, #0
	mov	r5, #0
	mov	r6, #0
	mov	r7, #0
	mov	r8, #0
	mov	r9, #0
	mov	r10, #0
	mov	r11, #0
T64x4_clear_loop:
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T64x4_clear_loop
	mov	r14, #256
T64x4_mv_back_loop1:
	ldm	r1!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T64x4_mv_back_loop1
T64x4_gather:
	vmov	r0, s0	// reload h
	vmov	r1, s3	// reload hh
	add	r0, #128
	mov	r12, #256
	vmov	r11, s7	// load round(2^32/q)
	vmov	r7, s8	// load -q
T64x4_gather1:	// load X array
	vmov	r9, s10	// pointer to X array
	mov	r14, #0
T64x4_gather2:
	ldr	r8, [r1, r14]	// load next of set
	str	r8, [r9], #4	// save to temp X array, point
	add	r14, r14, #256	// add 4N size of set
	cmp	r14, #1792	// (2l-1)*4N
	bne	T64x4_gather2
	vmov	r9, s10	// X array, loaded with a set
	vmov	r10, s16	// load T4 matrix 2
	mov	r2, #0		// counter j
T64x4_gather3:
	ldr	r6, [r0, r2]
	sxth	r4, r6
	asr	r5, r6, #16
	mov	r3, #0		// counter k
T64x4_gather4:
	ldrsh	r14, [r10], #2	// MAT1[j][k]
	ldr	r8, [r9, r3, LSL #2]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	add	r3, #1
	cmp	r3, #7
	bcc	T64x4_gather4
	br_32	r4, r7, r11, r6
	br_32	r5, r7, r11, r6
	pkhbt	r4, r4, r5, LSL #16
	str	r4, [r0, r2]
	add	r2, r2, #128
	cmp	r2, #640
	bne	T64x4_gather3
	add	r0, #4		// incr src
	add	r1, #4		// incr dst
	subs	r12, #4		// decr counter
	bne	T64x4_gather1
T64x4_end:
	vmov	r12, s1	// load 2M
	add	sp, sp, r12, LSL #2	// add back 12096 = 8M
	add	sp, sp, #64		// temp space 8*l
	vpop	{s16-s31}
	pop	{r4-r11,lr}
	bx	lr

