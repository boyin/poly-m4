	.p2align	2,,3
	.syntax		unified
	.text

T4_Mat1:
	.hword	8, 4, 2, 1
	.hword	1, 2, 4, 8
T_exp_ov_192:
//0-671:2295 
T_exp_ov_192_192:
	.hword	-1
T_exp_add_192_192:
	.hword	336	// #TERMS(192,192)/4
//0-671:2295 672-1007:4590 
T_exp_ov_192_96:
	.hword	-1
T_exp_add_192_96:
	.hword	504	// #TERMS(192,96)/4
//0-671:2295 672-1343:4590 1344-1511:9180 
T_exp_ov_192_48:
	.hword	-1
T_exp_add_192_48:
	.hword	756	// #TERMS(192,48)/4
T_mul_ov_192:
	.hword	1344, 1511
	.hword	1848, 2267
	.hword	-1
	.hword	189	// #TERMS(192,24)/4
	// max size = 10010 @ 1355
T_col_192_ov:
T_col_ov_192_24:
	// no overflow
T_col_add_192_24:
	.hword	1512	// =#shift/8, #iterations*4
T_col_ov_192_48:
// overflow ranges: 0-1344: 12-35  mod 48 1344-2688: 9-38  mod 48 2688-2976: 12-35  mod 48
	.hword 1344, 2, 12, 24, 24
	.hword 2688, 2, -3, 30, 18
	.hword 2976, 2, 3, 24, 24
	.hword	-1
T_col_add_192_48:
	.hword	1008	// =#shift/8, #iterations*4
T_col_ov_192_96:
// overflow ranges: 0-1920: 24-44  50-70  mod 96
	.hword 1920, 4, 24, 21, 5, 21, 49
	.hword	-1
T_col_add_192_96:
	.hword	672	// =#shift/8, #iterations*4
T4_Mat2:
	.hword	2295, 2295, 1530, -510, 2168, -2219, -51
	.hword	-5, 1148, 765, 765, -1339, -1339, 0
	.hword	-2293, -2293, -2294, 1785, 255, 0, 255
	.hword	4, -1149, 1531, 1531, 1339, 1339, 0
	.hword	-2, -2, -1531, 1020, 2168, 2219, -204

