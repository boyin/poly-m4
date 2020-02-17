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

alloc_save("d")
alloc_save("3")
alloc_save("F")

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

       

f = "r2"; g = "r3"; u = "r4"; v = "r5"; r = "r6"; s = "r7"
X = "r8"; Y = "r9"; Z = "r10"; W = "r14"; T= "r1"; O = "r12"
d = "r0"; M = "r11"

def j4ds_1y () : # one divstep, minus shifting of u and v
    global NIT, LIT
    print "	uxtb	%s, %s"	% (T, g)
    print "	tst	%s, %s, ASR #31" % (T, d)
    NIT = 0; LIT = []
    cond_ex("ne",[[u,r],[v,s],[f,g],d],T)
    # end of first half
    print "	sub	%s, %s, %s	// -f" % (T, X, f)
    print "	mul	%s, %s, %s	// T0 = -f0*g0" % (T, g, T)
    print "	sub	%s, %s, #1	// decrement minusdelta" % (d, d)
    print "	and	%s, %s, #0xff	// T0 = 0..4" % (T, T)
    print "	mla	%s, %s, %s, %s	// r+=T0*u, 0..10" % (r, T, u, r)
    print "	mla	%s, %s, %s, %s	// s+=T0*v, 0..10" % (s, T, v, s)
    print "	mla	%s, %s, %s, %s	// g+=T0*f" % (g, T, f, g)
    # special reduction combined with right shift 8
    print "	and	%s, %s, %s, LSR #8" % (T, X, g)
    print "	bic	%s, %s, %s" % (g, g, X)
    print "	add	%s, %s, %s, LSR #10" % (g, T, g)
    reduce_mod3_5(g, T, X)
    reduce_mod3_11(r, T, X)
    reduce_mod3_11(s, T, X)
    # end of second half

def j4ds_1x () : # one divstep, minus shifting of u and v
    j4ds_1y ()
    print "	lsl	%s, %s, #8	// u*=x" % (u, u)
    print "	lsl	%s, %s, #8	// v*=x" % (v, v)

def j4ds_1z () : # set up for up to 4 divsteps
    print "	ldr	%s, [%s] //f" % (f, f)
    print "	ldr	%s, [%s] //f" % (g, g)
    print "	mov	%s, #1	// u" % u
    print "	mov	%s, #0	// v" % v
    print "	mov	%s, #0	// r" % r
    print "	mov	%s, #1	// s" % s
    print "	ldr	%s, =0x03030303" % (X)
    # print "#ifndef __thumb2__"
    # print_str(X, "3", "save #0x03030303")
    # print "	ldr	r11, =0x0f0f0f0f"
    # print_str(X, "F", "save #0x0F0F0F0F")
    # print_ldr(X, "3", "reload #0x03030303")
    # print "#endif"
    
def j4ds_1 () :	# satisfy the same equations as j4ds, but only 1 divstep
    global NIT, LIT
    j4ds_1z ()
    print "jump4divsteps_ub3_1_0:	// start of turn 0"
    j4ds_1x () # r, s = 0..10

def j4ds_2() :
    global NIT, LIT
    j4ds_1z ()
    print "jump4divsteps_ub3_2_0:	// start of turn 0"
    j4ds_1x () # r, s = 0..10
    print "jump4divsteps_ub3_2_1:	// start of turn 1"
    j4ds_1x () # r, s = 0..42; u, v = 0..10

def j4ds_3() :
    global NIT, LIT
    j4ds_1z ()
    print "jump4divsteps_ub3_3_0:	// start of turn 0"
    j4ds_1x () 
    print "jump4divsteps_ub3_3_1:	// start of turn 1"
    j4ds_1x () 
    print "jump4divsteps_ub3_3_2:	// start of turn 2"
    j4ds_1x () 

def j4ds_4() :
    global NIT, LIT
    j4ds_1z ()
    print "jump4divsteps_ub3_4_0:	// start of turn 0"
    j4ds_1x () 
    print "jump4divsteps_ub3_4_1:	// start of turn 1"
    j4ds_1x () 
    print "jump4divsteps_ub3_4_2:	// start of turn 2"
    j4ds_1x () 
    print "jump4divsteps_ub3_4_3:	// start of turn 3"
    j4ds_1y ()
    
def j4ds_sub (NAME, routine) :
    print 
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "	.global		%s" % (NAME)
    print "	.type		%s, %%function" % (NAME) 
    print "%s:" % (NAME)
    print "	push	{r1,r4-r11,lr}"
    routine ()
    print "	pop	{r1}"
    print "	stm	r1!, {r2-r7}"
    print "	pop	{r4-r11,pc}"

    
j4ds_sub("jump4divsteps_mod3_1", j4ds_1)
j4ds_sub("jump4divsteps_mod3_2", j4ds_2)
j4ds_sub("jump4divsteps_mod3_3", j4ds_3)
j4ds_sub("jump4divsteps_mod3", j4ds_4)
