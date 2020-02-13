#include "red-asm.h"
// N=768 requires 157464=8x19683 storage

#include "polymul_768x768_B4_aux.h"
	.p2align	2,,3	
	.syntax		unified
	.text
// void gf_polymul_768x768_divR (int32_t *h, int32_t *f, int32_t *g);
	.global gf_polymul_768x768_divR
	.type	gf_polymul_768x768_divR, %function
gf_polymul_768x768_divR:
