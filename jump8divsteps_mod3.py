#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

ARGS = sys.argv
NIT = 0			# global variable, how many IT instructions?
LIT = []		# global variable, currently these IT instructions

# adjust
# def adj_size (size) :
#     if (size < q_ab) :  # 2341 is q-dependent
#         return(size)
#     else :
#         i = ceil ((floor(size * q16 / 2.0**16 + 0.5) - 0.5) * 2.0**16 / q16) - 1
#         return(i - q * floor(i * q16 / 2.0**16 +0.5))


#V[loc] = "s%d", "[sp,#%d]", "sp+%d" or "label[%d]" where V[label] = "sp+%d"
from loadsave import alloc_save,print_ldr,print_str,alloc_save_no,read_V,read_NV

# need to sync this list with whatever file that calls this file
# otherwise the results will be wrong 

alloc_save("D")
alloc_save("-1")
alloc_save("3")
alloc_save("F")
alloc_save("c")

def o(S) :
    return read_V(S)

# alloc_save("0" ) # scratch registers
# alloc_save("1" )
# alloc_save("2" )
# alloc_save("3" )
# alloc_save("4" )
# alloc_save("5" )
# alloc_save("6" )
# alloc_save("7" )
# alloc_save("8" )
# alloc_save("9" )
# alloc_save("10")
# alloc_save("11")
# alloc_save("12")
# alloc_save("13")
  
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

def reduce_mod3_5 (X, scr, r03) : # at most 5, r03 = 0x03030303 
    print "	usub8	%s, %s, %s		// >= 3 ?" % (scr, X, r03)
    print "	sel	%s, %s, %s		// select" % (X, scr, X)

def reduce_mod3_11 (X, scr, r03) : # r03 = 0x03030303, good for 4 adds
    print "	bic	%s, %s, %s		// top 3b < 3" % (scr, X, r03)
    print "	and	%s, %s, %s		// bot 2b < 4" % (X, X, r03)
    print "	add	%s, %s, %s, LSR #2	// range <=5" % (X, X, scr)
    reduce_mod3_5 (X, scr, r03)
    
def reduce_mod3_32 (X, scr, r03) : # r03 = 0x03030303, good for 8 adds
    print "	bic	%s, %s, %s		// top 3b < 8" % (scr, X, r03)
    print "	and	%s, %s, %s		// bot 2b < 4" % (X, X, r03)
    print "	add	%s, %s, %s, LSR #2	// range <=10" % (X, X, scr)
    reduce_mod3_11 (X, scr, r03)
    
# def reduce_mod3_lazy (X, scr, r03) :
#     print "#ifdef __thumb2__"	
#     print "	and	%s, %s, #0xF0F0F0F0	// top 4b < 16" % (scr, X)
#     print "	and	%s, %s, #0x0F0F0F0F	// bot 4b < 16" % (X, X)
#     print "	add	%s, %s, %s, LSR #4	// range < 31" % (X, X, scr)
#     print "#else"
#     print_ldr(r03, "F", "reload #0x0F0F0F0F")
#     print "	bic	%s, %s, %s	// top 4b < 16" % (scr, X, r03)
#     print "	and	%s, %s, %s	// bot 4b < 16" % (X, X, r03)
#     print "	add	%s, %s, %s, LSR #4	// range < 31" % (X, X, scr)
#     print_ldr(r03, "3", "reload #0x03030303")
#     print "#endif"
#      
# def reduce_mod3_full (X, scr, r03) :  
#     reduce_mod3_lazy (X, scr)
#     reduce_mod3_32 (X, scr, r03) 


def shift_left_8 (X0, X1) :
    print "	lsl	%s, %s, #8" % (X1, X1)
    print "	orr	%s, %s, %s, LSR #24" % (X1, X1, X0)
    print "	lsl	%s, %s, #8" % (X0, X0)

def shift_left_16 (X0, X1) :
    print "	lsl	%s, %s, #16" % (X1, X1)
    print "	orr	%s, %s, %s, LSR #16" % (X1, X1, X0)
    print "	lsl	%s, %s, #16" % (X0, X0)

