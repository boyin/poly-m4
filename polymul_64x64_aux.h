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
KA_exp_ov_64_8:
	.hword	104
	.hword	107
	.hword	-1
KA_exp_add_64_8:
	.hword	54	// #TERMS(64,8)/4
KA_mul_ov_64:
	// no multiplicative overflow
	.hword	81	// #TERMS(64,4)/4
KA_col_64_ov:
KA_col_ov_64_4:
	.hword	280
	.hword	282
	.hword	284
	.hword	286
	.hword	304
	.hword	306
	.hword	308
	.hword	310
	.hword	312
	.hword	314
	.hword	316
	.hword	318
	.hword	-1
KA_col_add_64_4:
	.hword	108	// =#shift/8, #iterations*4
KA_col_ov_64_8:
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
	.hword	74
	.hword	77
	.hword	82
	.hword	85
	.hword	90
	.hword	93
	.hword	98
	.hword	101
	.hword	106
	.hword	109
	.hword	114
	.hword	117
	.hword	122
	.hword	125
	.hword	130
	.hword	133
	.hword	138
	.hword	141
	.hword	146
	.hword	149
	.hword	154
	.hword	157
	.hword	162
	.hword	165
	.hword	170
	.hword	173
	.hword	178
	.hword	181
	.hword	186
	.hword	189
	.hword	194
	.hword	197
	.hword	202
	.hword	205
	.hword	210
	.hword	213
	.hword	-1
KA_col_add_64_8:
	.hword	72	// =#shift/8, #iterations*4
KA_col_ov_64_16:
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
	.hword	52
	.hword	53
	.hword	58
	.hword	58
	.hword	68
	.hword	70
	.hword	72
	.hword	75
	.hword	84
	.hword	86
	.hword	88
	.hword	91
	.hword	100
	.hword	101
	.hword	106
	.hword	106
	.hword	116
	.hword	117
	.hword	122
	.hword	122
	.hword	132
	.hword	134
	.hword	136
	.hword	139
	.hword	-1
KA_col_add_64_16:
	.hword	48	// =#shift/8, #iterations*4
KA_col_ov_64_32:
	.hword	6
	.hword	9
	.hword	11
	.hword	11
	.hword	14
	.hword	17
	.hword	19
	.hword	19
	.hword	22
	.hword	25
	.hword	27
	.hword	27
	.hword	38
	.hword	41
	.hword	43
	.hword	43
	.hword	46
	.hword	49
	.hword	51
	.hword	51
	.hword	54
	.hword	57
	.hword	59
	.hword	59
	.hword	71
	.hword	73
	.hword	75
	.hword	75
	.hword	78
	.hword	81
	.hword	83
	.hword	83
	.hword	86
	.hword	87
	.hword	-1
KA_col_add_64_32:
	.hword	32	// =#shift/8, #iterations*4

