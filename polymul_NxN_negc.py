#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
ARGS = sys.argv
SAVES = 0
if ("BARRETT" in sys.argv) : MONT_OR_BAR = 1
else : MONT_OR_BAR = 0

try :
    NN = int(sys.argv[1])
except :
    NN = 64
    
def alloc_save (S) : # allocate variable name s_S as a space
    global SAVES
    if not (("s_"+S) in locals() or ("s_"+S) in globals()) :
        globals()["s_"+S] = "s" + str(SAVES)
        SAVES +=1
    
# NARGS = len(ARGS)
# if (NARGS == 1) :
#     aux = open("polymul_NxN_aux.h","w+")
    
# adjust
# def adj_size (size) :
#     if (size < q_ab) :  # 2341 is q-dependent
#         return(size)
#     else :
#         i = ceil ((floor(size * q16 / 2.0**16 + 0.5) - 0.5) * 2.0**16 / q16) - 1
#         return(i - q * floor(i * q16 / 2.0**16 +0.5))

# may change to using vmov later
def print_ldr (reg, loc, comment) :
    #print("	ldr	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s  // %s" % (reg, loc, comment))

def print_str (reg, loc, comment) :
    #print("	str	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s	// %s" % (loc, reg, comment))
    
alloc_save("mq") # modulus -q = -4591
alloc_save("qi") # q^{-1} mod 2^16 or
alloc_save("q32")# round(2^32/q)
alloc_save("h")  # save h
alloc_save("0")  # scratch 0
alloc_save("1")  # scratch 1
alloc_save("2")  # scratch 2
alloc_save("3")  # scratch 3

def SCH_negc_prologue (N) :
    print '#include "red-asm.h"'
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    if (MONT_OR_BAR == 0) :
        print "// void gf_polymul_%dx%d_negc_divR (int32_t *h, int32_t *f, int32_t *g);" % (N,N)
        print "	.global gf_polymul_%dx%d_negc_divR" % (N,N)
        print "	.type	gf_polymul_%dx%d_negc_divR, %%function" % (N,N)
        print "gf_polymul_%dx%d_negc_divR:" % (N,N)
    else :
        print "// void gf_polymul_%dx%d_negc (int32_t *h, int32_t *f, int32_t *g);" % (N,N)
        print "	.global gf_polymul_%dx%d_negc" % (N,N)
        print "	.type	gf_polymul_%dx%d_negc, %%function" % (N,N)
        print "gf_polymul_%dx%d_negc:" % (N,N)
    
    print "	push	{r4-r11,lr}"
    # r1, r2 = multiplicand pointers to f and g
    # r3, r4 = multiplicand f, r12, r14 = multiplicand g
    # print_str("r0",s_h,"save h")
    if (MONT_OR_BAR == 0) :
        print "	movw	r14, #%d" % (qinv)
        print_str("r14", s_qi, "save qinv")
    else :
        print "	movw	r14, #%d" % (q32inv % 65536) 
        print "	movt	r14, #%d" % (q32inv // 65536)
        print_str("r14", s_q32, "save q32inv")
    print "	movw	r12, #%d" % (65536-q)
    print "	movt	r12, #65535"
    print_str("r12", s_mq, "save -q")

def SCH_negc_epilogue() :
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"


from polymul_NxN_negc_i import SCH_polymulNxN_negc

# if (NARGS > 1) :

if (MONT_OR_BAR == 0) : s = s_qi
else : s = s_q32
    
SCH_negc_prologue(NN)
SCH_polymulNxN_negc(NN,"r1","r2","r0",s_mq,s,s_0,s_1,s_2,s_3,MONT_OR_BAR)
SCH_negc_epilogue()
