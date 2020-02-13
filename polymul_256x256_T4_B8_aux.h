	.p2align	2,,3
	.syntax		unified
	.text

T4_Mat1:
	.hword	8, 4, 2, 1
	.hword	1, 2, 4, 8
T_exp_ov_64:
//0-223:2295 
T_exp_ov_64_64:
	.hword	-1
T_exp_add_64_64:
	.hword	112	// #TERMS(64,64)/4
//0-223:2295 224-335:4590 
T_exp_ov_64_32:
	.hword	-1
T_exp_add_64_32:
	.hword	168	// #TERMS(64,32)/4
//0-223:2295 224-447:4590 448-503:9180 
T_exp_ov_64_16:
	.hword	-1
T_exp_add_64_16:
	.hword	252	// #TERMS(64,16)/4
T_mul_ov_64:
	.hword	728, 755
	.hword	-1
	.hword	189	// #TERMS(64,8)/4
	// max size = 12582 @ 899
T_col_64_ov:
T_col_ov_64_8:
	// no overflow
T_col_add_64_8:
	.hword	504	// =#shift/8, #iterations*4
T_col_ov_64_16:
// overflow ranges: 0-896: 4-11  mod 16 896-992: 2-13  mod 16
	.hword 896, 2, 4, 8, 8
	.hword 992, 2, -2, 12, 4
	.hword	-1
T_col_add_64_16:
	.hword	336	// =#shift/8, #iterations*4
T_col_ov_64_32:
// overflow ranges: 0-640: 8-12  18-22  mod 32
	.hword 640, 4, 8, 5, 5, 5, 17
	.hword	-1
T_col_add_64_32:
	.hword	224	// =#shift/8, #iterations*4
T4_Mat2:
	.hword	2295, 2295, 1530, -510, 2168, -2219, -51
	.hword	-5, 1148, 765, 765, -1339, -1339, 0
	.hword	-2293, -2293, -2294, 1785, 255, 0, 255
	.hword	4, -1149, 1531, 1531, 1339, 1339, 0
	.hword	-2, -2, -1531, 1020, 2168, 2219, -204

