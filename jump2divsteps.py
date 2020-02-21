#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631		# q^{-1} mod 2^16
q32inv = -935519	# round(2^32/q)
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

alloc_save("q32")# round(2^32/q)
alloc_save_no("q", str(q))# ; print "q is %s" % read_V("q")
alloc_save("d")

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


f = "r2"; g = "r3"; u = "r4"; v = "r5"; r = "r6"; s = "r7"
qi = "r1"; rq = "r12"; X = "r8"; Y = "r9"; Z = "r10"; W = "r14"

        
def j2ds_prologue () :
    global V, NV
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "// void jump2divsteps (int minusdelta, int *M, int f, int g);"
    print "	.global jump2divsteps"
    print "	.type	jump2divsteps, %function"
    print "jump2divsteps:"
    print "	push	{r1,r4-r11,lr}"
    print_ldr(rq, "q", "load q")
    print "	movw	r1, #%d" % (q32inv % 65536) 
    print "	movt	r1, #%d" % (65536 + q32inv // 65536)
    print_str(qi, "q32", "save q32inv")

def j2ds_1_prologue () :
    global V, NV
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "// void jump2divsteps_1 (int minusdelta, int *M, int f, int g);"
    print "	.global jump2divsteps_1"
    print "	.type	jump2divsteps_1, %function"
    print "jump2divsteps_1:"
    print "	push	{r1,r4-r11,lr}"
    print_ldr(rq, "q", "load q")
    print "	movw	r1, #%d" % (q32inv % 65536) 
    print "	movt	r1, #%d" % (65536 + q32inv // 65536)
    print_str(qi, "q32", "save q32inv")

    

def j2ds_epilogue() :
    print "	pop	{r1}"
    print "	stm	r1, {r2-r7}"
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"

def j2ds_1 () :	# satisfy the same equations as j2ds, but only 1 divstep
    global NIT, LIT
    print "	mov	r4, #1	// u"
    print "	mov	r5, #0	// v"
    print "	mov	r6, #0	// r"
    print "	mov	r7, #1	// s"
    print "jump2divsteps_1_t0:	// start of turn 0"
    print "	uxth	r10, r3"
    print "	tst	r10, r0, ASR #31"
    NIT = 0; LIT = []
    cond_ex("ne",[["r4","r6"],["r5","r7"],["r2","r3"],"r0"],"r10")
    print "jump2divsteps_1_t0_1:	// end of first half"
    print "	mov	r11, #0"
    print "	ssub16	r8, r11, r3	// r8 = -g"
    print "	sub	r0, r0, #1	// decrement minusdelta"
    print "	smlsdx	r3, r2, r3, r11	// (f(0) g - g(0) f) / x "
    print "	br_32	r3, r12, r1, r11 //red. new g[0] %% %d, 32b" % (q)
    print "	uxth	r3, r3"
    print "	smulbb	r9, r8, r4	// - u[0] g[0]"
    print "	smlabb	r6, r2, r6, r9	// f[0] r[0] - g[0] u[0], 32bit"
    print "	smulbb	r9, r8, r5	// - v[0] g[0]"
    print "	smlabb	r7, r2, r7, r9	// f[0] s[0] - g[0] v[0], 32bit"
    print "	lsl	r4, r4, #16	// r4 was 0/1; shift"
    print "	lsl	r5, r5, #16	// r5 was 0/1; shift"
    print "	lsl	r6, r6, #16	// r6 was reduced, shift"
    print "	lsl	r7, r7, #16	// r7 was reduced, shift"


    
def j2ds() :
    global NIT, LIT
    print "	mov	r4, #1	// u"
    print "	mov	r5, #0	// v"
    print "	mov	r6, #0	// r"
    print "	mov	r7, #1	// s"
    print "jump2divsteps_t0:	// start of turn 0"
    print "	uxth	r10, r3"
    print "	tst	r10, r0, ASR #31"
    NIT = 0; LIT = []
    cond_ex("ne",[["r4","r6"],["r5","r7"],["r2","r3"],"r0"],"r10")
    print "jump2divsteps_t0_1:	// end of first half"
    print "	mov	r11, #0"
    print "	ssub16	r8, r11, r3	// r8 = -g"
    print "	sub	r0, r0, #1	// decrement minusdelta"
    print "	smlsdx	r3, r2, r3, r11	// (f(0) g - g(0) f) / x "
    print "	br_32	r3, r12, r1, r11 //red. new g[0] %% %d, 32b" % (q)
    print "	uxth	r3, r3"
    print "	smulbb	r9, r8, r4	// - u[0] g[0]"
    print "	smlabb	r6, r2, r6, r9	// f[0] r[0] - g[0] u[0], 32bit"
    print "	smulbb	r9, r8, r5	// - v[0] g[0]"
    print "	smlabb	r7, r2, r7, r9	// f[0] s[0] - g[0] v[0], 32bit"
    print "	lsl	r4, r4, #16	// r4 was 0/1; shift"
    print "	lsl	r5, r5, #16	// r5 was 0/1; shift"
    print "	uxth	r6, r6		// r6 was reduced"
    print "	uxth	r7, r7		// r7 was reduced"
    print "jump2divsteps_t1:	// start of turn 1" 
    print "	// top of r4(u)/r5(v): 0/1,  of r6(r)/r7(s): 0"
    print "	// start of first half, no need to reduce g[0]"
    print "	tst	r3, r0, ASR #31"
    NIT = 0; LIT = []
    cond_ex("ne",[["r4","r6"],["r5","r7"],["r2","r3"],"r0"],"r10")
    print "jump2divsteps_t1_1:	// end of first half"
    print "	mov	r11, #0"
    print "	sub	r0, r0, #1	// decrement minusdelta"
    print "	ssub16	r8, r11, r3	// r8 = -g"
    print "	smlsdx	r3, r2, r3, r11	// (f(0) g - g(0) f) / x "
    print "	br_32	r3, r12, r1, r11 //red. new g[0] %% %d, 32b" % (q)
    print "	uxth	r3, r3"
    print "	smulbb	r9, r8, r4	// - u[0] g[0]"
    print "	smlabb	r9, r2, r6, r9	// new r[0] = f[0] r[0] - g[0] u[0], 32b"
    print "	br_32	r9, r12, r1, r11 //red. new r[0] %% %d, 32b" % (q)
    print "	smulbt	r11, r8, r4	// - u[1] g[0]"
    print "	smlabt	r11, r2, r6, r11// new r[1] = f[0] r[1] - g[0] u[1], 32b"
    print "	pkhbt	r6, r9, r11, LSL #16	// new r (new r[1] reduced)"
    print "	smulbb	r9, r8, r5	// - v[0] g[0]"
    print "	smlabb	r9, r2, r7, r9	// new s[0] = f[0] s[0] - g[0] v[0], 32b"
    print "	br_32	r9, r12, r1, r11 //red. new s[0] %% %d, 32b" % (q)
    print "	smulbt	r11, r8, r5	// - v[1] g[0]"
    print "	smlabt	r11, r2, r7, r11// new s[1] = f[0] s[1] - g[0] v[1], 32b"
    print "	pkhbt	r7, r9, r11, LSL #16	// new s (new s[1] reduced)"
    print "	// note, we don't shift u,v here"

def j2ds_sub () :
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "jump2divsteps_sub:"
    print "	push	{lr}"
    j2ds ()
    print "	pop	{pc}"

def j2ds_1_sub () :
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "jump2divsteps_1_sub:"
    print "	push	{lr}"
    j2ds_1 ()
    print "	pop	{pc}"

def M2x2x2s_sub (u2, v2, r2, s2, u1, r1, qq, qi, fg, X, Y, Z, W, T) :
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "M2x2x2s:"
    print "	push	{lr}"
    print "	// first, new u = x u2 u1 + v2 r1"
    print "	smulbb	%s, %s, %s" % (X, v2, r1)
    print "	smuadx	%s, %s, %s" % (Y, v2, r1)
    print "	smultt	%s, %s, %s" % (Z, v2, r1)
    print "	smlabb	%s, %s, %s, %s" % (Y, u2, u1, Y)
    print "	smladx	%s, %s, %s, %s" % (Z, u2, u1, Z)
    print "	smultt	%s, %s, %s" % (W, u2, u1)
    print "	br_32x2	%s, %s, %s, %s, %s" % (X, Y, qq, qi, T)
    print "	br_32x2	%s, %s, %s, %s, %s" % (Z, W, qq, qi, T)
    print "	str	%s, [%s, #4]" % (Z, fg)
    print "	str	%s, [%s]" % (X, fg)
    print "	// then new r = x r2 u1 + s2 r1"
    print "	smulbb	%s, %s, %s" % (X, s2, r1)
    print "	smuadx	%s, %s, %s" % (Y, s2, r1)
    print "	smultt	%s, %s, %s" % (Z, s2, r1)
    print "	smlabb	%s, %s, %s, %s" % (Y, r2, u1, Y)
    print "	smladx	%s, %s, %s, %s" % (Z, r2, u1, Z)
    print "	smultt	%s, %s, %s" % (W, r2, u1)
    print "	br_32x2	%s, %s, %s, %s, %s" % (X, Y, qq, qi, T)
    print "	br_32x2	%s, %s, %s, %s, %s" % (Z, W, qq, qi, T)
    print "	str	%s, [%s, #20]" % (Z, fg)
    print "	str	%s, [%s, #16]" % (X, fg)
    print "	pop	{pc}"

def M2x2x2_2_sub (u, v, r, s, f1, g1, f0, g0, qq, qi, fg, X, Y, Z) :
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "M2x2x2_2:"
    print "	push	{lr}"
    print "	// first, new g = r f1 + s g1 + g0"
    print "	asr	%s, %s, #16" % (X, g0)
    print "	sxth	%s, %s" % (g0, g0)
    print "	smlabb	%s, %s, %s, %s" % (g0, r, f1, g0)
    print "	smladx	%s, %s, %s, %s" % (X, r, f1, X)
    print "	smultt	%s, %s, %s" % (Y, r, f1)
    print "	smlabb	%s, %s, %s, %s" % (g0, s, g1, g0)
    print "	smladx	%s, %s, %s, %s" % (X, s, g1, X)
    print "	smlatt	%s, %s, %s, %s" % (Y, s, g1, Y)
    print "	br_32x2	%s, %s, %s, %s, %s" % (g0, X, qq, qi, Z)
    print "	br_32	%s, %s, %s, %s" % (Y, qq, qi, Z)
    print "	uxth	%s, %s" % (Y, Y)
    print "	str	%s, [%s, #8]" % (g0, fg)
    print "	str	%s, [%s, #12]" % (Y, fg)
    print "	// then new f = x u f1 + x v g1 + f0"
    print "	asr	%s, %s, #16" % (g0, f0)
    print "	smlabb	%s, %s, %s, %s" % (g0, u, f1, g0)
    print "	smuadx	%s, %s, %s" % (X, u, f1)
    print "	smultt	%s, %s, %s" % (Y, u, f1)
    print "	smlabb	%s, %s, %s, %s" % (g0, v, g1, g0)
    print "	smladx	%s, %s, %s, %s" % (X, v, g1, X)
    print "	smlatt	%s, %s, %s, %s" % (Y, v, g1, Y)
    print "	br_32x2	%s, %s, %s, %s, %s" % (X, Y, qq, qi, Z)
    print "	br_32	%s, %s, %s, %s" % (g0, qq, qi, Z)
    print "	pkhbt	%s, %s, %s, LSL #16" % (f0, f0, g0)
    print "	str	%s, [%s]" % (f0, fg)
    print "	str	%s, [%s, #4]" % (X, fg)
    print "	pop	{pc}"

def j4ds (NAME1, NAME2) :
    global V, NV
    alloc_save_no("M1","sp+0")
    alloc_save_no("M2","sp+24")
    alloc_save_no("fg","sp+48")
    alloc_save_no("M","sp+64")
    alloc_save_no("pf","sp+68")
    alloc_save_no("pg","sp+72")
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "// void %s (int minusdelta, int *M, int *f, int *g);" % (NAME1)
    print "	.global %s" % (NAME1)
    print "	.type	%s, %%function" % (NAME1)
    print "%s:" % (NAME1)
    print "	push	{r1-r11,lr}"
    print_ldr("r12","q", "load q")
    print "	movw	r1, #%d" % (q32inv % 65536) 
    print "	movt	r1, #%d" % (65536 + q32inv // 65536)
    print_str("r1", "q32", "save q32inv")
    print "	sub	sp, sp, #64	// allocate 2x6+2x2 ints"
    print "	ldr	r2, [r2]	// f0"
    print "	ldr	r3, [r3]	// g0"
    print "	bl	jump2divsteps_sub"
    print_str("r0","d","store minusdelta")
    print "	stm	sp, {r2-r7}	// matrix 1 is at sp"
    print_ldr("r8","pf[0]","load f pointer")
    print_ldr("r9","pg[0]","load g pointer")
    print "	ldr	r8, [r8, #4]	// f1"
    print "	ldr	r9, [r9, #4]	// g1"
    print_ldr("r0","fg","load intermediate f,g pointer")
    print "	// compute [[x r4, x r5], [r6, r7]] * [r8, r9] + [r2, r3]"
    print "	bl	M2x2x2_2"
    print_ldr("r3","fg[8]","reload lower half of new g")
    print_ldr("r0","d","reload minusdelta")
    print "	bl	%s" % (NAME2)
    print_str("r0","d","store minusdelta")
    print_ldr("r14","M2","load matrix 2")
    print "	stm	r14, {r2-r7}"
    print_ldr("r8","fg[4]","reload top half of new f")
    print_ldr("r9","fg[12]","reload top half of new g")
    print_ldr("r0","M[0]","reload matrix pointer")
    print "	bl	M2x2x2_2"
    print "	// remains to multiply M1 by M2"
    print_ldr("r8","M1[8]","reload u1")
    print_ldr("r9","M1[16]","reload r1")
    print "	add	r0, r0, #16"
    print "	bl	M2x2x2s"
    print_ldr("r8","M1[12]","reload v1")
    print_ldr("r9","M1[20]","reload s1")
    print "	add	r0, r0, #8"
    print "	bl	M2x2x2s"
    print "	add	sp, sp, #76	// deallocate temp storage + pop r1-3"
    print_ldr("r0","d","reload minusdelta for return value")
    print "	pop	{r4-r11,pc}"

def j4ds_2 (NAME1, NAME2) :
    global V, NV
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "// void %s (int minusdelta, int *M, int *f, int *g);" % (NAME1)
    print "	.global %s" % (NAME1)
    print "	.type	%s, %%function" % (NAME1)
    print "%s:" % (NAME1)
    print "	push	{r1-r11,lr}"
    print_ldr("r12","q", "load q")
    print "	movw	r1, #%d" % (q32inv % 65536) 
    print "	movt	r1, #%d" % (65536 + q32inv // 65536)
    print_str("r1", "q32", "save q32inv")
    print "	ldr	r2, [r2]	// f0"
    print "	ldr	r3, [r3]	// g0"
    print "	bl	%s" % (NAME2)
    print_str("r0","d","store minusdelta")
    print "	ldr	r8, [sp, #4]"
    print "	ldr	r9, [sp, #8]"
    print "	ldr	r8, [r8, #4]	// f1"
    print "	ldr	r9, [r9, #4]	// g1"
    print "	ldr	r0, [sp]"
    print "	// compute [[x r4, x r5], [r6, r7]] * [r8, r9] + [r2, r3]"
    print "	bl	M2x2x2_2"
    print "	str	r4, [r0, #20]"
    print "	str	r5, [r0, #28]"
    print "	str	r6, [r0, #36]"
    print "	str	r7, [r0, #44]"
    print "	mov	r1, #0"
    print "	str	r1, [r0, #16]"
    print "	str	r1, [r0, #24]"
    print "	str	r1, [r0, #32]"
    print "	str	r1, [r0, #40]"
    print_ldr("r0","d","reload minusdelta for return value")
    print "	pop	{r1-r11,pc}"

    
if (len(sys.argv) >= 2) :
    NN = int(sys.argv[1])
    if (NN == 2) :
        print '#include "red-asm.h"'
        j2ds_prologue()
        j2ds()
        j2ds_epilogue()
        j2ds_1_prologue()
        j2ds_1()
        j2ds_epilogue()

    elif (NN == 4) :
        print '#include "red-asm.h"'
        M2x2x2s_sub ("r4","r5","r6","r7","r8","r9","r12","r1","r0","r2","r3","r10","r11","r14")
        M2x2x2_2_sub("r4","r5","r6","r7","r8","r9","r2","r3","r12","r1","r0","r10","r11","r14")
        j2ds_sub()
        j4ds("jump4divsteps","jump2divsteps_sub")
        j2ds_1_sub() 
        j4ds("jump4divsteps_3","jump2divsteps_1_sub")
        j4ds_2("jump4divsteps_2","jump2divsteps_sub")
        j4ds_2("jump4divsteps_1","jump2divsteps_1_sub")
