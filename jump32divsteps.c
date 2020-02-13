#include <stdint.h>
#include "cmsis.h"
#include <stdio.h>
extern void gf_polymul_16x16(void *h, void *f, void *g);
extern int jump16divsteps(int minusdelta, int *M, int *f, int *g);
void jump32steps(int minusdelta, int *M, int *f, int *g);
void gf_polymul_16x16_2x2_x2p2 (int *V,int *M,int *fh,int *gh);
void gf_polymul_16x16_2x2_x_2x2 (int *M, int *M1, int *M2);

#define q 4591
#define qR2inv 935519 // round(2^32/q)
#define _2P15 (1 << 15)

#if 1
// result range: +- 2295 (note: 3 loads for _2P15 and the longer qR2inv)
static inline int barrett_16x2i(int X) {
  int32_t QL = __SMLAWB(qR2inv,X,_2P15);
  int32_t QH = __SMLAWT(qR2inv,X,_2P15);
  int32_t SL = __SMULBT(q,QL);
  int32_t SH = __SMULBT(q,QH);
  return(__SSUB16(X,__PKHBT(SL,SH,16)));
}

#else 
#define barrett_16x2i(A) (A)
#endif
static int B32_1[17], B32_2[17];
int * BB32_1 = (int *)((void *)B32_1 + 2);
int * BB32_2 = (int *)((void *)B32_2 + 2);

void gf_polymul_16x16_2x2_x2p2 (int *V,int *M,int *fh,int *gh){
  int i, T, *X, *Y, *Z, *W;

  gf_polymul_16x16(BB32_1, M+16, fh); 	// x * u * fh
  gf_polymul_16x16(BB32_2, M+24, gh);	// x * v * gh
  for (X=V, Y=B32_1, Z=B32_2, W=M, i=8; i>0; i--) {// x(u fh+v gh)+f1
    //V[i] = barrett_16x2i(__SADD16(__SADD16(M[i],B32_1[i]),B32_2[i]));
    *(X++) = barrett_16x2i(__SADD16(__SADD16(*(W++),*(Y++)),*(Z++)));
  }  
  for (i=8; i>0; i--) {  
    //V[i+8] = barrett_16x2i(__SADD16(B8_1[i+32],B8_2[i+32]));
    *(X++) = barrett_16x2i(__SADD16(*(Y++),(*Z++)));
  } 
  gf_polymul_16x16(V+16, M+32, fh);	// r * fh
  gf_polymul_16x16(BB32_1, M+40, gh);	// s * gh
  for (Y=BB32_1, i=8; i>0; i--) {	// x(r fh+s gh) + g1
    //V[i+16] = barrett_16x2i(__SADD16(__SADD16((BB32_1[i],V[i+16])),M[i+8]);
    T = barrett_16x2i(__SADD16(__SADD16(*(W++),*(Y++)),*X)); *(X++) = T;
  } 
  for (i=8; i>0; i--) {  
    //V[i+24] = barrett_16x2i(__SADD16(BB32_1[i+8],V[i+24]));
    T = barrett_16x2i(__SADD16(*X, *(Y++))); *(X++) = T;
  } 
}

void gf_polymul_16x16_2x2_x_2x2 (int *M, int *M1, int *M2) {
  int i, T, *X, *Y;

  gf_polymul_16x16(BB32_1, M2, M1); 	// x * u2 * u1
  gf_polymul_16x16(M, M2+8, M1+16); 	// v2 * r1
  for (i=16, X=M, Y=B32_1; i>0; i--) {	// u = x u2 u1 + v2 r1
    //M[i] =  barrett_16x2i(__SADD16(M[i],B32_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
  gf_polymul_16x16(BB32_1, M2, M1+8); 	// x * u2 * v1
  gf_polymul_16x16(M+16, M2+8, M1+24); 	// v2 * s1
  for (i=16, Y=B32_1; i > 0; i--) {	// v = x u2 v1 + v2 s1
    //M[16+i] =  barrett_16x2i(__SADD16(M[16+i],B32_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
  gf_polymul_16x16(BB32_1, M2+16, M1); 	// x * r2 * u1
  gf_polymul_16x16(M+32, M2+24, M1+16); 	// s2 * r1
  for (i=16, Y = B32_1; i > 0; i--) {	// s = x r2 u1 + s2 r1
    //M[32+i] =  barrett_16x2i(__SADD16(M[32+i],B32_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
  gf_polymul_16x16(BB32_1, M2+16, M1+8); 	// x * r2 * v1
  gf_polymul_16x16(M+48, M2+24, M1+24); 	// s2 * s1
  for (i=16, Y = B32_1; i > 0; i--) {	// s = x r2 v1 + s2 s1
    //M[48+i] =  barrett_16x2i(__SADD16(M[48+i],B32_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
}
int jump32divsteps(int minusdelta, int *M, int *f, int *g){
int M1[96], M2[96], fg[32];
  minusdelta = jump16divsteps(minusdelta, M1, f, g);
  /*
  printf("u1 = GF4591x(");
  printn((short *)(M1+16),16);
  printf(")\n");
  printf("v1 = GF4591x(");
  printn((short *)(M1+24),16);
  printf(")\n");
  printf("r1 = GF4591x(");
  printn((short *)(M1+32),16);
  printf(")\n");
  printf("s1 = GF4591x(");
  printn((short *)(M1+40),16);
  printf(")\n");

  printf("f1 = GF4591x(");
  printn((short *)(M1),16);
  printf(")\n");
  printf("g1 = GF4591x(");
  printn((short *)(M1+8),16);
  printf(")\n");
  */
  gf_polymul_16x16_2x2_x2p2 (fg, M1, f+8, g+8);
  /*
  printf("f2 = GF4591x(");
  printn((short *)(fg),32);
  printf(")\n");
  printf("g2 = GF4591x(");
  printn((short *)(fg+16),32);
  printf(")\n");
  */
  minusdelta = jump16divsteps(minusdelta, M2, fg, fg+16);
  /*
  printf("u2 = GF4591x(");
  printn((short *)(M2+16),16);
  printf(")\n");
  printf("v2 = GF4591x(");
  printn((short *)(M2+24),16);
  printf(")\n");
  printf("r2 = GF4591x(");
  printn((short *)(M2+32),16);
  printf(")\n");
  printf("s2 = GF4591x(");
  printn((short *)(M2+40),16);
  printf(")\n");

  printf("f3 = GF4591x(");
  printn((short *)(M2),16);
  printf(")\n");
  printf("g3 = GF4591x(");
  printn((short *)(M2+8),16);
  printf(")\n");
  */
  gf_polymul_16x16_2x2_x2p2 (M, M2, fg+8, fg+24);
  gf_polymul_16x16_2x2_x_2x2(M+32, M1+16, M2+16);
  return(minusdelta);
}
