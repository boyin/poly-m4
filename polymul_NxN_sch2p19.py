#!/usr/bin/python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
NV = 0; V = {}

def alloc_save (S) :
    global NV
    global V

    V[S] =  "s" + str(NV)
    NV += 1

    
def cmod (A, B) :
    assert (B>0 and B==int(B))
    R = A % B
    if R > B/2 :
        return R - B
    else :
        return R

def print_ldr (reg, loc, comment) :
    if (re.match("^s[0-9]*$", V[loc])) :
        print "	vmov	%s, %s		// %s" % (reg, V[loc], comment)
    elif (re.match('sp\+([ 0-9]*)',V[loc])) :
        m = int(re.match('sp\+([ 0-9]*)',V[loc]).group(1))
        print "	add	%s, sp, #%d	// %s" % (reg, m, comment)
    else :
    	print("	ldr	%s, %s		// %s" % (reg, V[loc], comment))

def print_str (reg, loc, comment) :
    if re.match("^s[0-9]*$", V[loc]) :
        print("	vmov	%s, %s		// %s" % (V[loc], reg, comment))
    else :
        print("	str	%s, %s		// %s" % (reg, V[loc], comment))

alloc_save("h")			# V["h"] = s0	# h = output
alloc_save("g")			# V["g"] = s1	# g = input 1
alloc_save("N")			# V["N"] = s2	# N = size
alloc_save("gg")		# V["gg"]= s3	# temp array 1 (in)
alloc_save("hh")		# V["hh"]= s4	# temp array 2 (out)
alloc_save("C")			# V["C"] = s5	# count before adjusting
alloc_save("ct")		# V["ct"]= s6	# product-scanning counter
V["ff"] = "sp+0"                # alloc_save("ff")
alloc_save("hh2")		# V["hh2"]=s7	# a second copy of hh
        