def shift_left_24 (X0, X1) :
    print "	lsl	%s, %s, #24" % (X1, X1)
    print "	orr	%s, %s, %s, LSR #8" % (X1, X1, X0)
    print "	lsl	%s, %s, #24" % (X0, X0)

# def shift_left_32 (X0, X1) :
#     print "	mov	%s, %s" % (X1, X0)
#     print "	mov	%s, #0" % (X0)
#     
# def shift_left_40 (X0, X1) :
#     print "	lsl	%s, %s, #8" % (X1, X0)
#     print "	mov	%s, #0" % (X0)
#    
def shift_left_48 (X0, X1) :
    print "	lsl	%s, %s, #16" % (X1, X0)
    print "	mov	%s, #0" % (X0)

def shift_left_56 (X0, X1) :
    print "	lsl	%s, %s, #24" % (X1, X0)
    print "	mov	%s, #0" % (X0)
 
f0 = "r2"; f1 = "r3"; g0 = "r4"; g1 = "r5"; u0 = "r6"; u1 = "r7"
v0 = "r8"; v1 = "r9"; r0 = "r10"; r1 = "r11"; s0= "r12"; s1 = "r14"
X = "r0"; T = "r1"


def j8ds_1y (f0,f1,g0,g1,u,v,r,s,T,X) : # one divstep, minus shifting of u and v
    global NIT, LIT	# X = 0x0303003, o("-1")=-1.0f, o("D")= minusdelta
    # minusdelta < -1?
    print "	uxtb	%s, %s" % (T, g0)
    print "	vcmp.f32	%s, %s		// delta > 0?" % (o("-1"),o("D"))
    print "	vmrs	APSR_nzcv, FPSCR	// move carry"
    NIT = 1;
    LIT = ["	cmpcs	%s, #1" % (T)]
    cond_ex("cs",[[u,r], [v,s], [[f0,f1],[g0,g1]], o("D")], T)
    # end of first half
    print "	vadd.f32	%s, %s, %s 	// dec minusdelta" % (o("D"),o("D"),o("-1"))
    print "	sub	%s, %s, %s	// -f" % (T, X, f0)
    print "	mul	%s, %s, %s	// T0 = -f0*g0" % (T, g0, T)
    print "	and	%s, %s, #0xff	// T0 = 0..4" % (T, T)
    print "	mla	%s, %s, %s, %s	// r+=T0*u, 0..10" % (r, T, u, r)
    print "	mla	%s, %s, %s, %s	// s+=T0*v, 0..10" % (s, T, v, s)
    print "	mla	%s, %s, %s, %s	// g0+=T0*f0, 0..10" % (g0, T, f0, g0)
    print "	mla	%s, %s, %s, %s	// g1+=T0*f1, 0..10" % (g1, T, f1, g1)
    print "	lsr	%s, %s, #8" % (g0, g0)
    print "	orr	%s, %s, %s, LSL #24" % (g0, g0, g1)
    reduce_mod3_11(g0, T, X)
    # special reduction combined with right shift 8
    print "	and	%s, %s, %s, LSR #8" % (T, X, g1)
    print "	bic	%s, %s, %s" % (g1, g1, X)
    print "	add	%s, %s, %s, LSR #10" % (g1, T, g1)
    reduce_mod3_5(g1, T, X)
    reduce_mod3_11(r, T, X)
    reduce_mod3_11(s, T, X)
    # end of second half

def j8ds_1x (f0,f1,g0,g1,u,v,r,s,T,X) : # one divstep, with shifting of u and v
    j8ds_1y (f0,f1,g0,g1,u,v,r,s,T,X)
    print "	lsl	%s, %s, #8	// u*=x" % (u, u)
    print "	lsl	%s, %s, #8	// v*=x" % (v, v)

def j8ds_1w (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X) : # 1 divstep ext shift u,v
    j8ds_1y (f0,f1,g0,g1,u0,v0,r0,s0,T,X)
    print "	mov	%s, #256" % T
    print "	umull	%s, %s, %s, %s	// u*=x" % (u0, u1, u0, T)
    print "	umull	%s, %s, %s, %s	// v*=x" % (v0, v1, v0, T)
    print "	mov	%s, #0" % (r1)
    print "	mov	%s, #0" % (s1)
    
