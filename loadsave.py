#!/usr/bin/env python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
global V,NV
NV = 0; V = {}

def alloc_save (S) :
    global NV
    global V

    if not S in V :
        if NV < 32 :
            V[S] = "s" + str(NV)
        else :
            V[S] = "[sp,#%d]" % (NV-32)
        NV += 1

def alloc_save_no (S,X) :
    global V
    if not S in V :
        V[S] = X
    elif (re.match(r'sp+',V[S])) :
        print " // note %s redefined here" % S
        V[S] = X
    else :
        raise "redefined label %s" % S
    
        
def alloc_save_same (S,X) :
    global V
    if not S in V and X in V:
        V[S] = V[X]
        
def print_ldr (reg, loc, comment) :
    global V
    if (re.match(r'([A-Za-z0-9_]*)\[ *([0-9]*) *\]',loc)) :
        s1 = re.match(r'([A-Za-z0-9_]*)\[ *([0-9]*) *\]',loc).group(1)
        m1 = int(re.match(r'([A-Za-z0-9_]*)\[ *([0-9]*) *\]',loc).group(2))
        if re.match(r'sp\+ *([0-9]*) *',V[s1]) :
            m2 = int(re.match(r'sp\+ *([0-9]*) *',V[s1]).group(1))
            print "	ldr	%s, [sp, #%d]	// %s" % (reg, m1+m2, comment)  
    elif (re.match(r'sp\+ *([0-9]*) *',V[loc])) :
        m = int(re.match(r'sp\+ *([0-9]*) *',V[loc]).group(1))
        print "	add	%s, sp, #%d	// %s" % (reg, m, comment)
    elif (re.match(r'^ *([0-9]*) *$',V[loc])) :
        m = int(re.match(r' *([0-9]*) *',V[loc]).group(1))
        print "	mov	%s, #%d	// %s" % (reg, m, comment)
    elif (re.match(r'^s[0-9]*$', V[loc])) :
        print "	vmov	%s, %s		// %s" % (reg, V[loc], comment)
    else :
    	print("	ldr	%s, %s		// %s" % (reg, V[loc], comment))

def print_str (reg, loc, comment) :
    global V
    if (re.match(r'([A-Za-z0-9_]*)\[ *([0-9]*) *\]',loc)) :
        s1 = re.match(r'([A-Za-z0-9_]*)\[ *([0-9]*) *\]',loc).group(1)
        m1 = int(re.match(r'([A-Za-z0-9_]*)\[ *([0-9]*) *\]',loc).group(2))
        if re.match(r'sp\+ *([0-9]*) *',V[s1]) :
            m2 = int(re.match(r'sp\+ *([0-9]*) *',V[s1]).group(1))
            print "	str	%s, [sp, #%d]	// %s" % (reg, m1+m2, comment)  
    elif re.match("^s[0-9]*$", V[loc]) :
        print("	vmov	%s, %s		// %s" % (V[loc], reg, comment))
    elif (re.match(r'^(sp\+)? *([0-9]*) *$',V[loc])) :
        print("	// no need to store %s = %s" % (reg, V[loc]))
    else :
        print("	str	%s, %s		// %s" % (reg, V[loc], comment))

def read_V(loc) :
    global V
    return(V[loc])

def read_NV() :
    global NV
    return (NV)
