#include "red-asm.h"
// N=256 requires 15552=8x1944 storage

#include "polymul_256x256_B8_aux.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_256x256_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_256x256_divR
	.type	gf_polymul_256x256_divR, %function
gf_polymul_256x256_divR:
	push	{r4-r11,lr}
	vpush	{s16-s31}
	ldr	r12, =3888	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 15552 = 8M
		// ff=[sp], gg=[sp,#3888], hh=[sp,#7776]
	vmov	s0, r0	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+3888(=2M)
	vmov	s1, r12	// save 2M
	vmov	s2, r0	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+3888(=2M)
	vmov	s3, r14	// save h
	ldr	r14, =KA_exp_ov_256
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
	mov	r14, #512
KA256_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA256_mv_loop
KA256_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	vmov	r12, s1  // reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #256		// N0 = r2 = N
	vmov	r3, s4  // load list to reduce
KA256_exp_loop1:		// loop on N0
	cmp	r2, #8		// while (N0>B)
	beq	KA256_exp_end1
KA256_exp_reduce:		// reduce ff[], gg[]
	ldrsh	r4, [r3], #2	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA256_exp_adds	// only if -1 end
	vmov	r6, s8  // load -q
	vmov	r7, s7  // load q32inv
	mov	r10, #32768	// load 2^15
KA256_exp_red1:
	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]
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
	ldrsh	r4, [r3], #2	// re-load list entry
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
	ldrsh	r4, [r3], #2		// load N1/W/2
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
	itt	eq		// divisible by N0/2/W=2?
	subeq	r0, r0, r2	// then add N0!
	subeq	r1, r1, r2	// then add N0!
	b	KA256_exp_adds1
KA256_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	vmov	r1, s2  // reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA256_exp_loop1	// loop
KA256_exp_end1:

KA256_mul:
  // check multiplicative overflow (pre-mult size > q_mb=15799)
KA256_mul_ov:
	ldrsh	r2, [r3], #2
	cmp	r2, #-1		// multiplicative overflow?
	beq	KA256_muls
	mov	r8, #32768
	vmov	r6, s8  // load -q
	vmov	r7, s7  // load round(2^32/q)
KA256_mul_ov1:
	ldrsh	r11, [r3], #2
