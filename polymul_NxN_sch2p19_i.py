#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
global V

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

r_f = "r1"
r_g = "r2"
r_h = "r0"

# rotating accumulator k during round i
def acc_r (i,k) :
    #global V
    #return(read_V(str((4*i+k)%7))) 
    return(str((4*i+k)%7))
    
def add_block_initial (a,b) :
    print "	// block (%d,%d)" % (a,b)
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #-8"
    print "	smull	r6, r7, r2, r4"
    print "	smull	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smull	r10, r11, r3, r5"
    
def add_block (a,b) :
    print "	// block (%d,%d)" % (a,b)
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #-8"
    print " 	smlal	r6, r7, r2, r4"
    print "	smlal	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smlal	r10, r11, r3, r5"

def conv_3x64_7x32_body (i) :  
    global V
    print "	//r6-7/r8-9/r10-11 are partial accumulators"
    print "	//cut out 19b pieces put in r2-r8"
    print "	sbfx	r2, r6, #0, #19"
    print "	mov	r12, #-1"
    print "	smlal	r6, r7, r12, r2"
    #print "	subs	r6, r6, r2"
    #print "	sbc	r7, r7, r2, ASR #31"
    print "	sbfx	r3, r7, #0, #6"
    print "	sub	r7, r7, r3"
    print "	lsl	r3, r3, #13"
    print "	add	r3, r3, r6, LSR #19"
    print "	sbfx	r5, r8, #0, #19"
    print "	add	r4, r5, r7, ASR #6"
    print "	smlal	r8, r9, r12, r5"
    #print "	subs	r8, r8, r5"
    #print "	sbc	r9, r9, r5, ASR #31"
    print "	sbfx	r5, r9, #0, #6"
    print "	sub	r9, r9, r5"
    print "	lsl	r5, r5, #13"
    print "	add	r5, r5, r8, LSR #19"
    print "	sbfx	r7, r10, #0, #19"
    print "	add	r6, r7, r9, ASR #6"
    print "	smlal	r10, r11, r12, r7"
    #print "	subs	r10, r10, r7"
    #print "	sbc	r11, r11, r7, ASR #31"
    print "	sbfx	r7, r11, #0, #6"
    print "	sub	r11, r11, r7"
    print "	lsl	r7, r7, #13"
    print "	add	r7, r7, r10, LSR #19"
    #print "	asr	r8, r11, #6"
    #print "	stm	r9, {r2-r8}"

    
def conv_3x64_7x32_acc (i) :
    global V
    print "	// accumulate to", [read_V(acc_r(i,j)) for j in range(7)]
    print_ldr("r10", acc_r(i,0), "limb 0")
    print_ldr("r12", acc_r(i,1), "limb 1")
    print_ldr("r14", acc_r(i,2), "limb 2")
    print_ldr("r9", acc_r(i,3), "limb 3")
    print "	add	r2, r2, r10"
    print "	add	r3, r3, r12"
    print "	add	r4, r4, r14"
    print "	add	r5, r5, r9"
    print_ldr("r10", acc_r(i,4), "limb 4")
    print_ldr("r12", acc_r(i,5), "limb 5")
    print_ldr("r8", acc_r(i,6), "limb 6")
    print "	add	r6, r6, r10"
    print "	add	r7, r7, r12"
    print "	add	r8, r8, r11, asr #6"

def conv_3x64_7x32_acc_i (i) :
    global V
    print "	// accumulate r2-r4 to", [read_V(acc_r(i,j)) for j in range(3)]
    print_ldr("r10", acc_r(i,0), "limb 0")
    print_ldr("r12", acc_r(i,1), "limb 1")
    print_ldr("r14", acc_r(i,2), "limb 2")
    print "	add	r2, r2, r10"
    print "	add	r3, r3, r12"
    print "	add	r4, r4, r14"
    print "	asr	r8, r11, #6"

def conv_3x64_7x32_store (i) :
    global V
    print "	// store r2-r8 to", [read_V(acc_r(i,j)) for j in range(7)]
    for j in range(7) :
        print_str("r"+str(j+2), acc_r(i,j), "limb %d" % (j))

def conv_3x64_7x32_store_end (i) : # store 4 accumulators at end of thread 
    global V
    print "	// store r6-r8 to", [read_V(acc_r(i,j)) for j in range(4,7)]
    for j in range(4,7) :
        print_str("r"+str(j+2), acc_r(i,j), "limb %d" % (j))
    print "	// compress and store r2-r5"
    print_ldr("r6","hh","reload cursor")
    print_ldr("r7","q","load q")
    print_ldr("r8","q32","load round(-2^32/q)")
    print "	br_32x2	r2, r3, r7, r8, r9"
    print "	br_32x2	r4, r5, r7, r8, r9"
    print "	str	r2, [r6], #4"
    print "	str	r4, [r6], #4"
    print_str("r6","hh","store cursor")