def Sch_polymulNxNsh() :
    global V, NV

    print '#include "red-asm.h"'
    print 
    print "	.macro	conv_3x64_7x32"
    print "	//r6-7/r8-9/r10-11 are partial accumulators"
    print "	//cut out 19-bit pieces, add to 7x32b pointed by %s" % V["hh"]
    print "	sbfx	r2, r6, #0, #19"
    print "	subs	r6, r6, r2"
    print "	sbc	r7, r7, r2, ASR #31"
    print "	sbfx	r3, r7, #0, #6"
    print "	sub	r7, r7, r3"
    print "	lsl	r3, r3, #13"
    print "	add	r3, r3, r6, LSR #19"
    print "	asr	r4, r7, #6"
    print "	sbfx	r5, r8, #0, #19"
    print "	add	r4, r4, r5"
    print "	subs	r8, r8, r5"
    print "	sbc	r9, r9, r5, ASR #31"
    print "	sbfx	r5, r9, #0, #6"
    print "	sub	r9, r9, r5"
    print "	lsl	r5, r5, #13"
    print "	add	r5, r5, r8, LSR #19"
    print "	asr	r6, r9, #6"
    print "	sbfx	r7, r10, #0, #19"
    print "	add	r6, r6, r7"
    print "	subs	r10, r10, r7"
    print "	sbc	r11, r11, r7, ASR #31"
    print "	sbfx	r7, r11, #0, #6"
    print "	sub	r11, r11, r7"
    print "	lsl	r7, r7, #13"
    print "	add	r7, r7, r10, LSR #19"
    print "	asr	r8, r11, #6"
    print_ldr("r9","hh","reload hh")
    print "	ldrd	r10, r11, [r9]"
    print "	add	r2, r2, r10"
    print "	add	r3, r3, r11"
    print "	ldrd	r10, r11, [r9, #8]"
    print "	add	r4, r4, r10"
    print "	add	r5, r5, r11"
    print "	ldr	r10, [r9, #16]"
    print "	ldr	r11, [r9, #20]"
    print "	ldr	r12, [r9, #24]	// r12 is not important now"
    print "	add	r6, r6, r10"
    print "	add	r7, r7, r11"
    print "	add	r8, r8, r12"
    print "	stm	r9, {r2-r8}"
    #print "	add	r9, r9, #16"
    #print_str("r9","hh","store shifted hh")
    print "	.endm"
    print 
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "// void convert_2p19 (r0 = dst, r1 = src, r12 = length) "
    # print "convert_2p19:"
    # print "	ldrsh	r2, [r1], #2"
    # print "	ldrsh	r3, [r1], #2"
    # print "	ldrsh	r4, [r1], #2"
    # print "	ldrsh	r5, [r1], #2"
    # print "	ldrsh	r6, [r1], #2"
    # print "	ldrsh	r7, [r1], #2"
    # print "	ldrsh	r8, [r1], #2"
    # print "	ldrsh	r9, [r1], #2"
    # print "	add	r2, r2, r3, LSL #19"
    # print "	add	r3, r4, r5, LSL #19"
    # print "	add	r4, r6, r7, LSL #19"
    # print "	add	r5, r8, r9, LSL #19"
    # print "	stm	r0!, {r2-r5}"
    # print "	subs	r12, #8"
    # print "	bhi	convert_2p19"
    # print "	bx	lr"
    print "convert_2p19:"
    print "	mov	r11, #0x80000	// 2^19"
    print "convert_2p19_0:"
    print "	ldrsh	r2, [r1], #2"
    print "	ldr	r3, [r1], #4"
    print "	ldr	r4, [r1], #4"
    print "	ldr	r5, [r1], #4"
    print "	ldr	r6, [r1], #4"
    print "	ldr	r7, [r1], #4"
    print "	ldr	r8, [r1], #4"
    print "	ldr	r9, [r1], #4"
    print "	ldrsh	r10, [r1], #2"
    print "	mla	r2, r3, r11, r2"
    print "	asr	r3, r3, #16"
    print "	mla	r3, r4, r11, r3"
    print "	asr	r4, r4, #16"
    print "	mla	r4, r5, r11, r4"
    print "	asr	r5, r5, #16"
    print "	mla	r5, r6, r11, r5"
    print "	asr	r6, r6, #16"
    print "	mla	r6, r7, r11, r6"
    print "	asr	r7, r7, #16"
    print "	mla	r7, r8, r11, r7"
    print "	asr	r8, r8, #16"
    print "	mla	r8, r9, r11, r8"
    print "	asr	r9, r9, #16"
    print "	mla	r9, r10, r11, r9"
    print "	stm	r0!, {r2-r9}"
    print "	subs	r12, #16"
    print "	bhi	convert_2p19_0"
    print "	bx	lr"
    print
    print "// void gf_polymul_NxNsh (int *h, int *f, int *g, int N, int C);"
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "	.global gf_polymul_NxNsh"
    print "	.type	gf_polymul_NxNsh, %function"
    print "gf_polymul_NxNsh:"
    print "// 2N bytes each for ff, gg,  8N bytes for hh (32-bit accumulators)"
    print "	ldr	r12, [sp]	// load C from stack"
    #print "	pop	r12	// pop C from stack, wrong, don't pop!!"
    print "	push	{r4-r11,lr}"
    print_str("r0","h","save h")
    print_str("r2","g","save g")
    print_str("r3","N","save N")
    print "	sub	r4, r12, #1	// first block never overflows"
    print_str("r4","C","save C")
    print "	add	r4, r3, r3, LSL #1 // 3*N"
    print "	sub	sp, sp, r4, LSL #2 // sp -= 12N"
    print "	add	r4, sp, r3, LSL #1 // sp + 2N"
    print_str("r4","gg","save gg")
    print "	add	r4, sp, r3, LSL #2 // sp + 4N"
    print_str("r4","hh","save hh")
    print_str("r4","hh2","save hh again")
    print_ldr("r0","ff","load ff")
    #print "	mov	r0, r1"
    print "	mov	r12, r3"
    print "	bl	convert_2p19"
    print_ldr("r0","gg","load gg")
    print_ldr("r1","g","load g")
    #print "	mov	r0, r1"
    print_ldr("r12","N","load N")
    print "	bl	convert_2p19"
    print
    print_ldr("r0","hh","load hh")
    print_ldr("r1","N","load N")
    print "	mov	r2, #0"
    print_str("r2","ct","store product-scanning counter")
    print "	mov	r3, #0"
    print "	mov	r4, #0"
    print "	mov	r5, #0"
    print "	mov	r6, #0"
    print "	mov	r7, #0"
    print "	mov	r8, #0"
    print "	mov	r9, #0"
    print "clear4N:"
    print "	stm	r0!, {r2-r9}"
    print "	subs	r1, #4"
    print "	bne	clear4N"
    
    print_ldr("r0","ff","load ff")
    print_ldr("r1","gg","load gg")
    print "sch2p19_0:			// increasing thread length"
    print_ldr("r14","ct","load thread count")
    print "sch2p19_1:"
    print_ldr("r12","C","load safety count")
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #-8"
    print " 	smull	r6, r7, r2, r4"
    print "	smull	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smull	r10, r11, r3, r5"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_3	// first block, no overflows"
    print "sch2p19_2:"
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #-8"
    print " 	smlal	r6, r7, r2, r4"
    print "	smlal	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smlal	r10, r11, r3, r5"
    print "	sub	r12, r12, #1	// safety count = 0?"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_3"
    print "	cmp	r12, #0"
    print "	bne	sch2p19_2"
    print "sch2p19_3:"    
    print "	conv_3x64_7x32"
    print "	cmp	r14, #-1"
    print "	bne	sch2p19_1	// reset safety counter"
    print "	add	r1, #8		// next thread, move cursor"
    print_ldr("r12","hh","load hh")
    print "	add	r12, #16	// move cursor"
    print_str("r12","hh","store hh again")
    print_ldr("r14","ct","reload thread count")
    print "	add	r14, #1		// increment thread count"
    print_str("r14","ct","save new thread count")
    print "sch2p19_4:"
    print_ldr("r12","C","load safety count")
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #-8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #8"
    print " 	smull	r6, r7, r2, r4"
    print "	smull	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smull	r10, r11, r3, r5"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_6	// first block, no overflows"
    print "sch2p19_5:"
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #-8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #8"
    print " 	smlal	r6, r7, r2, r4"
    print "	smlal	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smlal	r10, r11, r3, r5"
    print "	sub	r12, r12, #1	// safety count = 0?"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_6"
    print "	cmp	r12, #0"
    print "	bne	sch2p19_5"
    print "sch2p19_6:"    
    print "	conv_3x64_7x32"
    print "	cmp	r14, #-1"
    print "	bne	sch2p19_4	// reset safety counter"
    print "	add	r0, r0, #8	// move cursor"
    print_ldr("r12","hh","load hh")
    print "	add	r12, #16	// move cursor"
    print_str("r12","hh","store hh again")
    print_ldr("r14","ct","reload thread count")
    print "	add	r14, #1		// increment thread count"
    print_str("r14","ct","save new thread count")
    print_ldr("r12","N","reload N")
    print "	cmp	r14, r12, LSR #2// thread count >= N/4?"
    print "	bcc	sch2p19_1	// next threads"
    print
    print "sch2p19_10:			// shortening thread length"
    print "	add	r0, r0, #8	// adjust cursor"
    print "	sub	r1, r1, #8	// adjust cursor"
    print_ldr("r14","ct","load thread count")
    print "	sub	r14, #2"
    print_str("r14","ct","store adjusted thread count")
    print "sch2p19_11:"
    print_ldr("r12","C","load safety count")
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #-8"
    print " 	smull	r6, r7, r2, r4"
    print "	smull	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smull	r10, r11, r3, r5"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_13	// first block, no overflows"
    print "sch2p19_12:"
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #-8"
    print " 	smlal	r6, r7, r2, r4"
    print "	smlal	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smlal	r10, r11, r3, r5"
    print "	sub	r12, r12, #1	// safety count = 0?"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_13"
    print "	cmp	r12, #0"
    print "	bne	sch2p19_12"
    print "sch2p19_13:"    
    print "	conv_3x64_7x32"
    print "	cmp	r14, #-1"
    print "	bne	sch2p19_11	// reset safety counter"
    print "	add	r1, r1, #16	// next thread, move cursor"
    print "	sub	r0, r0, #8	// next thread, move cursor"
    print_ldr("r12","hh","load hh")
    print "	add	r12, #16	// move cursor"
    print_str("r12","hh","store hh again")
    print_ldr("r14","ct","reload thread count")
    print "	subs	r14, r14, #1	// decrement thread count"
    print "	bcc	sch2p19_20	// if minus, end"
    print_str("r14","ct","save new thread count")
    print "sch2p19_14:"
    print_ldr("r12","C","load safety count")
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #-8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #8"
    print " 	smull	r6, r7, r2, r4"
    print "	smull	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smull	r10, r11, r3, r5"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_16	// first block, no overflows"
    print "sch2p19_15:"
    print "	ldr	r3, [r0, #4]"
    print "	ldr	r2, [r0], #-8"
    print "	ldr	r5, [r1, #4]"
    print "	ldr	r4, [r1], #8"
    print " 	smlal	r6, r7, r2, r4"
    print "	smlal	r8, r9, r2, r5"
    print "	smlal	r8, r9, r3, r4"
    print "	smlal	r10, r11, r3, r5"
    print "	sub	r12, r12, #1	// safety count = 0?"
    print "	subs	r14, r14, #1	// thread count = 0?"
    print "	bcc	sch2p19_16"
    print "	cmp	r12, #0"
    print "	bne	sch2p19_15"
    print "sch2p19_16:"    
    print "	conv_3x64_7x32"
    print "	cmp	r14, #-1"
    print "	bne	sch2p19_14	// reset safety counter"
    print "	add	r0, r0, #16	// move cursor"
    print "	sub	r1, r1, #8	// move cursor"
    print_ldr("r12","hh","load hh")
    print "	add	r12, #16	// move cursor"
    print_str("r12","hh","store hh again")
    print_ldr("r14","ct","reload thread count")
    print "	sub	r14, r14, #1	// decrement thread count"
    print_str("r14","ct","save new thread count")
    print "	b	sch2p19_11	// next threads"
    print "sch2p19_20:			// mv hh back to h"
    print_ldr("r0","hh2","reload old hh")
    print_ldr("r1","h","reload h")
    print_ldr("r11","N","reload N")
    print "	mov	r12, #%d" % (q)
    print "	movw	r14, #%d" % (65536 - (q32inv % 65536))
    print "	movt	r14, #%d" % (65535 - (q32inv // 65536))
    print "sch2p19_21:"
    print "	ldm	r0!, {r2-r9}"
    print "	br_32	r2, r12, r14, r10"
    print "	br_32	r3, r12, r14, r10"
    print "	br_32	r4, r12, r14, r10"
    print "	br_32	r5, r12, r14, r10"
    print "	br_32	r6, r12, r14, r10"
    print "	br_32	r7, r12, r14, r10"
    print "	br_32	r8, r12, r14, r10"
    print "	br_32	r9, r12, r14, r10"
    print "	pkhbt	r2, r2, r3, LSL #16"
    print "	pkhbt	r3, r4, r5, LSL #16"
    print "	pkhbt	r4, r6, r7, LSL #16"
    print "	pkhbt	r5, r8, r9, LSL #16"
    print "	stm	r1!, {r2-r5}"
    print "	subs	r11, r11, #4"
    print "	bne	sch2p19_21"

    print
    print_ldr("r3","N","load N")
    print "	add	r4, r3, r3, LSL #1 // 3*N"
    print "	add	sp, sp, r4, LSL #2 // sp += 12N"
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"


Sch_polymulNxNsh() 
