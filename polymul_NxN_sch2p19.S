#include "red-asm.h"

	.macro	conv_3x64_7x32
	//r6-7/r8-9/r10-11 are partial accumulators
	//cut out 19-bit pieces, add to 7x32b pointed by s4
	sbfx	r2, r6, #0, #19
	subs	r6, r6, r2
	sbc	r7, r7, r2, ASR #31
	sbfx	r3, r7, #0, #6
	sub	r7, r7, r3
	lsl	r3, r3, #13
	add	r3, r3, r6, LSR #19
	asr	r4, r7, #6
	sbfx	r5, r8, #0, #19
	add	r4, r4, r5
	subs	r8, r8, r5
	sbc	r9, r9, r5, ASR #31
	sbfx	r5, r9, #0, #6
	sub	r9, r9, r5
	lsl	r5, r5, #13
	add	r5, r5, r8, LSR #19
	asr	r6, r9, #6
	sbfx	r7, r10, #0, #19
	add	r6, r6, r7
	subs	r10, r10, r7
	sbc	r11, r11, r7, ASR #31
	sbfx	r7, r11, #0, #6
	sub	r11, r11, r7
	lsl	r7, r7, #13
	add	r7, r7, r10, LSR #19
	asr	r8, r11, #6
	vmov	r9, s4		// reload hh
	ldrd	r10, r11, [r9]
	add	r2, r2, r10
	add	r3, r3, r11
	ldrd	r10, r11, [r9, #8]
	add	r4, r4, r10
	add	r5, r5, r11
	ldr	r10, [r9, #16]
	ldr	r11, [r9, #20]
	ldr	r12, [r9, #24]	// r12 is not important now
	add	r6, r6, r10
	add	r7, r7, r11
	add	r8, r8, r12
	stm	r9, {r2-r8}
	.endm

	.p2align	2,,3	
	.syntax		unified
	.text
// void convert_2p19 (r0 = dst, r1 = src, r12 = length) 
convert_2p19:
	mov	r11, #0x80000	// 2^19
convert_2p19_0:
	ldrsh	r2, [r1], #2
	ldr	r3, [r1], #4
	ldr	r4, [r1], #4
	ldr	r5, [r1], #4
	ldr	r6, [r1], #4
	ldr	r7, [r1], #4
	ldr	r8, [r1], #4
	ldr	r9, [r1], #4
	ldrsh	r10, [r1], #2
	mla	r2, r3, r11, r2
	asr	r3, r3, #16
	mla	r3, r4, r11, r3
	asr	r4, r4, #16
	mla	r4, r5, r11, r4
	asr	r5, r5, #16
	mla	r5, r6, r11, r5
	asr	r6, r6, #16
	mla	r6, r7, r11, r6
	asr	r7, r7, #16
	mla	r7, r8, r11, r7
	asr	r8, r8, #16
	mla	r8, r9, r11, r8
	asr	r9, r9, #16
	mla	r9, r10, r11, r9
	stm	r0!, {r2-r9}
	subs	r12, #16
	bhi	convert_2p19_0
	bx	lr

// void gf_polymul_NxNsh (int *h, int *f, int *g, int N, int C);
	.p2align	2,,3	
	.syntax		unified
	.text
	.global gf_polymul_NxNsh
	.type	gf_polymul_NxNsh, %function
gf_polymul_NxNsh:
// 2N bytes each for ff, gg,  8N bytes for hh (32-bit accumulators)
	ldr	r12, [sp]	// load C from stack
	push	{r4-r11,lr}
	vmov	s0, r0		// save h
	vmov	s1, r2		// save g
	vmov	s2, r3		// save N
	sub	r4, r12, #1	// first block never overflows
	vmov	s5, r4		// save C
	add	r4, r3, r3, LSL #1 // 3*N
	sub	sp, sp, r4, LSL #2 // sp -= 12N
	add	r4, sp, r3, LSL #1 // sp + 2N
	vmov	s3, r4		// save gg
	add	r4, sp, r3, LSL #2 // sp + 4N
	vmov	s4, r4		// save hh
	vmov	s7, r4		// save hh again
	add	r0, sp, #0	// load ff
	mov	r12, r3
	bl	convert_2p19
	vmov	r0, s3		// load gg
	vmov	r1, s1		// load g
	vmov	r12, s2		// load N
	bl	convert_2p19

	vmov	r0, s4		// load hh
	vmov	r1, s2		// load N
	mov	r2, #0
	vmov	s6, r2		// store product-scanning counter
	mov	r3, #0
	mov	r4, #0
	mov	r5, #0
	mov	r6, #0
	mov	r7, #0
	mov	r8, #0
	mov	r9, #0
clear4N:
	stm	r0!, {r2-r9}
	subs	r1, #4
	bne	clear4N
	add	r0, sp, #0	// load ff
	vmov	r1, s3		// load gg
sch2p19_0:			// increasing thread length
	vmov	r14, s6		// load thread count
sch2p19_1:
	vmov	r12, s5		// load safety count
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #-8
 	smull	r6, r7, r2, r4
	smull	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smull	r10, r11, r3, r5
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_3	// first block, no overflows
sch2p19_2:
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #-8
 	smlal	r6, r7, r2, r4
	smlal	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smlal	r10, r11, r3, r5
	sub	r12, r12, #1	// safety count = 0?
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_3
	cmp	r12, #0
	bne	sch2p19_2
sch2p19_3:
	conv_3x64_7x32
	cmp	r14, #-1
	bne	sch2p19_1	// reset safety counter
	add	r1, #8		// next thread, move cursor
	vmov	r12, s4		// load hh
	add	r12, #16	// move cursor
	vmov	s4, r12		// store hh again
	vmov	r14, s6		// reload thread count
	add	r14, #1		// increment thread count
	vmov	s6, r14		// save new thread count
sch2p19_4:
	vmov	r12, s5		// load safety count
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #-8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #8
 	smull	r6, r7, r2, r4
	smull	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smull	r10, r11, r3, r5
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_6	// first block, no overflows
sch2p19_5:
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #-8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #8
 	smlal	r6, r7, r2, r4
	smlal	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smlal	r10, r11, r3, r5
	sub	r12, r12, #1	// safety count = 0?
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_6
	cmp	r12, #0
	bne	sch2p19_5
sch2p19_6:
	conv_3x64_7x32
	cmp	r14, #-1
	bne	sch2p19_4	// reset safety counter
	add	r0, r0, #8	// move cursor
	vmov	r12, s4		// load hh
	add	r12, #16	// move cursor
	vmov	s4, r12		// store hh again
	vmov	r14, s6		// reload thread count
	add	r14, #1		// increment thread count
	vmov	s6, r14		// save new thread count
	vmov	r12, s2		// reload N
	cmp	r14, r12, LSR #2// thread count >= N/4?
	bcc	sch2p19_1	// next threads

sch2p19_10:			// shortening thread length
	add	r0, r0, #8	// adjust cursor
	sub	r1, r1, #8	// adjust cursor
	vmov	r14, s6		// load thread count
	sub	r14, #2
	vmov	s6, r14		// store adjusted thread count
sch2p19_11:
	vmov	r12, s5		// load safety count
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #-8
 	smull	r6, r7, r2, r4
	smull	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smull	r10, r11, r3, r5
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_13	// first block, no overflows
sch2p19_12:
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #-8
 	smlal	r6, r7, r2, r4
	smlal	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smlal	r10, r11, r3, r5
	sub	r12, r12, #1	// safety count = 0?
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_13
	cmp	r12, #0
	bne	sch2p19_12
sch2p19_13:
	conv_3x64_7x32
	cmp	r14, #-1
	bne	sch2p19_11	// reset safety counter
	add	r1, r1, #16	// next thread, move cursor
	sub	r0, r0, #8	// next thread, move cursor
	vmov	r12, s4		// load hh
	add	r12, #16	// move cursor
	vmov	s4, r12		// store hh again
	vmov	r14, s6		// reload thread count
	subs	r14, r14, #1	// decrement thread count
	bcc	sch2p19_20	// if minus, end
	vmov	s6, r14		// save new thread count
sch2p19_14:
	vmov	r12, s5		// load safety count
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #-8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #8
 	smull	r6, r7, r2, r4
	smull	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smull	r10, r11, r3, r5
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_16	// first block, no overflows
sch2p19_15:
	ldr	r3, [r0, #4]
	ldr	r2, [r0], #-8
	ldr	r5, [r1, #4]
	ldr	r4, [r1], #8
 	smlal	r6, r7, r2, r4
	smlal	r8, r9, r2, r5
	smlal	r8, r9, r3, r4
	smlal	r10, r11, r3, r5
	sub	r12, r12, #1	// safety count = 0?
	subs	r14, r14, #1	// thread count = 0?
	bcc	sch2p19_16
	cmp	r12, #0
	bne	sch2p19_15
sch2p19_16:
	conv_3x64_7x32
	cmp	r14, #-1
	bne	sch2p19_14	// reset safety counter
	add	r0, r0, #16	// move cursor
	sub	r1, r1, #8	// move cursor
	vmov	r12, s4		// load hh
	add	r12, #16	// move cursor
	vmov	s4, r12		// store hh again
	vmov	r14, s6		// reload thread count
	sub	r14, r14, #1	// decrement thread count
	vmov	s6, r14		// save new thread count
	b	sch2p19_11	// next threads
sch2p19_20:			// mv hh back to h
	vmov	r0, s7		// reload old hh
	vmov	r1, s0		// reload h
	vmov	r11, s2		// reload N
	mov	r12, #4591
	movw	r14, #47521
	movt	r14, #65521
sch2p19_21:
	ldm	r0!, {r2-r9}
	br_32	r2, r12, r14, r10
	br_32	r3, r12, r14, r10
	br_32	r4, r12, r14, r10
	br_32	r5, r12, r14, r10
	br_32	r6, r12, r14, r10
	br_32	r7, r12, r14, r10
	br_32	r8, r12, r14, r10
	br_32	r9, r12, r14, r10
	pkhbt	r2, r2, r3, LSL #16
	pkhbt	r3, r4, r5, LSL #16
	pkhbt	r4, r6, r7, LSL #16
	pkhbt	r5, r8, r9, LSL #16
	stm	r1!, {r2-r5}
	subs	r11, r11, #4
	bne	sch2p19_21

	vmov	r3, s2		// load N
	add	r4, r3, r3, LSL #1 // 3*N
	add	sp, sp, r4, LSL #2 // sp += 12N
	pop	{r4-r11,lr}
	bx	lr
