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

r_f = "r1"
r_g = "r2"
r_h = "r0"

# rotating holder for array elements
def ar (i,j,k) : # five registers
    return('r' + str(1+(4*i+k-j) % 5))

# rotating accumulator k during round i
def ac (i,k) : # five registers
    return('r' + str(6+(4*i+k) % 5))
    
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
    
def reduce_mod3_lazy (X, scr, r03) :
    print "#ifdef __thumb2__"	
    print "	and	%s, %s, #0xF0F0F0F0	// top 4b < 16" % (scr, X)
    print "	and	%s, %s, #0x0F0F0F0F	// bot 4b < 16" % (X, X)
    print "	add	%s, %s, %s, LSR #4	// range < 31" % (X, X, scr)
    print "#else"
    print_ldr(r03, "F", "reload #0x0F0F0F0F")
    print "	bic	%s, %s, %s	// top 4b < 16" % (scr, X, r03)
    print "	and	%s, %s, %s	// bot 4b < 16" % (X, X, r03)
    print "	add	%s, %s, %s, LSR #4	// range < 31" % (X, X, scr)
    print_ldr(r03, "3", "reload #0x03030303")
    print "#endif"
    
def reduce_mod3_full (X, scr, r03) :  
    reduce_mod3_lazy (X, scr, r03)
    reduce_mod3_32 (X, scr, r03) 


def start_strip_top (i) :
    print "	// ([%d-%d], 0) blocks" % (4*i, 4*i+3)
    print "	ldr	%s, [r12]" % (ar(i,0,4))
    print "	ldr	%s, [r14, #%d]" % (ar(i,0,3), 16*i+12)
    print "	ldr	%s, [r14, #%d]" % (ar(i,0,2), 16*i+8)
    print "	ldr	%s, [r14, #%d]" % (ar(i,0,1), 16*i+4)
    print "	ldr	%s, [r14, #%d]" % (ar(i,0,0), 16*i)
    print "	umull	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,0,1),ar(i,0,4))
    print "	umull	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,0,3),ar(i,0,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,0,0),ar(i,0,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,0,2),ar(i,0,4))

def start_strip_bot (i) :
    j = N / 4 -1
    print "	// ([%d-%d], %d) blocks" % (4*i-N/4+1, 4*i-N/4+4, j)
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 4*j)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,3), 16*i-N+16)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,2), 16*i-N+12)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,1), 16*i-N+8)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,0), 16*i-N+4)
    print "	umull	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,j,1),ar(i,j,4))
    print "	umull	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,j,3),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,j,0),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,j,2),ar(i,j,4))
    
def continue_strip_top (i,j) :
    print "	// ([%d-%d], %d) blocks" % (4*i-j, 4*i-j+3, j)
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 4*j)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,0), 16*i-4*j)
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,j,0),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,j,1),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,j,2),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,j,3),ar(i,j,4))
    if (j % C1 == C1 - 1) :
        reduce_mod3_lazy(ac(i,0),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,1),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,2),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,3),ar(i,j,4),"r11")
    if (j % C2 == C2 - 1) :
        reduce_mod3_lazy(ac(i,4),ar(i,j,4),"r11")

def continue_strip_bot (i,j) :
    print "	// ([%d-%d], %d) blocks" % (4*i-j, 4*i-j+3, j)
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 4*j)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,3), 16*i-4*j+12)
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,j,0),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,j,1),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,j,2),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,j,3),ar(i,j,4))
    if ((N/4-j) % C1 == C1 - 1) :
        reduce_mod3_lazy(ac(i,0),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,1),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,2),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,3),ar(i,j,4),"r11")
    if ((N/4-j) % C2 == C2 - 1) :
        reduce_mod3_lazy(ac(i,4),ar(i,j,4),"r11")
        
def end_strip_top (i) :
    j = 4 * i
    print "	// ([0-2],%d), ([0-1],%d), (0,%d) blocks" % (4*i+1,4*i+2,4*i+3)
    if (j % C1 == C1 - 1) :
        reduce_mod3_32(ac(i,0),ar(i,j,4),"r11")
    else :
        reduce_mod3_full(ac(i,0),ar(i,j,4),"r11")
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 16*i+4)
    print "	umlal	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,j,2),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,j,1),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,j,0),ar(i,j,4))
    reduce_mod3_full(ac(i,1),ar(i,j,4),"r11")
    if (j % C1 == C1 - 2) :
        reduce_mod3_lazy(ac(i,2),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,3),ar(i,j,4),"r11")
    if (j % C2 == C2 - 2) :
        reduce_mod3_lazy(ac(i,4),ar(i,j,4),"r11")
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 16*i+8)
    print "	umlal	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,j,1),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,j,0),ar(i,j,4))
    reduce_mod3_full(ac(i,2),ar(i,j,4),"r11")
    if (j % C1 == C1 - 3) :
        reduce_mod3_lazy(ac(i,3),ar(i,j,4),"r11")
    if (j % C2 == C2 - 3) :
        reduce_mod3_lazy(ac(i,4),ar(i,j,4),"r11")
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 16*i+12)
    print "	umlal	%s, %s, %s, %s" % (ac(i,3),ac(i,4),ar(i,j,0),ar(i,j,4))
    reduce_mod3_full(ac(i,3),ar(i,j,4),"r11")
    reduce_mod3_lazy(ac(i,4),ar(i,j,4),"r11")
    print "	str	%s, [r0], #4" % (ac(i,0))
    print "	str	%s, [r0], #4" % (ac(i,1))
    print "	str	%s, [r0], #4" % (ac(i,2))
    print "	str	%s, [r0], #4" % (ac(i,3))
    
