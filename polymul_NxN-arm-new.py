#!/usr/bin/python
import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
ARGS = sys.argv
SAVES = 0

def alloc_save (S) : # allocate variable name s_S as a space
    global SAVES
    globals()["s_"+S] = "s" + str(SAVES)
    SAVES +=1

    
# NARGS = len(ARGS)
# if (NARGS == 1) :
#     aux = open("polymul_NxN_aux.h","w+")
    
# adjust
# def adj_size (size) :
#     if (size < q_ab) :  # 2341 is q-dependent
#         return(size)
#     else :
#         i = ceil ((floor(size * q16 / 2.0**16 + 0.5) - 0.5) * 2.0**16 / q16) - 1
#         return(i - q * floor(i * q16 / 2.0**16 +0.5))

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

def adj_stmt () :
    return("  br_16x2	%s")	# adjust W=2 shorts

# may change to using vmov later
def print_ldr (reg, loc, comment) :
    #print("	ldr	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s  // %s" % (reg, loc, comment))

def print_str (reg, loc, comment) :
    #print("	str	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s	// %s" % (loc, reg, comment))

# may change to vfp registers later.
# s_h = "[sp,#-4]";	s_2M = "[sp,#-8]";	s_gg = "[sp,#-12]";
# s_hh = "[sp,#-16]";	s_ov = "[sp,#-20]";	s_q = "[sp,#-24]";
# s_qi = "[sp, #-28]";	s_q32 = "[sp,#-32]";	s_mq = "[sp,#-36]";
#s_h = "s0";	s_2M = "s1";	s_gg = "s2";
#s_hh = "s3";	s_ov = "s4";	s_q = "s5";
#s_qi = "s6";	s_q32 = "s7";	s_mq = "s8";
alloc_save("h")  # h, output
alloc_save("2M") # 2M, M = KA_terms(N,N0)*l
alloc_save("gg") # gg, second input array, expanded, 2M in size, = sp + 2M
alloc_save("hh") # hh, output array, expanded, 4M in size
alloc_save("ov") # overflow list address"
alloc_save("q")  # modulus q = 4591
alloc_save("qi") # q^{-1} mod 2^16
alloc_save("q32")# round(2^32/q)
alloc_save("mq") # -q, I am stupid

def KA_terms (N,N0) :
    assert (isinstance(N,int) and (N==1<<int(log(N,2)+0.5)) and (N>=B))
    M = N ;
    while N > N0 :
        M += M/2
        N = N/2
    return M


B = 4 # base case
W = 2 # width of vectors
q_mb = int(sqrt((32767-2295)*2**16/B)) # multiplicative bound
N_range = 256
M_range = KA_terms(N_range,B)
size0 = [0 for i in range(M_range/W)] 
size2 = [0 for i in range(M_range/W*2)]
sizet = [0 for i in range(N_range/W*2)]

def KA_prologue () :
    # if (NARGS == 1) :
    #     print '#include "polymul_NxN_aux.h"'
    #     print "	.p2align	2,,3"
    #     print "	.syntax		unified"
    #     print "	.text"
    #
    print '#include "red-asm.h"'

