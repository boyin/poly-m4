	.p2align	2,,3
	.syntax		unified
	.text

T6_Mat1:
	.hword	1, 1, 1, 1, 1, 1
	.hword	1, -1, 1, -1, 1, -1
	.hword	1, 2, 4, 8, 16, 32
	.hword	1, -2, 4, -8, 16, -32
	.hword	32, 16, 8, 4, 2, 1
	.hword	-32, 16, -8, 4, -2, 1
	.hword	1, 4, 16, 64, 256, 1024
	.hword	1, -4, 16, -64, 256, -1024
	.hword	1024, 256, 64, 16, 4, 1
T_exp_ov_128:
//0-703:2295 
T_exp_ov_128_128:
	.hword	-1
T_exp_add_128_128:
	.hword	352	// #TERMS(128,128)/4
//0-703:2295 704-1055:4590 
T_exp_ov_128_64:
	.hword	-1
T_exp_add_128_64:
	.hword	528	// #TERMS(128,64)/4
//0-703:2295 704-1407:4590 1408-1583:9180 
T_exp_ov_128_32:
	.hword	-1
T_exp_add_128_32:
	.hword	792	// #TERMS(128,32)/4
//0-703:2295 704-1407:4590 1408-1583:9180 1584-1935:4590 1936-2287:9180 2288-2375:18360 
T_exp_ov_128_16:
	.hword	2288, 2375
	.hword	-1
T_exp_add_128_16:
	.hword	1188	// #TERMS(128,16)/4
T_mul_ov_128:
	.hword	3080
	.hword	3081
	.hword	3082
	.hword	3083
	.hword	3084
	.hword	3085
	.hword	3086
	.hword	3087
	.hword	3088
	.hword	3089
	.hword	3090
	.hword	3091
	.hword	3092
	.hword	3093
	.hword	3094
	.hword	3095
	.hword	3096
	.hword	3097
	.hword	3098
	.hword	3099
	.hword	3100
	.hword	3101
	.hword	3102
	.hword	3103
	.hword	3104
	.hword	3105
	.hword	3106
	.hword	3107
	.hword	3108
	.hword	3109
	.hword	3110
	.hword	3111
	.hword	3112
	.hword	3113
	.hword	3114
	.hword	3115
	.hword	3116
	.hword	3117
	.hword	3118
	.hword	3119
	.hword	3120
	.hword	3121
	.hword	3122
	.hword	3123
	.hword	3124
	.hword	3125
	.hword	3126
	.hword	3127
	.hword	3128
	.hword	3129
	.hword	3130
	.hword	3131
	.hword	3132
	.hword	3133
	.hword	3134
	.hword	3135
	.hword	3136
	.hword	3137
	.hword	3138
	.hword	3139
	.hword	3140
	.hword	3141
	.hword	3142
	.hword	3143
	.hword	3144
	.hword	3145
	.hword	3146
	.hword	3147
	.hword	3148
	.hword	3149
	.hword	3150
	.hword	3151
	.hword	3152
	.hword	3153
	.hword	3154
	.hword	3155
	.hword	3156
	.hword	3157
	.hword	3158
	.hword	3159
	.hword	3160
	.hword	3161
	.hword	3162
	.hword	3163
	.hword	3164
	.hword	3165
	.hword	3166
	.hword	3167
	.hword	3344
	.hword	3345
	.hword	3346
	.hword	3347
	.hword	3348
	.hword	3349
	.hword	3350
	.hword	3351
	.hword	3352
	.hword	3353
	.hword	3354
	.hword	3355
	.hword	3356
	.hword	3357
	.hword	3358
	.hword	3359
	.hword	3360
	.hword	3361
	.hword	3362
	.hword	3363
	.hword	3364
	.hword	3365
	.hword	3366
	.hword	3367
	.hword	3368
	.hword	3369
	.hword	3370
	.hword	3371
	.hword	3372
	.hword	3373
	.hword	3374
	.hword	3375
	.hword	3376
	.hword	3377
	.hword	3378
	.hword	3379
	.hword	3380
	.hword	3381
	.hword	3382
	.hword	3383
	.hword	3384
	.hword	3385
	.hword	3386
	.hword	3387
	.hword	3388
	.hword	3389
	.hword	3390
	.hword	3391
	.hword	3392
	.hword	3393
	.hword	3394
	.hword	3395
	.hword	3396
	.hword	3397
	.hword	3398
	.hword	3399
	.hword	3400
	.hword	3401
	.hword	3402
	.hword	3403
	.hword	3404
	.hword	3405
	.hword	3406
	.hword	3407
	.hword	3408
	.hword	3409
	.hword	3410
	.hword	3411
	.hword	3412
	.hword	3413
	.hword	3414
	.hword	3415
	.hword	3416
	.hword	3417
	.hword	3418
	.hword	3419
	.hword	3420
	.hword	3421
	.hword	3422
	.hword	3423
	.hword	3424
	.hword	3425
	.hword	3426
	.hword	3427
	.hword	3428
	.hword	3429
	.hword	3430
	.hword	3431
	.hword	3432
	.hword	3433
	.hword	3434
	.hword	3435
	.hword	3436
	.hword	3437
	.hword	3438
	.hword	3439
	.hword	3440
	.hword	3441
	.hword	3442
	.hword	3443
	.hword	3444
	.hword	3445
	.hword	3446
	.hword	3447
	.hword	3448
	.hword	3449
	.hword	3450
	.hword	3451
	.hword	3452
	.hword	3453
	.hword	3454
	.hword	3455
	.hword	3456
	.hword	3457
	.hword	3458
	.hword	3459
	.hword	3460
	.hword	3461
	.hword	3462
	.hword	3463
	.hword	3464
	.hword	3465
	.hword	3466
	.hword	3467
	.hword	3468
	.hword	3469
	.hword	3470
	.hword	3471
	.hword	3472
	.hword	3473
	.hword	3474
	.hword	3475
	.hword	3476
	.hword	3477
	.hword	3478
	.hword	3479
	.hword	3480
	.hword	3481
	.hword	3482
	.hword	3483
	.hword	3484
	.hword	3485
	.hword	3486
	.hword	3487
	.hword	3488
	.hword	3489
	.hword	3490
	.hword	3491
	.hword	3492
	.hword	3493
	.hword	3494
	.hword	3495
	.hword	3496
	.hword	3497
	.hword	3498
	.hword	3499
	.hword	3500
	.hword	3501
	.hword	3502
	.hword	3503
	.hword	3504
	.hword	3505
	.hword	3506
	.hword	3507
	.hword	3508
	.hword	3509
	.hword	3510
	.hword	3511
	.hword	3512
	.hword	3513
	.hword	3514
	.hword	3515
	.hword	3516
	.hword	3517
	.hword	3518
	.hword	3519
	.hword	-1
	.hword	891	// #TERMS(128,8)/4
	// max size = 12582 @ 2819