def j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X) : # set up for up to 8 divsteps
    print_str("r0","D","save minusdelta")
    print "	vcvt.f32.s32	%s, %s		// convert to float" %(o("D"),o("D"))
    print "	vmov.f32	%s, #-1.0	// float -1.0 #240" % (o("-1"))
    print "	ldr	%s, [r3, #4] // g1" % (g1)
    print "	ldr	%s, [r3] //g0" % (g0)
    print "	ldr	%s, [r2, #4] // f1" % (f1)
    print "	ldr	%s, [r2] //f0" % (f0)
    print "	mov	%s, #1	// u0" % (u0)
    print "	mov	%s, #0	// v0" % (v0)
    print "	mov	%s, #0	// r0" % (r0)
    print "	mov	%s, #1	// s0" % (s0)
    print "	movw	%s, 0x0303" % (X)
    print "	movt	%s, 0x0303" % (X)
    
def j8ds_1v (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X) : # no shift u,v
    global NIT, LIT	# X = 0x0303003, o("-1")=-1.0f, o("D")= minusdelta
    # minusdelta < -1?
    print "	uxtb	%s, %s" % (T, g0)
    print "	vcmp.f32	%s, %s		// delta > 0?" % (o("-1"),o("D"))
    print "	vmrs	APSR_nzcv, FPSCR	// move carry"
    NIT = 1;
    LIT = ["	cmpcs	%s, #1" % (T)]
    cond_ex("cs",[[[u0,u1],[r0,r1]], [[v0,v1],[s0,s1]], [[f0,f1],[g0,g1]], o("D")], T)
    # end of first half
    print "	vadd.f32	%s, %s, %s 	// dec minusdelta" % (o("D"),o("D"),o("-1"))
    print "	sub	%s, %s, %s	// -f" % (T, X, f0)
    print "	mul	%s, %s, %s	// T0 = -f0*g0" % (T, g0, T)
    print "	and	%s, %s, #0xff	// T0 = 0..4" % (T, T)
    print "	mla	%s, %s, %s, %s	// r0+=T0*u0, 0..10" % (r0, T, u0, r0)
    print "	mla	%s, %s, %s, %s	// r1+=T0*u1, 0..10" % (r1, T, u1, r1)
    print "	mla	%s, %s, %s, %s	// s0+=T0*v0, 0..10" % (s0, T, v0, s0)
    print "	mla	%s, %s, %s, %s	// s1+=T0*v1, 0..10" % (s1, T, v1, s1)
    print "	mla	%s, %s, %s, %s	// g0+=T0*f0, 0..10" % (g0, T, f0, g0)
    print "	mla	%s, %s, %s, %s	// g1+=T0*f1, 0..10" % (g1, T, f1, g1)
    print "	lsr	%s, %s, #8" % (g0, g0)
    print "	orr	%s, %s, %s, LSL #24" % (g0, g0, g1)
    reduce_mod3_11(g0, T, X)
    # special reduction combined with right shift 8
    print "	and	%s, %s, %s, LSR #8" % (T, X, g1)
    print "	bic	%s, %s, %s" % (g1, g1, X)
    print "	add	%s, %s, %s, LSR #10" % (g1, T, g1)
    reduce_mod3_5(g1, T, X)
    reduce_mod3_11(r0, T, X)
    reduce_mod3_11(r1, T, X)
    reduce_mod3_11(s0, T, X)
    reduce_mod3_11(s1, T, X)
    # end of second half

