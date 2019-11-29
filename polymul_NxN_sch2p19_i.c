#include <stdint.h>
#include "cmsis.h"
#include <stdio.h>

#define q32inv 935519
#define q 4591

void gf_polymul_768x768sh (int *h, int *f, int *g);
void gf_polymul_NxN_r2p19_addto_32 (int *h, int *f, int *g, int N, int C);

#define read_32_u2d2(F,G,F0,F1,G0,G1)					\
  {									\
    __asm__ volatile ("ldr %3, [%0, #4] \n\t"				\
		      "ldr %2, [%0], #8 \n\t"				\
		      "ldr %5, [%1, #4] \n\t"				\
		      "ldr %4, [%1], #-8 \n\t"				\
		      :"+r"(F),"+r"(G),"=r"(F0),"=r"(F1),"=r"(G0),"=r"(G1) \
		      :"m"(*(int (*)[2])(F)),"m"(*(int (*)[2])(G))	\
		      );						\
  }

#define convert_64_to_32x3(A1,A2,R1,R2,R3)				\
  {									\
    int d1, d2;								\
    __asm__ volatile ("sbfx	%2, %0, #0, #19 \n\t"			\
		      "subs	%0, %0, %2 \n\t"			\
		      "sbc	%1, %1, %2, ASR #31 \n\t"		\
		      "sbfx	%3, %1, #0, #6 \n\t"			\
		      "sub	%1, %1, %3 \n\t"			\
		      "lsl	%3, %3, #13 \n\t"			\
		      "add	%3, %3, %0, LSR #19 \n\t"		\
		      "asr	%4, %1, #6 \n\t"			\
		      :"=r"(d1),"=r"(d2),"=&r"((R1)),"=&r"((R2)),"=r"((R3)) \
		      :"0"(A1),"1"(A2)					\
		      );						\
  }

#define convert_64_to_32x3_add1(A1,A2,R1,R2,R3)				\
  {									\
    int d1, d2;								\
    __asm__ volatile ("sbfx	%3, %0, #0, #19 \n\t"			\
		      "add	%2, %2, %3 \n\t"			\
		      "subs	%0, %0, %3 \n\t"			\
		      "sbc	%1, %1, %3, ASR #31 \n\t"		\
		      "sbfx	%3, %1, #0, #6 \n\t"			\
		      "sub	%1, %1, %3 \n\t"			\
		      "lsl	%3, %3, #13 \n\t"			\
		      "add	%3, %3, %0, LSR #19 \n\t"		\
		      "asr	%4, %1, #6 \n\t"			\
		      :"=r"(d1),"=r"(d2),"+&r"((R1)),"=&r"((R2)),"=r"((R3)) \
		      :"0"(A1),"1"(A2)					\
		      );						\
  }

#define mult_2x2_r2p19_to_3x64(F0,F1,G0,G1,H0L,H0H,H1L,H1H,H2L,H2H)	\
  {									\
    __asm__ volatile ("smull	%0, %1, %6, %8 \n\t"			\
		      "smull	%2, %3, %6, %9 \n\t"			\
		      "smlal	%2, %3, %7, %8 \n\t"			\
		      "smull	%4, %5, %7, %9 \n\t"			\
		      :"=&r"(H0L),"=&r"(H0H),"=&r"(H1L),"=&r"(H1H),	\
		       "=r"(H2L),"=r"(H2H)				\
		      :"r"(F0),"r"(F1),"r"(G0),"r"(G1)			\
		      );						\
  }

#define madd_2x2_r2p19_to_3x64(F0,F1,G0,G1,H0L,H0H,H1L,H1H,H2L,H2H)	\
  {									\
    __asm__ volatile ("smlal	%0, %1, %6, %8 \n\t"			\
		      "smlal	%2, %3, %6, %9 \n\t"			\
		      "smlal	%2, %3, %7, %8 \n\t"			\
		      "smlal	%4, %5, %7, %9 \n\t"			\
		      :"+&r"(H0L),"+&r"(H0H),"+&r"(H1L),"+&r"(H1H),	\
		       "+r"(H2L),"+r"(H2H)				\
		      :"r"(F0),"r"(F1),"r"(G0),"r"(G1)			\
		      );						\
  }

