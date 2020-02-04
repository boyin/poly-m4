#include "red-asm.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_64x64 (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_64x64
	.type	gf_polymul_64x64, %function
gf_polymul_64x64:
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
	br_32x2	r5, r6, r3, r12, r14
	br_32x2	r7, r8, r3, r12, r14
	str	r5, [r0], #4
	str	r7, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	// block (0,8)
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
	// block (1,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	// block (8,0)
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #0]
	// block (9,0)
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
	// block (8,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (1,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (0,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	br_32x2	r6, r7, r3, r12, r14
	br_32x2	r8, r9, r3, r12, r14
	str	r6, [r0], #4
	str	r8, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	// block (0,10)
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
	// block (1,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	// block (2,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (3,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	// block (8,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,0)
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	br_32x2	r10, r11, r3, r12, r4
	br_32x2	r5, r6, r3, r12, r4
	str	r10, [r0], #4
	str	r5, [r0], #4
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #0]
	// block (11,0)
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
	// block (10,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (3,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (2,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	// block (1,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (0,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	br_32x2	r7, r8, r3, r12, r14
	br_32x2	r9, r10, r3, r12, r14
	str	r7, [r0], #4
	str	r9, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	// block (0,12)
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
	// block (1,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	// block (2,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (3,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	// block (4,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (5,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	// block (8,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,0)
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	br_32x2	r11, r5, r3, r12, r4
	br_32x2	r6, r7, r3, r12, r4
	str	r11, [r0], #4
	str	r6, [r0], #4
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #0]
	// block (13,0)
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
	// block (12,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (5,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (4,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	// block (3,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (2,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	// block (1,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (0,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
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
	br_32x2	r8, r9, r3, r12, r14
	br_32x2	r10, r11, r3, r12, r14
	str	r8, [r0], #4
	str	r10, [r0], #4
	ldr	r3, [r1, #0]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	// block (0,14)
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
	// block (1,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	// block (2,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (3,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	// block (4,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (5,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	// block (6,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (7,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (8,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,0)
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #0]
	// block (15,0)
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
	// block (14,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
	// block (6,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	// block (5,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (4,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	// block (3,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (2,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	// block (1,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
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
	// block (0,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	ldr	r12, [r2, #120]
	// block (1,15)
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
	// block (2,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
	// block (3,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	// block (4,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (5,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	// block (6,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (7,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (8,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,2)
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,1)
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	br_32x2	r6, r7, r3, r12, r14
	br_32x2	r8, r9, r3, r12, r14
	str	r6, [r0], #4
	str	r8, [r0], #4
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
	// block (15,2)
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
	// block (14,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
	// block (6,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	// block (5,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (4,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	// block (3,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
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
	// block (2,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r10, r11, r3, r12, r4
	br_32x2	r5, r6, r3, r12, r4
	str	r10, [r0], #4
	str	r5, [r0], #4
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #120]
	// block (3,15)
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
	// block (4,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
	// block (5,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	// block (6,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (7,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (8,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,4)
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,3)
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	br_32x2	r7, r8, r3, r12, r14
	br_32x2	r9, r10, r3, r12, r14
	str	r7, [r0], #4
	str	r9, [r0], #4
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
	// block (15,4)
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
	// block (14,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
	// block (6,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	// block (5,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
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
	// block (4,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r11, r5, r3, r12, r4
	br_32x2	r6, r7, r3, r12, r4
	str	r11, [r0], #4
	str	r6, [r0], #4
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #120]
	// block (5,15)
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
	// block (6,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
	// block (7,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (8,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,6)
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,5)
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	br_32x2	r8, r9, r3, r12, r14
	br_32x2	r10, r11, r3, r12, r14
	str	r8, [r0], #4
	str	r10, [r0], #4
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
	// block (15,6)
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
	// block (14,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (7,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
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
	// block (6,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r5, r6, r3, r12, r4
	br_32x2	r7, r8, r3, r12, r4
	str	r5, [r0], #4
	str	r7, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #120]
	// block (7,15)
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
	// block (8,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	// block (9,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (10,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,8)
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,7)
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
	// block (15,8)
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
	// block (14,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (9,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
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
	// block (8,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
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
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #120]
	// block (9,15)
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
	// block (10,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	// block (11,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (12,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,10)
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,9)
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
	// block (15,10)
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
	// block (14,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (11,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
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
	// block (10,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
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
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #120]
	// block (11,15)
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
	// block (12,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	// block (13,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (14,12)
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,11)
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
	// block (15,12)
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
	// block (14,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (13,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
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
	// block (12,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
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
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #120]
	// block (13,15)
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
	// block (14,14)
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	// block (15,13)
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
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
	br_32x2	r5, r6, r3, r12, r14
	br_32x2	r7, r8, r3, r12, r14
	str	r5, [r0], #4
	str	r7, [r0], #4
	ldr	r3, [r1, #120]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
	// block (15,14)
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
	// block (14,15)
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
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
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #120]
	// block (15,15)
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
	add	r1, #128
	add	r2, #128
	pop	{r4-r11,lr}
	bx	lr
