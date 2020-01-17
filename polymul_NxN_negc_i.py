import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
SAVES = 0
global MONT_OR_BAR 

r_f = "r1"
r_g = "r2"
r_h = "r0"

# rotating accumulator k during round i
def acc_r (i,k) :
    return("r%d" % (5+(4*i+k)%7)) 

def is_even (E) :
    if isinstance(E,int) :
        return (int(E/2)*2 == E)
    else :
        return(False)

def alloc_save (S) : # allocate variable name s_S as a space
    global SAVES
    if not (("s_"+S) in locals() or ("s_"+S) in globals()) :
        globals()["s_"+S] = "s" + str(SAVES)
        SAVES +=1

alloc_save("mq") # modulus -q = -4591
alloc_save("qi") # q^{-1} mod 2^16 or
alloc_save("q32")# round(2^32/q)
alloc_save("h")  # save h
alloc_save("0")  # scratch 0
alloc_save("1")  # scratch 1
alloc_save("2")  # scratch 2
alloc_save("3")  # scratch 3

# may change to using vmov later
def print_ldr (reg, loc, comment) :
    #print("	ldr	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s  // %s" % (reg, loc, comment))

def print_str (reg, loc, comment) :
    #print("	str	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s	// %s" % (loc, reg, comment))

# multiply and accumulate block pointed to by a and b (in row a+b)
def add_block(a,b,i) :
    print "	//block_%d_%d:" % (a,b)
    print "	ldr	r3, [%s, #%d]" % (r_f,8*a)
    print "	ldr	r4, [%s, #%d]" % (r_f,8*a+4)
    print "	ldr	r12, [%s, #%d]" % (r_g,8*b)
    print "	ldr	r14, [%s, #%d]" % (r_g,8*b+4)
    print "	smladx	%s, r3, r12, %s" % (acc_r(i,1),acc_r(i,1))
    print "	smladx	%s, r4, r12, %s" % (acc_r(i,3),acc_r(i,3))
    print "	smladx	%s, r3, r14, %s" % (acc_r(i,3),acc_r(i,3))
    print "	smladx	%s, r4, r14, %s" % (acc_r(i,5),acc_r(i,5))
    print "	smlabb	%s, r3, r12, %s" % (acc_r(i,0),acc_r(i,0))
    print "	smlabb	%s, r3, r14, %s" % (acc_r(i,2),acc_r(i,2))
    print "	pkhtb	r3, r3, r4"
    print "	smlad	%s, r3, r12, %s" % (acc_r(i,2),acc_r(i,2))
    print "	smlad	%s, r3, r14, %s" % (acc_r(i,4),acc_r(i,4))
    print "	smlatt	%s, r4, r12, %s" % (acc_r(i,4),acc_r(i,4))
    print "	smlatt	%s, r4, r14, %s" % (acc_r(i,6),acc_r(i,6))
    
# first block of row i, r3, r4, r12, r14 already set up
def add_block_first(i) :
    print "	smladx	%s, r3, r12, %s" % (acc_r(i,1),acc_r(i,1))
    print "	smuadx	%s, r4, r12" % (acc_r(i,3))
    print "	smladx	%s, r3, r14, %s" % (acc_r(i,3),acc_r(i,3))
    print "	smuadx	%s, r4, r14" % (acc_r(i,5))
    print "	smlabb	%s, r3, r12, %s" % (acc_r(i,0),acc_r(i,0))
    print "	smlabb	%s, r3, r14, %s" % (acc_r(i,2),acc_r(i,2))
    print "	pkhtb	r3, r3, r4"
    print "	smlad	%s, r3, r12, %s" % (acc_r(i,2),acc_r(i,2))
    print "	smuad	%s, r3, r14" % (acc_r(i,4))
    print "	smlatt	%s, r4, r12, %s" % (acc_r(i,4),acc_r(i,4))
    print "	smultt	%s, r4, r14" % (acc_r(i,6))
   
def reduce_4acc (i, scr) :
    print_ldr("r3",s_mq,"load -q")
    if (MONT_OR_BAR == 0) :
        print_ldr("r12",s_qi,"load qinv")
        redm = "mr_16x2"
    else :
        print_ldr("r12",s_q32,"load q32inv")
        redm = "br_32x2"
    print "	%s	%s, %s, r3, r12, %s" % (redm,acc_r(i,0),acc_r(i,1),scr)
    print "	%s	%s, %s, r3, r12, %s" % (redm,acc_r(i,2),acc_r(i,3),scr)
    print "	str	%s, [%s], #4" % (acc_r(i,0),r_h)
    print "	str	%s, [%s], #4" % (acc_r(i,2),r_h)

