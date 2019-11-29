#include "red-asm.h"
// N,l=128,4 requires 36288=8x7x648 storage

#include "polymul_512x512_T4_B8_aux.h"
	.p2align	2,,3	
// void gf_polymul_512x512_divR (int32_t *h, int32_t *f, int32_t *g);
	.syntax		unified
	.text
	.global gf_polymul_512x512_divR
	.type	gf_polymul_512x512_divR, %function
gf_polymul_512x512_divR:
	push	{r4-r11,lr}
	vpush	{s16-s31}
T128x4_saves:
	vmov	s0, r0	// // save h
	vmov	s11, r1	// // save f
	vmov	s12, r2	// // save g
	ldr	r12, =9072	// r12=2M
	sub	sp, sp, #64	// 4*2*l hwords
	vmov	s10, sp	// save pointer to temp space
	sub	sp, sp, r12, LSL #2	// subtract 36288 = 8M
		// ff=[sp], gg=[sp,#9072], hh=[sp,#18144]
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+9072(=2M)
	vmov	s1, r12	// save 2M
	vmov	s2, r0	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+9072(=2M)
	vmov	s3, r14	// save h
	ldr	r14, =T_exp_ov_128
	vmov	s4, r14	// save ov pointer
	ldr	r12, =T4_Mat1
	vmov	s15, r12	// save Matrix 1
	ldr	r14, =T4_Mat2
	vmov	s16, r14	// save Matrix 2
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
T128x4_begin:
	mov	r14, #256
T128x4_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x4_mv_loop
	// r1 = f+N/W, r2 = g+N/W, r3 = ff+N/W, r0 = gg+N/W
	add	r1, #512		// r1=f+(l-2)N/W
	add	r2, #512		// r2=g+(l-2)N/W
	mov	r14, #256
T128x4_mv_loop1:
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x4_mv_loop1
	// r3 = ff+2*N/W, r0 = gg+2*N/W
	b	T128x4_split

T128x4_split_sub:	// use twice, r0 = src, r1 = dst
	vmov	s13, r14	// first, save link to scratch
	add	r1, r1, #512
	vmov	s14, r1	// save destination pointer
	mov	r12, #256	// counter
	vmov	r11, s7	// load round(2^32/q)
	vmov	r7, s8	// load -q
T128x4_split_sub1:
	mov	r14, #0
	vmov	r9, s10	// pointer to X array
T128x4_split_sub2:
	ldr	r8, [r0, r14]	// load next of set
	str	r8, [r9], #4	// save to temp array, point
	add	r14, r14, #256	// add 2N size of set
	cmp	r14, #1024	// compare to 2T
	bne	T128x4_split_sub2
	vmov	r9, s10	// X array, loaded with a set
	vmov	r10, s15	// load T4 matrix 1
	mov	r2, #0		// counter j
T128x4_split_sub3:
	ldrsh	r14, [r10], #2	// MAT1[j][0]
	ldr	r8, [r9]		// X[0]
	smulbb	r4, r14, r8
	smulbt	r5, r14, r8
	mov	r3, #1		// counter k
T128x4_split_sub4:
	ldrsh	r14, [r10], #2	// MAT1[j][k]
	ldr	r8, [r9, r3, LSL #2]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	add	r3, #1
	cmp	r3, #4
	bcc	T128x4_split_sub4
	br_32	r4, r7, r11, r6
	br_32	r5, r7, r11, r6
	pkhbt	r4, r4, r5, LSL #16
	str	r4, [r1, r2]
	add	r2, #256
	cmp	r2, #1280
	bcc	T128x4_split_sub3
	add	r0, #4		// incr src
	add	r1, #4		// incr dst
	subs	r12, #4		// decr counter
	bne	T128x4_split_sub1
	vmov	r14, s13	// load original return addr
	bx	lr		// return

T128x4_split:
	vmov	r0, s11	// f
	mov	r1, sp		// ff
	bl	T128x4_split_sub
	vmov	r0, s12	// g
	vmov	r1, s2	// gg
	bl	T128x4_split_sub
T128x4_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	vmov	r12, s1	// reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #128		// N0 = r2 = N
	vmov	r3, s4	// load list to reduce
T128x4_exp_loop1:		// loop on N0
	cmp	r2, #8		// while (N0>B)
	beq	T128x4_exp_end1
T128x4_exp_reduce:		// reduce ff[], gg[]
	ldrsh	r4, [r3], #2	// list entry
	cmp	r4, #-1		// end of this list?
	beq	T128x4_exp_adds	// only if -1 end
	vmov	r6, s8	// load -q
	vmov	r7, s7	// load q32inv
	mov	r10, #32768	// load 2^15
T128x4_exp_red1:
	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]