T_col_128_ov:
T_col_ov_128_8:
	/* tailored overflow check
	// no overflow
	skipped overflow list */
T_col_add_128_8:
	.hword	2376	// =#shift/8, #iterations*4
T_col_ov_128_16:
// overflow ranges: 0-2816: 4-11  mod 16 2816-3168: 2-13  mod 16 3168-3872: 4-11  mod 16 3872-4576: 2-13  mod 16 4576-4736: 4-11  mod 16
	/* tailored overflow check
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
	.hword	900, 907
	.hword	916, 923
	.hword	932, 939
	.hword	948, 955
	.hword	964, 971
	.hword	980, 987
	.hword	996, 1003
	.hword	1012, 1019
	.hword	1028, 1035
	.hword	1044, 1051
	.hword	1060, 1067
	.hword	1076, 1083
	.hword	1092, 1099
	.hword	1108, 1115
	.hword	1124, 1131
	.hword	1140, 1147
	.hword	1156, 1163
	.hword	1172, 1179
	.hword	1188, 1195
	.hword	1204, 1211
	.hword	1220, 1227
	.hword	1236, 1243
	.hword	1252, 1259
	.hword	1268, 1275
	.hword	1284, 1291
	.hword	1300, 1307
	.hword	1316, 1323
	.hword	1332, 1339
	.hword	1348, 1355
	.hword	1364, 1371
	.hword	1380, 1387
	.hword	1396, 1403
	.hword	1412, 1419
	.hword	1428, 1435
	.hword	1444, 1451
	.hword	1460, 1467
	.hword	1476, 1483
	.hword	1492, 1499
	.hword	1508, 1515
	.hword	1524, 1531
	.hword	1540, 1547
	.hword	1556, 1563
	.hword	1572, 1579
	.hword	1588, 1595
	.hword	1604, 1611
	.hword	1620, 1627
	.hword	1636, 1643
	.hword	1652, 1659
	.hword	1668, 1675
	.hword	1684, 1691
	.hword	1700, 1707
	.hword	1716, 1723
	.hword	1732, 1739
	.hword	1748, 1755
	.hword	1764, 1771
	.hword	1780, 1787
	.hword	1796, 1803
	.hword	1812, 1819
	.hword	1828, 1835
	.hword	1844, 1851
	.hword	1860, 1867
	.hword	1876, 1883
	.hword	1892, 1899
	.hword	1908, 1915
	.hword	1924, 1931
	.hword	1940, 1947
	.hword	1956, 1963
	.hword	1972, 1979
	.hword	1988, 1995
	.hword	2004, 2011
	.hword	2020, 2027
	.hword	2036, 2043
	.hword	2052, 2059
	.hword	2068, 2075
	.hword	2084, 2091
	.hword	2100, 2107
	.hword	2116, 2123
	.hword	2132, 2139
	.hword	2148, 2155
	.hword	2164, 2171
	.hword	2180, 2187
	.hword	2196, 2203
	.hword	2212, 2219
	.hword	2228, 2235
	.hword	2244, 2251
	.hword	2260, 2267
	.hword	2276, 2283
	.hword	2292, 2299
	.hword	2308, 2315
	.hword	2324, 2331
	.hword	2340, 2347
	.hword	2356, 2363
	.hword	2372, 2379
	.hword	2388, 2395
	.hword	2404, 2411
	.hword	2420, 2427
	.hword	2436, 2443
	.hword	2452, 2459
	.hword	2468, 2475
	.hword	2484, 2491
	.hword	2500, 2507
	.hword	2516, 2523
	.hword	2532, 2539
	.hword	2548, 2555
	.hword	2564, 2571
	.hword	2580, 2587
	.hword	2596, 2603
	.hword	2612, 2619
	.hword	2628, 2635
	.hword	2644, 2651
	.hword	2660, 2667
	.hword	2676, 2683
	.hword	2692, 2699
	.hword	2708, 2715
	.hword	2724, 2731
	.hword	2740, 2747
	.hword	2756, 2763
	.hword	2772, 2779
	.hword	2788, 2795
	.hword	2804, 2811
	.hword	2818, 2829
	.hword	2834, 2845
	.hword	2850, 2861
	.hword	2866, 2877
	.hword	2882, 2893
	.hword	2898, 2909
	.hword	2914, 2925
	.hword	2930, 2941
	.hword	2946, 2957
	.hword	2962, 2973
	.hword	2978, 2989
	.hword	2994, 3005
	.hword	3010, 3021
	.hword	3026, 3037
	.hword	3042, 3053
	.hword	3058, 3069
	.hword	3074, 3085
	.hword	3090, 3101
	.hword	3106, 3117
	.hword	3122, 3133
	.hword	3138, 3149
	.hword	3154, 3165
	.hword	3172, 3179
	.hword	3188, 3195
	.hword	3204, 3211
	.hword	3220, 3227
	.hword	3236, 3243
	.hword	3252, 3259
	.hword	3268, 3275
	.hword	3284, 3291
	.hword	3300, 3307
	.hword	3316, 3323
	.hword	3332, 3339
	.hword	3348, 3355
	.hword	3364, 3371
	.hword	3380, 3387
	.hword	3396, 3403
	.hword	3412, 3419
	.hword	3428, 3435
	.hword	3444, 3451
	.hword	3460, 3467
	.hword	3476, 3483
	.hword	3492, 3499
	.hword	3508, 3515
	.hword	3524, 3531
	.hword	3540, 3547
	.hword	3556, 3563
	.hword	3572, 3579
	.hword	3588, 3595
	.hword	3604, 3611
	.hword	3620, 3627
	.hword	3636, 3643
	.hword	3652, 3659
	.hword	3668, 3675
	.hword	3684, 3691
	.hword	3700, 3707
	.hword	3716, 3723
	.hword	3732, 3739
	.hword	3748, 3755
	.hword	3764, 3771
	.hword	3780, 3787
	.hword	3796, 3803
	.hword	3812, 3819
	.hword	3828, 3835
	.hword	3844, 3851
	.hword	3860, 3867
	.hword	3874, 3885
	.hword	3890, 3901
	.hword	3906, 3917
	.hword	3922, 3933
	.hword	3938, 3949
	.hword	3954, 3965
	.hword	3970, 3981
	.hword	3986, 3997
	.hword	4002, 4013
	.hword	4018, 4029
	.hword	4034, 4045
	.hword	4050, 4061
	.hword	4066, 4077
	.hword	4082, 4093
	.hword	4098, 4109
	.hword	4114, 4125
	.hword	4130, 4141
	.hword	4146, 4157
	.hword	4162, 4173
	.hword	4178, 4189
	.hword	4194, 4205
	.hword	4210, 4221
	.hword	4226, 4237
	.hword	4242, 4253
	.hword	4258, 4269
	.hword	4274, 4285
	.hword	4290, 4301
	.hword	4306, 4317
	.hword	4322, 4333
	.hword	4338, 4349
	.hword	4354, 4365
	.hword	4370, 4381
	.hword	4386, 4397
	.hword	4402, 4413
	.hword	4418, 4429
	.hword	4434, 4445
	.hword	4450, 4461
	.hword	4466, 4477
	.hword	4482, 4493
	.hword	4498, 4509
	.hword	4514, 4525
	.hword	4530, 4541
	.hword	4546, 4557
	.hword	4562, 4573
	.hword	4580, 4587
	.hword	4596, 4603
	.hword	4612, 4619
	.hword	4628, 4635
	.hword	4644, 4651
	.hword	4660, 4667
	.hword	4676, 4683
	.hword	4692, 4699
	.hword	4708, 4715
	.hword	4724, 4731
	.hword	4740, 4747
	.hword	-1
	skipped overflow list */
