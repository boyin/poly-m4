#!/usr/bin/python
import sys
import re
from math import log,ceil,floor,sqrt

def cmod (A, B) :
    assert (B>0 and B==int(B))
    R = A % B
    if R > B/2 :
        return R - B
    else :
        return R

#V[loc] = "s%d", "[sp,#%d]", "sp+%d" or "label[%d]" where V[label] = "sp+%d"
from loadsave import alloc_save,print_ldr,print_str,alloc_save_no,read_V

# need to sync this list with whatever file that calls this file
# otherwise the results will be wrong
#
alloc_save("h")			# V["h"] = s0	# h = output
alloc_save("g")			# V["g"] = s1	# g = input 1
alloc_save("f")			# V["f"] = s2	# f = input 0

def mul32_mod3 (f0,f1,g0,g1,L0,L1,H0,H1,X0,X1,CT) : # CT:0=unroll else cnt reg
    # L = g[31] * f
    print "	and	%s, %s, %s, ASR #31" % (L0,f0,g0)
    print "	eor	%s, %s, %s, ASR #31" % (L1,f1,g1)
    print "	and	%s, %s, %s" % (L1, L1, L0)
    # g <<= 1
    print "	lsls	%s, %s, #1" % (g0,g0)
    print "	lsls	%s, %s, #1" % (g1,g1)
    # initialize H
    print "	ubfx	%s, %s, #31, #1" % (H0, L0)
    print "	ubfx	%s, %s, #31, #1" % (H1, L1)
    # X = g[31] * f
    print "	and	%s, %s, %s, ASR #31" % (X0,f0,g0)
    print "	eor	%s, %s, %s, ASR #31" % (X1,f1,g1)
    print "	ands	%s, %s, %s" % (X1, X1, X0)
    # L = (L << 1) + X
    print "	eor	%s, %s, %s, LSL #1" % (L1, X0, L1)
    print "	eor	%s, %s, %s, LSL #1" % (X0, X0, L0)
    print "	eor	%s, %s, %s, LSL #1" % (L0, X1, L0)
    print "	eors	%s, %s, %s" % (X1,X1,L1)
    print "	ands	%s, %s, %s" % (L1,L1,L0)
    print "	orrs	%s, %s, %s" % (L0,X0,X1)
    if (CT != 0) :
        print "	mov	%s, #30" % (CT)
        print "bs3_mul32_0:"
        count = 1;
    else : count = 30
    for i in range(count) :
        # g <<= 1
        print "	lsls	%s, %s, #1" % (g0,g0)
        print "	lsls	%s, %s, #1" % (g1,g1)
        # X = g[31] * f
        print "	ands	%s, %s, %s, ASR #31" % (X0,f0,g0)
        print "	eors	%s, %s, %s, ASR #31" % (X1,f1,g1)
        print "	ands	%s, %s, %s" % (X1, X1, X0)
        # (H,L) = ((H,L) << 1) + X
        print "	eors	%s, %s, %s, LSL #1" % (L1, X0, L1)
        print "	adc	%s, %s, %s	// RLX" % (H1, H1, H1)
        print "	eors	%s, %s, %s, LSL #1" % (X0, X0, L0)
        print "	adc	%s, %s, %s	// RLX" % (H0, H0, H0)
        print "	eor	%s, %s, %s, LSL #1" % (L0, X1, L0)
        print "	eors	%s, %s, %s" % (X1,X1,L1)
        print "	ands	%s, %s, %s" % (L1,L1,L0)
        print "	orrs	%s, %s, %s" % (L0,X0,X1)
    if (CT != 0) :
        print "	subs	%s, #1" % (CT)
        print "	bne	bs3_mul32_0"	

print '''	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_mul32
	.type		bs3_mul32, %function
	// void bs3_mul32(int *h, int *f, int *g); 
bs3_mul32:
	push	{r4-r11,lr}'''
print "	ldr	r4, [r1], #4"
print "	ldr	r5, [r1], #4"
print "	ldr	r6, [r2], #4"
print "	ldr	r7, [r2], #4"
mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14","r3")
print "	stm	r0!, {r8-r11}" 
print '''#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''

