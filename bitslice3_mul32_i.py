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
   
def add_to_mod3_d (a0, a1, b0, b1) : # destroys (b0,b1)
    print "	eor	%s, %s, %s	// (a1^b0)" % (a1, a1, b0)
    print "	eor	%s, %s, %s	// (a0^b0)" % (b0, b0, a0)
    print "	eor	%s, %s, %s	// (a0^b1)" % (a0, a0, b1)
    print "	eor	%s, %s, %s	// (b1^(a1^b0))" % (b1, b1, a1)
    print "	and	%s, %s, %s	// c1=(a1^b0)&(a0^b1)" % (a1,a1,a0)
    print "	orr	%s, %s, %s	// c0=(a0^b0)|(b1^(a1^b0))" % (a0,b0,b1)

def add_to_mod3_dx (c0, c1, a0, a1, b0, b1) : # destroys (b0,b1)
    print "	eor	%s, %s, %s	// (a1^b0)" % (c1, a1, b0)
    print "	eor	%s, %s, %s	// (a0^b0)" % (b0, b0, a0)
    print "	eor	%s, %s, %s	// (a0^b1)" % (c0, a0, b1)
    print "	eor	%s, %s, %s	// (b1^(a1^b0))" % (b1, b1, c1)
    print "	and	%s, %s, %s	// c1=(a1^b0)&(a0^b1)" % (c1,c1,c0)
    print "	orr	%s, %s, %s	// c0=(a0^b0)|(b1^(a1^b0))" % (c0,b0,b1)
    
def sub_from_mod3_d (a0, a1, b0, b1) : # destroys (b0,b1)
    print "	eor	%s, %s, %s	// (a0^b0)" % (a0, a0, b0)
    print "	eor	%s, %s, %s	// (a1^b0)" % (b0, b0, a1)
    print "	eor	%s, %s, %s	// (a1^b1)" % (a1, a1, b1)
    print "	eor	%s, %s, %s	// (b1^(a0^b0))" % (b1, b1, a0)
    print "	orr	%s, %s, %s	// c0=(a0^b0)|(a1^b1)" % (a0,a0,a1)
    print "	and	%s, %s, %s	// c1=(a1^b0)&(b1^(a0^b0))" % (a1,b0,b1)

def add_sub_mod3_d (a0, a1, b0, b1, X0, X1) : # destroys (X0,X1)
    print "	eor	%s, %s, %s	// (a0^b0)" % (X0, a0, b0)
    print "	eor	%s, %s, %s	// (a1^b0)" % (X1, b0, a1)
    print "	eor	%s, %s, %s	// (a1^b1)" % (b0, a1, b1)
    print "	eor	%s, %s, %s	// (a0^b1)" % (a1, a0, b1)
    print "	eor	%s, %s, %s	// (b1^(a1^b0))" % (a0, b1, X1)
    print "	eor	%s, %s, %s	// (b1^(a0^b0))" % (b1, b1, X0)
    print "	orr	%s, %s, %s	// c0=(a0^b0)|(b1^(a1^b0))" % (a0,a0,X0)
    print "	and	%s, %s, %s	// c1=(a1^b0)&(a0^b1)" % (a1,a1,X1)
    print "	orr	%s, %s, %s	// d0=(a0^b0)|(a1^b1)" % (b0,b0,X0)
    print "	and	%s, %s, %s	// d1=(a1^b0)&(b1^(a0^b0))" % (b1,b1,X1)

def mul32_mod3 (f0,f1,g0,g1,L0,L1,H0,H1,X0,X1,CT,name) :
    # CT:0=unroll else cnt reg, name = name of routine
    # L = g[31] * f
    print "	and	%s, %s, %s, ASR #31" % (L0,f0,g0)
    print "	eor	%s, %s, %s, ASR #31" % (L1,f1,g1)
    print "	and	%s, %s, %s" % (L1, L1, L0)
    # g <<= 1
    print "	rors	%s, %s, #31" % (g0,g0)
    print "	rors	%s, %s, #31" % (g1,g1)
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
        print "%s_0:" % (name)
        count = 1;
    else : count = 30
    for i in range(count) :
        # g <<= 1
        print "	rors	%s, %s, #31" % (g0,g0)
        print "	rors	%s, %s, #31" % (g1,g1)
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
        print "	bne	%s_0" % (name)	

def mul32_mod3_negc (f0,f1,g0,g1,L0,L1,X0,X1,CT,name) :
    # CT:0=unroll else cnt reg, name = name of routine
    # L = g[31] * f
    print "	and	%s, %s, %s, ASR #31" % (L0,f0,g0)
    print "	eor	%s, %s, %s, ASR #31" % (L1,f1,g1)
    print "	and	%s, %s, %s" % (L1, L1, L0)
    if (CT != 0) :
        print "	mov	%s, #31" % (CT)
        print "%s_0:" % (name)
        count = 1;
    else : count = 31
    for i in range(count) :
        # g <<= 1
        print "	rors	%s, %s, #31" % (g0,g0)
        print "	rors	%s, %s, #31" % (g1,g1)
        # negate top term in L
        print "	ands	%s, %s, #(1<<31)" % (X1, L0)
        print "	eors	%s, %s, %s" % (L1, L1, X1)
        # X = g[31] * f        
        print "	ands	%s, %s, %s, ASR #31" % (X0,f0,g0)
        print "	eors	%s, %s, %s, ASR #31" % (X1,f1,g1)
        print "	ands	%s, %s, %s" % (X1, X1, X0)
        # L += X
        print "	eor	%s, %s, %s, ROR #31" % (L1, X0, L1)
        print "	eor	%s, %s, %s, ROR #31" % (X0, X0, L0)
        print "	eor	%s, %s, %s, ROR #31" % (L0, X1, L0)
        print "	eors	%s, %s, %s" % (X1,X1,L1)
        print "	ands	%s, %s, %s" % (L1,L1,L0)
        print "	orrs	%s, %s, %s" % (L0,X0,X1)
    if (CT != 0) :
        print "	subs	%s, #1" % (CT)
        print "	bne	%s_0" % (name)	

