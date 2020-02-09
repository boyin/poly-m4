
// void gf_polymul_16x16_mod3 (int *h, int *f, int *g);
	.p2align	2,,3	
	.syntax		unified
	.text
	.global gf_polymul_16x16_mod3
	.type	gf_polymul_16x16_mod3, %function
gf_polymul_16x16_mod3:
	push	{r4-r11,lr}
	vmov	s0, r0		// save h
	vmov	s3, r0		// save hh
	vmov	s2, r1		// save f
	vmov	s1, r2		// save g
sch3_0:			// increasing thread length
	// block (0,0)
	ldr	r5, [r1, #4]
	ldr	r4, [r1]
	ldr	r7, [r2, #4]
	ldr	r6, [r2]
	mov	r3, 0x03030303
	umlal	r8, r9, r4, r6
	umull	r10, r11, r5, r7
	umlal	r9, r10, r4, r7
	umlal	r9, r10, r5, r6
	and	r12, r8, #0x1C1C1C1C	// top 3b < 8
	and	r8, r8, r3		// bot 2b < 4
	add	r8, r8, r12, LSR #2	// range <=10
	and	r12, r8, #0x1C1C1C1C	// top 3b < 3
	and	r8, r8, r3		// bot 2b < 4
	add	r8, r8, r12, LSR #2	// range <=5
	usub8	r12, r8, r3		// >= 3 ?
	sel	r8, r12, r8		// select
	and	r12, r9, #0x1C1C1C1C	// top 3b < 8
	and	r9, r9, r3		// bot 2b < 4
	add	r9, r9, r12, LSR #2	// range <=10
	and	r12, r9, #0x1C1C1C1C	// top 3b < 3
	and	r9, r9, r3		// bot 2b < 4
	add	r9, r9, r12, LSR #2	// range <=5
	usub8	r12, r9, r3		// >= 3 ?
	sel	r9, r12, r9		// select
	and	r12, r10, #0xF0F0F0F0	// top 4b < 16
	and	r10, r10, #0x0F0F0F0F	// bot 4b < 16
	add	r10, r10, r12, LSR #4	// range < 31
	and	r12, r11, #0xF0F0F0F0	// top 4b < 16
	and	r11, r11, #0x0F0F0F0F	// bot 4b < 16
	add	r11, r11, r12, LSR #4	// range < 31
	strd	r8, r9, [r0], 8
sch3_1:			// later blocks
	// block (0,1)
	ldr	r5, [r1, #4]
	ldr	r4, [r1, #0]
	ldr	r7, [r2, #12]
	ldr	r6, [r2, #8]
	umlal	r10, r11, r4, r6
	umull	r8, r9, r5, r7
	umlal	r11, r8, r5, r6
	umlal	r11, r8, r4, r7
	// block (1,0)
	ldr	r5, [r1, #12]
	ldr	r4, [r1, #8]
	ldr	r7, [r2, #4]
	ldr	r6, [r2, #0]
 	umlal	r10, r11, r4, r6
	umlal	r8, r9, r5, r7
	umlal	r11, r8, r5, r6
	umlal	r11, r8, r4, r7
	and	r12, r10, #0xF0F0F0F0	// top 4b < 16
	and	r10, r10, #0x0F0F0F0F	// bot 4b < 16
	add	r10, r10, r12, LSR #4	// range < 31
	and	r12, r10, #0x1C1C1C1C	// top 3b < 8
	and	r10, r10, r3		// bot 2b < 4
	add	r10, r10, r12, LSR #2	// range <=10
	and	r12, r10, #0x1C1C1C1C	// top 3b < 3
	and	r10, r10, r3		// bot 2b < 4
	add	r10, r10, r12, LSR #2	// range <=5
	usub8	r12, r10, r3		// >= 3 ?
	sel	r10, r12, r10		// select
	and	r12, r11, #0xF0F0F0F0	// top 4b < 16
	and	r11, r11, #0x0F0F0F0F	// bot 4b < 16
	add	r11, r11, r12, LSR #4	// range < 31
	and	r12, r11, #0x1C1C1C1C	// top 3b < 8
	and	r11, r11, r3		// bot 2b < 4
	add	r11, r11, r12, LSR #2	// range <=10
	and	r12, r11, #0x1C1C1C1C	// top 3b < 3
	and	r11, r11, r3		// bot 2b < 4
	add	r11, r11, r12, LSR #2	// range <=5
	usub8	r12, r11, r3		// >= 3 ?
	sel	r11, r12, r11		// select
	and	r12, r8, #0xF0F0F0F0	// top 4b < 16
	and	r8, r8, #0x0F0F0F0F	// bot 4b < 16
	add	r8, r8, r12, LSR #4	// range < 31
	and	r12, r9, #0xF0F0F0F0	// top 4b < 16
	and	r9, r9, #0x0F0F0F0F	// bot 4b < 16
	add	r9, r9, r12, LSR #4	// range < 31
	strd	r10, r11, [r0], #8
sch3_10:			// decreasing thread length
	// block (1,1)
	ldr	r5, [r1, #12]
	ldr	r4, [r1, #8]
	ldr	r7, [r2, #12]
	ldr	r6, [r2, #8]
	umlal	r8, r9, r4, r6
	umull	r10, r11, r5, r7
	umlal	r9, r10, r5, r6
	umlal	r9, r10, r4, r7
	and	r12, r8, #0xF0F0F0F0	// top 4b < 16
	and	r8, r8, #0x0F0F0F0F	// bot 4b < 16
	add	r8, r8, r12, LSR #4	// range < 31
	and	r12, r8, #0x1C1C1C1C	// top 3b < 8
	and	r8, r8, r3		// bot 2b < 4
	add	r8, r8, r12, LSR #2	// range <=10
	and	r12, r8, #0x1C1C1C1C	// top 3b < 3
	and	r8, r8, r3		// bot 2b < 4
	add	r8, r8, r12, LSR #2	// range <=5
	usub8	r12, r8, r3		// >= 3 ?
	sel	r8, r12, r8		// select
	and	r12, r9, #0xF0F0F0F0	// top 4b < 16
	and	r9, r9, #0x0F0F0F0F	// bot 4b < 16
	add	r9, r9, r12, LSR #4	// range < 31
	and	r12, r9, #0x1C1C1C1C	// top 3b < 8
	and	r9, r9, r3		// bot 2b < 4
	add	r9, r9, r12, LSR #2	// range <=10
	and	r12, r9, #0x1C1C1C1C	// top 3b < 3
	and	r9, r9, r3		// bot 2b < 4
	add	r9, r9, r12, LSR #2	// range <=5
	usub8	r12, r9, r3		// >= 3 ?
	sel	r9, r12, r9		// select
	and	r12, r10, #0xF0F0F0F0	// top 4b < 16
	and	r10, r10, #0x0F0F0F0F	// bot 4b < 16
	add	r10, r10, r12, LSR #4	// range < 31
	and	r12, r11, #0xF0F0F0F0	// top 4b < 16
	and	r11, r11, #0x0F0F0F0F	// bot 4b < 16
	add	r11, r11, r12, LSR #4	// range < 31
	strd	r8, r9, [r0], #8
sch3_20:			// mv hh back to h
	and	r12, r10, #0x1C1C1C1C	// top 3b < 8
	and	r10, r10, r3		// bot 2b < 4
	add	r10, r10, r12, LSR #2	// range <=10
	and	r12, r10, #0x1C1C1C1C	// top 3b < 3
	and	r10, r10, r3		// bot 2b < 4
	add	r10, r10, r12, LSR #2	// range <=5
	usub8	r12, r10, r3		// >= 3 ?
	sel	r10, r12, r10		// select
	and	r12, r11, #0x1C1C1C1C	// top 3b < 8
	and	r11, r11, r3		// bot 2b < 4
	add	r11, r11, r12, LSR #2	// range <=10
	and	r12, r11, #0x1C1C1C1C	// top 3b < 3
	and	r11, r11, r3		// bot 2b < 4
	add	r11, r11, r12, LSR #2	// range <=5
	usub8	r12, r11, r3		// >= 3 ?
	sel	r11, r12, r11		// select
	strd	r10, r11, [r0], #8
	pop	{r4-r11,lr}
	bx	lr
