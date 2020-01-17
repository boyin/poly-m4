#!/usr/bin/python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)


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
alloc_save("hh")		# V["hh"] = s3	# hh = cursor in h
for i in range(7) :		# seven scratch registers
    alloc_save(str(i))
alloc_save("q32")		# round(-2^32/q)


def SCH_prologue_sh(N,rf,rg,rh) :
    global V,NV
    print '#include "red-asm.h"'
    SCH_polymulNxNsh_defs()
    print
    print "// void gf_polymul_%dx%dsh (int *h, int *f, int *g);" % (N,N)
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "	.global gf_polymul_%dx%dsh" % (N,N)
    print "	.type	gf_polymul_%dx%dsh, %%function" % (N,N)
    print "gf_polymul_%dx%dsh:" % (N,N)
    print "	push	{r4-r11,lr}"
    print "	movw	r14, #%d" % ((-q32inv) % 65536) 
    print "	movt	r14, #%d" % (65536- (q32inv // 65536))
    print_str("r14","q32","save q32inv")
        
from polymul_NxN_sch2p19_ii import SCH_polymulNxNsh_defs
from polymul_NxN_sch2p19_i import SCH_polymulNxNsh

    
def SCH_epilogue_sh(N) :
    print "	add	sp, sp, #%d	// sp += 4N" % (4*N)
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"


if (len(sys.argv) >= 2) :
    NN = int(sys.argv[1])
else : NN = 256

if (len(sys.argv) >= 3) :
    CC = int(sys.argv[2])
else : CC = 7

if (len(sys.argv) >= 2) :
    NN = int(sys.argv[1])
else : NN = 256



SCH_prologue_sh(NN,"r1","r2","r0")
SCH_polymulNxNsh(NN,CC,"r1","r2","r0")
SCH_epilogue_sh(NN)