def j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X) :
    j8ds_1v (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    shift_left_8(u0, u1)
    shift_left_8(v0, v1)
    
def j8ds_1 () :	# satisfy the same equations as j8ds, but only 1 divstep
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_1_0:	// start of turn 0"
    j8ds_1y (f0,f1,g0,g1,u0,v0,r0,s0,T,X) # r, s = 0..10
    print "	mov	%s, #0x1000000" % (T)
    print "	umull	%s, %s, %s, %s" % (u1, u0, u0, T)
    print "	umull	%s, %s, %s, %s" % (v1, v0, v0, T)
    print "	umull	%s, %s, %s, %s" % (r1, r0, r0, T)
    print "	umull	%s, %s, %s, %s" % (s1, s0, s0, T)
    #shift_left_56(u0,u1)
    #shift_left_56(v0,v1)
    #shift_left_56(r0,r1)
    #shift_left_56(s0,s1)
    
def j8ds_2() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_2_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X)
    print "jump8divsteps_ub3_2_1:	// start of turn 1"
    j8ds_1y (f0,f1,g0,g1,u0,v0,r0,s0,T,X)
    print "	mov	%s, #0x10000" % (T)
    print "	umull	%s, %s, %s, %s" % (u1, u0, u0, T)
    print "	umull	%s, %s, %s, %s" % (v1, v0, v0, T)
    print "	umull	%s, %s, %s, %s" % (r1, r0, r0, T)
    print "	umull	%s, %s, %s, %s" % (s1, s0, s0, T)
    #shift_left_48(u0,u1)
    #shift_left_48(v0,v1)
    #shift_left_48(r0,r1)
    #shift_left_48(s0,s1)

def j8ds_3() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_3_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_3_1:	// start of turn 1"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_3_2:	// start of turn 2"
    j8ds_1y (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "	mov	%s, #0x100" % (T)
    print "	umull	%s, %s, %s, %s" % (u1, u0, u0, T)
    print "	umull	%s, %s, %s, %s" % (v1, v0, v0, T)
    print "	umull	%s, %s, %s, %s" % (r1, r0, r0, T)
    print "	umull	%s, %s, %s, %s" % (s1, s0, s0, T)
    #shift_left_40(u0,u1)
    #shift_left_40(v0,v1)
    #shift_left_40(r0,r1)
    #shift_left_40(s0,s1)

def j8ds_4() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u1,v1,r1,s1,X)
    print "jump8divsteps_ub3_4_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u1,v1,r1,s1,T,X) 
    print "jump8divsteps_ub3_4_1:	// start of turn 1"
    j8ds_1x (f0,f1,g0,g1,u1,v1,r1,s1,T,X) 
    print "jump8divsteps_ub3_4_2:	// start of turn 2"
    j8ds_1x (f0,f1,g0,g1,u1,v1,r1,s1,T,X) 
    print "jump8divsteps_ub3_4_3:	// start of turn 3"
    j8ds_1y (f0,f1,g0,g1,u1,v1,r1,s1,T,X)
    print "	mov	%s, #0" % (u0)
    print "	mov	%s, #0" % (v0)
    print "	mov	%s, #0" % (r0)
    print "	mov	%s, #0" % (s0)