def conv_3x64_7x32_store_end_i (i) : # store all 7 accumulators     
    global V
    print_ldr("r9","q","load q")
    print_ldr("r10","q32","load round(-2^32/q)")
    print "	// compress and store r2-r8"
    print "	br_32x2	r2, r3, r9, r10, r11"
    print "	br_32x2	r4, r5, r9, r10, r11"
    print "	br_32x2	r6, r7, r9, r10, r11"
    print "	br_32	r8, r9, r10, r11"
    print "	uxth	r8, r8"
    print_ldr("r11","hh","reload cursor")
    print "	str	r2, [r11], #4"
    print "	str	r4, [r11], #4"
    print "	str	r6, [r11], #4"
    print "	str	r8, [r11], #4"
    print_str("r11","hh","store cursor")

    
def conv_3x64_7x32 (i) :
    global V
    conv_3x64_7x32_body (i)
    conv_3x64_7x32_acc (i) 
    conv_3x64_7x32_store (i)
              

    
    
def SCH_polymulNxNsh(N,C,rf,rg,rh) :
    global V, NV, r_f, r_g, r_h, r_N
    r_f = rf; r_g = rg; r_h = rh

    alloc_save_no("N",str(N))
    alloc_save_no("C",str(C))
    alloc_save_no("ff","sp+0")
    alloc_save_no("gg","sp+%d" % (2*N))
    alloc_save_no("q",str(q))

    print_str(rh,"h","save h")
    print_str(rh,"hh","save hh")
    print_str(rf,"f","save f")
    print_str(rg,"g","save g")
    print "	sub	sp, sp, #%d	// space for ff,gg" % (4*N)
    
    print_ldr("r0","ff","load ff")
    print_ldr("r12","N","load N")
    print "	bl	convert_2p19"
    print_ldr("r0","gg","load gg")
    print_ldr("r1","g","load g")
    #print "	mov	r0, r1"
    print_ldr("r12","N","load N")
    print "	bl	convert_2p19"
    
    print "sch2p19_0:			// increasing thread length"
    for i in range(0,N/4) : # i is thread count
        print "	add	r1, sp, #%d	// load gg+2*%d" % (2*N+8*i,i)
        print_ldr("r0","ff","load ff")
        for j in range(0,i-C+1,C) :
            add_block_initial (j,i-j)
            for k in range(1,C) :
            	add_block (j+k,i-j-k)
            conv_3x64_7x32_body(i)
            if (j == 0) :
                conv_3x64_7x32_acc_i(i)
            else :
                conv_3x64_7x32_acc(i)
            conv_3x64_7x32_store(i)
        j = (i // C) * C
        add_block_initial (j,i-j)
        for k in range(j+1,i+1) :
            add_block (k, i-k)
        conv_3x64_7x32_body(i)
        if (j == 0) :
            if (i == 0) :
                print "	asr	r8, r11, #6"
            else :
                conv_3x64_7x32_acc_i(i)
        else :
            conv_3x64_7x32_acc(i)
        conv_3x64_7x32_store_end(i)
    print "sch2p19_10:			// decreasing thread length"
    for i in range(N/4, N/2-1) :
        print "	add	r1, sp, #%d	// load gg+2*%d" % (4*N-8,N/4-1)
        print "	add	r0, sp, #%d	// load ff+2*%d" % (8*i-N*2+8,i-N/4+1)
        for j in range(i-N/4+1,N/4-C,C) :
            add_block_initial (j,i-j)
            for k in range(1,C) :
            	add_block (j+k,i-j-k)
            conv_3x64_7x32_body(i)
            if (j == i-N/4+1) :
                conv_3x64_7x32_acc_i(i)
            else :
                conv_3x64_7x32_acc(i)
            conv_3x64_7x32_store(i)
        j = ((N/2 - i - 2) // C) * C + i-N/4+1
        add_block_initial (j,i-j)
        for k in range(j+1,N/4) :
            add_block (k, i-k)
        conv_3x64_7x32_body(i)
        if (j == i-N/4+1) :
            conv_3x64_7x32_acc_i(i)
        else :
            conv_3x64_7x32_acc(i)
        if (i == N/2 -2) :
            conv_3x64_7x32_store_end_i(i)
        else :
            conv_3x64_7x32_store_end(i)
    print "sch2p19_20:			// mv hh back to h"
    print_ldr("r0","h","reload h")
    print_ldr("r1","f","reload f")
    print_ldr("r2","g","reload g")
    print
