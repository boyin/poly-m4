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
for i in range(7) :		# seven scratch registers
    alloc_save(str(i))


r_f = "r1"
r_g = "r2"
r_h = "r0"

# rotating accumulator k during round i
def acc_r (i,k) :
    #global V
    #return(read_V(str((4*i+k)%7))) 
    return('r' + str(8+(k+2*(i%2))%4))
    
def add_block_initial (a,b) :
    print "	// block (%d,%d)" % (a,b)
    print "	ldr	r5, [r1, #%d]" % (8*a+4)
    print "	ldr	r4, [r1, #%d]" % (8*a)
    print "	ldr	r7, [r2, #%d]" % (8*b+4)
    print "	ldr	r6, [r2, #%d]" % (8*b)
    print "	umlal	%s, %s, r4, r6" % (acc_r(a+b,0),acc_r(a+b,1))
    print "	umull	%s, %s, r5, r7" % (acc_r(a+b,2),acc_r(a+b,3))
    print "	umlal	%s, %s, r5, r6" % (acc_r(a+b,1),acc_r(a+b,2))
    print "	umlal	%s, %s, r4, r7" % (acc_r(a+b,1),acc_r(a+b,2))
    
def add_block (a,b) :
    print "	// block (%d,%d)" % (a,b)
    print "	ldr	r5, [r1, #%d]" % (8*a+4)
    print "	ldr	r4, [r1, #%d]" % (8*a)  
    print "	ldr	r7, [r2, #%d]" % (8*b+4)
    print "	ldr	r6, [r2, #%d]" % (8*b)  
    print " 	umlal	%s, %s, r4, r6" % (acc_r(a+b,0),acc_r(a+b,1))
    print "	umlal	%s, %s, r5, r7" % (acc_r(a+b,2),acc_r(a+b,3))
    print "	umlal	%s, %s, r5, r6" % (acc_r(a+b,1),acc_r(a+b,2))
    print "	umlal	%s, %s, r4, r7" % (acc_r(a+b,1),acc_r(a+b,2))

def reduce_mod3_5 (X, scr, r03) : # at most 5, r03 = 0x03030303 
    print "	usub8	%s, %s, %s		// >= 3 ?" % (scr, X, r03)
    print "	sel	%s, %s, %s		// select" % (X, scr, X)

def reduce_mod3_11 (X, scr, r03) : # r03 = 0x03030303, good for 4 adds
    print "	and	%s, %s, #0x1C1C1C1C	// top 3b < 3" % (scr, X)
    print "	and	%s, %s, %s		// bot 2b < 4" % (X, X, r03)
    print "	add	%s, %s, %s, LSR #2	// range <=5" % (X, X, scr)
    reduce_mod3_5 (X, scr, r03)
    
def reduce_mod3_32 (X, scr, r03) : # r03 = 0x03030303, good for 8 adds
    print "	and	%s, %s, #0x1C1C1C1C	// top 3b < 8" % (scr, X)
    print "	and	%s, %s, %s		// bot 2b < 4" % (X, X, r03)
    print "	add	%s, %s, %s, LSR #2	// range <=10" % (X, X, scr)
    reduce_mod3_11 (X, scr, r03)
    
def reduce_mod3_lazy (X, scr) :
    print "	and	%s, %s, #0xF0F0F0F0	// top 4b < 16" % (scr, X)
    print "	and	%s, %s, #0x0F0F0F0F	// bot 4b < 16" % (X, X)
    print "	add	%s, %s, %s, LSR #4	// range < 31" % (X, X, scr)
    
def reduce_mod3_full (X, scr, r03) :  
    reduce_mod3_lazy (X, scr)
    reduce_mod3_32 (X, scr, r03) 
    