T128x4_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	br_16x2	r9, r6, r7, r10, r11, r12
	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	T128x4_exp_red2	// loop (r4)
	ldrsh	r4, [r3], #2	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	T128x4_exp_red1
T128x4_exp_adds:
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
T128x4_exp_adds1:
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
	beq	T128x4_exp_end
	bics	r7, r4, r2, ASR #2
	itt	eq
	subeq	r0, r0, r2
	subeq	r1, r1, r2
	b	T128x4_exp_adds1
T128x4_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	vmov	r1, s2	// reload gg

	lsr	r2, #1 		// N0 /= 2
	b	T128x4_exp_loop1	// loop
T128x4_exp_end1:

T128x4_mul:
  // check multiplicative overflow (pre-mult size > q_mb=15799)
	vmov	r6, s8	// load -q
	vmov	r7, s7	// load round(2^32/q)
	mov	r8, #32768
T128x4_mul_ov:
	ldrsh	r2, [r3], #2
	cmp	r2, #-1		// multiplicative overflow?
	beq	T128x4_muls
	ldr	r4, [r0, r2, LSL #2]
	ldr	r5, [r1, r2, LSL #2]
	br_16x2	r4, r6, r7, r8, r9, r10
	br_16x2 r5, r6, r7, r8, r9, r10
	str	r4, [r0, r2, LSL #2]
	str	r5, [r1, r2, LSL #2]
	b	T128x4_mul_ov
T128x4_muls:
	ldrsh	r14, [r3], #2	// r14 = N1/B
	vmov	s4, r3	// save overflow list pointer
	vmov	r2, s3	// load r2 = hh
T128x4_muls1:
	// begin polymul_8x8_divR
	ldr	r5, [r0, #4]		// f23
	ldr	r6, [r0, #8]		// f45
	ldr	r7, [r0, #12]		// f67
	ldr	r4, [r0],#16		// f01
	ldr	r9, [r1, #4]		// g23
	ldr	r10, [r1, #8]		// g45
	ldr	r11, [r1, #12]		// g67
	ldr	r8, [r1],#16		// g01
	vmov	s17, r14	// scr0=count
	smulbb	r12, r4, r8
	smuadx	r14, r4, r8
	vmov	s18, r12	// scr1=h0
	vmov	s19, r14	// scr2=h1
	smuadx	r12, r4, r9
	smladx	r12, r5, r8, r12
	smuadx	r14, r4, r10
	smladx	r14, r5, r9, r14
	smladx	r14, r6, r8, r14
	vmov	s20, r12	// scr3=h3
	vmov	s21, r14	// scr4=h5
	smuadx	r12, r4, r11
	smladx	r12, r5, r10, r12
	smladx	r12, r6, r9, r12
	smladx	r12, r7, r8, r12
	smuadx	r14, r5, r11
	smladx	r14, r6, r10, r14
	smladx	r14, r7, r9, r14
	vmov	s22, r12	// scr5=h7
	vmov	s23, r14	// scr6=h9
	smuadx	r12, r6, r11
	smladx	r12, r7, r10, r12
	smuadx	r14, r7, r11
	vmov	s24, r12	// scr7=h11
	vmov	s25, r14	// scr8=h13
	pkhtb	r3, r4, r5		// f21
	pkhtb	r5, r5, r6		// f43
	pkhtb	r6, r6, r7		// f65
	smultt	r12, r7, r11		// f7 g7
	smultt	r14, r7, r10		// f7 g5
	smlad	r14, r6, r11, r14
	vmov	s26, r12	// scr9=h14
	vmov	s27, r14	// scr10=h12
	smultt	r12, r7, r9		// f7 g3
	smlad	r12, r6, r10, r12
	smlad	r12, r5, r11, r12
	smultt	r14, r7, r8
	smlad	r14, r6, r9, r14
	smlad	r14, r5, r10, r14
	smlad	r14, r3, r11, r14
	vmov	s28, r12	// scr11=h10
	vmov	s29, r14	// scr12=h8, r7 now used up
	smulbb	r7, r4, r9
	smlad	r7, r3, r8, r7		// h2
	smulbb	r12, r4, r10
	smlad	r12, r3, r9, r12
	smlad	r12, r5, r8, r12	// h4
	smulbb	r14, r4, r11
	smlad	r14, r3, r10, r14
	smlad	r14, r5, r9, r14
	smlad	r14, r6, r8, r14	// h6
	movw	r3, #49905
	movw	r4, #4591
	vmov	r8, s20	// h3=scr3
	vmov	r9, s21	// h5=scr4
	vmov	r10, s22	// h7=scr5
	mr_16x2	r7, r8, r4, r3, r11	// h23
	mr_16x2	r12, r9, r4, r3, r11	// h45
	mr_16x2 r14, r10, r4, r3, r11	// h67
	vmov	r8, s29	// h8=scr12
	vmov	r9, s23	// h9=scr6
	mr_16x2	r8, r9, r4, r3, r11	// h89
	vmov	r10, s28	// h10=scr11
	vmov	r9, s24	// h11=scr7
	mr_16x2	r10, r9, r4, r3, r11	// h10,11
	str	r7, [r2, #4]
	str	r12, [r2, #8]
	str	r14, [r2, #12]
	str	r8, [r2, #16]
	str	r10, [r2, #20]
	vmov	r12, s27	// h12=scr10
	vmov	r10, s25	// h13=scr8
	vmov	r14, s26	// h14=scr9
	vmov	r7, s18	// h0=scr1
	vmov	r8, s19	// h1=scr2
	mr_16x2	r7, r8, r4, r3, r11
	mr_16x2	r12, r10, r4, r3, r11
	mr_hi	r14, r4, r3, r11
	lsr	r14, #16
	str	r12, [r2, #24]
	str	r14, [r2, #28]
	str	r7, [r2], #32
	vmov	r14, s17	// counter=scr0
// end polymul_8x8_divR
	subs	r14, #1
	bne	T128x4_muls1
T128x4_collect:
	vmov	r2, s3	// reload hh
	vmov	r3, s4	// reload overflow list
T128x4_col_8_ov:			// no overflow
T128x4_col_8_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
T128x4_col_8_add1:	// begin KA collect loop
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
	beq	T128x4_col_8_end
	tst	r14, #7	// set bit < 8?
	itt	eq		// then next 4 bloc
	addeq	r1, r1, #48
	addeq	r12, r12, #16
	b	T128x4_col_8_add1
T128x4_col_8_end:
T128x4_col_16_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	T128x4_col_16_add
	vmov	r0, s8	// load -q
	vmov	r1, s7	// load qinv32
	mov	r6,#32768
T128x4_col_16_ov1:
	ldrsh	r5, [r3], #2
T128x4_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	T128x4_col_16_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	T128x4_col_16_ov1
T128x4_col_16_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
T128x4_col_16_add1:	// begin KA collect loop
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
	beq	T128x4_col_16_end
	tst	r14, #15	// set bit < 16?
	itt	eq		// then next 8 bloc
	addeq	r1, r1, #96
	addeq	r12, r12, #32
	b	T128x4_col_16_add1
T128x4_col_16_end:
T128x4_col_32_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	T128x4_col_32_add
	vmov	r0, s8	// load -q
	vmov	r1, s7	// load qinv32
	mov	r6,#32768
T128x4_col_32_ov1:
	ldrsh	r5, [r3], #2
T128x4_col_32_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	T128x4_col_32_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	T128x4_col_32_ov1
T128x4_col_32_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
T128x4_col_32_add1:	// begin KA collect loop
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
	beq	T128x4_col_32_end
	tst	r14, #31	// set bit < 32?
	itt	eq		// then next 16 bloc
	addeq	r1, r1, #192
	addeq	r12, r12, #64
	b	T128x4_col_32_add1
T128x4_col_32_end:
T128x4_col_64_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	T128x4_col_64_add
	vmov	r0, s8	// load -q
	vmov	r1, s7	// load qinv32
	mov	r6,#32768
T128x4_col_64_ov1:
	ldrsh	r5, [r3], #2
T128x4_col_64_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	T128x4_col_64_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	T128x4_col_64_ov1
T128x4_col_64_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r0, #128			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
T128x4_col_64_add1:	// begin KA collect loop
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
	beq	T128x4_col_64_end
	tst	r14, #63	// set bit < 64?
	itt	eq
	addeq	r1, r1, r11		//+6*N0
	addeq	r12, r12, r0		//+2*N0
	b	T128x4_col_64_add1
T128x4_col_64_end:
T128x4_mv_back:
	vmov	r0, s0	// reload h
	vmov	r1, s3	// reload hh
	mov	r14, #512
T128x4_mv_back_loop:
	ldm	r1!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x4_mv_back_loop
	mov	r14, #1024
	mov	r4, #0
	mov	r5, #0
	mov	r6, #0
	mov	r7, #0
	mov	r8, #0
	mov	r9, #0
	mov	r10, #0
	mov	r11, #0
T128x4_clear_loop:
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x4_clear_loop
	mov	r14, #512
T128x4_mv_back_loop1:
	ldm	r1!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	T128x4_mv_back_loop1
T128x4_gather:
	vmov	r0, s0	// reload h
	vmov	r1, s3	// reload hh
	add	r0, #256
	mov	r12, #512
	vmov	r11, s7	// load round(2^32/q)
	vmov	r7, s8	// load -q
T128x4_gather1:	// load X array
	vmov	r9, s10	// pointer to X array
	mov	r14, #0
T128x4_gather2:
	ldr	r8, [r1, r14]	// load next of set
	str	r8, [r9], #4	// save to temp X array, point
	add	r14, r14, #512	// add 4N size of set
	cmp	r14, #3584	// (2l-1)*4N
	bne	T128x4_gather2
	vmov	r9, s10	// X array, loaded with a set
	vmov	r10, s16	// load T4 matrix 2
	mov	r2, #0		// counter j
T128x4_gather3:
	ldr	r6, [r0, r2]
	sxth	r4, r6
	asr	r5, r6, #16
	mov	r3, #0		// counter k
T128x4_gather4:
	ldrsh	r14, [r10], #2	// MAT1[j][k]
	ldr	r8, [r9, r3, LSL #2]	// X[k]
	smlabb	r4, r14, r8, r4
	smlabt	r5, r14, r8, r5
	add	r3, #1
	cmp	r3, 7
	bcc	T128x4_gather4
	br_32	r4, r7, r11, r6
	br_32	r5, r7, r11, r6
	pkhbt	r4, r4, r5, LSL #16
	str	r4, [r0, r2]
	add	r2, r2, #256
	cmp	r2, #1280
	bne	T128x4_gather3
	add	r0, #4		// incr src
	add	r1, #4		// incr dst
	subs	r12, #4		// decr counter
	bne	T128x4_gather1
T128x4_end:
	vmov	r12, s1	// load 2M
	add	sp, sp, r12, LSL #2	// add back 36288 = 8M
	add	sp, sp, #64		// temp space 8*l
	vpop	{s16-s31}
	pop	{r4-r11,lr}
	bx	lr