def end_strip_bot (i) :
    j = 4 * i - N / 4 +4
    print "	// ([%d-%d],%d),([%d-%d],%d),(%d,%d) blocks" % (N/4-3,N/4-1,j-1,N/4-2,N/4-1,j-2,N/4-1,j-3)
    if ((N/4-j) % C2 != C2 - 1) :
        reduce_mod3_lazy(ac(i,4),ar(i,j,4),"r11")
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 16*i-N+12)
    print "	umlal	%s, %s, %s, %s" % (ac(i,2),ac(i,3),ar(i,j,3),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,j,2),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,j,1),ar(i,j,4))
    reduce_mod3_full(ac(i,3),ar(i,j,4),"r11")
    if ((N/4-j) % C1 == C1 - 2) :
        reduce_mod3_lazy(ac(i,0),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,1),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,2),ar(i,j,4),"r11")
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 16*i-N+8)
    print "	umlal	%s, %s, %s, %s" % (ac(i,1),ac(i,2),ar(i,j,3),ar(i,j,4))
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,j,2),ar(i,j,4))
    reduce_mod3_full(ac(i,2),ar(i,j,4),"r11")
    if ((N/4-j) % C1 == C1 - 3) :
        reduce_mod3_lazy(ac(i,0),ar(i,j,4),"r11")
        reduce_mod3_lazy(ac(i,1),ar(i,j,4),"r11")
    print "	ldr	%s, [r12, #%d]" % (ar(i,j,4), 16*i-N+4)
    print "	umlal	%s, %s, %s, %s" % (ac(i,0),ac(i,1),ar(i,j,3),ar(i,j,4))
    reduce_mod3_full(ac(i,0),ar(i,j,4),"r11")
    reduce_mod3_full(ac(i,1),ar(i,j,4),"r11")
    print "	str	%s, [r0], #4" % (ac(i,0))
    print "	str	%s, [r0], #4" % (ac(i,1))
    print "	str	%s, [r0], #4" % (ac(i,2))
    print "	str	%s, [r0], #4" % (ac(i,3))
   
    
def SCH_polymulNxN_mod3(N,C1,C2,rf,rg,rh) :
    global V, NV, r_f, r_g, r_h, r_N
    r_f = rf; r_g = rg; r_h = rh
    globals()["C1"]=C1
    globals()["C2"]=C2
    globals()["N"]=N

    #assert (N>16)
    alloc_save_no("N",str(N))
    alloc_save_no("C1",str(C1))
    alloc_save_no("C2",str(C2))

    # print_str(rh,"h","save h")
    # print_str(rh,"hh","save hh")
    # print_str(rf,"f","save f")
    # print_str(rg,"g","save g")
    
    print "sch3_0:			// increasing thread length"
    print "	mov	%s, #0" % (ac(0,0))
    print "	mov	r12, %s" % rf
    print "	mov	r14, %s" % rg
    print "	ldr	r11, =0x03030303"

    print "#ifndef __thumb2__"
    print_str("r11", "3", "save #0x03030303")
    print "	ldr	r11, =0x0f0f0f0f"
    print_str("r11", "F", "save #0x0F0F0F0F")
    print_ldr("r11", "3", "reload #0x03030303")
    print "#endif"
    
    print "sch3_1:			// later blocks"
    for i in range(0,N/16) : # i is thread count
        start_strip_top (i)
        for j in range(1, 4*i+1) :
            continue_strip_top (i,j)
        end_strip_top (i) 
            
    print "sch3_10:			// decreasing thread length"
    for i in range(N/16, N/8-1) :
        start_strip_bot (i)
        for j in range(N/4-2, 4*i-N/4+3, -1) :
            continue_strip_bot (i,j)
        end_strip_bot (i) 
        
        
    print "sch3_20:			// mv hh back to h"
    i = N/8 - 1
    print "	mov	%s, #0" % (ac(i,1))
    print "	mov	%s, #0" % (ac(i,2))
    print "	mov	%s, #0" % (ac(i,3))
    print "	mov	%s, #0" % (ac(i,4))
    j = N / 4
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,1), N-12)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,2), N-8)
    print "	ldr	%s, [r14, #%d]" % (ar(i,j,3), N-4)
    end_strip_bot(i)

    