def KA_polymulNxN (N) :
    # KA_head
    print("// N=%d requires %d=8x%d storage\n" % (N,8*KA_terms(N,B),KA_terms(N,B)))
    # if (NARGS > 1) :
    aux = open("polymul_%dx%d.h" % (N,N), "w+")
    aux.write("extern void gf_polymul_%dx%d_divR (int32_t *h, int32_t *f, int32_t *g);\n")
    aux.close();
    aux = open("polymul_%dx%d_aux.h" % (N,N),"w+")
    aux.write("	.p2align	2,,3\n")
    aux.write("	.syntax		unified\n")
    aux.write("	.text\n\n")
    print '#include "polymul_%dx%d_aux.h"' % (N,N)
    print "	.p2align	2,,3	"
    print "	.syntax		unified"
    print "	.text"
    #
    print "// void gf_polymul_%dx%d_divR (int32_t *h, int32_t *f, int32_t *g);" % (N,N)
    print "	.global gf_polymul_%dx%d_divR" % (N,N)
    print "	.type	gf_polymul_%dx%d_divR, %%function" % (N,N)
    print "gf_polymul_%dx%d_divR:" % (N,N)
    #
    M = (KA_terms(N,B))
    #
    for i in range (M/W) : size0[i] = 0
    for i in range (M/W*2)  : size2[i] = 0
    for i in range (N/W*2)  : sizet[i] = 0
    print "	push	{r4-r11,lr}"
    print "	//vpush	{s16-s31}"
    print "	ldr	r12, =%d	// r12=2M" % (2*M)
    print "	sub	sp, sp, r12, LSL #2	// subtract %d = 8M" % (8*M) 
    print "		// ff=[sp], gg=[sp,#%d], hh=[sp,#%d]" % (2*M,4*M)
    print_str("r0",s_h,"save h")
    print "	mov	r3, sp"
    print "	add	r0, sp, r12	// gg=ff+%d(=2M)" % (2*M)
    print_str("r12", s_2M, "save 2M")
    print_str("r0", s_gg, "save gg (ff=sp)")
    print "	add	r14, r0, r12	// hh=gg+%d(=2M)" % (2*M)
    print_str("r14", s_hh, "save h")
    # if (NARGS == 1) :
    #     print "	movw	r14, #:lower16:KA_exp_ov_%d" % (N)
    #     print "	movt	r14, #:upper16:KA_exp_ov_%d" % (N)
    # else :
    print "	ldr	r14, =KA_exp_ov_%d" % N
    #
    print_str("r14", s_ov, "save ov pointer")
    print "	movw	r12, #%d" % (q)
    print_str("r12", s_q, "save q")
    print "	movw	r14, #%d" % (65536-qinv)
    print "	movt	r14, #65536-1"
    print_str("r14", s_qi, "save qinv")
    print "	rsb	r12, r12, #0		// -q"
    print_str("r12", s_mq, "save -q")
    print "	movw	r14, #%d" % (q32inv % 65536)
    print "	movt	r14, #%d" % (q32inv // 65536)
    print_str("r14", s_q32, "save q32inv")
    if (N>16) :
        print "	mov	r14, #%d" % (2*N)
    print "KA%d_mv_loop:	// r0 = gg, r1 = f, r2 = g, r3 = ff" % N
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
            print "	bne	KA%d_mv_loop" % N
    #
    print "KA%d_exp:	// ff @ sp, gg @ sp + 2M, 2M @ r12" % N
    print_ldr("r12",s_2M,"reload 2M")
    N0 = N
    for i in range(N/W) :
        size0[i] = 2295 
    #    
    print "	mov	r0, sp		// ff = r0"
    print "	add	r1, r0, r12	// gg = r1"
    print "	mov	r2, #%d		// N0 = r2 = N" % (N)
    aux.write("KA_exp_ov_%d:\n" % N)
    while (B < N0) :
        N1 = KA_terms(N,N0)
        size_mark = [0 for i in range(N1/W+1)]
        for j in range(0,N1,N0) :
            for k in range(0,N0/2,W) :
                # check additive overflow (size 2^15)
                if (size0[(j+k)/W]+size0[(j+k+N0/2)/W] >= 32768) :
                    size0[(j+k)/W] = adj_size(size0[(j+k)/W])
                    size0[(j+k+N0/2)/W] = adj_size(size0[(j+k+N0/2)/W])
                    size_mark[(j+k)/W] = 1
                    size_mark[(j+k+N0/2)/W] = 1
                size0[(N1+j/2+k)/W] = size0[(j+k)/W]+size0[(j+k+N0/2)/W]
        aux.write("KA_exp_ov_%d_%d:\n" % (N,N0))
        for j in range(0,N1/W) :
            if (size_mark[j] == 1) :
            	if (size_mark[j-1] == 0) :
                    aux.write("	.hword	%d\n" % j)
                if (size_mark[j+1] == 0) :
                    aux.write("	.hword	%d\n" % j)
        aux.write("	.hword	-1\n")
        aux.write("KA_exp_add_%d_%d:\n" % (N,N0))
        aux.write("	.hword	%d	// #TERMS(%d,%d)/4\n" % (N1/W/2,N,N0))
        N0 /= 2
        #
    #
    # main assembly routine for KA_exp
    print_ldr("r3", s_ov, "load list to reduce")
    print "KA%d_exp_loop1:		// loop on N0" % N
    print "	cmp	r2, #%d		// while (N0>B)" % (B)
    print "	beq	KA%d_exp_end1" % N
    #
    print "KA%d_exp_reduce:		// reduce ff[], gg[]" % N
    print "	ldrsh	r4, [r3], #2	// list entry"
    print "	cmp	r4, #-1		// end of this list?"
    print "	beq	KA%d_exp_adds	// only if -1 end" % N
    print_ldr("r6", s_mq, "load -q")
    print_ldr("r7", s_q32, "load q32inv")
    print "	mov	r10, #32768	// load 2^15"
    print "KA%d_exp_red1:" % N
    print "	ldrsh	r5, [r3], #2	// reduce ff[r4-r5], gg[r4-r5]"
    print "KA%d_exp_red2:			// while loop on r4" % N
    print "	ldr	r8, [r0, r4, LSL #2]	// ff[r4]"
    print "	ldr	r9, [r1, r4, LSL #2]	// gg[r4]"
    print "	br_16x2	r8, r6, r7, r10, r11, r12"
    print "	str	r8, [r0, r4, LSL #2]	// ff[r4] %= q"
    print "	br_16x2	r9, r6, r7, r10, r11, r12"
    print "	str	r9, [r1, r4, LSL #2]	// gg[r4] %= q"
    #
    print "	add	r4, #1"
    print "	cmp	r4, r5		// r4 > r5?"
    print "	bls	KA%d_exp_red2	// loop (r4)" % N
    print "	ldrsh	r4, [r3], #2	// re-load list entry"
    print "	cmp	r4, #-1		// re-check, end of list?"
    print "	bne	KA%d_exp_red1" % N
    print "KA%d_exp_adds:" % N
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
    print "KA%d_exp_adds1:" % N
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
    print "	beq	KA%d_exp_end" % N
    print "	bics	r7, r4, r2, ASR #2"
    #print "	bne	KA%d_exp_adds1" % N
    #print "	sub	r0, r0, r2"
    #print "	sub	r1, r1, r2"
    print "	itt	eq		// divisible by N0/2/W=%d?" % (N0/2/W)
    print "	subeq	r0, r0, r2	// then add N0!"
    print "	subeq	r1, r1, r2	// then add N0!"
    print "	b	KA%d_exp_adds1" % N
    print "KA%d_exp_end:" % N
    print "	rsb	r2, r2, #0"
    print "	mov	r0, sp		// reload ff"
    print_ldr("r1",s_gg, "reload gg")
    print
    print "	lsr	r2, #1 		// N0 /= 2"
    print "	b	KA%d_exp_loop1	// loop" %(N)
    print "KA%d_exp_end1:" % N
    print
    print "KA%d_mul:" % N
    size1 = size0
    N1 = KA_terms(N,B)
    size_mark = [0 for i in range(N1/W)]
    #
    print "  // check multiplicative overflow (pre-mult size > q_mb=%d)" % q_mb 
    for j in range(0,N1,B) :
        for i in range(B/W) :
            if (size0[j/W + i] > q_mb) :
                size0[j/W + i] = adj_size(size0[j/W])
                size1[j/W + i] = adj_size(size1[j/W])
                size_mark[j/W + i] = 1
    aux.write("KA_mul_ov_%d:\n" % N)
    size_mark_empty = 1
    for j in range(N1/W) :
        if (size_mark[j] == 1) :  
            size_mark_empty = 0
            aux.write("	.hword	%d\n" % j)
    if (size_mark_empty == 1) :
        print "		// no multiplicative overflow"
        aux.write("	// no multiplicative overflow\n")
    else :
        aux.write("	.hword	-1\n")
        # r3 points to KA_mul_ov_N at this point, and r0, r1 are ff, gg
        print_ldr("r6",s_mq,"load -q")
        print_ldr("r7",s_q32,"load round(2^32/q)")
        print "	mov	r8, #32768"
        print "KA%d_mul_ov:" % (N) 
        print "	ldrsh	r2, [r3], #2"	  
        print "	cmp	r2, #-1		// multiplicative overflow?"
        print "	beq	KA%d_muls" % (N)
        print "	ldr	r4, [r0, r2, LSL #2]"
        print "	ldr	r5, [r1, r2, LSL #2]"
        print "	br_16x2	r4, r6, r7, r8, r9, r10"
        print "	str	r4, [r0, r2, LSL #2]"
        print "	br_16x2 r5, r6, r7, r8, r9, r10"
        print "	str	r5, [r0, r2, LSL #2]"
        print "	b	KA%d_mul_ov" % (N)
    aux.write("	.hword	%d	// #TERMS(%d,%d)/4\n" % (N1/B,N,B)) 
    print "KA%d_muls:" % (N)
    print "	ldrsh	r14, [r3], #2	// r14 = N1/B"
    print_str("r3",s_ov,"save overflow list pointer")
    print_ldr("r2",s_hh,"load r2 = hh")
    print "KA%d_muls1:" % (N)
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
    print_ldr("r5",s_qi,"r5 = -q^{-1} mod 2^16")
    print_ldr("r6",s_q,"r6 = q")

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
    print "	subs	r14, #1"
    print "	bne	KA%d_muls1" % (N)
    #
    for j in range(0,N1,B) :
        t0 = max([size0[j/W+i] for i in range(B/W)])
        t1 = max([size1[j/W+i] for i in range(B/W)])
        for i in range (B/W) :
            size2[2*j/W+i] = mult_size_x(t0,t1,(i+1)*W)
            size2[(2*j+B)/W+i] = mult_size_x(t0,t1,B-1-i*W)
    # now hh = r2, everything else is disposable
    print "KA%d_collect:" % (N)
    aux.write("KA_col_%d_ov:\n" % N)
    print_ldr("r2",s_hh,"reload hh")
    print_ldr("r3",s_ov,"reload overflow list") # probably in each loop?
    N0 = B
    while (N0 < N) :
        N1 = KA_terms(N,2*N0)
        size_mark = [0 for i in range(KA_terms(N,N0)/W*2+1)]
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
        aux.write("KA_col_ov_%d_%d:\n" % (N,N0))
	if (size_mark_empty == 0) :
            for j in range(KA_terms(N,N0)/W*2) :
                if (size_mark[j] == 1) :
                    if (size_mark[j-1] == 0) :
                        aux.write("	.hword	%d\n" % j)
                    if (size_mark[j+1] == 0) :
                        aux.write("	.hword	%d\n" % j)
            aux.write("	.hword	-1\n")
        aux.write("KA_col_add_%d_%d:\n" % (N,N0))
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
            print "KA%d_col_%d_ov:			// no overflow" % (N,N0)
        else :
            # checking for overflows
            print "KA%d_col_%d_ov:" % (N,N0)
            #
            #print_ldr("r3",s_ov,"reload overflow list")
            print "	ldrsh	r4, [r3], #2"
            print "	cmp	r4, #-1"
            print "	beq	KA%d_col_%d_add" % (N,N0)
            #print "KA%d_col_%d_ov0:" % (N,N0)
            print_ldr("r0",s_mq,"load -q")
            print_ldr("r1",s_q32,"load qinv32")
            #print "	ldrd	r0, r1, %s	// load -q, q32inv" % (s_mq);
            print "	mov	r6,#32768"
            print "KA%d_col_%d_ov1:" % (N,N0)
            print "	ldrsh	r5, [r3], #2"
            print "KA%d_col_%d_ov2:" % (N,N0)
            print "	ldr	r8, [r2, r4, LSL #2]"
            print "	br_16x2	r8, r0, r1, r6, r7, r9"
            print "	str	r8, [r2, r4, LSL #2]"
            print "	add	r4, #1"
            print "	cmp	r4, r5"
            print "	bls	KA%d_col_%d_ov2" % (N,N0)
            print "	ldrsh	r4, [r3], #2"
            print "	cmp	r4, -1"
            print "	bne	KA%d_col_%d_ov1" % (N,N0)
        # hh has not left r2, ov has not left r3
        print "KA%d_col_%d_add:			// KA collection" % (N,N0)
        print "	ldrsh	r14, [r3], #2	// #shift/8, #iterations*4"
        #print_str("r3",s_ov,"save overflow list")
        print "	add	r12, r2, r14, LSL #3	// other pointer"
        print "	mov	r1, r2		// copy of hh"
        if (N0 == 4) :
            print "KA%d_col_%d_add1:	// beginning of KA collect" % (N,N0)
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
            print "	bne	KA%d_col_%d_add1" % (N,N0)
        elif (N0 < 64) :
            print "KA%d_col_%d_add1:	// begin KA collect loop" % (N,N0)
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
            print "	beq	KA%d_col_%d_end" % (N,N0)
            print "	tst	r14, #%d	// set bit < %d?" % (N0-1,N0)
            #print "	bne	KA%d_col_%d_add1" % (N,N0)
            #print "	add	r1, r1, #%d" % (N0*6)
            #print "	add	r12, r12, #%d" % (N0*2)
            print "	itt	eq		// no, then next set"
            print "	addeq	r1, r1, #%d" % (N0*6)
            print "	addeq	r12, r12, #%d" % (N0*2)
            print "	b	KA%d_col_%d_add1" % (N,N0)
        else : # N0 >= 64
            print "	mov	r0, #%d			// 2*N0" % (N0*2)
            print "	add	r11, r0, r0, LSL #1	// 6*N0"
            print "KA%d_col_%d_add1:	// begin KA collect loop" % (N,N0)
	    print "	ldr	r4, [r1, r0]		//+2*N0"
            print "	ldr	r6, [r1, r0, LSL #1]	//+4*N0"
            print "	ldr	r7, [r1, r11]		//+6*N0" 
            print "	ssub16	r4, r4, r6"
            print "	sadd16	r8, r4, r7"
            print "	ldr	r6, [r1]"
            print "	ldr	r7, [r12, r0]		//+2*N0"
            print "	ssub16	r4, r4, r6"
            print "	ssub16	r8, r7, r8"
            print "	ldr	r6, [r12], #4		// shift r12 up 4"
            print "	str	r8, [r1, r0, LSL #1] 	//+4*N0"
            print "	sadd16	r4, r4, r6"
            print "	str	r4, [r1, r0]		//+2*N0"
            print "	add	r1, r1, #4		// shift r1 up 4"
	    print "	subs	r14, r14, #2"
            print "	beq	KA%d_col_%d_end" % (N,N0)
            print "	tst	r14, #%d	// set bit < %d?" % (N0-1,N0)
            #print "	bne	KA%d_col_%d_add1" % (N,N0)
            #print "	add	r1, r1, r11		//+6*N0"
            #print "	add	r12, r12, r0		//+2*N0"
            print "	itt	eq			//next %d bloc" % (N0/W)
            print "	addeq	r1, r1, r11		//+6*N0"
            print "	addeq	r12, r12, r0		//+2*N0"
            print "	b	KA%d_col_%d_add1" % (N,N0)
        print "KA%d_col_%d_end:"   % (N,N0)     
        #
        N0 *= 2
    # hh should still be at #2
    print "KA%d_mv_back:			// hh=[sp,4M] still =r2" % N
    print_ldr("r0",s_h,"reload h")
    #print_ldr("r2",s_h,"reload hh")
    if (N>8) :
        print "	mov	r14, #%d" % (4*N)
    print "KA%d_mv_back_loop:" % N
    print "	ldm	r2!, {r4-r11}"
    print "	stm	r0!, {r4-r11}"
    if (N>8) :
        print "	subs	r14, #32"
        print "	bne	KA%d_mv_back_loop" % N
    #
    aux.write("\n")
    print "KA%d_end:" % N
    print_ldr("r12", s_2M, "load 2M")
    print "	add	sp, sp, r12, LSL #2	// add back %d = 8M" % (8*M) 
    print "	//vpop	{s16-s31}"
    print "	pop	{r4-r11,lr}"
    print "	bx	lr"
    print ""
    # if (NARGS > 1 ) :
    aux.close()
    # 
    
KA_prologue()
# if (NARGS > 1) :
NN = int(sys.argv[1])
KA_polymulNxN(NN)

# if (NARGS == 1) :
#     NN = 2 * B
#     while (NN <= N_range) :
#         KA_polymulNxN(NN)
#         NN *= 2
#     aux.close()
