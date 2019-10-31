	.p2align	2,,3
	.syntax		unified
	.text

T4_Mat1:
	.hword	1, 1, 1, 1
	.hword	1, -1, 1, -1
	.hword	8, 4, 2, 1
	.hword	8, -4, 2, -1
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
	.hword	728
	.hword	729
	.hword	730
	.hword	731
	.hword	732
	.hword	733
	.hword	734
	.hword	735
	.hword	736
	.hword	737
	.hword	738
	.hword	739
	.hword	740
	.hword	741
	.hword	742
	.hword	743
	.hword	744
	.hword	745
	.hword	746
	.hword	747
	.hword	748
	.hword	749
	.hword	750
	.hword	751
	.hword	752
	.hword	753
	.hword	754
	.hword	755
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
	.hword	4, 11
	.hword	20, 27
	.hword	36, 43
	.hword	52, 59
	.hword	68, 75
	.hword	84, 91
	.hword	100, 107
	.hword	116, 123
	.hword	132, 139
	.hword	148, 155
	.hword	164, 171
	.hword	180, 187
	.hword	196, 203
	.hword	212, 219
	.hword	228, 235
	.hword	244, 251
	.hword	260, 267
	.hword	276, 283
	.hword	292, 299
	.hword	308, 315
	.hword	324, 331
	.hword	340, 347
	.hword	356, 363
	.hword	372, 379
	.hword	388, 395
	.hword	404, 411
	.hword	420, 427
	.hword	436, 443
	.hword	452, 459
	.hword	468, 475
	.hword	484, 491
	.hword	500, 507
	.hword	516, 523
	.hword	532, 539
	.hword	548, 555
	.hword	564, 571
	.hword	580, 587
	.hword	596, 603
	.hword	612, 619
	.hword	628, 635
	.hword	644, 651
	.hword	660, 667
	.hword	676, 683
	.hword	692, 699
	.hword	708, 715
	.hword	724, 731
	.hword	740, 747
	.hword	756, 763
	.hword	772, 779
	.hword	788, 795
	.hword	804, 811
	.hword	820, 827
	.hword	836, 843
	.hword	852, 859
	.hword	868, 875
	.hword	884, 891
	.hword	898, 909
	.hword	914, 925
	.hword	930, 941
	.hword	946, 957
	.hword	962, 973
	.hword	978, 989
	.hword	994, 1005
	.hword	-1
T_col_add_64_16:
	.hword	336	// =#shift/8, #iterations*4
T_col_ov_64_32:
// overflow ranges: 0-640: 8-12  18-22  mod 32
	.hword	8, 12
	.hword	18, 22
	.hword	40, 44
	.hword	50, 54
	.hword	72, 76
	.hword	82, 86
	.hword	104, 108
	.hword	114, 118
	.hword	136, 140
	.hword	146, 150
	.hword	168, 172
	.hword	178, 182
	.hword	200, 204
	.hword	210, 214
	.hword	232, 236
	.hword	242, 246
	.hword	264, 268
	.hword	274, 278
	.hword	296, 300
	.hword	306, 310
	.hword	328, 332
	.hword	338, 342
	.hword	360, 364
	.hword	370, 374
	.hword	392, 396
	.hword	402, 406
	.hword	424, 428
	.hword	434, 438
	.hword	456, 460
	.hword	466, 470
	.hword	488, 492
	.hword	498, 502
	.hword	520, 524
	.hword	530, 534
	.hword	552, 556
	.hword	562, 566
	.hword	584, 588
	.hword	594, 598
	.hword	616, 620
	.hword	626, 630
	.hword	648, 652
	.hword	658, 662
	.hword	-1
T_col_add_64_32:
	.hword	224	// =#shift/8, #iterations*4
T4_Mat2:
	.hword	2295, 2295, 1530, -510, 2168, -2219, -51
	.hword	-5, 1148, 765, 765, -1339, -1339, 0
	.hword	-2293, -2293, -2294, 1785, 255, 0, 255
	.hword	4, -1149, 1531, 1531, 1339, 1339, 0
	.hword	-2, -2, -1531, 1020, 2168, 2219, -204

