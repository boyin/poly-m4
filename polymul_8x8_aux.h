	.p2align	2,,3
	.syntax		unified
	.text

KA_exp_ov_8:
KA_exp_ov_8_8:
	.hword	-1
KA_exp_add_8_8:
	.hword	2	// #TERMS(8,8)/4
KA_mul_ov_8:
	// no multiplicative overflow
	.hword	3	// #TERMS(8,4)/4
KA_col_8_ov:
KA_col_ov_8_4:
KA_col_add_8_4:
	.hword	4	// =#shift/8, #iterations*4