#define my_zero_ints(HH, NN)						\
  {									\
    int dummyH, dummyN;							\
    __asm__ volatile ("mov	r2, #0 \n\t"				\
		     "mov	r3, #0 \n\t"				\
		     "mov	r4, #0 \n\t"				\
		     "mov	r5, #0 \n\t"				\
		     "mov	r6, #0 \n\t"				\
		     "mov	r7, #0 \n\t"				\
		     "mov	r8, #0 \n\t"				\
		     "mov	r9, #0 \n\t"				\
		     "loop%=: \n\t"					\
		     "stm	%0!, {r2-r9} \n\t"			\
		     "subs 	%1, %1, #8 \n\t"			\
		     "bhi	loop%="					\
		     :"=r"(dummyH),"=r"(dummyN),"=m"(*(int (*)[4])(HH)) \
		     :"0"((HH)),"1"((NN))				\
		     :"r2","r3","r4","r5","r6","r7","r8","r9","cc"	\
		     );							\
  }

#define convert_r2p19(F, FF, NN)					\
  {									\
    int dummyF, dummyFF, dummyN;					\
    __asm__ volatile ("loop%=:\n\t"					\
		      "ldrsh	r2, [%0], #2 \n\t"			\
		      "ldrsh	r3, [%0], #2 \n\t"			\
		      "ldrsh	r4, [%0], #2 \n\t"			\
		      "ldrsh	r5, [%0], #2 \n\t"			\
		      "ldrsh	r6, [%0], #2 \n\t"			\
		      "ldrsh	r7, [%0], #2 \n\t"			\
		      "ldrsh	r8, [%0], #2 \n\t"			\
		      "ldrsh	r9, [%0], #2 \n\t"			\
		      "add	r2, r2, r3, LSL #19 \n\t"		\
		      "add	r3, r4, r5, LSL #19 \n\t"		\
		      "add	r4, r6, r7, LSL #19 \n\t"		\
		      "add	r5, r8, r9, LSL #19 \n\t"		\
		      "stm	%1!, {r2-r5} \n\t"			\
		      "subs	%2, #8 \n\t"				\
		      "bhi	loop%= \n\t"				\
		      :"=r"(dummyF),"=r"(dummyFF),"=r"(dummyN),		\
		       "=m"(*(short (*)[])(FF))				\
		      :"0"((F)),"1"((FF)),"2"((NN)),			\
		       "m"(*(short (*)[NN])(F))				\
		      :"r2","r3","r4","r5","r6","r7","r8","r9","cc"	\
		      );						\
  }

#define convert_barrett_32_to_16(HH,H,NN)				\
  {									\
    int dummyH, dummyHH, dummyNN;					\
    __asm__ volatile("loop%=:\n\t"					\
		     "ldm	%0!, {r2-r9}\n\t"			\
		     "smmulr	r10, r2, %[Q32i]\n\t"			\
		     "mla	r2, r10, %[Q], r2\n\t"			\
		     "smmulr	r10, r3, %[Q32i]\n\t"			\
		     "mla	r3, r10, %[Q], r3\n\t"			\
		     "smmulr	r10, r4, %[Q32i]\n\t"			\
		     "mla	r4, r10, %[Q], r4\n\t"			\
		     "smmulr	r10, r5, %[Q32i]\n\t"			\
		     "mla	r5, r10, %[Q], r5\n\t"			\
		     "smmulr	r10, r6, %[Q32i]\n\t"			\
		     "mla	r6, r10, %[Q], r6\n\t"			\
		     "smmulr	r10, r7, %[Q32i]\n\t"			\
		     "mla	r7, r10, %[Q], r7\n\t"			\
		     "smmulr	r10, r8, %[Q32i]\n\t"			\
		     "mla	r8, r10, %[Q], r8\n\t"			\
		     "smmulr	r10, r9, %[Q32i]\n\t"			\
		     "mla	r9, r10, %[Q], r9\n\t"			\
		     "pkhbt	r2, r2, r3, LSL #16 \n\t"		\
		     "pkhbt	r3, r4, r5, LSL #16 \n\t"		\
		     "pkhbt	r4, r6, r7, LSL #16 \n\t"		\
		     "pkhbt	r5, r8, r9, LSL #16 \n\t"		\
		     "stm	%1!, {r2-r5}\n\t"			\
		     "subs	%2, %2, #8\n\t"				\
		     "bhi	loop%=\n\t"				\
		     :"=r"(dummyHH),"=r"(dummyH),"=r"(dummyNN),		\
		      "=m"(*(short (*)[NN])(H))				\
		     :"0"((HH)),"1"((H)),"2"((NN)),			\
		      [Q]"r"(q),[Q32i]"r"(-q32inv),			\
		      "m"(*(int (*)[NN])(HH))				\
		     :"r2","r3","r4","r5","r6","r7","r8","r9","r10","cc" \
		     );							\
  }


void gf_polymul_NxNsh_r2p19_addto_32 (int *h, int *f, int *g, int N, int C) {
  int i, j, k;
  int *fi, *gi, *hi, *fo, *go;
  int f0, f1, g0, g1;
  int h0l, h0h, h1l, h1h, h2l, h2h;
  int a0, a1, a2, a3, a4, a5, a6;

  hi = h; 
  for (i=0; i<N/4; i++, hi+=4) {
    fi = f; gi = g + i * 2; j = i; 
    while (j>=0) {
      read_32_u2d2(fi,gi,f0,f1,g0,g1);
      //f0 = *(fi); f1 = *(fi+1); fi += 2;
      //g1 = *(gi+1); g0 = *gi; gi -= 2;
      mult_2x2_r2p19_to_3x64(f0,f1,g0,g1,h0l,h0h,h1l,h1h,h2l,h2h);
      //printf("\ni=%d,j=%d,k=%d (%d,%d,%d)",i,j,C,fi-f,gi-g,hi-h);
      if (j--) for (k = C-1; (j>=0) && (k>0); j--, k--) {
	  read_32_u2d2(fi,gi,f0,f1,g0,g1);
	  //f0 = *(fi); f1 = *(fi+1); fi += 2;
	  //g1 = *(gi+1); g0 = *gi; gi -= 2;
	  madd_2x2_r2p19_to_3x64(f0,f1,g0,g1,h0l,h0h,h1l,h1h,h2l,h2h);
	  //printf("\ti=%d,j=%d,k=%d (%d,%d,%d)",i,j,k,fi-f,gi-g,hi-h);
	}
      convert_64_to_32x3(h0l,h0h,a0,a1,a2);
      convert_64_to_32x3_add1(h1l,h1h,a2,a3,a4);
      convert_64_to_32x3_add1(h2l,h2h,a4,a5,a6);
      *hi += a0; *(hi+1) += a1; *(hi+2) += a2; *(hi+3) += a3;
      *(hi+4) += a4; *(hi+5) += a5; *(hi+6) += a6;
    }
  }
  fo = f; go = g + N/2 - 2; 
  for (i=N/4-2; i>=0; i--, hi+=4) {
    fi = (fo+=2) ; gi = go; j = i;
    while (j>=0) {
      read_32_u2d2(fi,gi,f0,f1,g0,g1);
      //f0 = *(fi); f1 = *(fi+1); fi += 2;
      //g1 = *(gi+1); g0 = *gi; gi -= 2;
      mult_2x2_r2p19_to_3x64(f0,f1,g0,g1,h0l,h0h,h1l,h1h,h2l,h2h);
      //printf("\ni=%d,j=%d,k=%d (%d,%d,%d)",i,j,C,fi-f,gi-g,hi-h);
      if (j--) for (k = C-1; (j>=0) && k; j--, k--) {
	  read_32_u2d2(fi,gi,f0,f1,g0,g1);
	  //f0 = *(fi); f1 = *(fi+1); fi += 2;
	  //g1 = *(gi+1); g0 = *gi; gi -= 2;
	  madd_2x2_r2p19_to_3x64(f0,f1,g0,g1,h0l,h0h,h1l,h1h,h2l,h2h);
	  //printf("\ti=%d,j=%d,k=%d (%d,%d,%d)",i,j,k,fi-f,gi-g,hi-h);
	}
      convert_64_to_32x3(h0l,h0h,a0,a1,a2);
      convert_64_to_32x3_add1(h1l,h1h,a2,a3,a4);
      convert_64_to_32x3_add1(h2l,h2h,a4,a5,a6);
      *hi += a0; *(hi+1) += a1; *(hi+2) += a2; *(hi+3) += a3;
      *(hi+4) += a4; *(hi+5) += a5; *(hi+6) += a6;

    }
  }
  //printf("\n");
}





void gf_polymul_768x768sh (int *h, int *f, int *g) {
  int ff[384], gg[384], hh[1536];
  
  convert_r2p19(f, ff, 768);
  convert_r2p19(g, gg, 768);
  my_zero_ints(hh, 1536);
  gf_polymul_NxNsh_r2p19_addto_32(hh,ff,gg,768,28);
  convert_barrett_32_to_16(hh, h, 1536);
}

void gf_polymul_16x16sh (int *h, int *f, int *g) {
  int ff[8], gg[8], hh[32];
  
  convert_r2p19(f, ff, 16);
  convert_r2p19(g, gg, 16);
  my_zero_ints(hh, 32);
  gf_polymul_NxNsh_r2p19_addto_32(hh,ff,gg,16,2);
  convert_barrett_32_to_16(hh, h, 32);
}
