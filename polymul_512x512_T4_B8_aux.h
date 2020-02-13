	.p2align	2,,3
	.syntax		unified
	.text

T4_Mat1:
	.hword	8, 4, 2, 1
	.hword	1, 2, 4, 8
T_exp_ov_128:
//0-447:2295 
T_exp_ov_128_128:
	.hword	-1
T_exp_add_128_128:
	.hword	224	// #TERMS(128,128)/4
//0-447:2295 448-671:4590 
T_exp_ov_128_64:
	.hword	-1
T_exp_add_128_64:
	.hword	336	// #TERMS(128,64)/4
//0-447:2295 448-895:4590 896-1007:9180 
T_exp_ov_128_32:
	.hword	-1
T_exp_add_128_32:
	.hword	504	// #TERMS(128,32)/4
//0-447:2295 448-895:4590 896-1007:9180 1008-1231:4590 1232-1455:9180 1456-1511:18360 
T_exp_ov_128_16:
	.hword	1456, 1511
	.hword	-1
T_exp_add_128_16:
	.hword	756	// #TERMS(128,16)/4
T_mul_ov_128:
	.hword	1960, 2015
	.hword	2128, 2239
	.hword	-1
	.hword	567	// #TERMS(128,8)/4
	// max size = 12582 @ 1795
T_col_128_ov:
T_col_ov_128_8:
	// no overflow
T_col_add_128_8:
	.hword	1512	// =#shift/8, #iterations*4
T_col_ov_128_16:
// overflow ranges: 0-1792: 4-11  mod 16 1792-2016: 2-13  mod 16 2016-2464: 4-11  mod 16 2464-2912: 2-13  mod 16 2912-3008: 4-11  mod 16
	.hword 1792, 2, 4, 8, 8
	.hword 2016, 2, -2, 12, 4
	.hword 2464, 2, 2, 8, 8
	.hword 2912, 2, -2, 12, 4
	.hword 3008, 2, 2, 8, 8
	.hword	-1
T_col_add_128_16:
	.hword	1008	// =#shift/8, #iterations*4
T_col_ov_128_32:
// overflow ranges: 0-896: 8-12  18-22  mod 32 896-1344: 8-14  16-23  mod 32 1344-1792: 8-12  18-22  mod 32 1792-1984: 8-14  16-23  mod 32
	.hword 896, 4, 8, 5, 5, 5, 17
	.hword 1344, 4, 0, 7, 1, 8, 16
	.hword 1792, 4, 0, 5, 5, 5, 17
	.hword 1984, 4, 0, 7, 1, 8, 16
	.hword	-1
T_col_add_128_32:
	.hword	672	// =#shift/8, #iterations*4
T_col_ov_128_64:
// overflow ranges: 0-896: 13-19  23-23  28-35  39-39  44-49  55-55  mod 64 896-1280: 15-19  23-23  28-35  39-39  44-47  mod 64
	.hword 896, 12, 13, 7, 3, 1, 4, 8, 3, 1, 4, 6, 5, 1, 21
	.hword 1280, 10, 2, 5, 3, 1, 4, 8, 3, 1, 4, 4, 31
	.hword	-1
T_col_add_128_64:
	.hword	448	// =#shift/8, #iterations*4
T4_Mat2:
	.hword	2295, 2295, 1530, -510, 2168, -2219, -51
	.hword	-5, 1148, 765, 765, -1339, -1339, 0
	.hword	-2293, -2293, -2294, 1785, 255, 0, 255
	.hword	4, -1149, 1531, 1531, 1339, 1339, 0
	.hword	-2, -2, -1531, 1020, 2168, 2219, -204

