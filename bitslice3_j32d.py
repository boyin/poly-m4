#!/usr/bin/env python
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

alloc_save("ct")		# V["ct"] = s0	# the counter
alloc_save("1")			# V["1"] = s1	# the float value 1
alloc_save("M")			# V["M"] = s2	# M = output matrix ptr
alloc_save("D")			# V["D"] = s3	# delta = input 0
alloc_save("Temp")		# V["Temp"] = s4	# store temp data

def div_bot_trit_to_CZ (a1,b0,b1,X1): # a[0]!=0, destroys X1
    print "	eor	%s, %s, %s	" % (X1,a1,b1)
    print "	and	%s, %s, %s	// M = g/f in (b0[0],X1[0])" % (X1,X1,b0)
    print "	bfi	%s, %s, #1, #1	// M = (X1[1],X1[0])" % (X1,b0)
    print "	lsl	%s, %s, #29	// shift to bit 29 and 30" % (X1, X1)
    print "	msr	APSR_nzcvq, %s	// (Z=prod[0], C=prod[1])" % (X1)
    
def mul_mod3_CZ (a0, a1, b0, b1) :
    print "	ite	eq"
    print "	moveq	%s, %s" % (a0, b0)
    print "	movne	%s, #0" % (a0)
    print "	ite	cs"
    print "	biccs	%s, %s, %s" % (a1, a0, b1)
    print "	andcc	%s, %s, %s" % (a1, a0, b1)
    
def mul_mod3 (c0, c1, a0, a1, b0, b1) : # (c0,c1) can = (a0,a1), nondestructive
    print "	and	%s, %s, %s	// c0 = a0 & b0" % (c0, a0, b0)
    print "	eor	%s, %s, %s	// c1 = a1 ^ b1" % (c1, a1, b1)
    print "	ands	%s, %s, %s	// c1 = c0 & (a1 ^ b1)" % (c1, c1, c0)

def mul_mod3_2x_trit (d0, d1, a0, a1, b0, b1, c1) : # d = a * b / c, c0 = 1
    print "	and	%s, %s, %s	// d0 = a0 & b0" % (d0, a0, b0)	
    print "	eor	%s, %s, %s	// d1 = a1 ^ b1" % (d1, a1, b1) 
    print "	eors	%s, %s, %s	// d1 = a1 ^ b1 ^ c1" % (d1, d1, c1) 
    print "	ands	%s, %s, %s	// d1 = d0&(a1^b1^c1)" % (d1, d1, d0)	
    # b0, b1, c1 can be rotations, destroy flags
    
def add_to_mod3_d (a0, a1, b0, b1) : # destroys (b0,b1)
    print "	eor	%s, %s, %s	// (a1^b0)" % (a1, a1, b0)
    print "	eor	%s, %s, %s	// (a0^b0)" % (b0, b0, a0)
    print "	eor	%s, %s, %s	// (a0^b1)" % (a0, a0, b1)
    print "	eor	%s, %s, %s	// (b1^(a1^b0))" % (b1, b1, a1)
    print "	and	%s, %s, %s	// c1=(a1^b0)&(a0^b1)" % (a1,a1,a0)
    print "	orr	%s, %s, %s	// c0=(a0^b0)|(b1^(a1^b0))" % (a0,b0,b1)

def sub_from_mod3_d (a0, a1, b0, b1) : # destroys (b0,b1), flags
    print "	eors	%s, %s, %s	// (a0^b0)" % (a0, a0, b0)
    print "	eors	%s, %s, %s	// (a1^b0)" % (b0, b0, a1)
    print "	eors	%s, %s, %s	// (a1^b1)" % (a1, a1, b1)
    print "	eors	%s, %s, %s	// (b1^(a0^b0))" % (b1, b1, a0)
    print "	orrs	%s, %s, %s	// c0=(a0^b0)|(a1^b1)" % (a0,a0,a1)
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

NIT = 0			# global variable, how many IT instructions?
LIT = []		# global variable, currently these IT instructions
def cond_ex (c, L, scr) : # L is a list of [A, B] or [N],
    # A <=> B is a conditional exchange, N is N <- -N to be negated
    global NIT, LIT
    i = NIT 
    for X in L :
        if isinstance(X, str) : i += 1
        if isinstance(X, list) and len(X) == 2 and isinstance(X[0], list):
            assert(len(X[0])==len(X[1])); i += 3*len(X[0])
        if isinstance(X, list) and len(X) == 2 and isinstance(X[0], str): i += 3
    LL = LIT
    for X in L :
        if isinstance(X, str) :
            if (X[0]=="r") : LL.append("	neg%s	%s, %s" % (c, X, X))
            if (X[0]=="s") :
                LL.append("	vneg%s.f32	%s, %s" % (c, X, X))
        if isinstance(X, list) and len(X) == 2 and isinstance(X[0], str):
            LL.append("	mov%s	%s, %s	// %s<->%s" % (c,scr,X[0],X[0],X[1]))
            LL.append("	mov%s	%s, %s" % (c, X[0], X[1]))
            LL.append("	mov%s	%s, %s" % (c, X[1], scr))
        if isinstance(X, list) and len(X) == 2 and isinstance(X[0], list):
            for j in range(len(X[0])) :
                LL.append("	mov%s	%s, %s	// %s<->%s" % (c, scr, X[0][j], X[0][j], X[1][j]))
                LL.append("	mov%s	%s, %s" % (c, X[0][j], X[1][j]))
                LL.append("	mov%s	%s, %s" % (c, X[1][j], scr))
    for j in range (0, i, 4) :
        if i - j >= 4 :
            LL.insert(5*j/4, "	itttt	%s" % c)
        else :
            LL.insert(5*j/4, "	i" + "t"*(i-j) + "	" + c)
    for j in LL :
        print j 

    
