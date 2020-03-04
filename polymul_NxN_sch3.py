#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

#V[loc] = "s%d", "[sp,#%d]", "sp+%d" or "label[%d]" where V[label] = "sp+%d"
from loadsave import alloc_save,print_ldr,print_str,alloc_save_no,read_V

# need to sync this list with whatever file that calls this file
# otherwise the results will be wrong
#
alloc_save("h")			# V["h"] = s0	# h = output
alloc_save("g")			# V["g"] = s1	# g = input 1
alloc_save("f")			# V["f"] = s2	# f = input 0
alloc_save("hh")		# V["hh"] = s3	# hh = cursor in h
alloc_save("3")
alloc_save("F")


def SCH_prologue_mod3(N,rf,rg,rh) :
    global V,NV
    print
    print "// void gf_polymul_%dx%d_mod3 (int *h, int *f, int *g);" % (N,N)
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "	.global gf_polymul_%dx%d_mod3" % (N,N)
    print "	.type	gf_polymul_%dx%d_mod3, %%function" % (N,N)
    print "gf_polymul_%dx%d_mod3:" % (N,N)
    print "	push	{r4-r11,lr}"

    
def SCH_epilogue_mod3(N) :
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"


if (len(sys.argv) >= 2) :
    NN = int(sys.argv[1])
else : NN = 32

if (len(sys.argv) >= 3) :
    C1 = int(sys.argv[2])
else : C1 = 7

if (len(sys.argv) >= 4) :
    C2 = int(sys.argv[3])
else : C2 = 7
        
from polymul_NxN_sch3_i import SCH_polymulNxN_mod3

SCH_prologue_mod3(NN,"r1","r2","r0")
SCH_polymulNxN_mod3(NN,C1,C2,"r1","r2","r0")
SCH_epilogue_mod3(NN)