def SCH_polymulNxN_negc(N,rf,rg,rh,smq,sqi,s0,s1,s2,s3,MB) :
    assert (N == int(N/4)*4)    
    global r_f, r_g, r_h, s_mq, s_qi, s_q32, s_0, s_1, s_2, s_3, MONT_OR_BAR
    MONT_OR_BAR = MB;
    r_f = rf; r_g = rg; r_h = rh; s_mq = smq;
    s_0 = s0; s_1 = s1; s_2 = s2; s_3 = s_3
    if (MONT_OR_BAR == 0) : s_qi = sqi
    else : s_q32 = sqi
    
    # load 4x4 multiplications at a time from (r3,r4), (r12,r14)
    # doing 7 rotating accumulators in r5-r11
    # left top, very first block
    print "	//block_%d_0:" % (N/4-1)
    print "	ldr	r3, [%s, #%d]" % (r_f, 2*N-8)
    print "	ldr	r4, [%s, #%d]" % (r_f, 2*N-4)
    print "	ldr	r12, [%s]" % (r_g)
    print "	ldr	r14, [%s, #4]" % (r_g)
    print "	smuadx	%s, r3, r12" % (acc_r(-1,1))
    print "	smuadx	%s, r4, r12" % (acc_r(-1,3))
    print "	smladx	%s, r3, r14, %s" % (acc_r(-1,3),acc_r(-1,3))
    print "	smuadx	%s, r4, r14" % (acc_r(-1,5))
    print "	smulbb	%s, r3, r12" % (acc_r(-1,0))
    print "	smulbb	%s, r3, r14" % (acc_r(-1,2))
    print "	pkhtb	r3, r3, r4"
    print "	smlad	%s, r3, r12, %s" % (acc_r(-1,2),acc_r(-1,2))
    print "	smuad	%s, r3, r14" % (acc_r(-1,4))
    print "	smlatt	%s, r4, r12, %s" % (acc_r(-1,4),acc_r(-1,4))
    print "	smultt	%s, r4, r14" % (acc_r(-1,6))
    for b in range(1,N/4) :
        a = N/4 - 1 - b
        add_block(a, b, -1)
    print_str(acc_r(-1,0),s_0,"save thread 0")
    print_str(acc_r(-1,1),s_1,"save thread 1")
    print_str(acc_r(-1,2),s_2,"save thread 2")
    print_str(acc_r(-1,3),s_3,"save thread 3")
    
    for i in range(N/4-1) :
        a += 1
        print "	//block_%d_%d:" % (a,b)
        print "	ldr	r3, [%s, #%d]" % (r_f,8*a)
        print "	ldr	r4, [%s, #%d]" % (r_f,8*a+4)
        if (i>0) : print "	ldr	r12, [%s, #%d]" % (r_g,8*b)
        add_block_first(i)
        #
        # split even and odd i
        #
        if (is_even(i)) : # even i, already done (i+1, N/4-1)
            for a in range(i+2, N/4) :
            	b = N/4 + i - a # until a = N/4 = 0, b = i
                add_block(a, b, i)
        else : # odd i, already done (i,0)
            for b in range(1, i+1) :
                a = i - b # until a = 0, b = i
                add_block(a, b, i);
        print "	neg	%s, %s" % (acc_r(i,0), acc_r(i,0))
        print "	neg	%s, %s" % (acc_r(i,1), acc_r(i,1))
        print "	neg	%s, %s" % (acc_r(i,2), acc_r(i,2))
        print "	neg	%s, %s" % (acc_r(i,3), acc_r(i,3))
        print "	neg	%s, %s" % (acc_r(i,4), acc_r(i,4))
        print "	neg	%s, %s" % (acc_r(i,5), acc_r(i,5))
        print "	neg	%s, %s" % (acc_r(i,6), acc_r(i,6))

        if (is_even(i)) : # even i, a = 0, b = i
            for a in range(i+1) : # until a = i, b = 0
                b = i - a
                add_block(a, b, i);
        else : # odd i, a = N/4 - 1, b = i+1
            for b in range(i+1, N/4) : # until a = i+1, b = N/4 - 1
                a = N/4 + i - b
                add_block(a, b, i);
            print "	neg	%s, %s" % (acc_r(i,0), acc_r(i,0)) 
            print "	neg	%s, %s" % (acc_r(i,1), acc_r(i,1)) 
            print "	neg	%s, %s" % (acc_r(i,2), acc_r(i,2)) 
            print "	neg	%s, %s" % (acc_r(i,3), acc_r(i,3)) 
        reduce_4acc(i,"r4")
    # after very last block, need to reduce the last 4 accumulators
    print_ldr(acc_r(N/4-2,1),s_0,"load thread 0")
    print_ldr(acc_r(N/4-2,2),s_1,"load thread 1")
    print_ldr(acc_r(N/4-2,3),s_2,"load thread 2")
    print_ldr(acc_r(N/4-2,0),s_3,"load thread 3")
    print "	add	%s, %s" % (acc_r(N/4-2,4),acc_r(N/4-2,1))
    print "	add	%s, %s" % (acc_r(N/4-2,5),acc_r(N/4-2,2))
    print "	add	%s, %s" % (acc_r(N/4-2,6),acc_r(N/4-2,3))
    reduce_4acc(N/4-1,"r4")
    print "	add	%s, #%d" % (r_f,2*N)
    print "	add	%s, #%d" % (r_g,2*N)
