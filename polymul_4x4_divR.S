	// Simple GNU assembly test

// polymul_4x4_divR(int *h, int *f, int *g); 

#define q 	4591
#define qinv 	15631	// q^{-1} mod 2^16
#define	qRinv 	14	// round(2^16/q)
#define	qR2inv	935519	// round(2^32/q)
#define _2P15 	32768	
	
.p2align 2,,3	
.syntax	unified
.text


	
.global	polymul_4x4_divR
.type 	polymul_4x4_divR, %function

	.macro	mr_hi, res32, qq, neg_qqinv, scr
	smulbb	\scr, \res32, \neg_qqinv
	smlabb	\res32, \qq, \scr, \res32
	.endm
	
	.macro	mr_16x2, r0, r1, qq, neg_qqinv, scr
	mr_hi	\r0, \qq, \neg_qqinv, \scr
	mr_hi	\r1, \qq, \neg_qqinv, \scr
	pkhtb	\r0, \r1, \r0, ASR #16
	.endm
	
polymul_4x4_divR:
	push 	{r4-r11,lr}
	vpush	{s16-s31}
	
	ldr	r3, [r1, #2]		// r3 = f12
	ldr	r4, [r1]  		// r4 = f01, f5 = f23
	ldr	r5, [r1, #4]
	ldr	r6, [r2]  		// r6 = g01, r7 = g23
	ldr	r7, [r2, #4]
	smulbb	r8, r4, r6		// r8 = f0 g0 = h0 (32bit)
	smuadx	r9, r4, r6		// r9 = f0 g1 + f1 g0 = h1 (32bit)
	smulbb	r10, r4, r7		// r10 = f0 g2
	smuadx	r11, r4, r7		// r11 = f0 g3 + f1 g2
	smultt	r12, r5, r6		// r12 = f3 g1
	smultt	r4, r5, r7		// r4 = f3 g3 = h6 (32bit)
	smladx  r10, r3, r6, r10	// r10 += f1 g1 + f2 g0 = h2 (32bit)
	smladx  r12, r3, r7, r12	// r12 += f1 g3 + f2 g2 = h4 (32bit)
	smladx  r11, r5, r6, r11	// r11 += f2 g1 + f3 g0 = h3 (32bit)
	smuadx	r3, r5, r7		// r3 = f2 g3 + f3 g2 = h5 (32bit)
	ldr	r6, = -qinv		// r5 = -q^{-1} mod 2^16	
	ldr	r5, = q			// r4 = q

	mr_16x2	r8, r9, r5, r6, r7
	str	r8, [r0]

	mr_16x2	r10, r11, r5, r6, r7
	str	r10, [r0, #4]

	mr_16x2	r12, r3, r5, r6, r7
	str	r12, [r0, #8]

	mr_hi	r4, r5, r6, r7             
	lsr	r4, #16
	str	r4, [r0, #12]
	
polymul_4x4_divR_return:	
 	vpop	{s16-s31}
	pop	{r4-r11,lr}
	bx	lr
