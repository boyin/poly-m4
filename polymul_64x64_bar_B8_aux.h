	.p2align	2,,3
	.syntax		unified
	.text

KA_exp_ov_64:
KA_exp_ov_64_64:
	.hword	-1
KA_exp_add_64_64:
	.hword	16	// #TERMS(64,64)/4
KA_exp_ov_64_32:
	.hword	-1
KA_exp_add_64_32:
	.hword	24	// #TERMS(64,32)/4
KA_exp_ov_64_16:
	.hword	-1
KA_exp_add_64_16:
	.hword	36	// #TERMS(64,16)/4
KA_mul_ov_64:
	.hword	104
	.hword	105
	.hword	106
	.hword	107
	.hword	-1
	.hword	27	// #TERMS(64,8)/8
KA_col_64_ov:
KA_col_ov_64_8:
KA_col_add_64_8:
	.hword	72	// =#shift/8, #iterations*4
KA_col_ov_64_16:
	.hword	4
	.hword	11
	.hword	20
	.hword	27
	.hword	36
	.hword	43
	.hword	52
	.hword	59
	.hword	68
	.hword	75
	.hword	84
	.hword	91
	.hword	100
	.hword	107
	.hword	116
	.hword	123
	.hword	130
	.hword	141
	.hword	-1
KA_col_add_64_16:
	.hword	48	// =#shift/8, #iterations*4
KA_col_ov_64_32:
	.hword	8
	.hword	12
	.hword	18
	.hword	22
	.hword	40
	.hword	44
	.hword	50
	.hword	54
	.hword	72
	.hword	76
	.hword	82
	.hword	86
	.hword	-1
KA_col_add_64_32:
	.hword	32	// =#shift/8, #iterations*4