T_col_add_128_16:
	.hword	1584	// =#shift/8, #iterations*4
T_col_ov_128_32:
// overflow ranges: 0-1408: 8-12  18-22  mod 32 1408-2112: 8-14  16-23  mod 32 2112-2816: 8-12  18-22  mod 32 2816-3136: 8-14  16-23  mod 32
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
	.hword	680, 684
	.hword	690, 694
	.hword	712, 716
	.hword	722, 726
	.hword	744, 748
	.hword	754, 758
	.hword	776, 780
	.hword	786, 790
	.hword	808, 812
	.hword	818, 822
	.hword	840, 844
	.hword	850, 854
	.hword	872, 876
	.hword	882, 886
	.hword	904, 908
	.hword	914, 918
	.hword	936, 940
	.hword	946, 950
	.hword	968, 972
	.hword	978, 982
	.hword	1000, 1004
	.hword	1010, 1014
	.hword	1032, 1036
	.hword	1042, 1046
	.hword	1064, 1068
	.hword	1074, 1078
	.hword	1096, 1100
	.hword	1106, 1110
	.hword	1128, 1132
	.hword	1138, 1142
	.hword	1160, 1164
	.hword	1170, 1174
	.hword	1192, 1196
	.hword	1202, 1206
	.hword	1224, 1228
	.hword	1234, 1238
	.hword	1256, 1260
	.hword	1266, 1270
	.hword	1288, 1292
	.hword	1298, 1302
	.hword	1320, 1324
	.hword	1330, 1334
	.hword	1352, 1356
	.hword	1362, 1366
	.hword	1384, 1388
	.hword	1394, 1398
	.hword	1416, 1422
	.hword	1424, 1431
	.hword	1448, 1454
	.hword	1456, 1463
	.hword	1480, 1486
	.hword	1488, 1495
	.hword	1512, 1518
	.hword	1520, 1527
	.hword	1544, 1550
	.hword	1552, 1559
	.hword	1576, 1582
	.hword	1584, 1591
	.hword	1608, 1614
	.hword	1616, 1623
	.hword	1640, 1646
	.hword	1648, 1655
	.hword	1672, 1678
	.hword	1680, 1687
	.hword	1704, 1710
	.hword	1712, 1719
	.hword	1736, 1742
	.hword	1744, 1751
	.hword	1768, 1774
	.hword	1776, 1783
	.hword	1800, 1806
	.hword	1808, 1815
	.hword	1832, 1838
	.hword	1840, 1847
	.hword	1864, 1870
	.hword	1872, 1879
	.hword	1896, 1902
	.hword	1904, 1911
	.hword	1928, 1934
	.hword	1936, 1943
	.hword	1960, 1966
	.hword	1968, 1975
	.hword	1992, 1998
	.hword	2000, 2007
	.hword	2024, 2030
	.hword	2032, 2039
	.hword	2056, 2062
	.hword	2064, 2071
	.hword	2088, 2094
	.hword	2096, 2103
	.hword	2120, 2124
	.hword	2130, 2134
	.hword	2152, 2156
	.hword	2162, 2166
	.hword	2184, 2188
	.hword	2194, 2198
	.hword	2216, 2220
	.hword	2226, 2230
	.hword	2248, 2252
	.hword	2258, 2262
	.hword	2280, 2284
	.hword	2290, 2294
	.hword	2312, 2316
	.hword	2322, 2326
	.hword	2344, 2348
	.hword	2354, 2358
	.hword	2376, 2380
	.hword	2386, 2390
	.hword	2408, 2412
	.hword	2418, 2422
	.hword	2440, 2444
	.hword	2450, 2454
	.hword	2472, 2476
	.hword	2482, 2486
	.hword	2504, 2508
	.hword	2514, 2518
	.hword	2536, 2540
	.hword	2546, 2550
	.hword	2568, 2572
	.hword	2578, 2582
	.hword	2600, 2604
	.hword	2610, 2614
	.hword	2632, 2636
	.hword	2642, 2646
	.hword	2664, 2668
	.hword	2674, 2678
	.hword	2696, 2700
	.hword	2706, 2710
	.hword	2728, 2732
	.hword	2738, 2742
	.hword	2760, 2764
	.hword	2770, 2774
	.hword	2792, 2796
	.hword	2802, 2806
	.hword	2824, 2830
	.hword	2832, 2839
	.hword	2856, 2862
	.hword	2864, 2871
	.hword	2888, 2894
	.hword	2896, 2903
	.hword	2920, 2926
	.hword	2928, 2935
	.hword	2952, 2958
	.hword	2960, 2967
	.hword	2984, 2990
	.hword	2992, 2999
	.hword	3016, 3022
	.hword	3024, 3031
	.hword	3048, 3054
	.hword	3056, 3063
	.hword	3080, 3086
	.hword	3088, 3095
	.hword	3112, 3118
	.hword	3120, 3127
	.hword	3144, 3150
	.hword	3152, 3159
	.hword	-1
