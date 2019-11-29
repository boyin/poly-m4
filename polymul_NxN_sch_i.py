import sys
import re
from math import log,ceil,floor,sqrt

q = 4591
qinv = 15631	# q^{-1} mod 2^16
q16inv = 14	# round(2^16/q)
q32inv = 935519	# round(2^32/q)
SAVES = 0
MONT_OR_BAR = 0

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

# may change to using vmov later
def print_ldr (reg, loc, comment) :
    #print("	ldr	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s  // %s" % (reg, loc, comment))

def print_str (reg, loc, comment) :
    #print("	str	%s, %s	// %s" % (reg, loc, comment))
    print("	vmov	%s, %s	// %s" % (loc, reg, comment))

# multiply and accumulate block pointed to by a and b (in row a+b)
def add_block(a,b) :
    i = a + b
    print "	// block (%d,%d)" % (a,b)
    print "	ldr	r12, [%s, #%d]" % (r_g,8*b)
    print "	ldr	r14, [%s, #%d]" % (r_g,8*b+4)
    print "	ldr	r3, [%s, #%d]" % (r_f,8*a)
    print "	ldr	r4, [%s, #%d]" % (r_f,8*a+4)
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

def SCH_polymulNxN(N,rf,rg,rh,smq,sqi) :
    assert (N == int(N/4)*4)    
    global r_f, r_g, r_h, s_mq, s_qi, s_q32
    r_f = rf; r_g = rg; r_h = rh; s_mq = smq;
    if (MONT_OR_BAR == 0) : s_qi = sqi
    else : s_q32 = sqi
    # load 4x4 multiplications at a time from (r3,r4), (r12,r14)
    # doing 7 rotating accumulators in r5-r11
    print "	ldr	r12, [%s]" % (r_g)
    print "	ldr	r14, [%s, #4]" % (r_g)
    print "	ldr	r3, [%s]" % (r_f)
    print "	ldr	r4, [%s, #4]" % (r_f)
    # left top, very first block
    print "	// block (0,0)"
    print "	smuadx	%s, r3, r12" % (acc_r(0,1))
    print "	smuadx	%s, r4, r12" % (acc_r(0,3))
    print "	smladx	%s, r3, r14, %s" % (acc_r(0,3),acc_r(0,3))
    print "	smuadx	%s, r4, r14" % (acc_r(0,5))
    print "	smulbb	%s, r3, r12" % (acc_r(0,0))
    print "	smulbb	%s, r3, r14" % (acc_r(0,2))
    print "	pkhtb	r3, r3, r4"
    print "	smlad	%s, r3, r12, %s" % (acc_r(0,2),acc_r(0,2))
    print "	smuad	%s, r3, r14" % (acc_r(0,4))
    print "	smlatt	%s, r4, r12, %s" % (acc_r(0,4),acc_r(0,4))
    print "	smultt	%s, r4, r14" % (acc_r(0,6))
    # now need to conserve r14 when reducing first 4 accumulators
    for i in range(1,N/4) :
        a0 = 0; b0 = i
        a1 = i; b1 = 0
        if (not is_even(i)) : # odd i, r14 set according to b1
            reduce_4acc(i-1,"r4")
            print "	ldr	r3, [%s, #%d]" % (r_f,8*a1)
            print "	ldr	r4, [%s, #%d]" % (r_f,8*a1+4)
            print "	ldr	r12, [%s, #%d]" % (r_g,8*b1)
            print "	// block (%d,%d)" % (a1,b1)
        else : # even i, r4 set according to a0
            reduce_4acc(i-1,"r14")
            print "	ldr	r3, [%s, #%d]" % (r_f,8*a0)
            print "	ldr	r12, [%s, #%d]" % (r_g,8*b0)
            print "	ldr	r14, [%s, #%d]" % (r_g,8*b0+4)
            print "	// block (%d,%d)" % (a0,b0)
        add_block_first(i)
        #
        # split even and odd i
        #
        if (not is_even(i)) : # odd i, already done (a1,b1)
            for b in range(b1+1,b0+1) :
                a = i - b
                add_block(a,b);
        else : # even i, already done (a0,b0)
            for a in range(a0+1,a1+1) :
                b = i - a
                add_block(a,b);

    for i in range(N/4,N/2-1) :
        a0 = (i-N/4+1); b0 = (N/4-1);
        a1 = (N/4-1); b1 = (i-N/4+1);
        if (not is_even(i)) : # odd i, r4 set according to a1
            reduce_4acc(i-1,"r14")
            print "	ldr	r3, [%s, #%d]" % (r_f,8*a1)
            print "	ldr	r12, [%s, #%d]" % (r_g,8*b1)
            print "	ldr	r14, [%s, #%d]" % (r_g,8*b1+4)
            print "	// block (%d,%d)" % (a1,b1)
        else : # even i, r14 set according to b0
            reduce_4acc(i-1,"r4")
            print "	ldr	r3, [%s, #%d]" % (r_f,8*a0)
            print "	ldr	r4, [%s, #%d]" % (r_f,8*a0+4)
            print "	ldr	r12, [%s, #%d]" % (r_g,8*b0)
            print "	// block (%d,%d)" % (a0,b0)
        add_block_first(i)
        #
        # split even and odd i
        #
        if (not is_even(i)) : # odd i, already done (a1,b1)
            for b in range(b1+1,b0+1) :
                a = i - b
                add_block(a,b);
        else : # even i, already done (a0,b0)
            for a in range(a0+1,a1+1) :
                b = i - a
                add_block(a,b);

    # after very last block, need to reduce the last 7 accumulators
    reduce_4acc(N/2-2,"r4")
    if (MONT_OR_BAR == 0) :
        print "	mr_16x2	%s, %s, r3, r12, r4" % (acc_r(N/2-1,0),acc_r(N/2-1,1))
        print "	mr_hi	%s, r3, r12, r4" % (acc_r(N/2-1,2))
        print "	lsr	%s, #16" % (acc_r(N/2-1,2))
    else :
        print "	br_32x2	%s, %s, r3, r12, r4" % (acc_r(N/2-1,0),acc_r(N/2-1,1))
        print "	br_32	%s, r3, r12, r4" % (acc_r(N/2-1,2))
    print "	str	%s, [%s], #4" % (acc_r(N/2-1,0),r_h)
    print "	str	%s, [%s], #4" % (acc_r(N/2-1,2),r_h)
    print "	add	%s, #%d" % (r_f,2*N)
    print "	add	%s, #%d" % (r_g,2*N)
