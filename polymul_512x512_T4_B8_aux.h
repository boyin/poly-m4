	.p2align	2,,3
	.syntax		unified
	.text

T4_Mat1:
	.hword	1, 1, 1, 1
	.hword	1, -1, 1, -1
	.hword	8, 4, 2, 1
	.hword	8, -4, 2, -1
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
	.hword	1960
	.hword	1961
	.hword	1962
	.hword	1963
	.hword	1964
	.hword	1965
	.hword	1966
	.hword	1967
	.hword	1968
	.hword	1969
	.hword	1970
	.hword	1971
	.hword	1972
	.hword	1973
	.hword	1974
	.hword	1975
	.hword	1976
	.hword	1977
	.hword	1978
	.hword	1979
	.hword	1980
	.hword	1981
	.hword	1982
	.hword	1983
	.hword	1984
	.hword	1985
	.hword	1986
	.hword	1987
	.hword	1988
	.hword	1989
	.hword	1990
	.hword	1991
	.hword	1992
	.hword	1993
	.hword	1994
	.hword	1995
	.hword	1996
	.hword	1997
	.hword	1998
	.hword	1999
	.hword	2000
	.hword	2001
	.hword	2002
	.hword	2003
	.hword	2004
	.hword	2005
	.hword	2006
	.hword	2007
	.hword	2008
	.hword	2009
	.hword	2010
	.hword	2011
	.hword	2012
	.hword	2013
	.hword	2014
	.hword	2015
	.hword	2128
	.hword	2129
	.hword	2130
	.hword	2131
	.hword	2132
	.hword	2133
	.hword	2134
	.hword	2135
	.hword	2136
	.hword	2137
	.hword	2138
	.hword	2139
	.hword	2140
	.hword	2141
	.hword	2142
	.hword	2143
	.hword	2144
	.hword	2145
	.hword	2146
	.hword	2147
	.hword	2148
	.hword	2149
	.hword	2150
	.hword	2151
	.hword	2152
	.hword	2153
	.hword	2154
	.hword	2155
	.hword	2156
	.hword	2157
	.hword	2158
	.hword	2159
	.hword	2160
	.hword	2161
	.hword	2162
	.hword	2163
	.hword	2164
	.hword	2165
	.hword	2166
	.hword	2167
	.hword	2168
	.hword	2169
	.hword	2170
	.hword	2171
	.hword	2172
	.hword	2173
	.hword	2174
	.hword	2175
	.hword	2176
	.hword	2177
	.hword	2178
	.hword	2179
	.hword	2180
	.hword	2181
	.hword	2182
	.hword	2183
	.hword	2184
	.hword	2185
	.hword	2186
	.hword	2187
	.hword	2188
	.hword	2189
	.hword	2190
	.hword	2191
	.hword	2192
	.hword	2193
	.hword	2194
	.hword	2195
	.hword	2196
	.hword	2197
	.hword	2198
	.hword	2199
	.hword	2200
	.hword	2201
	.hword	2202
	.hword	2203
	.hword	2204
	.hword	2205
	.hword	2206
	.hword	2207
	.hword	2208
	.hword	2209
	.hword	2210
	.hword	2211
	.hword	2212
	.hword	2213
	.hword	2214
	.hword	2215
	.hword	2216
	.hword	2217
	.hword	2218
	.hword	2219
	.hword	2220
	.hword	2221
	.hword	2222
	.hword	2223
	.hword	2224
	.hword	2225
	.hword	2226
	.hword	2227
	.hword	2228
	.hword	2229
	.hword	2230
	.hword	2231
	.hword	2232
	.hword	2233
	.hword	2234
	.hword	2235
	.hword	2236
	.hword	2237
	.hword	2238
	.hword	2239
	.hword	-1
	.hword	567	// #TERMS(128,8)/4
	// max size = 12582 @ 1795
T_col_128_ov:
T_col_ov_128_8:
	// no overflow
T_col_add_128_8:
	.hword	1512	// =#shift/8, #iterations*4
