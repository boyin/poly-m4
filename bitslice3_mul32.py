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

alloc_save("0" ) # scratch registers
alloc_save("1" )
alloc_save("2" )
alloc_save("3" )
alloc_save("4" )
alloc_save("5" )
alloc_save("6" )
alloc_save("7" )
alloc_save("8" )
alloc_save("9" )
alloc_save("10")
alloc_save("11")
alloc_save("12")
alloc_save("13")

from bitslice3_mul32_i import add_to_mod3_d,sub_from_mod3_d,mul32_mod3,mul32_mod3_negc,add_sub_mod3_d

        
def bs3_header1 (name) :
    print '''	// bitslice functions
	.p2align	2,,3
	.syntax		unified
	.text'''
    print "	.global 	%s" % (name)
    print "	.type		%s, %%function" % (name)
    print "	// void %s(int *h, int *f, int *g);" % (name) 
    print "%s:" % (name)
    print "	push	{r4-r11,lr}"

bs3_header1 ("bs3_mul32")
print "	ldr	r4, [r1], #4"
print "	ldr	r5, [r1], #4"
print "	ldr	r6, [r2], #4"
print "	ldr	r7, [r2], #4"
mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14",0,"")
print "	stm	r0!, {r8-r11}" 
print '''#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''

bs3_header1 ("bs3_mul32s")
print "	ldr	r4, [r1], #4"
print "	ldr	r5, [r1], #4"
print "	ldr	r6, [r2], #4"
print "	ldr	r7, [r2], #4"
mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14",0,"")
print "	lsls	r8, r8, #1"
print "	adc	r10, r10, r10"
print "	lsls	r9, r9, #1"
print "	adc	r11, r11, r11"
print "	stm	r0!, {r8-r11}" 
print '''#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''

bs3_header1 ("bs3_mul32_negc")
print "	ldr	r4, [r1], #4"
print "	ldr	r5, [r1], #4"
print "	ldr	r6, [r2], #4"
print "	ldr	r7, [r2], #4"
mul32_mod3_negc ("r4","r5","r6","r7","r8","r9","r10","r11",0,"")
print "	strd	r8, r9, [r0], #8" 
print '''#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''

bs3_header1 ("bs3_mul64_negc")
print "	ldr	r4, [r1]"
print "	ldr	r5, [r1, #4]"
print "	ldr	r6, [r2]"
print "	ldr	r7, [r2, #4]"
print "	ldr	r8, [r1, #8]"
print "	ldr	r9, [r1, #12]"
print "	ldr	r10, [r2, #8]"
print "	ldr	r11, [r2, #12]"
add_to_mod3_d("r4","r5","r8","r9")
add_to_mod3_d("r6","r7","r10","r11")
mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14",0,"")
print_str("r8","0","save c01l0")
print_str("r9","1","save c01l1")
print_str("r10","2","save c01h0")
print_str("r11","3","save c01h1")
print "	// c01 = (a0+a1)(b0+b1) in scratch 0-3"
print "	ldr	r4, [r1, #8]"
print "	ldr	r5, [r1, #12]"
print "	ldr	r6, [r2, #8]"
print "	ldr	r7, [r2, #12]"
mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14",0,"")
print_str("r8","4","save c1l0")
print_str("r9","5","save c1l1")
print_str("r10","6","save c1h0")
print_str("r11","7","save c1h1")
print "	// c1 = a1 b1 in scratch 4-7"
print "	ldr	r5, [r1, #4]"
print "	ldr	r4, [r1], #16"
print "	ldr	r7, [r2, #4]"
print "	ldr	r6, [r2], #16"
mul32_mod3 ("r4","r5","r6","r7","r8","r9","r10","r11","r12","r14",0,"bs3_mul64_negc0")
print "	// c0 = a0 b0 in r8-11, now compute (c0-c1 R)(1-R) + c01 R"
print_ldr("r4","4","load c1l0")
print_ldr("r5","5","load c1l1")
print_ldr("r6","6","load c1h0")
print_ldr("r7","7","load c1h1")
add_to_mod3_d("r8","r9","r6","r7")
sub_from_mod3_d("r10","r11","r4","r5")
print "	// (c0-c1 R) in r8-11"
add_sub_mod3_d("r10","r11","r8","r9","r6","r7")
print "	// (c0-c1 R)(1-R) in r10,r11,r8,r9"
print_ldr("r4","0","load c01l0")
print_ldr("r5","1","load c01l1")
print_ldr("r6","2","load c01h0")
print_ldr("r7","3","load c01h1")
add_to_mod3_d("r8","r9","r4","r5")
sub_from_mod3_d("r10","r11","r6","r7")
print "	str	r10, [r0], #4"
print "	str	r11, [r0], #4"
print "	str	r8, [r0], #4"
print "	str	r9, [r0], #4"
print '''#ifndef __thumb__
	pop	{r4-r11,lr}
	bx	lr
#else
	pop	{r4-r11,pc}
#endif'''