def SCH_polymulNxN_mod3(N,C1,C2,rf,rg,rh) :
    global V, NV, r_f, r_g, r_h, r_N
    r_f = rf; r_g = rg; r_h = rh

    assert (N>8)
    
    alloc_save_no("N",str(N))
    alloc_save_no("C1",str(C1))
    alloc_save_no("C2",str(C2))

    print_str(rh,"h","save h")
    print_str(rh,"hh","save hh")
    print_str(rf,"f","save f")
    print_str(rg,"g","save g")
    
    
    print "sch3_0:			// increasing thread length"
    print "	// block (0,0)"
    print "	ldr	r5, [r1, #4]" 
    print "	ldr	r4, [r1]" 
    print "	ldr	r7, [r2, #4]" 
    print "	ldr	r6, [r2]"
    print "	mov	r3, 0x03030303"
    print "	umlal	%s, %s, r4, r6" % (acc_r(0,0),acc_r(0,1))
    print "	umull	%s, %s, r5, r7" % (acc_r(0,2),acc_r(0,3))
    print "	umlal	%s, %s, r4, r7" % (acc_r(0,1),acc_r(0,2))
    print "	umlal	%s, %s, r5, r6" % (acc_r(0,1),acc_r(0,2))
    reduce_mod3_32(acc_r(0,0),"r12","r3")
    reduce_mod3_32(acc_r(0,1),"r12","r3")
    reduce_mod3_lazy(acc_r(0,2),"r12")
    reduce_mod3_lazy(acc_r(0,3),"r12")
    print "	strd	%s, %s, [r0], 8" % (acc_r(0,0),acc_r(0,1))
    print "sch3_1:			// later blocks"
    C = min(C1,C2)
    for i in range(1,N/8) : # i is thread count
        add_block_initial (0,i)
        for j in range(1,i+1) :
            add_block (j,i-j)
            if (j % C == C-1) :
                reduce_mod3_lazy(acc_r(i,0),"r12")
                reduce_mod3_lazy(acc_r(i,1),"r12")
                reduce_mod3_lazy(acc_r(i,2),"r12")
                reduce_mod3_lazy(acc_r(i,3),"r12")
        if ((i+1) % C == 0) :
            reduce_mod3_32(acc_r(i,0),"r12","r3")
            reduce_mod3_32(acc_r(i,1),"r12","r3")
        else :
            reduce_mod3_full(acc_r(i,0),"r12","r3")
            reduce_mod3_full(acc_r(i,1),"r12","r3")
            reduce_mod3_lazy(acc_r(i,2),"r12")
            reduce_mod3_lazy(acc_r(i,3),"r12")
        print "	strd	%s, %s, [r0], #8" % (acc_r(i,0),acc_r(i,1))
             
    print "sch3_10:			// decreasing thread length"
    for i in range(N/8, N/4-1) :
        add_block_initial (i-N/8+1, N/8-1)
        for j in range(i-N/8+2,N/8) :
            add_block (j,i-j)
            if ((j-(i-N/8+1)) % C == C-1) :
                reduce_mod3_lazy(acc_r(i,0),"r12")
                reduce_mod3_lazy(acc_r(i,1),"r12")
                reduce_mod3_lazy(acc_r(i,2),"r12")
                reduce_mod3_lazy(acc_r(i,3),"r12")
        if ((N/4-i-1) % C == 0) :
            reduce_mod3_32(acc_r(i,0),"r12","r3")
            reduce_mod3_32(acc_r(i,1),"r12","r3")
        else :
            reduce_mod3_full(acc_r(i,0),"r12","r3")
            reduce_mod3_full(acc_r(i,1),"r12","r3")
            reduce_mod3_lazy(acc_r(i,2),"r12")
            reduce_mod3_lazy(acc_r(i,3),"r12")
        print "	strd	%s, %s, [r0], #8" % (acc_r(i,0),acc_r(i,1))

    print "sch3_20:			// mv hh back to h"
    reduce_mod3_32(acc_r(i,2),"r12","r3")
    reduce_mod3_32(acc_r(i,3),"r12","r3")
    print "	strd	%s, %s, [r0], #8" % (acc_r(i,2),acc_r(i,3))
    