T_col_add_128_32:
	.hword	1056	// =#shift/8, #iterations*4
T_col_ov_128_64:
// overflow ranges: 0-1408: 13-19  23-23  28-35  39-39  44-49  55-55  mod 64 1408-2048: 15-19  23-23  28-35  39-39  44-47  mod 64
	.hword	13, 19
	.hword	23, 23
	.hword	28, 35
	.hword	39, 39
	.hword	44, 49
	.hword	55, 55
	.hword	77, 83
	.hword	87, 87
	.hword	92, 99
	.hword	103, 103
	.hword	108, 113
	.hword	119, 119
	.hword	141, 147
	.hword	151, 151
	.hword	156, 163
	.hword	167, 167
	.hword	172, 177
	.hword	183, 183
	.hword	205, 211
	.hword	215, 215
	.hword	220, 227
	.hword	231, 231
	.hword	236, 241
	.hword	247, 247
	.hword	269, 275
	.hword	279, 279
	.hword	284, 291
	.hword	295, 295
	.hword	300, 305
	.hword	311, 311
	.hword	333, 339
	.hword	343, 343
	.hword	348, 355
	.hword	359, 359
	.hword	364, 369
	.hword	375, 375
	.hword	397, 403
	.hword	407, 407
	.hword	412, 419
	.hword	423, 423
	.hword	428, 433
	.hword	439, 439
	.hword	461, 467
	.hword	471, 471
	.hword	476, 483
	.hword	487, 487
	.hword	492, 497
	.hword	503, 503
	.hword	525, 531
	.hword	535, 535
	.hword	540, 547
	.hword	551, 551
	.hword	556, 561
	.hword	567, 567
	.hword	589, 595
	.hword	599, 599
	.hword	604, 611
	.hword	615, 615
	.hword	620, 625
	.hword	631, 631
	.hword	653, 659
	.hword	663, 663
	.hword	668, 675
	.hword	679, 679
	.hword	684, 689
	.hword	695, 695
	.hword	717, 723
	.hword	727, 727
	.hword	732, 739
	.hword	743, 743
	.hword	748, 753
	.hword	759, 759
	.hword	781, 787
	.hword	791, 791
	.hword	796, 803
	.hword	807, 807
	.hword	812, 817
	.hword	823, 823
	.hword	845, 851
	.hword	855, 855
	.hword	860, 867
	.hword	871, 871
	.hword	876, 881
	.hword	887, 887
	.hword	909, 915
	.hword	919, 919
	.hword	924, 931
	.hword	935, 935
	.hword	940, 945
	.hword	951, 951
	.hword	973, 979
	.hword	983, 983
	.hword	988, 995
	.hword	999, 999
	.hword	1004, 1009
	.hword	1015, 1015
	.hword	1037, 1043
	.hword	1047, 1047
	.hword	1052, 1059
	.hword	1063, 1063
	.hword	1068, 1073
	.hword	1079, 1079
	.hword	1101, 1107
	.hword	1111, 1111
	.hword	1116, 1123
	.hword	1127, 1127
	.hword	1132, 1137
	.hword	1143, 1143
	.hword	1165, 1171
	.hword	1175, 1175
	.hword	1180, 1187
	.hword	1191, 1191
	.hword	1196, 1201
	.hword	1207, 1207
	.hword	1229, 1235
	.hword	1239, 1239
	.hword	1244, 1251
	.hword	1255, 1255
	.hword	1260, 1265
	.hword	1271, 1271
	.hword	1293, 1299
	.hword	1303, 1303
	.hword	1308, 1315
	.hword	1319, 1319
	.hword	1324, 1329
	.hword	1335, 1335
	.hword	1357, 1363
	.hword	1367, 1367
	.hword	1372, 1379
	.hword	1383, 1383
	.hword	1388, 1393
	.hword	1399, 1399
	.hword	1423, 1427
	.hword	1431, 1431
	.hword	1436, 1443
	.hword	1447, 1447
	.hword	1452, 1455
	.hword	1487, 1491
	.hword	1495, 1495
	.hword	1500, 1507
	.hword	1511, 1511
	.hword	1516, 1519
	.hword	1551, 1555
	.hword	1559, 1559
	.hword	1564, 1571
	.hword	1575, 1575
	.hword	1580, 1583
	.hword	1615, 1619
	.hword	1623, 1623
	.hword	1628, 1635
	.hword	1639, 1639
	.hword	1644, 1647
	.hword	1679, 1683
	.hword	1687, 1687
	.hword	1692, 1699
	.hword	1703, 1703
	.hword	1708, 1711
	.hword	1743, 1747
	.hword	1751, 1751
	.hword	1756, 1763
	.hword	1767, 1767
	.hword	1772, 1775
	.hword	1807, 1811
	.hword	1815, 1815
	.hword	1820, 1827
	.hword	1831, 1831
	.hword	1836, 1839
	.hword	1871, 1875
	.hword	1879, 1879
	.hword	1884, 1891
	.hword	1895, 1895
	.hword	1900, 1903
	.hword	1935, 1939
	.hword	1943, 1943
	.hword	1948, 1955
	.hword	1959, 1959
	.hword	1964, 1967
	.hword	1999, 2003
	.hword	2007, 2007
	.hword	2012, 2019
	.hword	2023, 2023
	.hword	2028, 2031
	.hword	2063, 2067
	.hword	2071, 2071
	.hword	2076, 2083
	.hword	2087, 2087
	.hword	2092, 2095
	.hword	-1
T_col_add_128_64:
	.hword	704	// =#shift/8, #iterations*4
T6_Mat2:
	.hword	-4, -4, -1893, -2054, -651, 1024, -868, 1241, -266, -1585, -1851
	.hword	-1440, 16, 1088, 1088, -17, -17, 1736, 1736, -1298, -1298, 0
	.hword	1169, 1169, -46, 68, -1428, 1455, 49, -22, -633, -1298, -1931
	.hword	1512, -85, -101, -101, 373, 373, 17, 17, -72, -72, 0
	.hword	-1457, -1457, -2124, -2031, 644, -1361, 644, -1361, 1798, 0, 1798
	.hword	-360, 1237, 1377, 1377, -1508, -1508, -1152, -1152, 72, 72, 0
	.hword	1440, 1440, -1202, -1088, -535, -606, -2012, 871, -633, 1298, 665
	.hword	287, -1169, -68, -68, 1152, 1152, -601, -601, 1298, 1298, 0
	.hword	-1148, -1148, -1621, -1782, 1970, -512, 2187, -729, -266, 1585, 1319

