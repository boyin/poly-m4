#include <stdint.h>
#include "cmsis.h"
#include <stdio.h>
extern void gf_polymul_8x8(void *h, void *f, void *g);
extern int jump8divsteps(int minusdelta, int *M, int *f, int *g);
void jump16steps(int minusdelta, int *M, int *f, int *g);
void gf_polymul_8x8_2x2_x2p2 (int *V,int *M,int *fh,int *gh);
void gf_polymul_8x8_2x2_x_2x2 (int *M, int *M1, int *M2);

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
static int B16_1[9], B16_2[9];
int * BB16_1 = (int *)((void *)B16_1 + 2);
int * BB16_2 = (int *)((void *)B16_2 + 2);

void gf_polymul_8x8_2x2_x2p2 (int *V,int *M,int *fh,int *gh){
  int i, T, *X, *Y, *Z, *W;

  gf_polymul_8x8(BB16_1, M+8, fh); 	// x * u * fh
  gf_polymul_8x8(BB16_2, M+12, gh);	// x * v * gh
  for (X=V, Y=B16_1, Z=B16_2, W=M, i=4; i>0; i--) {// x(u fh+v gh)+f1
    //V[i] = barrett_16x2i(__SADD16(__SADD16(M[i],B16_1[i]),B16_2[i]));
    *(X++) = barrett_16x2i(__SADD16(__SADD16(*(W++),*(Y++)),*(Z++)));
  }  
  for (i=4; i>0; i--) {  
    //V[i+4] = barrett_16x2i(__SADD16(B4_1[i+16],B4_2[i+16]));
    *(X++) = barrett_16x2i(__SADD16(*(Y++),(*Z++)));
  } 
  gf_polymul_8x8(V+8, M+16, fh);	// r * fh
  gf_polymul_8x8(BB16_1, M+20, gh);	// s * gh
  for (Y=BB16_1, i=4; i>0; i--) {	// x(r fh+s gh) + g1
    //V[i+8] = barrett_16x2i(__SADD16(__SADD16((BB16_1[i],V[i+8])),M[i+4]);
    T = barrett_16x2i(__SADD16(__SADD16(*(W++),*(Y++)),*X)); *(X++) = T;
  } 
  for (i=4; i>0; i--) {  
    //V[i+12] = barrett_16x2i(__SADD16(BB16_1[i+4],V[i+12]));
    T = barrett_16x2i(__SADD16(*X, *(Y++))); *(X++) = T;
  } 
}

void gf_polymul_8x8_2x2_x_2x2 (int *M, int *M1, int *M2) {
  int i, T, *X, *Y;

  gf_polymul_8x8(BB16_1, M2, M1); 	// x * u2 * u1
  gf_polymul_8x8(M, M2+4, M1+8); 	// v2 * r1
  for (i=8, X=M, Y=B16_1; i>0; i--) {	// u = x u2 u1 + v2 r1
    //M[i] =  barrett_16x2i(__SADD16(M[i],B16_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
  gf_polymul_8x8(BB16_1, M2, M1+4); 	// x * u2 * v1
  gf_polymul_8x8(M+8, M2+4, M1+12); 	// v2 * s1
  for (i=8, Y=B16_1; i > 0; i--) {	// v = x u2 v1 + v2 s1
    //M[8+i] =  barrett_16x2i(__SADD16(M[8+i],B16_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
  gf_polymul_8x8(BB16_1, M2+8, M1); 	// x * r2 * u1
  gf_polymul_8x8(M+16, M2+12, M1+8); 	// s2 * r1
  for (i=8, Y = B16_1; i > 0; i--) {	// s = x r2 u1 + s2 r1
    //M[16+i] =  barrett_16x2i(__SADD16(M[16+i],B16_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
  gf_polymul_8x8(BB16_1, M2+8, M1+4); 	// x * r2 * v1
  gf_polymul_8x8(M+24, M2+12, M1+12); 	// s2 * s1
  for (i=8, Y = B16_1; i > 0; i--) {	// s = x r2 v1 + s2 s1
    //M[24+i] =  barrett_16x2i(__SADD16(M[24+i],B16_1[i]));
    T = barrett_16x2i(__SADD16(*X,*(Y++))); *(X++) = T;
  }
}
int jump16divsteps(int minusdelta, int *M, int *f, int *g){
int M1[48], M2[48], fg[16];
  minusdelta = jump8divsteps(minusdelta, M1, f, g);
  /*
  printf("u1 = GF4591x(");
  printn((short *)(M1+8),8);
  printf(")\n");
  printf("v1 = GF4591x(");
  printn((short *)(M1+12),8);
  printf(")\n");
  printf("r1 = GF4591x(");
  printn((short *)(M1+16),8);
  printf(")\n");
  printf("s1 = GF4591x(");
  printn((short *)(M1+20),8);
  printf(")\n");

  printf("f1 = GF4591x(");
  printn((short *)(M1),8);
  printf(")\n");
  printf("g1 = GF4591x(");
  printn((short *)(M1+4),8);
  printf(")\n");
  */
  gf_polymul_8x8_2x2_x2p2 (fg, M1, f+4, g+4);
  /*
  printf("f2 = GF4591x(");
  printn((short *)(fg),16);
  printf(")\n");
  printf("g2 = GF4591x(");
  printn((short *)(fg+8),16);
  printf(")\n");
  */
  minusdelta = jump8divsteps(minusdelta, M2, fg, fg+8);
  /*
  printf("u2 = GF4591x(");
  printn((short *)(M2+8),8);
  printf(")\n");
  printf("v2 = GF4591x(");
  printn((short *)(M2+12),8);
  printf(")\n");
  printf("r2 = GF4591x(");
  printn((short *)(M2+16),8);
  printf(")\n");
  printf("s2 = GF4591x(");
  printn((short *)(M2+20),8);
  printf(")\n");

  printf("f3 = GF4591x(");
  printn((short *)(M2),8);
  printf(")\n");
  printf("g3 = GF4591x(");
  printn((short *)(M2+4),8);
  printf(")\n");
  */
  gf_polymul_8x8_2x2_x2p2 (M, M2, fg+4, fg+12);
  gf_polymul_8x8_2x2_x_2x2(M+16, M1+8, M2+8);
  return(minusdelta);
}