def j8ds_5() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_5_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_5_1:	// start of turn 1"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_5_2:	// start of turn 2"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_5_3:	// start of turn 3"
    j8ds_1w (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_5_4:	// start of turn 4"
    j8ds_1v (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    #shift_left_24(u0,u1)
    #shift_left_24(v0,v1)
    #shift_left_24(r0,r1)
    #shift_left_24(s0,s1)
    print "	mov	%s, 0x1000000" % (T)
    print "	umull	%s, %s, %s, %s" % (u0, X, u0, T)
    print "	add	%s, %s, %s, LSL #24" % (u1, X, u1)
    print "	umull	%s, %s, %s, %s" % (v0, X, v0, T)
    print "	add	%s, %s, %s, LSL #24" % (v1, X, v1)
    print "	umull	%s, %s, %s, %s" % (r0, X, r0, T)
    print "	add	%s, %s, %s, LSL #24" % (r1, X, r1)
    print "	umull	%s, %s, %s, %s" % (s0, X, s0, T)
    print "	add	%s, %s, %s, LSL #24" % (s1, X, s1)

    
def j8ds_6() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_6_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_6_1:	// start of turn 1"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_6_2:	// start of turn 2"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_6_3:	// start of turn 3"
    j8ds_1w (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_6_4:	// start of turn 4"
    j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_6_5:	// start of turn 5"
    j8ds_1v (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    #shift_left_16(u0,u1)
    #shift_left_16(v0,v1)
    #shift_left_16(r0,r1)
    #shift_left_16(s0,s1)
    print "	mov	%s, 0x10000" % (T)
    print "	umull	%s, %s, %s, %s" % (u0, X, u0, T)
    print "	add	%s, %s, %s, LSL #16" % (u1, X, u1)
    print "	umull	%s, %s, %s, %s" % (v0, X, v0, T)
    print "	add	%s, %s, %s, LSL #16" % (v1, X, v1)
    print "	umull	%s, %s, %s, %s" % (r0, X, r0, T)
    print "	add	%s, %s, %s, LSL #16" % (r1, X, r1)
    print "	umull	%s, %s, %s, %s" % (s0, X, s0, T)
    print "	add	%s, %s, %s, LSL #16" % (s1, X, s1)

def j8ds_7() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_7_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_7_1:	// start of turn 1"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_7_2:	// start of turn 2"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_7_3:	// start of turn 3"
    j8ds_1w (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_7_4:	// start of turn 4"
    j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_7_5:	// start of turn 5"
    j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_7_6:	// start of turn 6"
    j8ds_1v (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "	mov	%s, 0x100" % (T)
    print "	umull	%s, %s, %s, %s" % (u0, X, u0, T)
    print "	add	%s, %s, %s, LSL #8" % (u1, X, u1)
    print "	umull	%s, %s, %s, %s" % (v0, X, v0, T)
    print "	add	%s, %s, %s, LSL #8" % (v1, X, v1)
    print "	umull	%s, %s, %s, %s" % (r0, X, r0, T)
    print "	add	%s, %s, %s, LSL #8" % (r1, X, r1)
    print "	umull	%s, %s, %s, %s" % (s0, X, s0, T)
    print "	add	%s, %s, %s, LSL #8" % (s1, X, s1)
    #shift_left_8(u0,u1)
    #shift_left_8(v0,v1)
    #shift_left_8(r0,r1)
    #shift_left_8(s0,s1)
    
def j8ds_8() :
    global NIT, LIT
    j8ds_1z (f0,f1,g0,g1,u0,v0,r0,s0,X)
    print "jump8divsteps_ub3_8_0:	// start of turn 0"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_8_1:	// start of turn 1"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_8_2:	// start of turn 2"
    j8ds_1x (f0,f1,g0,g1,u0,v0,r0,s0,T,X) 
    print "jump8divsteps_ub3_8_3:	// start of turn 3"
    j8ds_1w (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_8_4:	// start of turn 4"
    j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_8_5:	// start of turn 5"
    j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_8_6:	// start of turn 6"
    j8ds_1u (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
    print "jump8divsteps_ub3_8_7:	// start of turn 7"
    j8ds_1v (f0,f1,g0,g1,u0,u1,v0,v1,r0,r1,s0,s1,T,X)
      
    
def j8ds_sub (NAME, routine) :
    print 
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "	.global		%s" % (NAME)
    print "	.type		%s, %%function" % (NAME) 
    print "%s:" % (NAME)
    print "	push	{r1,r4-r11,lr}"
    routine ()
    print "	vcvt.s32.f32	%s, %s	// back to int" % (o("D"),o("D"))
    print_ldr("r0","D","restore minusdelta")
    print "	pop	{r1}"
    print "	stm	r1!, {r2-r12,r14}"
    print "	pop	{r4-r11,pc}"

    
j8ds_sub("jump8divsteps_mod3_1", j8ds_1)
j8ds_sub("jump8divsteps_mod3_2", j8ds_2)
j8ds_sub("jump8divsteps_mod3_3", j8ds_3)
j8ds_sub("jump8divsteps_mod3_4", j8ds_4)
j8ds_sub("jump8divsteps_mod3_5", j8ds_5)
j8ds_sub("jump8divsteps_mod3_6", j8ds_6)
j8ds_sub("jump8divsteps_mod3_7", j8ds_7)
j8ds_sub("jump8divsteps_mod3", j8ds_8)
