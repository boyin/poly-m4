#include "red-asm.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_64x64_negc (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_64x64_negc
	.type	gf_polymul_64x64_negc, %function
gf_polymul_64x64_negc:
	push	{r4-r11,lr}
	movw	r14, #18015
	movt	r14, #14
	vmov	s2, r14	// save q32inv
	movw	r12, #60945
	movt	r12, #65535
	vmov	s0, r12	// save -q
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2]
	ldr	r14, [r2, #4]
block_15_0:
	smuadx	r9, r3, r12
	smuadx	r11, r4, r12
	smladx	r11, r3, r14, r11
	smuadx	r6, r4, r14
	smulbb	r8, r3, r12
	smulbb	r10, r3, r14
	pkhtb	r3, r3, r4
	smlad	r10, r3, r12, r10
	smuad	r5, r3, r14
	smlatt	r5, r4, r12, r5
	smultt	r7, r4, r14
block_14_1:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_13_2:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_12_3:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_11_4:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_10_5:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_9_6:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_8_7:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_7_8:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_6_9:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_5_10:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_4_11:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_3_12:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_2_13:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_1_14:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_0_15:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	vmov	s4, r8	// save thread 0
	vmov	s5, r9	// save thread 1
	vmov	s6, r10	// save thread 2
	vmov	s7, r11	// save thread 3
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
block_1_15:
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
block_2_14:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_3_13:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_4_12:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_5_11:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_6_10:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_7_9:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_8_8:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_9_7:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_10_6:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_11_5:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_12_4:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_13_3:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_14_2:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_15_1:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
block_0_0:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
	ldr	r12, [r2, #0]
block_1_0:
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
block_0_1:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
block_15_2:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_14_3:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_13_4:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_12_5:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_11_6:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_10_7:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_9_8:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_8_9:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_7_10:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_6_11:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_5_12:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_4_13:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_3_14:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_2_15:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r9, r10, r3, r12, r4
	br_32x2	r11, r5, r3, r12, r4
	str	r9, [r0], #4
	str	r11, [r0], #4
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #120]
block_3_15:
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
block_4_14:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_5_13:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_6_12:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_7_11:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_8_10:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_9_9:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_10_8:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_11_7:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_12_6:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_13_5:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_14_4:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_15_3:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
block_0_2:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_1_1:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_2_0:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
block_3_0:
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
block_2_1:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_1_2:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_0_3:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
block_15_4:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_14_5:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_13_6:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_12_7:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_11_8:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_10_9:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_9_10:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_8_11:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_7_12:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_6_13:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_5_14:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_4_15:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r10, r11, r3, r12, r4
	br_32x2	r5, r6, r3, r12, r4
	str	r10, [r0], #4
	str	r5, [r0], #4
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #120]
block_5_15:
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
block_6_14:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_7_13:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_8_12:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_9_11:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_10_10:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_11_9:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_12_8:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_13_7:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_14_6:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_15_5:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
block_0_4:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_1_3:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_2_2:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_3_1:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_4_0:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
block_5_0:
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
block_4_1:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_3_2:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_2_3:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_1_4:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_0_5:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
block_15_6:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_14_7:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_13_8:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_12_9:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_11_10:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_10_11:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_9_12:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_8_13:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_7_14:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_6_15:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r11, r5, r3, r12, r4
	br_32x2	r6, r7, r3, r12, r4
	str	r11, [r0], #4
	str	r6, [r0], #4
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #120]
block_7_15:
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
block_8_14:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_9_13:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_10_12:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_11_11:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_12_10:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_13_9:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_14_8:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_15_7:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
block_0_6:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_1_5:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_2_4:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_3_3:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_4_2:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_5_1:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_6_0:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
block_7_0:
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
block_6_1:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_5_2:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_4_3:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_3_4:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_2_5:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_1_6:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_0_7:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
block_15_8:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_14_9:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_13_10:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_12_11:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_11_12:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_10_13:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_9_14:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_8_15:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r5, r6, r3, r12, r4
	br_32x2	r7, r8, r3, r12, r4
	str	r5, [r0], #4
	str	r7, [r0], #4
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #120]
block_9_15:
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
block_10_14:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_11_13:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_12_12:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_13_11:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_14_10:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_15_9:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
block_0_8:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_1_7:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_2_6:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_3_5:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_4_4:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_5_3:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_6_2:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_7_1:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_8_0:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
block_9_0:
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
block_8_1:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_7_2:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_6_3:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_5_4:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_4_5:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_3_6:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_2_7:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_1_8:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_0_9:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
block_15_10:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_14_11:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_13_12:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_12_13:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_11_14:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_10_15:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r6, r7, r3, r12, r4
	br_32x2	r8, r9, r3, r12, r4
	str	r6, [r0], #4
	str	r8, [r0], #4
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #120]
block_11_15:
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
block_12_14:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_13_13:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_14_12:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_15_11:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
block_0_10:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_1_9:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_2_8:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_3_7:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_4_6:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_5_5:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_6_4:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_7_3:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_8_2:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_9_1:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_10_0:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
block_11_0:
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
block_10_1:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_9_2:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_8_3:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_7_4:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_6_5:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_5_6:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_4_7:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_3_8:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_2_9:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_1_10:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_0_11:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
block_15_12:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_14_13:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_13_14:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_12_15:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r7, r8, r3, r12, r4
	br_32x2	r9, r10, r3, r12, r4
	str	r7, [r0], #4
	str	r9, [r0], #4
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #120]
block_13_15:
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
block_14_14:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_15_13:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
block_0_12:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_1_11:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_2_10:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_3_9:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_4_8:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_5_7:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_6_6:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_7_5:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_8_4:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_9_3:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_10_2:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_11_1:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_12_0:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
block_13_0:
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
block_12_1:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_11_2:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_10_3:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_9_4:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_8_5:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_7_6:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_6_7:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_5_8:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_4_9:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_3_10:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_2_11:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_1_12:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_0_13:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
block_15_14:
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_14_15:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #120]
	ldr	r14, [r2, #124]
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
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r8, r9, r3, r12, r4
	br_32x2	r10, r11, r3, r12, r4
	str	r8, [r0], #4
	str	r10, [r0], #4
	ldr	r3, [r1, #120]
	ldr	r4, [r1, #124]
	ldr	r12, [r2, #120]
block_15_15:
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
	neg	r5, r5
	neg	r6, r6
	neg	r7, r7
	neg	r8, r8
	neg	r9, r9
	neg	r10, r10
	neg	r11, r11
block_0_14:
	ldr	r3, [r1, #0]
	ldr	r4, [r1, #4]
	ldr	r12, [r2, #112]
	ldr	r14, [r2, #116]
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
block_1_13:
	ldr	r3, [r1, #8]
	ldr	r4, [r1, #12]
	ldr	r12, [r2, #104]
	ldr	r14, [r2, #108]
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
block_2_12:
	ldr	r3, [r1, #16]
	ldr	r4, [r1, #20]
	ldr	r12, [r2, #96]
	ldr	r14, [r2, #100]
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
block_3_11:
	ldr	r3, [r1, #24]
	ldr	r4, [r1, #28]
	ldr	r12, [r2, #88]
	ldr	r14, [r2, #92]
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
block_4_10:
	ldr	r3, [r1, #32]
	ldr	r4, [r1, #36]
	ldr	r12, [r2, #80]
	ldr	r14, [r2, #84]
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
block_5_9:
	ldr	r3, [r1, #40]
	ldr	r4, [r1, #44]
	ldr	r12, [r2, #72]
	ldr	r14, [r2, #76]
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
block_6_8:
	ldr	r3, [r1, #48]
	ldr	r4, [r1, #52]
	ldr	r12, [r2, #64]
	ldr	r14, [r2, #68]
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
block_7_7:
	ldr	r3, [r1, #56]
	ldr	r4, [r1, #60]
	ldr	r12, [r2, #56]
	ldr	r14, [r2, #60]
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
block_8_6:
	ldr	r3, [r1, #64]
	ldr	r4, [r1, #68]
	ldr	r12, [r2, #48]
	ldr	r14, [r2, #52]
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
block_9_5:
	ldr	r3, [r1, #72]
	ldr	r4, [r1, #76]
	ldr	r12, [r2, #40]
	ldr	r14, [r2, #44]
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
block_10_4:
	ldr	r3, [r1, #80]
	ldr	r4, [r1, #84]
	ldr	r12, [r2, #32]
	ldr	r14, [r2, #36]
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
block_11_3:
	ldr	r3, [r1, #88]
	ldr	r4, [r1, #92]
	ldr	r12, [r2, #24]
	ldr	r14, [r2, #28]
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
block_12_2:
	ldr	r3, [r1, #96]
	ldr	r4, [r1, #100]
	ldr	r12, [r2, #16]
	ldr	r14, [r2, #20]
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
block_13_1:
	ldr	r3, [r1, #104]
	ldr	r4, [r1, #108]
	ldr	r12, [r2, #8]
	ldr	r14, [r2, #12]
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
block_14_0:
	ldr	r3, [r1, #112]
	ldr	r4, [r1, #116]
	ldr	r12, [r2, #0]
	ldr	r14, [r2, #4]
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
	vmov	r6, s4  // load thread 0
	vmov	r7, s5  // load thread 1
	vmov	r8, s6  // load thread 2
	vmov	r5, s7  // load thread 3
	add	r9, r6
	add	r10, r7
	add	r11, r8
	vmov	r3, s0  // load -q
	vmov	r12, s2  // load q32inv
	br_32x2	r9, r10, r3, r12, r4
	br_32x2	r11, r5, r3, r12, r4
	str	r9, [r0], #4
	str	r11, [r0], #4
	add	r1, #128
	add	r2, #128
	pop	{r4-r11,lr}
	bx	lr
