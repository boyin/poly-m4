	// Simple GNU assembly test

// polymul_4x4_divR(int *h, int *f, int *g); 


.p2align 2,,3	
.syntax	unified
.text

q:	.quad 4591
qR2inv:	.quad -935519	

.p2align 2,,3	
.syntax	unified
.text
.global	polymul_4x4
.type 	polymul_4x4, %function
polymul_4x4:
	push 	{r3-r11,lr}
	ldr	r3,=4591		// r3 = q
	ldr	r14,=-935519 		// r14 = round(2^32/q)
	ldrd	r4, r5, [r1]  		// r4 = f01, r5 = f23
	ldrd	r6, r7, [r2]  		// r6 = g01, r7 = g23
	smulbb	r8, r4, r6		// r8 = f0 g0 = h0 (32bit)
	smuadx	r9, r4, r6		// r9 = f0 g1 + f1 g0 = h1 (32bit)
	smmulr	r10, r8, r14		// r10 ~= r8 // q
	smmulr	r11, r9, r14		// r11 ~= r9 // q
	mla	r8, r10, r3, r8		// r8 = h0 
	mla	r9, r11, r3, r9		// r9 = h1 
	pkhbt	r9, r8, r9, LSL #16	// r9 = (h0, h1) = h01
	ldr	r8, [r2, #2]		// [r8] = g12
	//mov	r8, r7, LSL #16
	//orr	r8, r8, r6, LSR #16
	str	r9, [r0]		// h[0] = [r0] = h01
	smuadx	r10, r4, r7		// r10 = f0 g3 + f1 g2
	smulbb	r9, r5, r6		// r9 = f2 g0
	smladx	r10, r5, r6, r10	// r10 = h3 (32bit)
	smladx	r9, r4, r8, r9		// r9 = h2 (32bit)
	smmulr	r11, r9, r14		// r11 ~= r9 // q
	smmulr	r12, r10, r14		// r12 ~= r10 // q
	mla	r9, r11, r3, r9		// r9 = h2
	mla	r10, r12, r3, r10	// r10 = h3
	pkhbt	r9, r9, r10, LSL #16	// r9 = (h2, h3) = h23
	str	r9, [r0, #4]		// h[1] = [r0+4] = h23
	smultt	r9, r4, r7		// r9 = f1 g3
	smuadx	r10, r5, r7		// r10 = f2 g3 + f3 g2 = h5 (32bit)
	smultt	r4, r5, r7		// r4 = f3 g3 = h6 (32bit)
	smladx	r9, r5, r8, r9		// r9 = h4 (32bit)
	smmulr	r5, r9, r14		// r5 ~= r9 // q
	smmulr	r6, r10, r14		// r6 ~= r10 // q
	smmulr  r7, r4, r14		// r7 ~= r4 // q
	mla	r8, r5, r3, r9		// r8 = h4
	mla	r9, r6, r3, r10		// r9 = h5
	mla	r4, r7, r3, r4		// r4 = h6
	pkhbt	r8, r8, r9, LSL #16	// r8 = (h4, h5) = h45
	uxth	r4, r4			// kill the top half of r4
	str	r8, [r0, #8]
	str	r4, [r0, #12]
	
polymul_4x4_return:	
	pop	{r3-r11,lr}
	bx	lr

.p2align 2,,3	
.syntax	unified
.text
.global	polymul_4x4s
.type 	polymul_4x4s, %function
polymul_4x4s:
	push 	{r3-r11,lr}
	ldr	r3,=4591		// r3 = q
	ldr	r14,=-935519 		// r14 = round(2^32/q)
	ldrd	r4, r5, [r1]  		// r4 = f01, r5 = f23
	ldrd	r6, r7, [r2]  		// r6 = g01, r7 = g23
	smultt	r8, r5, r7		// r8 = f3 g3 = h6 (32bit)
	smuadx	r9, r5, r7		// r9 = f2 g3 + f3 g2 = h5 (32bit)
	smmulr	r10, r8, r14		// r10 ~= r8 // q
	smmulr	r11, r9, r14		// r11 ~= r9 // q
	mla	r8, r10, r3, r8		// r8 = h6
	mla	r9, r11, r3, r9		// r9 = h5 
	pkhbt	r9, r9, r8, LSL #16	// r9 = (h5, h6) = h56
	ldr	r8, [r2, #2]		// [r8] = g12
	str	r9, [r0, #12]		// h[3] = [r0+12] = h56
	smuadx	r10, r4, r7		// r10 = f0 g3 + f1 g2
	smultt	r9, r4, r7		// r9 = f1 g3
	smladx	r10, r5, r6, r10	// r10 = h3 (32bit)
	smladx	r9, r5, r8, r9		// r9 = f1 g3 + f2 g2 + f3 g1 =h4 (32bit)
	smmulr	r11, r9, r14		// r11 ~= r9 // q
	smmulr	r12, r10, r14		// r12 ~= r10 // q
	mla	r9, r11, r3, r9		// r9 = h4
	mla	r10, r12, r3, r10	// r10 = h3
	pkhbt	r9, r10, r9, LSL #16	// r9 = (h3, h4) = h34
	str	r9, [r0, #8]		// h[2] = [r0+8] = h34
	smulbb	r9, r5, r6		// r9 = f2 g0
	smuadx	r10, r4, r6		// r10 = f0 g1 + f1 g0 = h1 (32bit)
	smulbb	r5, r4, r6		// r5 = f0 g0 = h0 (32bit)
	smladx	r9, r4, r8, r9		// r9 = f2 g0 + f1 g1 + f0 g2 =h2 (32bit)
	smmulr	r4, r9, r14		// r4 ~= r9 // q
	smmulr	r6, r10, r14		// r6 ~= r10 // q
	smmulr  r7, r5, r14		// r7 ~= r5 // q
	mla	r8, r4, r3, r9		// r8 = h2
	mla	r9, r6, r3, r10		// r9 = h1
	mla	r5, r7, r3, r5		// r5 = h0
	pkhbt	r8, r9, r8, LSL #16	// r8 = (h1, h2) = h12
	lsl	r5, r5, #16		// kill the bottom half of r5
	str	r8, [r0, #4]
	str	r5, [r0]
	
polymul_4x4s_return:	
	pop	{r3-r11,lr}
	bx	lr

	
	
