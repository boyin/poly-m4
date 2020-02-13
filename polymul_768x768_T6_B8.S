#include "red-asm.h"
// N=768 requires 104976=8x13122 storage

#include "polymul_768x768_B6_aux.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_768x768_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_768x768_divR
	.type	gf_polymul_768x768_divR, %function
gf_polymul_768x768_divR:
	push	{r4-r11,lr}
	vpush	{s16-s31}
	movw	r12, #26244	// r12=2M
	sub	sp, sp, r12, LSL #2	// subtract 104976 = 8M
		// ff=[sp], gg=[sp,#26244], hh=[sp,#52488]
	vmov	s0, r0	// save h
	mov	r3, sp
	add	r0, sp, r12	// gg=ff+26244(=2M)
	vmov	s1, r12	// save 2M
	vmov	s2, r0	// save gg (ff=sp)
	add	r14, r0, r12	// hh=gg+26244(=2M)
	vmov	s3, r14	// save h
	ldr	r14, =KA_exp_ov_768
	vmov	s4, r14	// save ov pointer
	movw	r12, #4591
	movw	r14, #15631
	vmov	s6, r14	// save qinv
	rsb	r12, r12, #0		// -q
	vmov	s8, r12	// save -q
	movw	r14, #18015
	movt	r14, #14
	vmov	s7, r14	// save q32inv
	mov	r14, #1536
KA768_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff
	ldm	r1!, {r4-r11}
	stm	r3!, {r4-r11}
	ldm	r2!, {r4-r11}
	stm	r0!, {r4-r11}
	subs	r14, #32
	bne	KA768_mv_loop
KA768_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12
	vmov	r12, s1  // reload 2M
	mov	r0, sp		// ff = r0
	add	r1, r0, r12	// gg = r1
	mov	r2, #768		// N0 = r2 = N
	vmov	r3, s4  // load list to reduce
KA768_exp_loop1:		// loop on N0
	cmp	r2, #6		// while (N0>B)
	beq	KA768_exp_end1
KA768_exp_reduce:		// reduce ff[], gg[]
	ldrsh	r4, [r3], #2	// list entry
	cmp	r4, #-1		// end of this list?
	beq	KA768_exp_adds	// only if -1 end
	vmov	r6, s8  // load -q
	vmov	r7, s7  // load q32inv
	mov	r10, #32768	// load 2^15
KA768_exp_red1:
	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]
KA768_exp_red2:			// while loop on r4
	ldr	r8, [r0, r4, LSL #2]	// ff[r4]
	ldr	r9, [r1, r4, LSL #2]	// gg[r4]
	br_16x2	r8, r6, r7, r10, r11, r12
	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q
	add	r4, #1
	cmp	r4, r5		// r4 > r5?
	bls	KA768_exp_red2	// loop (r4)
	ldrsh	r4, [r3], #2	// re-load list entry
	cmp	r4, #-1		// re-check, end of list?
	bne	KA768_exp_red1
KA768_exp_adds:
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
KA768_exp_adds1:
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
	beq	KA768_exp_end
	adds	r12, r12, #8
	ittt	eq		// divisible by N0/2/W?
	subeq	r0, r0, r2	// then add N0!
	subeq	r1, r1, r2	// then add N0!
	moveq	r12, r2		// reload with N0
	b	KA768_exp_adds1
KA768_exp_end:
	rsb	r2, r2, #0
	mov	r0, sp		// reload ff
	vmov	r1, s2  // reload gg

	lsr	r2, #1 		// N0 /= 2
	b	KA768_exp_loop1	// loop
KA768_exp_end1:

KA768_mul:
  // check multiplicative overflow (pre-mult size > q_mb=18243)
KA768_mul_ov:
	ldrsh	r2, [r3], #2
	cmp	r2, #-1		// multiplicative overflow?
	beq	KA768_muls
	mov	r8, #32768
	vmov	r6, s8  // load -q
	vmov	r7, s7  // load round(2^32/q)
KA768_mul_ov1:
	ldrsh	r11, [r3], #2
KA768_mul_ov2:
	ldr	r4, [r0, r2, LSL #2]
	ldr	r5, [r1, r2, LSL #2]
	br_16x2	r4, r6, r7, r8, r9, r10
	br_16x2 r5, r6, r7, r8, r9, r10
	str	r4, [r0, r2, LSL #2]
	str	r5, [r1, r2, LSL #2]
	add	r2, r2, #1
	cmp	r2, r11
	bls	KA768_mul_ov2
	ldrsh	r2, [r3], #2
	cmp	r2, -1
	bne	KA768_mul_ov1
KA768_muls:
	ldrsh	r14, [r3], #2	// r14 = N1/B
	vmov	s4, r3	// save overflow list pointer
	vmov	r2, s3  // load r2 = hh
KA768_muls1:
	vmov	s9, r14	// save counter to scr0
