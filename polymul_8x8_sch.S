#include "red-asm.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_8x8 (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_8x8
	.type	gf_polymul_8x8, %function
gf_polymul_8x8:
	push	{r4-r11,lr}
	movw	r14, #18015
	movt	r14, #14
	vmov	s2, r14	// save q32inv
	movw	r12, #60945
	movt	r12, #65535
	vmov	s0, r12	// save -q
	ldr	r12, [r2]
	ldr	r14, [r2, #4]
	ldr	r3, [r1]
	ldr	r4, [r1, #4]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r5, r6, r3, r12, r4
	br_32x2	r7, r8, r3, r12, r4
	str	r5, [r0], #4
	str	r7, [r0], #4
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #0]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r9, r10, r3, r12, r4
	br_32x2	r11, r5, r3, r12, r4
	str	r9, [r0], #4
	str	r11, [r0], #4
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #8]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r6, r7, r3, r12, r4
	br_32x2	r8, r9, r3, r12, r4
	str	r6, [r0], #4
	str	r8, [r0], #4
	br_32x2	r10, r11, r3, r12, r4
	br_32	r5, r3, r12, r4
 bfc	r5, #16, #16
	str	r10, [r0], #4
	str	r5, [r0], #4
	add	r1, #16
	add	r2, #16
	pop	{r4-r11,lr}
	bx	lr
