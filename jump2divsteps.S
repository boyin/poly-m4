#include "red-asm.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void jump2divsteps (int minusdelta, int *M, int f, int g);
	.global jump2divsteps
	.type	jump2divsteps, %function
jump2divsteps:
	push	{r1,r4-r11,lr}
	mov	r12, #4591	// load q
	movw	r1, #47521
	movt	r1, #65521
	vmov	s0, r1		// save q32inv
	mov	r4, #1	// u
	mov	r5, #0	// v
	mov	r6, #0	// r
	mov	r7, #1	// s
jump2divsteps_t0:	// start of turn 0
	uxth	r10, r3
	tst	r10, r0, ASR #31
	itttt	ne
	movne	r10, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r10
	movne	r10, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r10
	movne	r10, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r10
	negne	r0, r0
jump2divsteps_t0_1:	// end of first half
	mov	r11, #0
	ssub16	r8, r11, r3	// r8 = -g
	sub	r0, r0, #1	// decrement minusdelta
	smlsdx	r3, r2, r3, r11	// (f(0) g - g(0) f) / x 
	br_32	r3, r12, r1, r11 //red. new g[0] % 4591, 32b
	uxth	r3, r3
	smulbb	r9, r8, r4	// - u[0] g[0]
	smlabb	r6, r2, r6, r9	// f[0] r[0] - g[0] u[0], 32bit
	smulbb	r9, r8, r5	// - v[0] g[0]
	smlabb	r7, r2, r7, r9	// f[0] s[0] - g[0] v[0], 32bit
	lsl	r4, #16		// r4 was 0/1; shift
	lsl	r5, #16		// r5 was 0/1; shift
	uxth	r6, r6		// r6 was reduced
	uxth	r7, r7		// r7 was reduced
jump2divsteps_t1:	// start of turn 1
	// top of r4(u)/r5(v): 0/1,  of r6(r)/r7(s): 0
	// start of first half, no need to reduce g[0]
	tst	r10, r0, ASR #31
	itttt	ne
	movne	r10, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r10
	movne	r10, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r10
	movne	r10, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r10
	negne	r0, r0
jump2divsteps_t1_1:	// end of first half
	mov	r11, #0
	sub	r0, r0, #1	// decrement minusdelta
	ssub16	r8, r11, r3	// r8 = -g
	smlsdx	r3, r2, r3, r11	// (f(0) g - g(0) f) / x 
	br_32	r3, r12, r1, r11 //red. new g[0] % 4591, 32b
	uxth	r3, r3
	smulbb	r9, r8, r4	// - u[0] g[0]
	smlabb	r9, r2, r6, r9	// new r[0] = f[0] r[0] - g[0] u[0], 32b
	br_32	r9, r12, r1, r11 //red. new r[0] % 4591, 32b
	smulbt	r11, r8, r4	// - u[1] g[0]
	smlabt	r11, r2, r6, r11// new r[1] = f[0] r[1] - g[0] u[1], 32b
	pkhbt	r6, r9, r11, LSL #16	// new r (new r[1] reduced)
	smulbb	r9, r8, r5	// - v[0] g[0]
	smlabb	r9, r2, r7, r9	// new s[0] = f[0] s[0] - g[0] v[0], 32b
	br_32	r9, r12, r1, r11 //red. new s[0] % 4591, 32b
	smulbt	r11, r8, r5	// - v[1] g[0]
	smlabt	r11, r2, r7, r11// new s[1] = f[0] s[1] - g[0] v[1], 32b
	pkhbt	r7, r9, r11, LSL #16	// new s (new s[1] reduced)
	// note, we don't shift u,v here
	pop	{r1}
	stm	r1, {r2-r7}
	pop	{r4-r11,lr}
	bx	lr