KA256_mul_ov2:
	ldr	r4, [r0, r2, LSL #2]
	ldr	r5, [r1, r2, LSL #2]
	br_16x2	r4, r6, r7, r8, r9, r10
	br_16x2 r5, r6, r7, r8, r9, r10
	str	r4, [r0, r2, LSL #2]
	str	r5, [r1, r2, LSL #2]
	add	r2, r2, #1
	cmp	r2, r11
	bls	KA256_mul_ov2
	ldrsh	r2, [r3], #2
	cmp	r2, -1
	bne	KA256_mul_ov1
KA256_muls:
	ldrsh	r14, [r3], #2	// r14 = N1/B
	vmov	s4, r3	// save overflow list pointer
	vmov	r2, s3  // load r2 = hh
KA256_muls1:
	// begin polymul_8x8_divR
	ldr	r5, [r0, #4]		// f23
	ldr	r6, [r0, #8]		// f45
	ldr	r7, [r0, #12]		// f67
	ldr	r4, [r0],#16		// f01
	ldr	r9, [r1, #4]		// g23
	ldr	r10, [r1, #8]		// g45
	ldr	r11, [r1, #12]		// g67
	ldr	r8, [r1],#16		// g01
	vmov	s9, r14	// scr0=count
	smulbb	r12, r4, r8
	smuadx	r14, r4, r8
	vmov	s10, r12	// scr1=h0
	vmov	s11, r14	// scr2=h1
	smuadx	r12, r4, r9
	smladx	r12, r5, r8, r12
	smuadx	r14, r4, r10
	smladx	r14, r5, r9, r14
	smladx	r14, r6, r8, r14
	vmov	s12, r12	// scr3=h3
	vmov	s13, r14	// scr4=h5
	smuadx	r12, r4, r11
	smladx	r12, r5, r10, r12
	smladx	r12, r6, r9, r12
	smladx	r12, r7, r8, r12
	smuadx	r14, r5, r11
	smladx	r14, r6, r10, r14
	smladx	r14, r7, r9, r14
	vmov	s14, r12	// scr5=h7
	vmov	s15, r14	// scr6=h9
	smuadx	r12, r6, r11
	smladx	r12, r7, r10, r12
	smuadx	r14, r7, r11
	vmov	s16, r12	// scr7=h11
	vmov	s17, r14	// scr8=h13
	pkhtb	r3, r4, r5		// f21
	pkhtb	r5, r5, r6		// f43
	pkhtb	r6, r6, r7		// f65
	smultt	r12, r7, r11		// f7 g7
	smultt	r14, r7, r10		// f7 g5
	smlad	r14, r6, r11, r14
	vmov	s18, r12	// scr9=h14
	vmov	s19, r14	// scr10=h12
	smultt	r12, r7, r9		// f7 g3
	smlad	r12, r6, r10, r12
	smlad	r12, r5, r11, r12
	smultt	r14, r7, r8
	smlad	r14, r6, r9, r14
	smlad	r14, r5, r10, r14
	smlad	r14, r3, r11, r14
	vmov	s20, r12	// scr11=h10
	vmov	s21, r14	// scr12=h8, r7 now used up
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
	vmov	r8, s12  // h3=scr3
	vmov	r9, s13  // h5=scr4
	vmov	r10, s14  // h7=scr5
	mr_16x2	r7, r8, r4, r3, r11	// h23
	mr_16x2	r12, r9, r4, r3, r11	// h45
	mr_16x2 r14, r10, r4, r3, r11	// h67
	vmov	r8, s21  // h8=scr12
	vmov	r9, s15  // h9=scr6
	mr_16x2	r8, r9, r4, r3, r11	// h89
	vmov	r10, s20  // h10=scr11
	vmov	r9, s16  // h11=scr7
	mr_16x2	r10, r9, r4, r3, r11	// h10,11
	str	r7, [r2, #4]
	str	r12, [r2, #8]
	str	r14, [r2, #12]
	str	r8, [r2, #16]
	str	r10, [r2, #20]
	vmov	r12, s19  // h12=scr10
	vmov	r10, s17  // h13=scr8
	vmov	r14, s18  // h14=scr9
	vmov	r7, s10  // h0=scr1
	vmov	r8, s11  // h1=scr2
	mr_16x2	r7, r8, r4, r3, r11	// h01
	mr_16x2	r12, r10, r4, r3, r11	// h12,13
	mr_hi	r14, r4, r3, r11
	lsr	r14, #16
	str	r14, [r2, #28]
	str	r12, [r2, #24]
	str	r7, [r2], #32
	vmov	r14, s9  // counter=scr0
	subs	r14, #1
	bne	KA256_muls1
KA256_collect:
	vmov	r2, s3  // reload hh
	vmov	r3, s4  // reload overflow list
KA256_col_8_ov:			// no overflow
KA256_col_8_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
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
	itt	eq		// no, then next set
	addeq	r1, r1, #48
	addeq	r12, r12, #16
	b	KA256_col_8_add1
KA256_col_8_end:
KA256_col_16_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA256_col_16_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA256_col_16_ov1:
	ldrsh	r5, [r3], #2
KA256_col_16_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_16_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA256_col_16_ov1
KA256_col_16_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
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
	itt	eq		// no, then next set
	addeq	r1, r1, #96
	addeq	r12, r12, #32
	b	KA256_col_16_add1
KA256_col_16_end:
KA256_col_32_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA256_col_32_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA256_col_32_ov1:
	ldrsh	r5, [r3], #2
KA256_col_32_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_32_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA256_col_32_ov1
KA256_col_32_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
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
	itt	eq		// no, then next set
	addeq	r1, r1, #192
	addeq	r12, r12, #64
	b	KA256_col_32_add1
KA256_col_32_end:
KA256_col_64_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA256_col_64_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA256_col_64_ov1:
	ldrsh	r5, [r3], #2
KA256_col_64_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_64_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA256_col_64_ov1
KA256_col_64_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r0, #128			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
KA256_col_64_add1:	// begin KA collect loop
	ldr	r4, [r1, r0]		//+2*N0
	ldr	r6, [r1, r0, LSL #1]	//+4*N0
	ldr	r7, [r1, r11]		//+6*N0
	ssub16	r4, r4, r6
	sadd16	r8, r4, r7
	ldr	r6, [r1]
	ldr	r7, [r12, r0]		//+2*N0
	ssub16	r4, r4, r6
	ssub16	r8, r7, r8
	ldr	r6, [r12], #4		// shift r12 up 4
	str	r8, [r1, r0, LSL #1] 	//+4*N0
	sadd16	r4, r4, r6
	str	r4, [r1, r0]		//+2*N0
	add	r1, r1, #4		// shift r1 up 4
	subs	r14, r14, #2
	beq	KA256_col_64_end
	tst	r14, #63	// set bit < 64?
	itt	eq			//next 32 bloc
	addeq	r1, r1, r11		//+6*N0
	addeq	r12, r12, r0		//+2*N0
	b	KA256_col_64_add1
KA256_col_64_end:
KA256_col_128_ov:
	ldrsh	r4, [r3], #2
	cmp	r4, #-1
	beq	KA256_col_128_add
	vmov	r0, s8  // load -q
	vmov	r1, s7  // load qinv32
	mov	r6,#32768
KA256_col_128_ov1:
	ldrsh	r5, [r3], #2
KA256_col_128_ov2:
	ldr	r8, [r2, r4, LSL #2]
	br_16x2	r8, r0, r1, r6, r7, r9
	str	r8, [r2, r4, LSL #2]
	add	r4, #1
	cmp	r4, r5
	bls	KA256_col_128_ov2
	ldrsh	r4, [r3], #2
	cmp	r4, -1
	bne	KA256_col_128_ov1
KA256_col_128_add:			// KA collection
	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4
	add	r12, r2, r14, LSL #3	// other pointer
	mov	r1, r2		// copy of hh
	mov	r0, #256			// 2*N0
	add	r11, r0, r0, LSL #1	// 6*N0
KA256_col_128_add1:	// begin KA collect loop
	ldr	r4, [r1, r0]		//+2*N0
	ldr	r6, [r1, r0, LSL #1]	//+4*N0
	ldr	r7, [r1, r11]		//+6*N0
	ssub16	r4, r4, r6
	sadd16	r8, r4, r7
	ldr	r6, [r1]
	ldr	r7, [r12, r0]		//+2*N0
	ssub16	r4, r4, r6
	ssub16	r8, r7, r8
	ldr	r6, [r12], #4		// shift r12 up 4
	str	r8, [r1, r0, LSL #1] 	//+4*N0
	sadd16	r4, r4, r6
	str	r4, [r1, r0]		//+2*N0
	add	r1, r1, #4		// shift r1 up 4
	subs	r14, r14, #2
	beq	KA256_col_128_end
	tst	r14, #127	// set bit < 128?
	itt	eq			//next 64 bloc
	addeq	r1, r1, r11		//+6*N0
	addeq	r12, r12, r0		//+2*N0
	b	KA256_col_128_add1
KA256_col_128_end:
KA256_mv_back:			// hh=[sp,4M] still =r2
	vmov	r0, s0  // reload h
	mov	r14, #1024
KA256_mv_back_loop:
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA256_mv_back_loop
KA256_end:
	vmov	r12, s1  // load 2M
	add	sp, sp, r12, LSL #2	// add back 15552 = 8M
	vpop	{s16-s31}
	pop	{r4-r11,lr}
	bx	lr