T_col_ov_128_16:
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
	.hword	1794, 1805
	.hword	1810, 1821
	.hword	1826, 1837
	.hword	1842, 1853
	.hword	1858, 1869
	.hword	1874, 1885
	.hword	1890, 1901
	.hword	1906, 1917
	.hword	1922, 1933
	.hword	1938, 1949
	.hword	1954, 1965
	.hword	1970, 1981
	.hword	1986, 1997
	.hword	2002, 2013
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
	.hword	2466, 2477
	.hword	2482, 2493
	.hword	2498, 2509
	.hword	2514, 2525
	.hword	2530, 2541
	.hword	2546, 2557
	.hword	2562, 2573
	.hword	2578, 2589
	.hword	2594, 2605
	.hword	2610, 2621
	.hword	2626, 2637
	.hword	2642, 2653
	.hword	2658, 2669
	.hword	2674, 2685
	.hword	2690, 2701
	.hword	2706, 2717
	.hword	2722, 2733
	.hword	2738, 2749
	.hword	2754, 2765
	.hword	2770, 2781
	.hword	2786, 2797
	.hword	2802, 2813
	.hword	2818, 2829
	.hword	2834, 2845
	.hword	2850, 2861
	.hword	2866, 2877
	.hword	2882, 2893
	.hword	2898, 2909
	.hword	2916, 2923
	.hword	2932, 2939
	.hword	2948, 2955
	.hword	2964, 2971
	.hword	2980, 2987
	.hword	2996, 3003
	.hword	3012, 3019
	.hword	-1
T_col_add_128_16:
	.hword	1008	// =#shift/8, #iterations*4
T_col_ov_128_32:
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
	.hword	904, 919
	.hword	936, 951
	.hword	968, 983
	.hword	1000, 1015
	.hword	1032, 1047
	.hword	1064, 1079
	.hword	1096, 1111
	.hword	1128, 1143
	.hword	1160, 1175
	.hword	1192, 1207
	.hword	1224, 1239
	.hword	1256, 1271
	.hword	1288, 1303
	.hword	1320, 1335
	.hword	1352, 1356
	.hword	1362, 1366
	.hword	1384, 1388
	.hword	1394, 1398
	.hword	1416, 1420
	.hword	1426, 1430
	.hword	1448, 1452
	.hword	1458, 1462
	.hword	1480, 1484
	.hword	1490, 1494
	.hword	1512, 1516
	.hword	1522, 1526
	.hword	1544, 1548
	.hword	1554, 1558
	.hword	1576, 1580
	.hword	1586, 1590
	.hword	1608, 1612
	.hword	1618, 1622
	.hword	1640, 1644
	.hword	1650, 1654
	.hword	1672, 1676
	.hword	1682, 1686
	.hword	1704, 1708
	.hword	1714, 1718
	.hword	1736, 1740
	.hword	1746, 1750
	.hword	1768, 1772
	.hword	1778, 1782
	.hword	1800, 1815
	.hword	1832, 1847
	.hword	1864, 1879
	.hword	1896, 1911
	.hword	1928, 1943
	.hword	1960, 1975
	.hword	1992, 2007
	.hword	-1
T_col_add_128_32:
	.hword	672	// =#shift/8, #iterations*4
T_col_ov_128_64:
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
	.hword	911, 915
	.hword	919, 919
	.hword	924, 931
	.hword	935, 935
	.hword	940, 943
	.hword	975, 979
	.hword	983, 983
	.hword	988, 995
	.hword	999, 999
	.hword	1004, 1007
	.hword	1039, 1043
	.hword	1047, 1047
	.hword	1052, 1059
	.hword	1063, 1063
	.hword	1068, 1071
	.hword	1103, 1107
	.hword	1111, 1111
	.hword	1116, 1123
	.hword	1127, 1127
	.hword	1132, 1135
	.hword	1167, 1171
	.hword	1175, 1175
	.hword	1180, 1187
	.hword	1191, 1191
	.hword	1196, 1199
	.hword	1231, 1235
	.hword	1239, 1239
	.hword	1244, 1251
	.hword	1255, 1255
	.hword	1260, 1263
	.hword	1295, 1299
	.hword	1303, 1303
	.hword	1308, 1315
	.hword	1319, 1319
	.hword	1324, 1327
	.hword	-1
T_col_add_128_64:
	.hword	448	// =#shift/8, #iterations*4
T4_Mat2:
	.hword	2295, 2295, 1530, -510, 2168, -2219, -51
	.hword	-5, 1148, 765, 765, -1339, -1339, 0
	.hword	-2293, -2293, -2294, 1785, 255, 0, 255
	.hword	4, -1149, 1531, 1531, 1339, 1339, 0
	.hword	-2, -2, -1531, 1020, 2168, 2219, -204

