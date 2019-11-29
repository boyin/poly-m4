#!/usr/bin/python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
NV = 0; V = {}
MONT_OR_BAR = 0

# def alloc_save (S) : # allocate variable name s_S as a space
#     global SAVES
#     if not (("s_"+S) in locals() or ("s_"+S) in globals()) :
#         globals()["s_"+S] = "s" + str(SAVES)
#         SAVES +=1

def alloc_save (S) :
    global NV
    global V
    #globals()["V["+S+"]"] = "s" + str(NV)
    V[S] =  "s" + str(NV)
    NV += 1

#aux = open("polymul_NxN_aux.h","w+")
# adjust
# def adj_size (size) :
#     if (size < q_ab) :  # 2341 is q-dependent
#         return(size)
#     else :
#         i = ceil ((floor(size * q16 / 2.0**16 + 0.5) - 0.5) * 2.0**16 / q16) - 1
#         return(i - q * floor(i * q16 / 2.0**16 +0.5))

def is_even (E) :
    if isinstance(E,int) :
        return (int(E/2)*2 == E)
    else :
        return(False)

def adj_size (size) : return (2295) # ARM adjustment is tight.

def mr_size (size) :
    return (2295 + size // 65536)

def mult_size_x (sizea, sizeb, x) :
    return (2295 + (sizea * sizeb * x) // 65536)

def adjd (size) :
    if (size < 16384) :
        return size
    else :
        return adj_size(size)

def cmod (A, B) :
    assert (B>0 and B==int(B))
    R = A % B
    if R > B/2 :
        return R - B
    else :
        return R

def adj_stmt () :
    return("  br_16x2	%s")	# adjust W=2 shorts

# changed to using vmov from ldr/str, saves 1 cycles
def print_ldr (reg, loc, comment) :
    #print("	ldr	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s	// %s" % (reg, loc, comment))
def print_str (reg, loc, comment) :
    #print("	str	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s	// %s" % (loc, reg, comment))
# changed to vfp registers later.
# V["h"] = "[sp,#-4]";	V["2M"] = "[sp,#-8]";	V["gg"] = "[sp,#-12]";
# V["hh"] = "[sp,#-16]";	V["ov"] = "[sp,#-20]";	V["q"] = "[sp,#-24]";
# V["qi"] = "[sp, #-28]";	V["q32"] = "[sp,#-32]";	V["mq"] = "[sp,#-36]";
# V["T"] = "[sp, #-40]";	V["X"] = "[sp, #-44]";	V["f"] = "[sp, #-48]"
# V["g"] = "[sp, #-52]";	V["scr"] = "[sp, #-56]"
alloc_save("h")  #V["h"] = "s0"		#h, output
alloc_save("2M") #V["2M"] = "s1"	#2M, M = KA_terms(N,N0)*(2*l-1)  
alloc_save("gg") #V["gg"] = "s2"	#gg, 2d inputs (exp size 2M) = sp+2M
alloc_save("hh") #V["hh"] = "s3"	#hh, outputs (exp size 4M) = sp+4M
alloc_save("ov") #V["ov"] = "s4"	#overflow list address           
#alloc_save("q")  #V["q"] = "s5" 	#modulus q = 4591 (don't need this)
alloc_save("src")			#not "scr"
alloc_save("qi") #V["qi"] = "s6"	#q^{-1} mod 2^16            
alloc_save("q32")#V["q32"] = "s7"	#round(2^32/q) 
alloc_save("-q") #V["-q"] = "s8"	#-q, I am stupid, shouldn't need  
alloc_save("T")  #V["T"] = "s9"		#T = l * N                       
#alloc_save("2M0")#V["2M0"] = "s10"	#2*M0, M0 = KA_terms(N,N0)
alloc_save("X")  #V["X"] = "s10"	#temporary space pointer
alloc_save("f")	 #V["f"] = "s11"	#f 
alloc_save("g")  #V["g"] = "s12"	#g
alloc_save("scr")#V["scr"] = "s13" 	#scratch register
alloc_save("dst")#V["dst"] = "s14"	#save destination reg
alloc_save("M1") #V["M1"] = "s15"	#matrix 1
alloc_save("M2") #V["M2"] = "s16"	#matrix 2
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

def KA_terms (N,N0) :
    assert (isinstance(N,int) and (N==1<<int(log(N,2)+0.5)) and (N>=B))
    M = N ;
    while N > N0 :
        M += M/2
        N = N/2
    return M

#T = 768	# Toom size
#l = 6 		# Toom #segments
#B = 32		# adventurous new base case
#B = 16		# new base case
B = 8		# new base case
#B = 4 		# base case
W = 2 		# width of vectors
q_mb = int(sqrt((32767-2295)*2**16/B)) # multiplicative bound
N_range = 256
l_range = 6
M_range = (2*l_range-1)*KA_terms(N_range,B)
size0 = [0 for i in range(M_range/W)] 
size2 = [0 for i in range(M_range/W*2)]
sizet = [0 for i in range(N_range/W*2)]

# MAT1 and MAT2 computed using Toom_Matrix.sage
# l = 6 case
MAT1_6 = [[1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 1], [1, -1, 1, -1, 1, -1], [1, 2, 4, 8, 16, 32], [1, -2, 4, -8, 16, -32], [32, 16, 8, 4, 2, 1], [-32, 16, -8, 4, -2, 1], [1, 4, 16, 64, 256, 1024], [1, -4, 16, -64, 256, -1024], [1024, 256, 64, 16, 4, 1]]
MAT2_6 = [[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [-4, -4, -1893, -2054, -651, 1024, -868, 1241, -266, -1585, -1851], [-1440, 16, 1088, 1088, -17, -17, 1736, 1736, -1298, -1298, 0], [1169, 1169, -46, 68, -1428, 1455, 49, -22, -633, -1298, -1931], [1512, -85, -101, -101, 373, 373, 17, 17, -72, -72, 0], [-1457, -1457, -2124, -2031, 644, -1361, 644, -1361, 1798, 0, 1798], [-360, 1237, 1377, 1377, -1508, -1508, -1152, -1152, 72, 72, 0], [1440, 1440, -1202, -1088, -535, -606, -2012, 871, -633, 1298, 665], [287, -1169, -68, -68, 1152, 1152, -601, -601, 1298, 1298, 0], [-1148, -1148, -1621, -1782, 1970, -512, 2187, -729, -266, 1585, 1319], [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
# l = 5 case
MAT1_5 = [[1, 0, 0, 0, 0], [0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, -1, 1, -1, 1], [1, 2, 4, 8, 16], [1, -2, 4, -8, 16], [16, 8, 4, 2, 1], [16, -8, 4, -2, 1], [1, 4, 16, 64, 256]]
MAT2_5 = [[1, 0, 0, 0, 0, 0, 0, 0, 0], [-1148, 4, 1360, -816, -51, 17, -685, 1553, -1202], [-1153, -1, 1020, 1020, 1135, 1135, -51, -51, 0], [1436, -21, -1529, -1327, 1983, 491, 51, -17, -576], [1153, 1153, 256, 256, -1084, -1084, -1084, -1084, 0], [-1436, 21, -1786, 51, 338, 1779, 2270, 2287, 576], [-1, -1153, 1020, 1020, -51, -51, 1135, 1135, 0], [1148, -4, -340, -204, -2270, -2287, -1636, 768, 1202], [0, 1, 0, 0, 0, 0, 0, 0, 0]]
# l = 4 case
MAT1_4 = [[1, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1], [1, -1, 1, -1],  [8, 4, 2, 1], [8,-4,2,-1],[1, 2, 4, 8]]
MAT2_4 =  [[    1,     0,     0,     0,     0,     0,     0],
[ 2295,  2295,  1530,  -510,  2168, -2219,   -51],
[   -5,  1148,   765,   765, -1339, -1339,     0],
[-2293, -2293, -2294,  1785,   255,     0,   255],
[    4, -1149,  1531,  1531,  1339,  1339,     0],
[   -2,    -2, -1531,  1020,  2168,  2219,  -204],
[    0,     1,     0,     0,     0,     0,     0]]
# l = 3 case
MAT1_3 = [[1, 0, 0], [0, 0, 0], [1, 1, 1], [1, -1, 1], [1, 2, 4]]
MAT2_3 = [[1, 0, 0, 0, 0], [2295, 2, 1, 1530, 765], [-1, -1, -2295, -2295, 0], [-2295, -2, 2295, 765, -765], [0, 1, 0, 0, 0]]

def T_prologue () :
    print '#include "red-asm.h"'

def T_polymulNxN (T, l) :
    global V,NV
    # MAT1, MAT2 are data inputs
    # T_head
    assert (l > 2 and l < 7 and l == int(l))
    if l == 3 : MAT1 = MAT1_3; MAT2 = MAT2_3
    elif l == 4 : MAT1 = MAT1_4; MAT2 = MAT2_4
    elif l == 5 : MAT1 = MAT1_5; MAT2 = MAT2_5
    else: MAT1 = MAT1_6; MAT2 = MAT2_6
    #
    N = T / l
    lgN = int(log(N)/log(2)+0.5)
    M0 = KA_terms(N,B)
    M = M0 * (2*l-1)
    print("// N,l=%d,%d requires %d=8x%dx%d storage\n" % (N,l,(2*l-1)*8*KA_terms(N,B),(2*l-1),KA_terms(N,B)))
    aux = open("polymul_%dx%d.h" % (T,T),"w+")
    aux.write("void gf_polymul_%dx%d_divR (int32_t *h, int32_t *f, int32_t *g);\n" % (T,T))
    aux.close()
    aux = open("polymul_%dx%d_T%d_B%d_aux.h" % (T,T,l,B),"w+")
    aux.write("	.p2align	2,,3\n")
    aux.write("	.syntax		unified\n")
    aux.write("	.text\n\n")
    print '#include "polymul_%dx%d_T%d_B%d_aux.h"' % (T,T,l,B)
    print "	.p2align	2,,3	"
    print "// void gf_polymul_%dx%d_divR (int32_t *h, int32_t *f, int32_t *g);" % (T,T)
    print "	.syntax		unified"
    print "	.text"
    print "	.global gf_polymul_%dx%d_divR" % (T,T)
    print "	.type	gf_polymul_%dx%d_divR, %%function" % (T,T)
    print "gf_polymul_%dx%d_divR:" % (T,T)
    #
    for i in range (M/W) : size0[i] = 0
    for i in range (M/W*2)  : size2[i] = 0
    for i in range (N/W*2)  : sizet[i] = 0
    print "	push	{r4-r11,lr}"
    if (NV>16) :
        print "	vpush	{s16-s31}"
    print "T%dx%d_saves:" % (N,l)
    print_str("r0",V["h"],"// save h")
    print_str("r1",V["f"],"// save f")
    print_str("r2",V["g"],"// save g")
    # do I need this 2M0?
    #print "	ldr	r14, =%d	// r14=2M0" %(2*M0)
    #print_str("r14",V["2M0"],"save 2M0")
    print "	ldr	r12, =%d	// r12=2M" % (2*M)
    print "	sub	sp, sp, #%d	// 4*2*l hwords" % (16 * l)
    #print_str("sp",V["X"],"save pointer to temp space")
    print "	mov	r3, sp"
    print_str("r3",V["X"],"save pointer to temp space")
    print "	sub	sp, sp, r12, LSL #2	// subtract %d = 8M" % (8*M) 
    print "		// ff=[sp], gg=[sp,#%d], hh=[sp,#%d]" % (2*M,4*M)
    print "	mov	r3, sp"
    print "	add	r0, sp, r12	// gg=ff+%d(=2M)" % (2*M)
    print_str("r12", V["2M"], "save 2M")
    print_str("r0", V["gg"], "save gg (ff=sp)")
    print "	add	r14, r0, r12	// hh=gg+%d(=2M)" % (2*M)
    print_str("r14", V["hh"], "save h")
    if (B >= 32) : # code too large for relocatable code
        print "	movw	r14, #:lower16:T_exp_ov_%d" % (N)
        print "	movt	r14, #:upper16:T_exp_ov_%d" % (N)
        print "	movw	r11, #:lower16:T%d_Mat2" % (l)
        print "	movt	r11, #:upper16:T%d_Mat2" % (l)
        print "	movw	r12, #:lower16:T%d_Mat1" % (l)
        print "	movt	r12, #:upper16:T%d_Mat1" % (l)
    else : # use relocatable code if possible
        print "	ldr	r14, =T_exp_ov_%d" % N
        print "	ldr	r11, =T%d_Mat2" % (l)
        print "	ldr	r12, =T%d_Mat1" % (l)
    print_str("r14", V["ov"], "save ov pointer")
    print_str("r12", V["M1"], "save Matrix 1")
    print_str("r11", V["M2"], "save Matrix 2")
    print "	movw	r12, #%d" % (q)
    #print_str("r12", V["q"], "save q")
    print "	movw	r14, #%d" % (qinv)
    #print "	movt	r14, #65536-1"
    print_str("r14", V["qi"], "save qinv")
    print "	rsb	r12, r12, #0		// -q"
    print_str("r12", V["-q"], "save -q")
    print "	movw	r14, #%d" % (q32inv % 65536)
    print "	movt	r14, #%d" % (q32inv // 65536)
    print_str("r14", V["q32"], "save q32inv")
    #
    print "T%dx%d_begin:" % (N,l)
    # copy one 2N-long segments from f,g to ff and gg
    if (N>16) :
        print "	mov	r14, #%d" % (2*N)
    print "T%dx%d_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff" % (N,l)
    if (N==8) :
    	print "	ldm	r1!, {r4-r7}"
    	print "	ldm	r2!, {r8-r11}"
    	print "	stm	r3!, {r4-r7}"
    	print "	stm	r0!, {r8-r11}"
    else :	# N >= 16
        print "	ldm	r1!, {r4-r11}"
        print "	stm	r3!, {r4-r11}"
        print "	ldm	r2!, {r4-r11}"
        print "	stm	r0!, {r4-r11}"
        if (N>16) :
            print "	subs	r14, #32"
            print "	bne	T%dx%d_mv_loop" %  (N,l)
    print "	// r1 = f+N/W, r2 = g+N/W, r3 = ff+N/W, r0 = gg+N/W"
    # copy one 2N-long segments from f+(l-1)*N/2,g+(l-1)*N/2 to ff+N/2 and gg+N/2
    print "	add	r1, #%d		// r1=f+(l-2)N/W" % ((l-2)*2*N)
    print "	add	r2, #%d		// r2=g+(l-2)N/W" % ((l-2)*2*N)
    if (N>16) :
        print "	mov	r14, #%d" % (2*N)
    print "T%dx%d_mv_loop1:" % (N,l)
    if (N==8) :
    	print "	ldm	r1!, {r4-r7}"
    	print "	ldm	r2!, {r8-r11}"
    	print "	stm	r3!, {r4-r7}"
    	print "	stm	r0!, {r8-r11}"
    else :	# N >= 16
        print "	ldm	r1!, {r4-r11}"
        print "	stm	r3!, {r4-r11}"
        print "	ldm	r2!, {r4-r11}"
        print "	stm	r0!, {r4-r11}"
        if (N>16) :
            print "	subs	r14, #32"
            print "	bne	T%dx%d_mv_loop1" %  (N,l)
    #
    print "	// r3 = ff+2*N/W, r0 = gg+2*N/W"
    aux.write("T%d_Mat1:\n" % l)
    for j in range(4,2*l-1,2) :
        aux.write("	.hword	")
        for k in range(l-1) :
            mult = cmod(MAT1[j][k],q)
            aux.write("%d, " % (mult))
        mult = cmod(MAT1[j][l-1],q)
        aux.write("%d\n" % (mult))
    #        
    print "	b	T%dx%d_split" % (N,l)
    print
    print "T%dx%d_split_sub:	// use twice, r0 = src, r1 = dst" % (N,l)
    print_str("r14",V["scr"],"first, save link to scratch")
    print "	add	r1, r1, #%d" % (4*N)
    # do I need to save this?
    # print_str("r1",V["dst"],"save destination pointer")
    print "	mov	r12, #%d	// counter" % (2*N)
    print_ldr("r11",V["q32"],"load round(2^32/q)")
    print_ldr("r7",V["-q"],"load -q")
    print "T%dx%d_split_sub1:" % (N,l)
    print "	mov	r14, #0"
    print_ldr("r9",V["X"],"pointer to X array")
    print "	mov	r5, #0"
    print "	mov	r6, #0"
    print "T%dx%d_split_sub2:" % (N,l)
    for j in range(l) :
        print "	ldr	r8, [r0, r14]	// load next of set" 
        print "	str	r8, [r9, #%d]	// save to temp array" % (4*j)
        if (is_even(j)) :
            print "	sadd16	r5, r5, r8"
        else :
            print "	sadd16	r6, r6, r8"
        if (j < l - 1) :
            print "	add	r14, r14, #%d	// add 2N size of set" % (2*N)
    print "	sadd16	r4, r5, r6"
    print "	ssub16	r5, r5, r6"
    print "	mov	r3, #32768"
    print "	br_16x2	r4, r7, r11, r3, r6, r10"
    print "	br_16x2	r5, r7, r11, r3, r6, r10"
    #print_ldr("r9",V["X"],"X array, loaded with a set")
    print_ldr("r10",V["M1"],"load T%d matrix 1" % (l))
    print "	str	r4, [r1]"
    print "	mov	r2, #%d		// counter j" % (2*N)
    print "	str	r5, [r1, r2]"
    print "	add	r2, r2, #%d	// counter j" % (2*N)
    print "T%dx%d_split_sub3:" % (N,l)
    print "	ldrsh	r14, [r10], #2	// MAT1[j][0]"
    print "	ldr	r8, [r9]		// X[0]"
    print "	smulbb	r4, r14, r8"	
    print "	smulbt	r5, r14, r8"
    print "	ldrsh	r14, [r10], #2	// MAT1[j][1]"
    print "	ldr	r8, [r9, #4]		// X[1]"
    print "	smulbb	r3, r14, r8"  
    print "	smulbt	r6, r14, r8"
    print "T%dx%d_split_sub4:" % (N,l)
    for k in range(2,l) :
        print "	ldrsh	r14, [r10], #2	// MAT1[j][%d]" % (k)
        print "	ldr	r8, [r9, #%d]	// X[k]" % (4*k)
        if (is_even(k)) :
            print "	smlabb	r4, r14, r8, r4"	
            print "	smlabt	r5, r14, r8, r5"
        else:
            print "	smlabb	r3, r14, r8, r3"	
            print "	smlabt	r6, r14, r8, r6"
    print "	add	r8, r4, r3	// row j"
    print "	cmp	r2, #%d" % ((2*l-4)*2*N)
    print "	bcs	T%dx%d_split_sub5" % (N,l)
    print "	sub	r3, r4, r3	// row j+1"
    print "	add	r4, r5, r6	// row j"
    print "	sub	r5, r5, r6	// row j+1"
    print "	br_32	r8, r7, r11, r6"
    print "	br_32	r3, r7, r11, r6"
    print "	br_32	r4, r7, r11, r6"
    print "	br_32	r5, r7, r11, r6"
    print "	pkhbt	r8, r8, r4, LSL #16"
    print "	pkhbt	r3, r3, r5, LSL #16"
    print "	str	r8, [r1, r2]"
    print "	add	r2, #%d" % (2*N)
    print "	str	r3, [r1, r2]"
    print "	add	r2, #%d" % (2*N)
    print "	b	T%dx%d_split_sub3" % (N,l)
    print "T%dx%d_split_sub5:" % (N,l)
    print "	add	r4, r5, r6	// row j"
    print "	br_32	r8, r7, r11, r6"
    print "	br_32	r4, r7, r11, r6"
    print "	pkhbt	r8, r8, r4, LSL #16"
    print "	str	r8, [r1, r2]"
    print "	add	r0, #4		// incr src"
    print "	add	r1, #4		// incr dst"
    print "	subs	r12, #4		// decr counter"
    print "	bne	T%dx%d_split_sub1" % (N,l)
    #
    print_ldr("r14",V["scr"],"load original return addr")
    print "	bx	lr		// return"
    print
    print "T%dx%d_split:" % (N,l)
    print_ldr("r0",V["f"],"f")
    print "	mov	r1, sp		// ff"
    print "	bl	T%dx%d_split_sub" % (N,l)
    print_ldr("r0",V["g"],"g")
    print_ldr("r1",V["gg"],"gg")
    print "	bl	T%dx%d_split_sub" % (N,l)
    #
    print "T%dx%d_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12" % (N,l)
    print_ldr("r12",V["2M"],"reload 2M")
    N0 = N
    for i in range(N*(2*l-1)/W) :
        size0[i] = 2295 
    # due to the reduction earlier all bounds are +- 2295
    print "	mov	r0, sp		// ff = r0"
    print "	add	r1, r0, r12	// gg = r1"
    print "	mov	r2, #%d		// N0 = r2 = N" % (N)
    aux.write("T_exp_ov_%d:\n" % N)
    while (B < N0) :
        N1 = (2*l-1)*KA_terms(N,N0)
        size_mark = [0 for i in range(N1/W+1)]
        #
        aux.write("//")
        size_last = 0
        size_value = 2295
        for j in range(1,N1/W) :
            if (size0[j] != size_value) :
                aux.write("%d-%d:%d " % (size_last,j-1,size_value))
                size_last = j
                size_value = size0[j]
        aux.write("%d-%d:%d "%(size_last,N1/W-1,size_value))
        aux.write("\n")
        #
        for j in range(0,N1,N0) :
            for k in range(0,N0/2,W) :
                # check additive overflow (size 2^15)
                if (size0[(j+k)/W]+size0[(j+k+N0/2)/W] >= 32768) :
                    size0[(j+k)/W] = adj_size(size0[(j+k)/W])
                    size0[(j+k+N0/2)/W] = adj_size(size0[(j+k+N0/2)/W])
                    size_mark[(j+k)/W] = 1
                    size_mark[(j+k+N0/2)/W] = 1
                size0[(N1+j/2+k)/W] = size0[(j+k)/W]+size0[(j+k+N0/2)/W]
        aux.write("T_exp_ov_%d_%d:\n" % (N,N0))
        for j in range(0,N1/W) :
            if (size_mark[j] == 1) :
            	if (size_mark[j-1] == 0) :
                    aux.write("	.hword	%d, " % j)
                if (size_mark[j+1] == 0) :
                    aux.write("%d\n" % j)
        aux.write("	.hword	-1\n")
        aux.write("T_exp_add_%d_%d:\n" % (N,N0))
        aux.write("	.hword	%d	// #TERMS(%d,%d)/4\n" % (N1/W/2,N,N0))
        N0 /= 2
        #
    #
    # main assembly routine for T_exp
    print_ldr("r3", V["ov"], "load list to reduce")
    print "T%dx%d_exp_loop1:		// loop on N0" % (N,l)
    print "	cmp	r2, #%d		// while (N0>B)" % (B)
    print "	beq	T%dx%d_exp_end1" % (N,l)
    #
    print "T%dx%d_exp_reduce:		// reduce ff[], gg[]" % (N,l)
    print "	ldrsh	r4, [r3], #2	// list entry"
    print "	cmp	r4, #-1		// end of this list?"
    print "	beq	T%dx%d_exp_adds	// only if -1 end" % (N,l)
    print_ldr("r6", V["-q"], "load -q")
    print_ldr("r7", V["q32"], "load q32inv")
    print "	mov	r10, #32768	// load 2^15"
    print "T%dx%d_exp_red1:" %  (N,l)
    print "	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]"
    print "T%dx%d_exp_red2:			// while loop on r4" % (N,l)
    print "	ldr	r8, [r0, r4, LSL #2]	// ff[r4]"
    print "	ldr	r9, [r1, r4, LSL #2]	// gg[r4]"
    print "	br_16x2	r8, r6, r7, r10, r11, r12"
    print "	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q"
    print "	br_16x2	r9, r6, r7, r10, r11, r12"
    print "	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q"
    #
    print "	add	r4, #1"
    print "	cmp	r4, r5		// r4 > r5?"
    print "	bls	T%dx%d_exp_red2	// loop (r4)" % (N,l)
    print "	ldrsh	r4, [r3], #2	// re-load list entry"
    print "	cmp	r4, #-1		// re-check, end of list?"
    print "	bne	T%dx%d_exp_red1" % (N,l)
    print "T%dx%d_exp_adds:" % (N,l)
    print "/*"
    print "  for (j=0; j<N1/2/W; j+=N0/2/W) {" 
    print "    for (k=0; k<N0/2/W; k++) {" 
    print "     ff[j+k+N1/W]=__SADD16(ff[2*j+k],ff[2*j+k+N0/2/W]);"
    print "     gg[j+k+N1/W]=__SADD16(gg[2*j+k],gg[2*j+k+N0/2/W]);"
    print "    }"
    print "*/"
    print "	ldrsh	r4, [r3], #2		// load N1/W/2"
    print "	add	r5, r0, r4, LSL #3	// r5 = ff + N1/W"
    print "	add	r6, r1, r4, LSL #3	// r6 = gg + N1/W"
    print "	add	r0, r0, r2		// r0 = ff + N0/2/W"
    print "	add	r1, r1, r2		// r1 = gg + N0/2/W"
    print "	rsb	r2, r2, #0			// r2 = -N0"
    print "T%dx%d_exp_adds1:" % (N,l)
    print "	ldr	r8, [r0, r2]"
    print "	ldr	r10, [r0], #4"
    print "	ldr	r9, [r0, r2]"
    print "	ldr	r11, [r0], #4"
    print "	sadd16	r8, r8, r10"
    print "	sadd16	r9, r9, r11"
    print "	strd	r8, r9, [r5], #8"
    print "	ldr	r8, [r1, r2]"
    print "	ldr	r10, [r1], #4"
    print "	ldr	r9, [r1, r2]"
    print "	ldr	r11, [r1], #4"
    print "	sadd16	r8, r8, r10"
    print "	sadd16	r9, r9, r11"
    print "	strd	r8, r9, [r6], #8"
    print "	subs	r4, r4, #2"
    print "	beq	T%dx%d_exp_end" % (N,l)
    print "	bics	r7, r4, r2, ASR #2"
    #print "	bne	T%dx%d_exp_adds1" % (N,l)
    #print "	sub	r0, r0, r2"
    #print "	sub	r1, r1, r2"
    print "	itt	eq"
    print "	subeq	r0, r0, r2"
    print "	subeq	r1, r1, r2"
    print "	b	T%dx%d_exp_adds1" % (N,l)
    print "T%dx%d_exp_end:" % (N,l)
    print "	rsb	r2, r2, #0"
    print "	mov	r0, sp		// reload ff"
    print_ldr("r1",V["gg"], "reload gg")
    print
    print "	lsr	r2, #1 		// N0 /= 2"
    print "	b	T%dx%d_exp_loop1	// loop" %(N,l)
    print "T%dx%d_exp_end1:" % (N,l)
    print
    print "T%dx%d_mul:" % (N,l)
    size1 = size0
    N1 = (2*l-1)*KA_terms(N,B)
    size_mark = [0 for i in range(N1/W+1)]
    #
    print "  // check multiplicative overflow (pre-mult size > q_mb=%d)" % q_mb 
    for j in range(0,N1,B) :
        for i in range(B/W) :
            if (size0[j/W + i] > q_mb) :
                size0[j/W + i] = adj_size(size0[j/W])
                size1[j/W + i] = adj_size(size1[j/W])
                size_mark[j/W + i] = 1
    aux.write("T_mul_ov_%d:\n" % N)
    size_mark_empty = 1
    for j in range(N1/W) :
        if (size_mark[j] == 1) :  
            size_mark_empty = 0
            if (size_mark[j-1] == 0) :
                aux.write("	.hword	%d," % j)
            if (size_mark[j+1] == 0) :
                aux.write(" %d\n" % j)
    if (size_mark_empty == 1) :
        print "		// no multiplicative overflow"
        aux.write("	// no multiplicative overflow\n")
    else :
        aux.write("	.hword	-1\n")
        # r3 points to T_mul_ov_N at this point, and r0, r1 are ff, gg
        print "T%dx%d_mul_ov:" %  (N,l) 
        print "	ldrsh	r2, [r3], #2"	  
        print "	cmp	r2, #-1		// multiplicative overflow?"
        print "	beq	T%dx%d_muls" %  (N,l)
        print "	mov	r8, #32768"
        print_ldr("r6",V["-q"],"load -q")
        print_ldr("r7",V["q32"],"load round(2^32/q)")
        print "T%dx%d_mul_ov1:" %  (N,l) 
        print "	ldrsh	r11, [r3], #2"
        print "T%dx%d_mul_ov2:" %  (N,l) 
        print "	ldr	r4, [r0, r2, LSL #2]"
        print "	ldr	r5, [r1, r2, LSL #2]"
        print "	br_16x2	r4, r6, r7, r8, r9, r10"
        print "	br_16x2 r5, r6, r7, r8, r9, r10"
        print "	str	r4, [r0, r2, LSL #2]"
        print "	str	r5, [r1, r2, LSL #2]"
        print "	add	r2, r2, #1"
        print "	cmp	r2, r11"
        print "	bls	T%dx%d_mul_ov2" %  (N,l)
        print "	ldrsh	r2, [r3], #2"
        print "	cmp	r2, -1"
        print "	bne	T%dx%d_mul_ov1" %  (N,l)
    aux.write("	.hword	%d	// #TERMS(%d,%d)/4\n" % (N1/B,N,B)) 
    print "T%dx%d_muls:" %  (N,l)
    print "	ldrsh	r14, [r3], #2	// r14 = N1/B"
    print_str("r3",V["ov"],"save overflow list pointer")
    print_ldr("r2",V["hh"],"load r2 = hh")
    print "T%dx%d_muls1:" %  (N,l)
    if (B==4) : # I will write other cases later
        print '''	// begin polymul_4x4_divR
	ldr	r3, [r0, #2]		// r3 = f12
	ldr	r5, [r0, #4]
	ldr	r4, [r0], #8  		// r4 = f01, f5 = f23
	ldr	r7, [r1, #4]
	ldr	r6, [r1], #8  		// r6 = g01, r7 = g23
	smulbb	r8, r4, r6		// r8 = f0 g0 = h0 (32bit)
	smuadx	r9, r4, r6		// r9 = f0 g1 + f1 g0 = h1 (32bit)
	smulbb	r10, r4, r7		// r10 = f0 g2
	smuadx	r11, r4, r7		// r11 = f0 g3 + f1 g2
	smultt	r12, r5, r6		// r12 = f3 g1
	smultt	r4, r5, r7		// r4 = f3 g3 = h6 (32bit)
	smladx  r10, r3, r6, r10	// r10 += f1 g1 + f2 g0 = h2 (32bit)
	smladx  r12, r3, r7, r12	// r12 += f1 g3 + f2 g2 = h4 (32bit)
	smladx  r11, r5, r6, r11	// r11 += f2 g1 + f3 g0 = h3 (32bit)
	smuadx	r3, r5, r7		// r3 = f2 g3 + f3 g2 = h5 (32bit)'''
        print_ldr("r5",V["qi"],"r5 = q^{-1} mod 2^16")
        print_ldr("r6",V["-q"],"r6 = -q")
        #print "	movw	r6, #%d		// r6 = q" % (q)
        #
        print '''	mr_16x2	r12, r3, r6, r5, r7
	mr_hi	r4, r6, r5, r7             
	lsr	r4, #16
	mr_16x2	r8, r9, r6, r5, r7
	mr_16x2	r10, r11, r6, r5, r7
        str	r10, [r2, #4]
	str	r12, [r2, #8]
	str	r4, [r2, #12]
	str	r8, [r2], #16
	// end polymul_4x4_divR '''
    #elif (B==8) :
    #    print '''	// begin polymul_8x8_divR
    #    ldr	r5, [r0, #4]		// f23
    #    ldr	r6, [r0, #8]		// f45
    #    ldr	r7, [r0, #12]		// f67
    #    ldr	r4, [r0],#16		// f01
    #    ldr	r9, [r1, #4]		// g23
    #    ldr	r10, [r1, #8]		// g45
    #    ldr	r11, [r1, #12]		// g67
    #    ldr	r8, [r1],#16		// g01'''
    #    print_str("r14",V["0"],"scr0=count")
    #    print "	smulbb	r12, r4, r8"
    #    print "	smuadx	r14, r4, r8"
    #    print_str("r12",V["1"],"scr1=h0")
    #    print_str("r14",V["2"],"scr2=h1")
    #    print "	smuadx	r12, r4, r9"
    #    print "	smladx	r12, r5, r8, r12"
    #    print "	smuadx	r14, r4, r10"
    #    print "	smladx	r14, r5, r9, r14"
    #    print "	smladx	r14, r6, r8, r14"
    #    print_str("r12",V["3"],"scr3=h3")
    #    print_str("r14",V["4"],"scr4=h5")
    #    print "	smuadx	r12, r4, r11"
    #    print "	smladx	r12, r5, r10, r12"
    #    print "	smladx	r12, r6, r9, r12"
    #    print "	smladx	r12, r7, r8, r12"
    #    print "	smuadx	r14, r5, r11"
    #    print "	smladx	r14, r6, r10, r14"
    #    print "	smladx	r14, r7, r9, r14"
    #    print_str("r12",V["5"],"scr5=h7")
    #    print_str("r14",V["6"],"scr6=h9")
    #    print "	smuadx	r12, r6, r11"
    #    print "	smladx	r12, r7, r10, r12"
    #    print "	smuadx	r14, r7, r11"
    #    print_str("r12",V["7"],"scr7=h11")
    #    print_str("r14",V["8"],"scr8=h13")
    #    print "	pkhtb	r3, r4, r5		// f21"
    #    print "	pkhtb	r5, r5, r6		// f43"
    #    print "	pkhtb	r6, r6, r7		// f65"
    #    print "	smultt	r12, r7, r11		// f7 g7"
    #    print "	smultt	r14, r7, r10		// f7 g5"
    #    print "	smlad	r14, r6, r11, r14"
    #    print_str("r12",V["9"],"scr9=h14")
    #    print_str("r14",V["10"],"scr10=h12")
    #    print "	smultt	r12, r7, r9		// f7 g3"
    #    print "	smlad	r12, r6, r10, r12"
    #    print "	smlad	r12, r5, r11, r12"
    #    print "	smultt	r14, r7, r8"
    #    print "	smlad	r14, r6, r9, r14"
    #    print "	smlad	r14, r5, r10, r14"
    #    print "	smlad	r14, r3, r11, r14"
    #    print_str("r12",V["11"],"scr11=h10")
    #    print_str("r14",V["12"],"scr12=h8, r7 now used up")
    #    print "	smulbb	r7, r4, r9"
    #    print "	smlad	r7, r3, r8, r7		// h2"
    #    print "	smulbb	r12, r4, r10"
    #    print "	smlad	r12, r3, r9, r12"
    #    print "	smlad	r12, r5, r8, r12	// h4"
    #    print "	smulbb	r14, r4, r11"
    #    print "	smlad	r14, r3, r10, r14"
    #    print "	smlad	r14, r5, r9, r14"
    #    print "	smlad	r14, r6, r8, r14	// h6" 
    #    print "	movw	r3, #%d" %(65536-qinv)
    #    print "	movw	r4, #%d" %(q)
    #    print_ldr("r8", V["3"],"h3=scr3")
    #    print_ldr("r9", V["4"],"h5=scr4")
    #    print_ldr("r10", V["5"],"h7=scr5")
    #    print "	mr_16x2	r7, r8, r4, r3, r11	// h23"
    #    print "	mr_16x2	r12, r9, r4, r3, r11	// h45"
    #    print "	mr_16x2 r14, r10, r4, r3, r11	// h67"
    #    print_ldr("r8", V["12"],"h8=scr12")
    #    print_ldr("r9", V["6"],"h9=scr6")
    #    print "	mr_16x2	r8, r9, r4, r3, r11	// h89"
    #    print_ldr("r10",V["11"],"h10=scr11")
    #    print_ldr("r9",V["7"],"h11=scr7")
    #    print "	mr_16x2	r10, r9, r4, r3, r11	// h10,11"
    #    print "	str	r7, [r2, #4]"
    #    print "	str	r12, [r2, #8]"
    #    print "	str	r14, [r2, #12]"
    #    print "	str	r8, [r2, #16]"
    #    print "	str	r10, [r2, #20]"
    #    print_ldr("r12",V["10"],"h12=scr10")
    #    print_ldr("r10",V["8"],"h13=scr8")
    #    print_ldr("r14",V["9"],"h14=scr9")
    #    print_ldr("r7",V["1"],"h0=scr1")
    #    print_ldr("r8",V["2"],"h1=scr2")
    #    print "	mr_16x2	r7, r8, r4, r3, r11"
    #    print "	mr_16x2	r12, r10, r4, r3, r11"
    #    print "	mr_hi	r14, r4, r3, r11"
    #    print "	lsr	r14, #16"
    #    print "	str	r12, [r2, #24]"
    #    print "	str	r14, [r2, #28]"
    #    print "	str	r7, [r2], #32"
    #    print_ldr("r14",V["0"],"counter=scr0")
    #	print "// end polymul_8x8_divR"
    elif (B==8 or B==16 or B==32) :

        from polymul_NxN_sch_i import SCH_polymulNxN
        if (MONT_OR_BAR == 0) : s = V["qi"]
        else : s = V["q32"]
        print_str("r14",V["0"],"save counter to scr0")
        SCH_polymulNxN(B,"r0","r1","r2",V["-q"],s)
        print_ldr("r14",V["0"],"counter=scr0")
    print "	subs	r14, #1"
    print "	bne	T%dx%d_muls1" %  (N,l)
    #
    size_value = 0 ; size_last = 0
    for j in range(0,N1,B) :
        t0 = max([size0[j/W+i] for i in range(B/W)])
        t1 = max([size1[j/W+i] for i in range(B/W)])
        for i in range (B/W) :
            size2[2*j/W+i] = mult_size_x(t0,t1,(i+1)*W)
            size2[(2*j+B)/W+i] = mult_size_x(t0,t1,B-1-i*W)
            if (size2[2*j/W+i] > size_value) :
                size_value=size2[2*j/W+i]
                size_last = 2*j/W+i
            if (size2[(2*j+B)/W+i] > size_value) :
                size_value=size2[(2*j+B)/W+i]
                size_last = (2*j+B)/W+i
    aux.write("\t// max size = %d @ %d\n" % (size_value,size_last))
    # now hh = r2, everything else is disposable
    print "T%dx%d_collect:" %  (N,l)
    aux.write("T_col_%d_ov:\n" % N)
    print_ldr("r2",V["hh"],"reload hh")
    print_ldr("r3",V["ov"],"reload overflow list") # probably in each loop?
    N0 = B
    while (N0 < N) :
        N1 = (2*l-1)*KA_terms(N,2*N0)
        N2 = (2*l-1)*KA_terms(N,N0)
        size_mark = [0 for i in range(N2/W*2+2)]
        size_mark_empty = 1
        for j in range(0,N1,2*N0) :
            # check additive overflow
            # if a 4-sum is greater than 32768, adjust everything >8191
            for i in range(0,N0,W) :
                if (size2[(2*j+N0+i)/W]+size2[(2*j+2*N0+i)/W]+size2[(2*j+i)/W] + size2[(2*N1+j+i)/W]>= 32768 or size2[(2*j+N0+i)/W]+size2[(2*j+2*N0+i)/W]+size2[(2*j+3*N0+i)/W] + size2[(2*N1+N0+j+i)/W]>= 32768) :
                    if (size2[(2*j+i)/W] > 8191) :
                        size2[(2*j+i)/W] = adj_size(size2[(2*j+i)/W])
                        size_mark[(2*j+i)/W]=1
                    if (size2[(2*j+N0+i)/W] > 8191) :
                        size2[(2*j+N0+i)/W] = adj_size(size2[(2*j+N0+i)/W])
                        size_mark[(2*j+N0+i)/W]=1
                    if (size2[(2*j+2*N0+i)/W] > 8191) :
                        size2[(2*j+2*N0+i)/W] = adj_size(size2[(2*j+2*N0+i)/W])
                        size_mark[(2*j+2*N0+i)/W]=1
                    if (size2[(2*j+3*N0+i)/W] > 8191) :
                        size2[(2*j+3*N0+i)/W] = adj_size(size2[(2*j+3*N0+i)/W])
                        size_mark[(2*j+3*N0+i)/W]=1
                    if (size2[(2*N1+j+i)/W] > 8191) :
                        size2[(2*N1+j+i)/W] = adj_size(size2[(2*N1+j+i)/W])
                        size_mark[(j+2*N1+i)/W]=1
                    if (size2[(2*N1+N0+j+i)/W] > 8191) :
                        size2[(2*N1+N0+j+i)/W] =adj_size(size2[(2*N1+N0+j+i)/W])
                        size_mark[(j+2*N1+N0+i)/W]=1
                    size_mark_empty = 0                    
        aux.write("T_col_ov_%d_%d:\n" % (N,N0))
        if (size_mark_empty == 0) :
            size_marks_loc_last = 0
            size_marks_list = []
            size_marks_list_last = []
            for i in range(2*N0/W) :
                if (size_mark[i]==1 and size_mark[i-1]==0) :
                    size_marks_list_last.append(i)
                if (size_mark[i]==1 and size_mark[i+1]==0) :
                    size_marks_list_last.append(i)
            for j in range(2*N0/W,(2*l-1)*KA_terms(N,N0)/W*2,2*N0/W) :
                size_marks_list_this = []
                for i in range(2*N0/W) :
                    if (size_mark[i+j]==1 and size_mark[i+j-1]==0) :
                        size_marks_list_this.append(i) 
                    if (size_mark[i+j]==1 and size_mark[i+j+1]==0) :
                        size_marks_list_this.append(i) 
                if (size_marks_list_this != size_marks_list_last) :
                    size_marks_list.append([size_marks_loc_last,j,size_marks_list_last])
                    size_marks_list_last = size_marks_list_this
                    size_marks_loc_last = j
                    if not is_even(len(size_marks_list_this)) :
                        print "//",j,size_marks_list_this[0],size_marks_list_this[1],str(size_marks_list_this[2]),str(size_mark[j:j+N0]),"\n"
            size_marks_list.append([size_marks_loc_last,j,size_marks_list_last])
            aux.write("// overflow ranges:")
            for a in size_marks_list :
                aux.write(" %d-%d:" % (a[0],a[1]))
                for i in range(0,len(a[2]),2) :
                    aux.write(" %d-%d " % (a[2][i],a[2][i+1]))
                aux.write(" mod %d" % (2*N0/W))
            aux.write("\n")
            a2_last = 0;
            for a in size_marks_list :
                aux.write("	.hword %d, %d" % (a[1],len(a[2])))
                if (len(a[2])>0) :
                    aux.write(", %d" % (a[2][0]-a2_last)) # offset
                    for i in range(0,len(a[2])-2,2) :
		        aux.write(", %d" % (a[2][i+1]-a[2][i]+1)) # interval length
                        aux.write(", %d" % (a[2][i+2]-a[2][i+1]-1)) # skip
		    aux.write(", %d" % (a[2][-1]-a[2][-2]+1)) # interval length
                    aux.write(", %d\n" % (2*N0/W+a[2][0]-a[2][-1]-1)) # skip
                    a2_last = a[2][0];
                else :
                    aux.write(", %d\n" % (-a2_last))
                    a2_last = 0;
            aux.write("	.hword	-1\n")
        #if (T==768 and (N0==8 or N0==16)):
        #    aux.write("	/* tailored overflow check\n") 
	# if (size_mark_empty == 0) :
        #     for j in range((2*l-1)*KA_terms(N,N0)/W*2) :
        #         if (size_mark[j] == 1) :
        #             if (size_mark[j-1] == 0) :
        #                 aux.write("	.hword	%d, " % j)
        #             if (size_mark[j+1] == 0) :
        #                 if (size_mark[j+2] == 1) :
        #                     size_mark[j+1] = 1
        #                 else :
        #                     aux.write("%d\n" % j)
        #     aux.write("	.hword	-1\n")
        else : aux.write("	// no overflow\n")
        #if (T==768 and (N0==8 or N0==16)):
        #    aux.write("	skipped overflow list */\n") 
        aux.write("T_col_add_%d_%d:\n" % (N,N0))
        aux.write("	.hword	%d	// =#shift/8, #iterations*4\n" % (N1/W))
        for j in range(0,N1,2*N0) :
            # KA sequence of collection
            for i in range(0,N0,W) :
                sizet[i/W] = size2[(2*j+N0+i)/W]+size2[(2*j+2*N0+i)/W]
            for i in range(0,N0,W) :
                sizet[(N0+i)/W] = sizet[i/W] + size2[(2*j+3*N0+i)/W]
            for i in range(0,N0,W) :
                sizet[i/W] = sizet[i/W] + size2[(2*j+i)/W]
            for i in range(0,N0,W) :
                size2[(2*j+2*N0+i)/W] = sizet[(N0+i)/W] + size2[(j+2*N1+N0+i)/W]
            for i in range(0,N0,W) :
                size2[(2*j+N0+i)/W] = sizet[i/W] + size2[(2*N1+j+i)/W]
        if (size_mark_empty == 1) :
            print "T%dx%d_col_%d_ov:			// no overflow"%(N,l,N0)
        else :
            # checking for overflows
            print "T%dx%d_col_%d_ov:" %  (N,l,N0)
            #print_ldr("r3",V["ov"],"reload overflow list")
            print_ldr("r0",V["-q"],"load -q")
            print_ldr("r1",V["q32"],"load qinv32")
            print "	mov	r6, #32768"
            print "	mov	r12, 0	// pointer to data"	     
            print "T%dx%d_col_%d_ov1:" %  (N,l,N0)
            print "	ldrsh	r4, [r3], #2	// bound"
            print "	cmp	r4, #-1"
            print "	beq	T%dx%d_col_%d_add" %  (N,l,N0)
            #print "T%dx%d_col_%d_ov0:" %  (N,l,N0)
            print "	ldrsh	r11, [r3], #2	// r11 : count of a[2] entries"
            print "	ldrsh	r5, [r3], #2	// offset"
            print "	add	r12, r12, r5"
            print "	cmp	r11, #0"
            print "	bne	T%dx%d_col_%d_ov2" %  (N,l,N0)
            print "	mov	r12, r4		// empty set of intervals"
            print "	b	T%dx%d_col_%d_ov1" %  (N,l,N0)
            print "T%dx%d_col_%d_ov2:" %  (N,l,N0)
            print "	asr	r5, r11, #1	// r5 : number of intervals"
            print "T%dx%d_col_%d_ov3:" %  (N,l,N0)
            print "	ldrsh	r10, [r3], #2	// size of interval"
            print "T%dx%d_col_%d_ov4:" %  (N,l,N0)
            print "	ldr	r8, [r2, r12, LSL #2]"
            print "	br_16x2	r8, r0, r1, r6, r7, r9"
            print "	str	r8, [r2, r12, LSL #2]"
            print "	add	r12, r12, #1"
            print "	subs	r10, r10, #1"
            print "	bgt	T%dx%d_col_%d_ov4" %  (N,l,N0)
            print "	ldrsh	r10, [r3], #2	// offset"
            print "	add	r12, r12, r10"
            print "	subs	r5, r5, #1	// last interval?"
            print "	bgt	T%dx%d_col_%d_ov3" %  (N,l,N0)
            print "	cmp	r12, r4		// am I above the bound?"
            print "	bge	T%dx%d_col_%d_ov1" %  (N,l,N0)
            print "	sub	r3, r3, r11, LSL #1	// roll back"
            print "	b	T%dx%d_col_%d_ov2" %  (N,l,N0)
        # hh has not left r2, ov has not left r3
        print "T%dx%d_col_%d_add:			// KA collection" %  (N,l,N0)
        print "	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4"
        #print_str("r3",V["ov"],"save overflow list")
        print "	add	r12, r2, r14, LSL #3	// other pointer"
        print "	mov	r1, r2		// copy of hh"
        if (N0 == 4) :
            print "T%dx%d_col_%d_add1:	// beginning of KA collect" %  (N,l,N0)
	    print "	ldrd	r4, r5, [r1, #%d]" % (N0*2)
            print "	ldrd	r6, r7, [r1, #%d]" % (N0*4)
            print "	ssub16	r4, r4, r6"
            print "	ssub16	r5, r5, r7"
            print "	ldrd	r6, r7, [r1, #%d]" % (N0*6)
            print "	sadd16	r8, r4, r6"
            print "	sadd16	r9, r5, r7"
            print "	ldrd	r6, r7, [r1], #%d" % (N0*4)
            print "	ssub16	r4, r4, r6"
            print "	ssub16	r5, r5, r7"
            print "	ldrd	r6, r7, [r12, #%d]" % (N0*2)
            print "	ssub16	r8, r6, r8"
            print "	ssub16	r9, r7, r9"
            print "	strd	r8, r9, [r1], #%d" % (-N0*2)
            print "	ldrd	r6, r7, [r12], #%d	// shift r12" % (N0*4)
            print "	sadd16	r4, r4, r6"
            print "	sadd16	r5, r5, r7"
            print "	strd	r4, r5, [r1], #%d" % (N0*6)
            print "	subs	r14, #4"
            print "	bne	T%dx%d_col_%d_add1" %  (N,l,N0)
        elif (N0 < 64) :
            print "T%dx%d_col_%d_add1:	// begin KA collect loop" %  (N,l,N0)
	    print "	ldrd	r4, r5, [r1, #%d]" % (N0*2)
            print "	ldrd	r6, r7, [r1, #%d]" % (N0*4)
            print "	ssub16	r4, r4, r6"
            print "	ssub16	r5, r5, r7"
            print "	ldrd	r6, r7, [r1, #%d]" % (N0*6)
            print "	sadd16	r8, r4, r6"
            print "	sadd16	r9, r5, r7"
            print "	ldrd	r6, r7, [r1]"
            print "	ssub16	r4, r4, r6"
            print "	ssub16	r5, r5, r7"
            print "	ldrd	r6, r7, [r12, #%d]" % (N0*2)
            print "	ssub16	r8, r6, r8"
            print "	ssub16	r9, r7, r9"
            print "	strd	r8, r9, [r1, #%d]" % (N0*4)
            print "	ldrd	r6, r7, [r12], #8	// shift r12 up 8"
            print "	sadd16	r4, r4, r6"
            print "	sadd16	r5, r5, r7"
            print "	strd	r4, r5, [r1, #%d]" % (N0*2)
            print "	add	r1, r1, #8		// shift r1 up 8"
            print "	subs	r14, r14, #4"
            print "	beq	T%dx%d_col_%d_end" %  (N,l,N0)
            print "	tst	r14, #%d	// set bit < %d?" % (N0-1,N0)
            #print "	bne	T%dx%d_col_%d_add1" %  (N,l,N0)
            #print "	add	r1, r1, #%d" % (N0*6)
            #print "	add	r12, r12, #%d" % (N0*2)
            print "	itt	eq		// then next %d bloc" % (N0/W)
            print "	addeq	r1, r1, #%d" % (N0*6)
            print "	addeq	r12, r12, #%d" % (N0*2)
            print "	b	T%dx%d_col_%d_add1" %  (N,l,N0)
        else : # N0 >= 64
            print "	mov	r0, #%d			// 2*N0" % (N0*2)
            print "	add	r11, r0, r0, LSL #1	// 6*N0"
            print "T%dx%d_col_%d_add1:	// begin KA collect loop" %  (N,l,N0)
	    print "	ldr	r4, [r1, r0]		//+2*N0"
            print "	ldr	r6, [r1, r0, LSL #1]	//+4*N0"
            print "	ssub16	r4, r4, r6"
            print "	ldr	r6, [r1, r11]		//+6*N0" 
            print "	sadd16	r8, r4, r6"
            print "	ldr	r6, [r1]"
            print "	ssub16	r4, r4, r6"
            print "	ldr	r6, [r12, r0]		//+2*N0"
            print "	ssub16	r8, r6, r8"
            print "	str	r8, [r1, r0, LSL #1] 	//+4*N0"
            print "	ldr	r6, [r12], #4		// shift r12 up 4"
            print "	sadd16	r4, r4, r6"
            print "	str	r4, [r1, r0]		//+2*N0"
            print "	add	r1, r1, #4		// shift r1 up 4"
	    print "	subs	r14, r14, #2"
            print "	beq	T%dx%d_col_%d_end" %  (N,l,N0)
            print "	tst	r14, #%d	// set bit < %d?" % (N0-1,N0)
            print "	itt	eq"
            print "	addeq	r1, r1, r11		//+6*N0"
            print "	addeq	r12, r12, r0		//+2*N0"
            print "	b	T%dx%d_col_%d_add1" %  (N,l,N0)
        print "T%dx%d_col_%d_end:"   %  (N,l,N0)     
        #
        N0 *= 2
    aux.write("T%d_Mat2:\n" % l)
    for j in range(1, 2*l-2) :
        aux.write("	.hword	")
        for k in range(2*l-2) :
            mult = cmod(MAT2[j][k],q)
            aux.write("%d, " % (mult))
        mult = cmod(MAT2[j][2*l-2],q)
        aux.write("%d\n" % (mult))

    print "T%dx%d_mv_back:" % (N,l)
    print_ldr("r0",V["h"],"reload h")
    print_ldr("r1",V["hh"],"reload hh")
    if (N>8) :
        print "	mov	r14, #%d" % (4*N)
    print "T%dx%d_mv_back_loop:" % (N,l)
    print "	ldm	r1!, {r4-r11}"
    print "	stm	r0!, {r4-r11}"
    if (N>8) :
        print "	subs	r14, #32"
        print "	bne	T%dx%d_mv_back_loop" % (N,l)
    #
    print "	mov	r14, #%d" % ((2*l-4)*2*N)
    for j in range(4,12) :
        print "	mov	r%d, #0" % (j)
    print "T%dx%d_clear_loop:" % (N,l)
    print "	stm	r0!, {r4-r11}"
    print "	subs	r14, #32"
    print "	bne	T%dx%d_clear_loop" % (N,l)
    #
    #print "	add	r1, #%d" % ((2*l-3)*2*N)
    if (N>8) :
        print "	mov	r14, #%d" % (4*N)
    print "T%dx%d_mv_back_loop1:" % (N,l)
    print "	ldm	r1!, {r4-r11}"
    print "	stm	r0!, {r4-r11}"
    if (N>8) :
        print "	subs	r14, #32"
        print "	bne	T%dx%d_mv_back_loop1" % (N,l)
    #
    print "T%dx%d_gather:" % (N,l)
    print_ldr("r0",V["h"],"reload h")
    print_ldr("r1",V["hh"],"reload hh")
    print "	add	r0, #%d" % (2*N)
    print "	mov	r12, #%d" % (4*N)
    print_ldr("r11",V["q32"],"load round(2^32/q)")
    print_ldr("r7",V["-q"],"load -q")
    print "T%dx%d_gather1:	// load X array" % (N,l)
    print_ldr("r9",V["X"],"pointer to X array")
    print "	mov	r14, #0"
    print "T%dx%d_gather2:" % (N,l)
    print "	ldr	r8, [r1, r14]	// load next of set"
    print "	str	r8, [r9], #4	// save to temp X array, point"
    print "	add	r14, r14, #%d	// add 4N size of set" % (4*N)
    print "	cmp	r14, #%d	// (2l-1)*4N" % ((2*l-1)*4*N)
    print "	bne	T%dx%d_gather2" % (N,l)
    print_ldr("r9",V["X"],"X array, loaded with a set")
    print_ldr("r10",V["M2"],"load T%d matrix 2" % (l))
    print "	mov	r2, #0		// counter j"
    print "T%dx%d_gather3:" % (N,l)
    print "	ldr	r6, [r0, r2]"
    print "	sxth	r4, r6"
    print "	asr	r5, r6, #16"
    print "	mov	r3, #0		// counter k"
    print "T%dx%d_gather4:" % (N,l)
    print "	ldrsh	r14, [r10], #2	// MAT1[j][k]"
    print "	ldr	r8, [r9, r3, LSL #2]	// X[k]"
    print "	smlabb	r4, r14, r8, r4"	
    print "	smlabt	r5, r14, r8, r5"
    print "	add	r3, #1"
    print "	cmp	r3, #%d" % (2*l-1)
    print "	bcc	T%dx%d_gather4" % (N,l)
    print "	br_32	r4, r7, r11, r6"
    print "	br_32	r5, r7, r11, r6"
    print "	pkhbt	r4, r4, r5, LSL #16"
    print "	str	r4, [r0, r2]"
    print "	add	r2, r2, #%d" % (2*N)
    print "	cmp	r2, #%d" % ((2*l-3)*2*N)
    print "	bne	T%dx%d_gather3" % (N,l)
    print "	add	r0, #4		// incr src"
    print "	add	r1, #4		// incr dst"
    print "	subs	r12, #4		// decr counter"
    print "	bne	T%dx%d_gather1" % (N,l)
    #
    aux.write("\n")
    print "T%dx%d_end:" % (N,l)
    print_ldr("r12",V["2M"],"load 2M")
    print "	add	sp, sp, r12, LSL #2	// add back %d = 8M" % (8*M) 
    print "	add	sp, sp, #%d		// temp space 8*l" % (16*l)
    if (NV>16) :
        print "	vpop	{s16-s31}"
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"
    print ""
    #
    aux.close()
    
T_prologue()
TT = 768
LL = 6
if (len(sys.argv)==3) :
#TT = 640
#LL = 5
    TT = int(sys.argv[1])
    LL = int(sys.argv[2])
T_polymulNxN(TT,LL)

