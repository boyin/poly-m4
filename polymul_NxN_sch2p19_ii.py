#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
NV = 0; V = {}


def SCH_polymulNxNsh_defs () :
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    print "// void convert_2p19 (r0 = dst, r1 = src, r12 = length) "
    print "convert_2p19:"
    print "convert_2p19_0:"
    print "	ldrsh	r2, [r1], #2"
    for i in range(3,10) :
        print "	ldr	r%d, [r1], #4" % (i)
    print "	ldrsh	r10, [r1], #2"
    for i in range(2,9) :
        print "	add	r%d, r%d, r%d, LSL #19" % (i,i,i+1)
        print "	asr	r%d, r%d, #16" % (i+1,i+1)
    print "	add	r9, r9, r10, LSL #19"
    print "	stm	r0!, {r2-r9}"
    print "	subs	r12, #16"
    print "	bhi	convert_2p19_0"
    print "	bx	lr"
