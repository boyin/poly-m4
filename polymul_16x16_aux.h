	.p2align	2,,3
	.syntax		unified
	.text

KA_exp_ov_16:
KA_exp_ov_16_16:
	.hword	-1
KA_exp_add_16_16:
	.hword	4	// #TERMS(16,16)/4
KA_exp_ov_16_8:
	.hword	-1
KA_exp_add_16_8:
	.hword	6	// #TERMS(16,8)/4
KA_mul_ov_16:
	// no multiplicative overflow
	.hword	9	// #TERMS(16,4)/4
KA_col_16_ov:
KA_col_ov_16_4:
KA_col_add_16_4:
	.hword	12	// =#shift/8, #iterations*4
KA_col_ov_16_8:
	.hword	2
	.hword	5
	.hword	10
	.hword	13
	.hword	18
	.hword	21
	.hword	-1
KA_col_add_16_8:
	.hword	8	// =#shift/8, #iterations*4

