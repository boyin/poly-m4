#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt


ARGS = sys.argv
SAVES = 0

#V[loc] = "s%d", "[sp,#%d]", "sp+%d" or "label[%d]" where V[label] = "sp+%d"
from loadsave import alloc_save,print_ldr,print_str,alloc_save_no,read_V,read_NV
alloc_save("h")
alloc_save("ov")

try : NN = int(sys.argv[1])
except : NN = 256
try : B = int(sys.argv[2])
except: 
    B = 32
assert (isinstance(B/32,int))


def is_even (E) :
    if isinstance(E,int) :
        return (int(E/2)*2 == E)
    else :
        return(False)

def KA_terms (N,N0) :
    M = N ;
    while N > N0 :
        M += M/2
        N = N/2
    return M

W = 32 # width of vectors
N_range = B * 16
M_range = KA_terms(N_range,B)

def KA_prologue () :
    print

from bitslice3_mul32_i import add_to_mod3_d,sub_from_mod3_d,mul32_mod3,mul32_mod3_negc,add_sub_mod3_d,add_to_mod3_dx

def KA_polymulNxN (N) :
    # KA_head
    print("// N=%d requires %d storage" % (N,KA_terms(N,B)))
    HN = "bitslice3_mul%d" % (N)
    RN = "bs3_mul%d" % (N)
    aux = open(HN + ".h", "w+")
    aux.write("extern void " + RN + " (int32_t *h, int32_t *f, int32_t *g);\n")
    aux.close();
    
    print "	.p2align	2,,3"
    print "	.syntax		unified"
    print "	.text"
    N0 = N
    print "KA_%d:" % N
    while (N0 >= B) :
        print "	.word	%d" % KA_terms(N,N0) 
        N0 /= 2
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    #
    print "// void %s (int32_t *h, int32_t *f, int32_t *g);" % (RN)
    print "	.global %s" % (RN)
    print "	.type	%s, %%function" % (RN)
    print "%s:" % (RN)
    #
    M = (KA_terms(N,B))
    alloc_save_no("ff","sp+0")
    alloc_save_no("gg","sp+%d" % (M//4))
    alloc_save_no("hh","sp+%d" % (M//2))
    alloc_save_no("M4",str(M//4))
    #
    print "	push	{r4-r11,lr}"
    if (read_NV() > 16) :
        print "	vpush	{s16-s31}"
    print "	sub	sp, sp, #%d	// subtract M" % (M) 
    print "		// ff=[sp], gg=[sp,#%d], hh=[sp,#%d]" % (M//4, M//2)
    print_str("r0","h","save h")
    print_ldr("r3","ff","load ff pointer")
    print_ldr("r0","gg","load gg pointer")
    #
    if (N>128) :
        print "	mov	r14, #%d" % (N)
    print "KA%d_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff" % N
    if (N==64) :
    	print "	ldm	r1!, {r4-r7}"
    	print "	ldm	r2!, {r8-r11}"
    	print "	stm	r3!, {r4-r7}"
    	print "	stm	r0!, {r8-r11}"
    else :	# N >= 128
        print "	ldm	r1!, {r4-r11}"
        print "	stm	r3!, {r4-r11}"
        print "	ldm	r2!, {r4-r11}"
        print "	stm	r0!, {r4-r11}"
        if (N>128) :
            print "	subs	r14, #128"
            print "	bne	KA%d_mv_loop" % N
    #
    print "KA%d_exp:	// ff @ sp, gg @ sp + M/4, M/4 @ r12" % N
    print_ldr("r0","ff","load ff")
    print_ldr("r1","gg","load gg")
    print "	ldr	r3, =KA_%d" % N
    print_str("r3","ov","save list of multiplication sizes pointer")
    print "	mov	r2, #%d		// N0/8 = r2 = N/8" % (N//8)
    print "KA%d_exp_loop1:		// loop on N0(/8)" % N
    print "	cmp	r2, #%d		// while (N0>B)" % (B//8)
    print "	beq	KA%d_exp_end1" % N    
    # main assembly routine for KA_exp
    print "KA%d_exp_adds:" % N
    print "/*"
    print "  for (j=0; j<N1; j+=N0) {" 
    print "    for (k=0; k<N0/2; k+=32) {" 
    print "     add3(ff+(j+k+N1)/4,ff+(2*j+k)/4,ff+(2*j+k+N0/2)/4);"
    print "     add3(gg+(j+k+N1)/4,gg+(2*j+k)/4,gg+(2*j+k+N0/2)/4);"
    print "    }"
    print "*/"
    print "	ldr	r4, [r3], #4		// load N1=KA_terms(N,N0)"
    print "	add	r5, r0, r4, LSR #2	// r5 = ff + N1/4"
    print "	add	r6, r1, r4, LSR #2	// r6 = gg + N1/4"
    print "	add	r0, r0, r2		// r0 = ff + N0/8"
    print "	add	r1, r1, r2		// r1 = gg + N0/8"
    print "	rsb	r2, r2, #0		// r2 = -N0/8"
    print "	mov	r12, r2"
    print "KA%d_exp_adds1:" % N
    print "	ldr	r8, [r0, r2]"
    print "	ldr	r10, [r0], #4"
    print "	ldr	r9, [r0, r2]"
    print "	ldr	r11, [r0], #4"
    add_to_mod3_d ("r8", "r9", "r10", "r11") 
    print "	strd	r8, r9, [r5], #8"
    print "	ldr	r8, [r1, r2]"
    print "	ldr	r10, [r1], #4"
    print "	ldr	r9, [r1, r2]"
    print "	ldr	r11, [r1], #4"
    add_to_mod3_d ("r8", "r9", "r10", "r11") 
    print "	strd	r8, r9, [r6], #8"
    print "	subs	r4, r4, #64	// total of N1/64 pairs"
    print "	beq	KA%d_exp_end" % N
    print "	adds	r12, r12, #8	// from N0/8 each time 8"
    print "	ittt	eq		// divisible by N0/2?"
    print "	subeq	r0, r0, r2	// then add N0/8!"
    print "	subeq	r1, r1, r2	// then add N0/8!"
    print "	moveq	r12, r2		// reload with N0/8"
    print "	b	KA%d_exp_adds1" % N
    print "KA%d_exp_end:" % N
    print "	rsb	r2, r2, #0	// back to + N0/8"	
    print_ldr("r0","ff", "reload ff")
    print_ldr("r1","gg", "reload gg")
    print
    print "	lsr	r2, #1 		// N0 /= 2"
    print "	b	KA%d_exp_loop1	// loop" %(N)
    print "KA%d_exp_end1:" % N
    print
    print "KA%d_mul:" % N
    N1 = KA_terms(N,B)
    #
    print_str("r3","ov","save N1 list pointer")
    print "	ldr	r3, [r3]	// r3 = N1"
    print_ldr("r2","hh","load r2 = hh")
    print "KA%d_muls1:" % (N)
    if (B==32) :
        print "	ldr	r4, [r0], #4"
        print "	ldr	r5, [r0], #4"
        print "	ldr	r6, [r1], #4"
        print "	ldr	r7, [r1], #4"
        mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14",0,"")
        print "	stm	r2!, {r8-r11}"         
    print "	subs	r3, #32"
    print "	bne	KA%d_muls1" % (N)
    #
    # now hh = r2, everything else is disposable
    print "KA%d_collect:" % (N)
    print_ldr("r2","hh","reload hh")
    N0 = B
    while (N0 < N) :
        N1 = KA_terms(N,2*N0)
        # hh has not left r2, ov has not left r3
        print "KA%d_col_%d_add:			// KA collection" % (N,N0)
        print_ldr("r3","ov","reload N1 list") # probably in each loop?
        print "	ldr	r14, [r3, #-4]!	// N1"
        print_str("r3","ov","save N1 list")
        print "	add	r12, r2, r14, LSR #1	// points into array"
        print "	mov	r1, r2		// copy of hh"
    	print "	mov	r11, #%d	// N0" % (N0)
        print "KA%d_col_%d_add1:	// beginning of KA collect" % (N,N0)
	print "	ldrd	r4, r5, [r1, #%d]" % (N0//4)
        print "	ldrd	r6, r7, [r1, #%d]" % (N0//2)
        sub_from_mod3_d("r4", "r5", "r6", "r7")
        print "	ldrd	r6, r7, [r1, #%d]" % (3*N0//4)
        #print "	mov	r8, r4"
        #print "	mov	r9, r5"
        #add_to_mod3_d("r8","r9","r6","r7")
        add_to_mod3_dx("r8", "r9", "r4", "r5", "r6", "r7")
        print "	ldrd	r6, r7, [r1]"
        sub_from_mod3_d("r4", "r5", "r6", "r7")
        print "	ldrd	r6, r7, [r12, #%d]" % (N0//4)
        sub_from_mod3_d("r6", "r7", "r8", "r9")
        print "	ldrd	r8, r9, [r12], #8	// shift r12"
        print "	strd	r6, r7, [r1, #%d]" % (N0//2)
        add_to_mod3_d("r4", "r5", "r8", "r9")
        print "	strd	r4, r5, [r1, #%d]" % (N0//4)
        print "	add	r1, r1, #8"
        print "	subs	r14, r14, #64"
        print "	beq	KA%d_col_%d_end" % (N,N0)
        print "	subs	r11, r11, #32"
        print "	ittt	eq	// no, then next set"
        print "	addeq	r1, r1, #%d" % (3*N0//4)
        print "	addeq	r12, r12, #%d" % (N0//4)
        print "	moveq	r11, #%d	// N0" % (N0)
        print "	b	KA%d_col_%d_add1" % (N,N0)
        print "KA%d_col_%d_end:"   % (N,N0)     
        #
        N0 *= 2
    # hh should still be at #2
    print "KA%d_mv_back:			// hh still =r2" % N
    print_ldr("r0","h","reload h")
    if (N>64) :
        print "	mov	r14, #%d" % (N)
    print "KA%d_mv_back_loop:" % N
    print "	ldm	r2!, {r4-r11}	// 4 pairs = 128 trits"
    print "	stm	r0!, {r4-r11}"
    if (N>64) :
        print "	subs	r14, #64"
        print "	bne	KA%d_mv_back_loop" % N
    #
    print "KA%d_end:" % N
    print "	add	sp, sp, #%d" % (M) 
    if (read_NV() > 16) :
        print "	vpop	{s16-s31}"
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"
    print ""
    # if (NARGS > 1 ) :
    # 
    
KA_prologue()
KA_polymulNxN(NN)

# if (NARGS == 1) :
#     NN = 2 * B
#     while (NN <= N_range) :
#         KA_polymulNxN(NN)
#         NN *= 2
#     aux.close(
