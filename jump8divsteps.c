#include <stdint.h>
#include "cmsis.h"
#include <stdio.h>

extern int jump4divsteps(int minusdelta, int *M, int *f, int *g);
extern void polymul_4x4(void *h, void *f, void *g); 
extern void polymul_4x4s(void *k, void *f, void *g); 
int jump8divsteps(int minusdelta, int *M, int *f, int *g);
void polymul_4x4_2x2_x2p2 (int *V, int *M, int *fh, int *gh);
void polymul_4x4_2x2_x_2x2 (int *M, int *M1, int *M2);

#define q 4591
#define qR2inv 935519 // round(2^32/q)
#define _2P15 (1 << 15)

#if 0
// result range: +- 2295 (note: 3 loads for _2P15 and the longer qR2inv)
static inline int barrett_16x2(int X) {
  int32_t QL = __SMLAWB(qR2inv,X,_2P15);
  int32_t QH = __SMLAWT(qR2inv,X,_2P15);
  int32_t SL = __SMULBT(q,QL);
  int32_t SH = __SMULBT(q,QH);
  return(__SSUB16(X,__PKHBT(SL,SH,16)));
}

#else 
#define barrett_16x2(A) (A)

#endif

void polymul_4x4_2x2_x2p2 (int *V, int *M, int *fh, int *gh) {
  int i, B[4];

  polymul_4x4s(V, M+4, fh); 	// x * u * fh
  polymul_4x4s(B, M+6, gh);	// x * v * gh
  for (i = 0; i < 2; i++) {	// x( u fh + v gh) + f1
    V[i] =  barrett_16x2(__SADD16(__SADD16(M[i],V[i]),B[i]));
    V[2+i] =  barrett_16x2(__SADD16(V[2+i],B[2+i]));
  }
  polymul_4x4(V+4, M+8, fh);	// r * fh
  polymul_4x4(B, M+10, gh);	// s * gh
  for (i = 0; i < 2; i++) {	// x( r fh + s gh) + g1
    V[4+i] =  barrett_16x2(__SADD16(__SADD16(M[2+i],V[4+i]),B[i]));
    V[6+i] =  barrett_16x2(__SADD16(V[6+i],B[2+i]));
  }
}

void polymul_4x4_2x2_x_2x2 (int *M, int *M1, int *M2) {
  int i, B[4];

  polymul_4x4s(M, M2, M1); 	// x * u2 * u1
  polymul_4x4(B, M2+2, M1+4); 	// v2 * r1
  for (i = 0; i < 4; i++) {	// u = x u2 u1 + v2 r1
    M[i] =  barrett_16x2(__SADD16(M[i],B[i]));
  }
  polymul_4x4s(M+4, M2, M1+2); 	// x * u2 * v1
  polymul_4x4(B, M2+2, M1+6); 	// v2 * s1
  for (i = 0; i < 4; i++) {	// v = x u2 v1 + v2 s1
    M[4+i] =  barrett_16x2(__SADD16(M[4+i],B[i]));
  }
  polymul_4x4s(M+8, M2+4, M1); 	// x * r2 * u1
  polymul_4x4(B, M2+6, M1+4); 	// s2 * r1
  for (i = 0; i < 4; i++) {	// s = x r2 u1 + s2 r1
    M[8+i] =  barrett_16x2(__SADD16(M[8+i],B[i]));
  }
  polymul_4x4s(M+12, M2+4, M1+2); 	// x * r2 * v1
  polymul_4x4(B, M2+6, M1+6); 		// s2 * s1
  for (i = 0; i < 4; i++) {	// s = x r2 v1 + s2 s1
    M[12+i] =  barrett_16x2(__SADD16(M[12+i],B[i]));
  }
}

int jump8divsteps(int minusdelta, int *M, int *f, int *g){
  int M1[24], M2[24], fg[8];

  minusdelta = jump4divsteps(minusdelta, M1, f, g);

  /*
  printf("u1 = GF4591x(");
  printn((short *)(M1+4),4);
  printf(")\n");
  printf("v1 = GF4591x(");
  printn((short *)(M1+6),4);
  printf(")\n");
  printf("r1 = GF4591x(");
  printn((short *)(M1+8),4);
  printf(")\n");
  printf("s1 = GF4591x(");
  printn((short *)(M1+10),4);
  printf(")\n");

  printf("f1 = GF4591x(");
  printn((short *)(M1),4);
  printf(")\n");
  printf("g1 = GF4591x(");
  printn((short *)(M1+2),4);
  printf(")\n");
  */
  polymul_4x4_2x2_x2p2 (fg, M1, f+2, g+2);

  /*
  printf("f2 = GF4591x(");
  printn((short *)(fg),8);
  printf(")\n");
  printf("g2 = GF4591x(");
  printn((short *)(fg+4),8);
  printf(")\n");
  */
  
  minusdelta = jump4divsteps(minusdelta, M2, fg, fg+4);

  /*
  printf("u2 = GF4591x(");
  printn((short *)(M2+4),4);
  printf(")\n");
  printf("v2 = GF4591x(");
  printn((short *)(M2+6),4);
  printf(")\n");
  printf("r2 = GF4591x(");
  printn((short *)(M2+8),4);
  printf(")\n");
  printf("s2 = GF4591x(");
  printn((short *)(M2+10),4);
  printf(")\n");
  
  printf("f3 = GF4591x(");
  printn((short *)(M2),4);
  printf(")\n");
  printf("g3 = GF4591x(");
  printn((short *)(M2+2),4);
  printf(")\n");
  */
  
  polymul_4x4_2x2_x2p2 (M, M2, fg+2, fg+6);
  polymul_4x4_2x2_x_2x2(M+8, M1+4, M2+4);
  return(minusdelta);
}

