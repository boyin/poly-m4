	.p2align	2,,3
	.syntax		unified
	.text

KA_exp_ov_32:
KA_exp_ov_32_32:
	.hword	-1
KA_exp_add_32_32:
	.hword	8	// #TERMS(32,32)/4
KA_exp_ov_32_16:
	.hword	-1
KA_exp_add_32_16:
	.hword	12	// #TERMS(32,16)/4
KA_exp_ov_32_8:
	.hword	-1
KA_exp_add_32_8:
	.hword	18	// #TERMS(32,8)/4
KA_mul_ov_32:
	// no multiplicative overflow
	.hword	27	// #TERMS(32,4)/4
KA_col_32_ov:
KA_col_ov_32_4:
	.hword	104
	.hword	106
	.hword	-1
KA_col_add_32_4:
	.hword	36	// =#shift/8, #iterations*4
KA_col_ov_32_8:
	.hword	2
	.hword	5
	.hword	10
	.hword	13
	.hword	18
	.hword	21
	.hword	26
	.hword	29
	.hword	34
	.hword	37
	.hword	42
	.hword	45
	.hword	50
	.hword	53
	.hword	58
	.hword	61
	.hword	66
	.hword	69
	.hword	-1
KA_col_add_32_8:
	.hword	24	// =#shift/8, #iterations*4
KA_col_ov_32_16:
	.hword	4
	.hword	5
	.hword	10
	.hword	10
	.hword	20
	.hword	21
	.hword	26
	.hword	26
	.hword	36
	.hword	37
	.hword	42
	.hword	42
	.hword	-1
KA_col_add_32_16:
	.hword	16	// =#shift/8, #iterations*4