def v (s) :
    return read_V(s)
    
f0 = "r0"; f1 = "r1"; g0 = "r2"; g1 = "r3"
u0 = "r6"; u1 = "r7"; v0 = "r8"; v1 = "r9"
r0 = "r10"; r1 = "r11"; s0 = "r12"; s1 = "r14"
X0 = "r4"; X1 = "r5"

#	f = r0, r1	u = r4, r5	v = r6, r7
#	g = r2, r3	r = r8, r9	s = r10, r11
#	scratch registers = r12, r14

print '''	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text
	.global 	bs3_jump32divsteps
	.type		bs3_jump32divsteps, %function
	//normal usage is 'vmov.f32 s0, #31.0' before calling
	//int bs3_jump32divsteps(int delta, int *f, int *g, int *M, float rep+1);
bs3_jump32divsteps:'''
#print "	ldr	r12, [sp]"
print "	push	{r4-r11,lr}"
#print_str("r12","Temp","save temporary data pointer")
print_str("r3","M","save result matrix ptr")
print_str("r0","D","save delta")
print "	ldr	%s, [r1]" % f0
print "	ldr	%s, [r1, #4]" % f1
print "	ldr	%s, [r2, #4]" % g1 
print "	ldr	%s, [r2]" % g0
for i in [f0,f1,g0,g1] :
    print "	rbit	%s, %s" % (i,i)
print "	mov	%s, #(1<<31)" % u0
print "	mov	%s, #(1<<31)" % s0
for i in [u1,v0,v1,r0,r1,s1] :
    print "	mov	%s, #0" % (i)
print "	vmov.f32	%s, #1.0	// float 1.0 #112" % (v("1"))
#print "	vmov.f32	%s, #31.0	// float 31.0 #63" % (v("ct"))
print "	vcvt.f32.s32	%s, %s		// convert to float" %(v("D"),v("D"))
print "bs3_jump32divsteps_0:		// first half"

print "	vcmp.f32	%s, %s		// delta > 0?" % (v("D"),v("1"))
print "	vmrs	APSR_nzcv, FPSCR	// move carry"
NIT = 1
LIT = ["	tstcs	r0, %s, LSL #1	// set cs by g0[0], then if cs" % (g0)]
cond_ex("cs",[[[f0,f1],[g0,g1]],[[u0,u1],[r0,r1]],[[v0,v1],[s0,s1]],v("D")],X1)

# print "	itttt	cs			// if cs, delta > 0, then"
# print "	tstcs	r0, %s, LSL #1		// set cs by g0[0], then if cs" % (g0) 
# print "	movcs	%s, %s	// exchange f0,g0" % (X0, f0)
# print "	movcs	%s, %s" % (f0, g0)
# print "	movcs	%s, %s" % (g0, X0)
# print "	itttt	cs			// exchanges"
# print "	movcs	%s, %s	// exchange f1,g1" % (X1, f1)
# print "	movcs	%s, %s" % (f1, g1)
# print "	movcs	%s, %s" % (g1, X1)
# print "	movcs	%s, %s	// exchange u0,r0" % (X0, u0)
# print "	itttt	cs			// exchanges"
# print "	movcs	%s, %s" % (u0, r0)
# print "	movcs	%s, %s" % (r0, X0)
# print "	movcs	%s, %s	// exchange u1,r1" % (X1, u1)
# print "	movcs	%s, %s" % (u1, r1)
# print "	itttt	cs			// exchanges"
# print "	movcs	%s, %s" % (r1, X1)
# print "	movcs	%s, %s	// exchange v0,s0" % (X0, v0)
# print "	movcs	%s, %s" % (v0, s0)
# print "	movcs	%s, %s" % (s0, X0)
# print "	itttt	cs			// exchanges"
# print "	movcs	%s, %s	// exchange v1,s1" % (X1, v1)
# print "	movcs	%s, %s" % (v1, s1)
# print "	movcs	%s, %s" % (s1, X1)
# print "	vnegcs.f32	%s, %s	// negate delta" % (v("D"),v("D"))

print "bs3_jump32divsteps_1:		// second half"
print "	vadd.f32	%s, %s, %s	// delta++" % (v("D"),v("D"),v("1"))

for R in [(u0,u1,r0,r1),(v0,v1,s0,s1),(f0,f1,g0,g1)] :
    mul_mod3_2x_trit(X0,X1,R[0],R[1],g0+",ASR #31",g1+",ASR #31",f1+",ASR #31") 
    sub_from_mod3_d(R[2],R[3],X0,X1)

print "	lsl	%s, %s, #1	// g = g/x" % (g0, g0)
print "	lsl	%s, %s, #1" % (g1, g1)
print "	vsub.f32	%s, %s, %s" % (v("ct"),v("ct"),v("1"))
print "	vcmp.f32	%s, #0.0" % (v("ct"))
print "	vmrs	APSR_nzcv, FPSCR	// move c flag"
print "	itttt	cs	// u = xu, v = xv if ct >= 0"

for i in [u0,u1,v0,v1] :
    print "	lsrcs	%s, %s, #1" % (i,i)

#print_ldr("r12","Temp","reload output matrix ptr")
#print "	stm	r12!, {r0-r11}	// store results"
#print_str("r12","Temp","save output matrix ptr")

print "	bcs	bs3_jump32divsteps_0"
print "bs3_jump32divsteps_2:	// clean up"
for i in [f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1] :
    print "	rbit	%s, %s" % (i,i)
print_ldr(X0,"M","reload output ptr for results")
print("	stm	%s,{"+"%s,"*11+"%s}") % (X0,f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1)
print "	vcvt.s32.f32	%s, %s	// back to int" % (v("D"),v("D"))
print_ldr("r0","D","restore delta")
print '''
#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''



