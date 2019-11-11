#ifndef _RED_ASM_H_
#define _RED_ASM_H_ 1

// macros for reduction mod qq	

	.macro	mr_hi, res32, qq, neg_qqinv, scr
	smulbb	\scr, \res32, \neg_qqinv
	smlabb	\res32, \qq, \scr, \res32
	.endm
	
	.macro	mr_16x2, r0, r1, qq, neg_qqinv, scr, res
	mr_hi	\r0, \qq, \neg_qqinv, \scr
	mr_hi	\r1, \qq, \neg_qqinv, \scr
    	.ifb	\res
	pkhtb	\r0, \r1, \r0, ASR #16
	.else	
	pkhtb	\res, \r1, \r0, ASR #16
	.endif
	.endm

	.macro	br_lo, res, mq, q32inv, _2p15, scr
	smlawb	\scr, \res, \q32inv, \_2p15
	smlatb	\res, \mq, \scr, \res
	.endm
	// note that high half of res is undefined
	// must save with strh

	.macro	br_16x2, res, mq, q32inv, _2p15, scr1, scr2, newres
	smlawb	\scr1, \q32inv, \res, \_2p15
	smlatb	\scr2, \scr1, \mq, \res
	smlawt	\scr1, \q32inv, \res, \_2p15
	smultb	\scr1, \scr1, \mq
	add	\scr1, \res, \scr1, LSL #16 
	.ifb	\newres
	pkhbt	\res, \scr2, \scr1
	.else	
	pkhbt	\newres, \scr2, \scr1
	.endif
	.endm	

	.macro	br_32, res, mq, q32inv, scr
	smmulr	\scr, \res, \q32inv
	mla	\res, \mq, \scr, \res
	.endm

	  // no good don't use
	.macro	center_adj, res, qqx2, scr // qqx2 = 2 copies of qq
	sadd16	scr, res, qqx2
	sel	res, scr
	ssub16	scr, res, qqx2
	sel	res, scr
	.endm	  

#endif
