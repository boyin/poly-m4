#include "red-asm.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_32x32 (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_32x32
	.type	gf_polymul_32x32, %function
gf_polymul_32x32:
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
	br_32x2	r9, r10, r3, r12, r14
	br_32x2	r11, r5, r3, r12, r14
	str	r9, [r0], #4
	str	r11, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r6, r7, r3, r12, r4
	br_32x2	r8, r9, r3, r12, r4
	str	r6, [r0], #4
	str	r8, [r0], #4
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #0]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r10, r11, r3, r12, r14
	br_32x2	r5, r6, r3, r12, r14
	str	r10, [r0], #4
	str	r5, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r7, r8, r3, r12, r4
	br_32x2	r9, r10, r3, r12, r4
	str	r7, [r0], #4
	str	r9, [r0], #4
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #0]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r11, r5, r3, r12, r14
	br_32x2	r6, r7, r3, r12, r14
	str	r11, [r0], #4
	str	r6, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r8, r9, r3, r12, r4
	br_32x2	r10, r11, r3, r12, r4
	str	r8, [r0], #4
	str	r10, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #0]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r5, r6, r3, r12, r4
	br_32x2	r7, r8, r3, r12, r4
	str	r5, [r0], #4
	str	r7, [r0], #4
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #56]
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
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	br_32x2	r9, r10, r3, r12, r14
	br_32x2	r11, r5, r3, r12, r14
	str	r9, [r0], #4
	str	r11, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r6, r7, r3, r12, r4
	br_32x2	r8, r9, r3, r12, r4
	str	r6, [r0], #4
	str	r8, [r0], #4
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #56]
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
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r10, r11, r3, r12, r14
	br_32x2	r5, r6, r3, r12, r14
	str	r10, [r0], #4
	str	r5, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r7, r8, r3, r12, r4
	br_32x2	r9, r10, r3, r12, r4
	str	r7, [r0], #4
	str	r9, [r0], #4
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #56]
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
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r11, r5, r3, r12, r14
	br_32x2	r6, r7, r3, r12, r14
	str	r11, [r0], #4
	str	r6, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r8, r9, r3, r12, r4
	br_32x2	r10, r11, r3, r12, r4
	str	r8, [r0], #4
	str	r10, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #56]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r5, r6, r3, r12, r4
	br_32x2	r7, r8, r3, r12, r4
	str	r5, [r0], #4
	str	r7, [r0], #4
	br_32x2	r9, r10, r3, r12, r4
	br_32	r11, r3, r12, r4
 bfc	r11, #16, #16
	str	r9, [r0], #4
	str	r11, [r0], #4
	add	r1, #64
	add	r2, #64
	pop	{r4-r11,lr}
	bx	lr
