#!/usr/bin/env python
import sys
import re

print '''#ifndef __thumb__	
	.macro	cbz, reg, label
	cmp	reg, #0
	beq	label
	.endm

	.macro	cbnz, reg, label
	cmp	reg, #0
	bne	label
	.endm
#endif

	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bitslice3_8
	.type		bitslice3_8, %function

	// void bitslice3_8(int *f, char *g, int c);
bitslice3_8:
	push	{r4-r11,lr}	
	and	r12, r2, #31
	bics	r14, r2, #31
	beq	bitslice3_8_1
bitslice3_8_0:	
	ldm	r1!, {r2-r9}
	sbfx	r10, r9, #24, #1
	sbfx	r11, r9, #31, #1'''
for j in range(9,1,-1) :
    for k in range(3,-1,-1) :
        if (j<9 or k<3) :
            print "	teq	r0, r%d, LSR #%d" % (j, k*8+1)
            print "	adc	r10, r10, r10"
            print "	teq	r0, r%d, LSR #%d" % (j, k*8+8)
            print "	adc	r11, r11, r11"
print '''	strd	r10, r11, [r0], #+8
	subs	r14, r14, #32
	bne	bitslice3_8_0
bitslice3_8_1:
	cmp	r12, #0
	beq	bitslice3_8_3
	mov	r10, #0
	mov	r11, #0
	add	r1, r1, r12
bitslice3_8_2:
	ldrsb	r2, [r1, #-1]!
	teq	r0, r2, LSR #1
	adc	r10, r10, r10
	teq	r0, r2, LSR #8
	adc	r11, r11, r11
	subs	r12, #1
	bne	bitslice3_8_2
	strd	r10, r11, [r0], #8
bitslice3_8_3:
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''


print '''	//unbitslice functions	
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	unbitslice3_8
	.type		unbitslice3_8, %function

	// void unbitslice3_8(char *f, int *g, int c);
unbitslice3_8:
	push	{r4-r11,lr}	
	subs	r14, r2, #32
	bcc	unbitslice3_8_1
unbitslice3_8_0:
	ldrd	r10, r11, [r1], #8'''
for j in range(9,1,-1) :
    for k in range(3,-1,-1) :
        print "	sbfx	r12, r11, #%d, #1" % (4*(j-2)+k)
        if (j>0 or k>0) :
            print "	teq	r10, r10, LSR #%d" % (4*(j-2)+k+1)
            print "	adc	r12, r12, r12"
            print "	bfi	r%d, r12, #%d, #8" % (j,k*8)
        else :
            print "	bfi	r12, r10, #0, #1"
            print "	bfi	r2, r12, #0, #8"
print '''
	stm	r0!, {r2-r9}	
	subs	r14, r14, #32
	bcs	unbitslice3_8_0
unbitslice3_8_1:
	adds	r14, r14, #32
	beq	unbitslice3_8_3
	ldrd	r10, r11, [r1], #8	
unbitslice3_8_2:
	sbfx	r12, r11, #0, #1
	lsr	r11, r11, #1
	bfi	r12, r10, #0, #1
	lsr	r10, r10, #1
	strb	r12, [r0], #1
	subs	r14, r14, #1
	bne	unbitslice3_8_2
unbitslice3_8_3:
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''
