	.p2align	2,,3
	.syntax		unified
	.text

KA_exp_ov_256:
KA_exp_ov_256_256:
	.hword	-1
KA_exp_add_256_256:
	.hword	64	// #TERMS(256,256)/4
KA_exp_ov_256_128:
	.hword	-1
KA_exp_add_256_128:
	.hword	96	// #TERMS(256,128)/4
KA_exp_ov_256_64:
	.hword	-1
KA_exp_add_256_64:
	.hword	144	// #TERMS(256,64)/4
KA_exp_ov_256_32:
	.hword	416
	.hword	431
	.hword	-1
KA_exp_add_256_32:
	.hword	216	// #TERMS(256,32)/4
KA_mul_ov_256:
	.hword	560
	.hword	561
	.hword	562
	.hword	563
	.hword	564
	.hword	565
	.hword	566
	.hword	567
	.hword	568
	.hword	569
	.hword	570
	.hword	571
	.hword	572
	.hword	573
	.hword	574
	.hword	575
	.hword	608
	.hword	609
	.hword	610
	.hword	611
	.hword	612
	.hword	613
	.hword	614
	.hword	615
	.hword	616
	.hword	617
	.hword	618
	.hword	619
	.hword	620
	.hword	621
	.hword	622
	.hword	623
	.hword	624
	.hword	625
	.hword	626
	.hword	627
	.hword	628
	.hword	629
	.hword	630
	.hword	631
	.hword	632
	.hword	633
	.hword	634
	.hword	635
	.hword	636
	.hword	637
	.hword	638
	.hword	639
	.hword	-1
	.hword	81	// #TERMS(256,16)/16
KA_col_256_ov:
KA_col_ov_256_16:
	.hword	514
	.hword	525
	.hword	530
	.hword	541
	.hword	546
	.hword	557
	.hword	562
	.hword	573
	.hword	706
	.hword	717
	.hword	722
	.hword	733
	.hword	738
	.hword	749
	.hword	754
	.hword	765
	.hword	770
	.hword	781
	.hword	786
	.hword	797
	.hword	802
	.hword	813
	.hword	818
	.hword	829
	.hword	997
	.hword	1001
	.hword	1005
	.hword	1005
	.hword	1013
	.hword	1017
	.hword	1021
	.hword	1021
	.hword	1029
	.hword	1033
	.hword	1037
	.hword	1037
	.hword	1045
	.hword	1049
	.hword	1053
	.hword	1053
	.hword	1061
	.hword	1065
	.hword	1069
	.hword	1069
	.hword	1077
	.hword	1081
	.hword	1085
	.hword	1085
	.hword	1093
	.hword	1097
	.hword	1101
	.hword	1101
	.hword	1109
	.hword	1113
	.hword	1117
	.hword	1117
	.hword	1157
	.hword	1161
	.hword	1165
	.hword	1165
	.hword	1173
	.hword	1177
	.hword	1181
	.hword	1181
	.hword	1189
	.hword	1193
	.hword	1197
	.hword	1197
	.hword	1205
	.hword	1209
	.hword	1213
	.hword	1213
	.hword	-1
KA_col_add_256_16:
	.hword	432	// =#shift/8, #iterations*4
KA_col_ov_256_32:
	.hword	8
	.hword	23
	.hword	40
	.hword	55
	.hword	72
	.hword	87
	.hword	104
	.hword	119
	.hword	136
	.hword	151
	.hword	168
	.hword	183
	.hword	200
	.hword	215
	.hword	232
	.hword	247
	.hword	264
	.hword	279
	.hword	296
	.hword	311
	.hword	328
	.hword	343
	.hword	360
	.hword	375
	.hword	392
	.hword	407
	.hword	424
	.hword	439
	.hword	456
	.hword	471
	.hword	488
	.hword	503
	.hword	520
	.hword	535
	.hword	552
	.hword	567
	.hword	584
	.hword	599
	.hword	616
	.hword	631
	.hword	648
	.hword	663
	.hword	680
	.hword	695
	.hword	712
	.hword	727
	.hword	744
	.hword	759
	.hword	776
	.hword	791
	.hword	808
	.hword	823
	.hword	840
	.hword	855
	.hword	-1
KA_col_add_256_32:
	.hword	288	// =#shift/8, #iterations*4
KA_col_ov_256_64:
	.hword	16
	.hword	28
	.hword	34
	.hword	46
	.hword	80
	.hword	92
	.hword	98
	.hword	110
	.hword	144
	.hword	156
	.hword	162
	.hword	174
	.hword	208
	.hword	220
	.hword	226
	.hword	238
	.hword	272
	.hword	286
	.hword	288
	.hword	303
	.hword	336
	.hword	350
	.hword	352
	.hword	367
	.hword	400
	.hword	412
	.hword	418
	.hword	430
	.hword	464
	.hword	476
	.hword	482
	.hword	494
	.hword	528
	.hword	542
	.hword	544
	.hword	559
	.hword	-1
KA_col_add_256_64:
	.hword	192	// =#shift/8, #iterations*4
KA_col_ov_256_128:
	.hword	29
	.hword	39
	.hword	47
	.hword	47
	.hword	56
	.hword	71
	.hword	79
	.hword	79
	.hword	88
	.hword	97
	.hword	111
	.hword	111
	.hword	157
	.hword	167
	.hword	175
	.hword	175
	.hword	184
	.hword	199
	.hword	207
	.hword	207
	.hword	216
	.hword	225
	.hword	239
	.hword	239
	.hword	287
	.hword	295
	.hword	303
	.hword	303
	.hword	312
	.hword	327
	.hword	335
	.hword	335
	.hword	344
	.hword	351
	.hword	-1
KA_col_add_256_128:
	.hword	128	// =#shift/8, #iterations*4

