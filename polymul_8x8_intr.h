//#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
// #include "params.h"
#include "cmsis.h"

#ifndef __POLYMUL_16X16_H
#define __POLYMUL_16X16_H

#define q 4591
#define qinv 15631
#define q16 14 // round(2^16/q)
#define qR2inv 935519 // round(2^32/q)
#define _2P15 (1 << 15)
typedef int32_t int16x2;

/* caller must ensure that x-y does not overflow */
static inline int smaller_mask(int x,int y)
{
  return (x - y) >> 31;
}

// result range: +- 4591 (note: 2 loads for M1 and M)
static inline int32_t mm_hi(int32_t P, int32_t M, int32_t M1){
  int32_t d = __SMULBB(P,M1);
  int32_t e = __SMLABB(d,M,P);
  return(e);
}

// result range: +- 2295 (note: 3 loads for _2P15 and the longer qR2inv)
static inline int32_t barrett_16x2(int16x2 X) {
  int32_t QL = __SMLAWB(qR2inv,X,_2P15);
  int32_t QH = __SMLAWT(qR2inv,X,_2P15);
  int32_t SL = __SMULBT(q,QL);
  int32_t SH = __SMULBT(q,QH);
  return(__SSUB16(X,__PKHBT(SL,SH,16)));
}

// result range: +- 2881 (note: 2 loads for _2P15 and q16)
static inline int32_t  barrett_fake_16x2(int16x2 X) {
  int32_t QL = __SMLABB(q16,X,_2P15);
  int32_t QH = __SMLABT(q16,X,_2P15);
  int32_t SL = __SMULBT(q,QL);
  int32_t SH = __SMULBT(q,QH);
  return(__SSUB16(X,__PKHBT(SL,SH,16)));
}

// result range: +- 2512 (note that SMMULR takes twice as long)
static inline int32_t barrett_32(int32_t X) {
  int32_t Q = __SMMULR(qR2inv,X);
  return(__MLS(q,Q,X));
}

//define USE_VEC16
//#define ARM_VEC16

static inline int16_t montproduct_16 (int16_t x, int16_t y) {

  int32_t a = __SMULBB(x,y);
  int32_t e = mm_hi(a,q,-qinv);
  return(((uint32_t) e >> 16));
 
  /*
  int32_t a = (int32_t) x * (int32_t) y;
  int16_t d = (int16_t) a * (int16_t) qinv;
  int32_t e = (int32_t) d * (int32_t) q;
  return((int16_t) ((a-e) >> 16)); 
  */
}


static inline int16x2 montproduct_16x2 (int16x2 x, int16_t y) {
  
  int32_t ab = __SMULBB(x,y);
  int32_t eb = mm_hi(ab,q,-qinv);
  
  int32_t at = __SMULTB(x,y);
  int32_t et = mm_hi(at,q,-qinv);
  
  return(et | ((uint32_t) eb) >> 16); 
  
  /*
  int16_t x_lo = (int16_t) x;
  int16_t x_hi = x >> 16;
  
  int32_t a_lo = (int32_t) x_lo * (int32_t) y;
  int16_t d_lo = (int16_t) a_lo * (int16_t) qinv;
  int32_t e_lo = (int32_t) d_lo * (int32_t) q;
  int32_t r_lo = (((uint32_t) (a_lo-e_lo)) >> 16);
  
  int32_t a_hi = (int32_t) x_hi * (int32_t) y;
  int16_t d_hi = (int16_t) a_hi * (int16_t) qinv;
  int32_t e_hi = (int32_t) d_hi * (int32_t) q;
  int32_t r_hi = (a_hi - e_hi); 
  
  return(r_hi | r_lo); 
  */
}

static inline int16x2 montproduct_16x2x2 (int16x2 x, int16x2 y) {

  int32_t ab = __SMULBB(x,y);
  int32_t eb = mm_hi(ab,q,-qinv);
  
  int32_t at = __SMULTT(x,y);
  int32_t et = mm_hi(at,q,-qinv);
  
  return(et | ((uint32_t) eb >> 16));

  /*
  int16_t y_lo = (int16_t) y;
  int16_t y_hi = y >> 16;
  int16_t x_lo = (int16_t) x;
  int16_t x_hi = x >> 16;
  
  int32_t a_lo = (int32_t) x_lo * (int32_t) y_lo;
  int16_t d_lo = (int16_t) a_lo * (int16_t) qinv;
  int32_t e_lo = (int32_t) d_lo * (int32_t) q;
  
  int32_t a_hi = (int32_t) x_hi * (int32_t) y_hi;
  int16_t d_hi = (int16_t) a_hi * (int16_t) qinv;
  int32_t e_hi = (int32_t) d_hi * (int32_t) q;
  
  return((a_hi-e_hi) | (((uint32_t) (a_lo-e_lo))>>16)); 
  */
}

/*
void print8 (short *b) {
  int i;
  printf("((%d)+(%d)*x",b[0],b[1]);
  for (i=2; i<8; i++) {
    printf("+(%d)*x^%d",b[i],i);
  }
  printf(")");
}
*/

static inline void print8 (int *b) {
  int i,y;
  y = b[0];
  printf("((%d)+(%d)*x",(int)(short) y, (y>>16));
  for (i=1; i<4; i++) {
    y = b[i];
    printf("+(%d)*x^%d+(%d)*x^%d",(int)(short)y,2*i,(y>>16),2*i+1);
  }
  printf(")");
}


#ifndef TEST
static inline void gf_polymul_4x4_divR(int32_t volatile *z, const int32_t *x, const int32_t *y) {
  int32_t x01 = x[0];
  int32_t x23 = x[1];
  int32_t y01 = y[0];
  int32_t y23 = y[1];
  int32_t x12 = ((uint32_t) x01 >> 16) | (x23 << 16);
  
  int32_t z0 = __SMULBB(x01,y01);
  int32_t z1 = __SMUADX(x01,y01);
  int32_t z6 = __SMULTT(x23,y23);
  int32_t z5 = __SMUADX(x23,y23);
  int32_t z3 = __SMUADX(x01,y23);
  z3 = __SMLADX(x23,y01,z3);
  int32_t z4 = __SMULTT(x23,y01);
  int32_t z2 = __SMULBB(x01,y23);
  z2 = __SMLADX(x12,y01,z2);
  z4 = __SMLADX(x12,y23,z4);

  int32_t e0 = mm_hi(z0,q,-qinv);
  int32_t e1 = mm_hi(z1,q,-qinv);
  int32_t e2 = mm_hi(z2,q,-qinv);
  int32_t e3 = mm_hi(z3,q,-qinv);
  ((int32_t volatile *)z)[0] = (e1 | (((uint32_t) e0) >> 16));
  ((int32_t volatile *)z)[1] = (e3 | (((uint32_t) e2) >> 16));
  int32_t e4 = mm_hi(z4,q,-qinv);
  int32_t e5 = mm_hi(z5,q,-qinv);
  int32_t e6 = mm_hi(z6,q,-qinv);
  ((int32_t volatile *)z)[2] = (e5 | (((uint32_t) e4) >> 16));
  ((int32_t volatile *)z)[3] = (((uint32_t) e6) >> 16);
}


static  inline void gf_polymul_8x8_divR(int32_t *z, const int32_t *x, const int32_t *y) {
  int32_t x01[2];
  int32_t y01[2];
  int32_t z01[4];
  
  x01[0] = __SADD16(x[0],x[2]);
  x01[1] = __SADD16(x[1],x[3]);
  y01[0] = __SADD16(y[0],y[2]);
  y01[1] = __SADD16(y[1],y[3]);
  
  gf_polymul_4x4_divR(z,x,y);
  //printf("z0=GF4591("); print8(z); printf(")\n");
  gf_polymul_4x4_divR(z+4,x+2,y+2);
  //printf("z1=GF4591("); print8(z+8); printf(")\n");
  gf_polymul_4x4_divR(z01,x01,y01);
  //printf("z01=GF4591("); print8(z01); printf(")\n");
  
  int32_t t0L = __SSUB16(z[4],z[2]);
  int32_t t0H = __SSUB16(z[5],z[3]);
  int32_t t1L = __SSUB16(t0L,z[6]);
  int32_t t1H = __SSUB16(t0H,z[7]);
  t0L = __SADD16(t0L,z[0]);
  t0H = __SADD16(t0H,z[1]);
  ((int32_t volatile *)z)[2] = __SSUB16(z01[0],t0L);
  ((int32_t volatile *)z)[3] = __SSUB16(z01[1],t0H);
  ((int32_t volatile *)z)[4] = __SADD16(z01[2],t1L);
  ((int32_t volatile *)z)[5] = __SADD16(z01[3],t1H);
  
}

static  inline void gf_polymul_8x8_divR_negc(int32_t *z, int32_t *x, int32_t *y) {
  int32_t x01[2];
  int32_t y01[2];
  int32_t z01[4];
  
  x01[0] = __SADD16(x[0],x[2]);
  x01[1] = __SADD16(x[1],x[3]);
  y01[0] = __SADD16(y[0],y[2]);
  y01[1] = __SADD16(y[1],y[3]);
 
  gf_polymul_4x4_divR(z,x,y);
  gf_polymul_4x4_divR(z+4,x+2,y+2);
  gf_polymul_4x4_divR(z01,x01,y01);
  
  int32_t t1L = __SSUB16(z[2],z[4]);
  int32_t t1H = __SSUB16(z[3],z[5]);
  int32_t t0L = __SADD16(z[0],z[6]);
  int32_t t0H = __SADD16(z[1],z[7]);
  int32_t s0L = __SADD16(t0L,t1L);
  int32_t s0H = __SADD16(t0H,t1H);
  int32_t s1L = __SSUB16(t1L,t0L);
  int32_t s1H = __SSUB16(t1H,t0H);
  
  z[2] = __SADD16(z01[0],s1L);
  z[3] = __SADD16(z01[1],s1H);
  z[0] = __SSUB16(s0L,z01[2]);
  z[1] = __SSUB16(s0H,z01[3]);
  
}


#else

static inline void gf_polymul_4x4_divR(int16_t *z, const int16_t *x, const int16_t *y) {
  int32_t x01 = *((int32_t *)x);
  int32_t x23 = *((int32_t *)(x+2));
  int32_t y01 = *((int32_t *)y);
  int32_t y23 = *((int32_t *)(y+2));
  int32_t x12 = *((int32_t *)(x+1));
  
  int32_t z0 = __SMULBB(x01,y01);
  int32_t z1 = __SMUADX(x01,y01);
  int32_t z6 = __SMULTT(x23,y23);
  int32_t z5 = __SMUADX(x23,y23);
  int32_t z3 = __SMUADX(x01,y23);
  z3 = __SMLADX(x23,y01,z3);
  int32_t z4 = __SMULTT(x23,y01);
  int32_t z2 = __SMULBB(x01,y23);
  z2 = __SMLADX(x12,y01,z2);
  z4 = __SMLADX(x12,y23,z4);

  int32_t e0 = mm_hi(z0,q,-qinv);
  int32_t e1 = mm_hi(z1,q,-qinv);
  int32_t e2 = mm_hi(z2,q,-qinv);
  int32_t e3 = mm_hi(z3,q,-qinv);
  *((int32_t *)z) = (e1 | (((uint32_t) e0) >> 16));
  *((int32_t *)(z+2)) = (e3 | (((uint32_t) e2) >> 16));
  int32_t e4 = mm_hi(z4,q,-qinv);
  int32_t e5 = mm_hi(z5,q,-qinv);
  int32_t e6 = mm_hi(z6,q,-qinv);
  *((int32_t *)(z+4)) = (e5 | (((uint32_t) e4) >> 16));
  *((int32_t *)(z+6)) = (((uint32_t) e6) >> 16);
}


static  inline void gf_polymul_8x8_divR(int16_t *z, const int16_t *x, const int16_t *y) {
  int16_t x01[4];
  int16_t y01[4];
  int16_t z01[8];
  
  *((int32_t *)x01) = __SADD16(*((int32_t *)x),*((int32_t *)(x+4)));
  *((int32_t *)(x01+2)) = __SADD16(*((int32_t *)(x+2)),*((int32_t *)(x+6)));
  *((int32_t *)y01) = __SADD16(*((int32_t *)y),*((int32_t *)(y+4)));
  *((int32_t *)(y01+2)) = __SADD16(*((int32_t *)(y+2)),*((int32_t *)(y+6)));
  
  gf_polymul_4x4_divR(z,x,y);
  printf("z0=GF4591("); print8(z); printf(")\n");
  gf_polymul_4x4_divR(z+8,x+4,y+4);
  printf("z1=GF4591("); print8(z+8); printf(")\n");
  gf_polymul_4x4_divR(z01,x01,y01);
  printf("z01=GF4591("); print8(z01); printf(")\n");
  
  int32_t t0L = __SSUB16(*((int32_t *)(z+8)),*((int32_t *)(z+4)));
  int32_t t0H = __SSUB16(*((int32_t *)(z+10)),*((int32_t *)(z+6)));
  int32_t t1L = __SSUB16(t0L,*((int32_t *)(z+12)));
  int32_t t1H = __SSUB16(t0H,*((int32_t *)(z+14)));
  t0L = __SADD16(t0L,*((int32_t *)z));
  t0H = __SADD16(t0H,*((int32_t *)(z+2)));
  *((int32_t *)(z+4)) = __SSUB16(*((int32_t *)z01),t0L);
  *((int32_t *)(z+6)) = __SSUB16(*((int32_t *)(z01+2)),t0H);
  *((int32_t *)(z+8)) = __SADD16(*((int32_t *)(z01+4)),t1L);
  *((int32_t *)(z+10)) = __SADD16(*((int32_t *)(z01+6)),t1H);
  
}


static  inline void gf_polymul_8x8_divR_negc(int16_t *z, int16_t *x, int16_t *y) {
  int16_t x01[4];
  int16_t y01[4];
  int16_t z01[8];
  
  *((int32_t *)x01) = __SADD16(*((int32_t *)x),*((int32_t *)(x+4)));
  *((int32_t *)(x01+2)) = __SADD16(*((int32_t *)(x+2)),*((int32_t *)(x+6)));
  *((int32_t *)y01) = __SADD16(*((int32_t *)y),*((int32_t *)(y+4)));
  *((int32_t *)(y01+2)) = __SADD16(*((int32_t *)(y+2)),*((int32_t *)(y+6)));

  gf_polymul_4x4_divR(z,x,y);
  gf_polymul_4x4_divR(z+8,x+4,y+4);
  gf_polymul_4x4_divR(z01,x01,y01);
  
  int32_t t1L = __SSUB16(*((int32_t *)(z+4)),*((int32_t *)(z+8)));
  int32_t t1H = __SSUB16(*((int32_t *)(z+6)),*((int32_t *)(z+10)));
  int32_t t0L = __SADD16(*((int32_t *)z),*((int32_t *)(z+12)));
  int32_t t0H = __SADD16(*((int32_t *)(z+2)),*((int32_t *)(z+14)));
  int32_t s0L = __SADD16(t0L,t1L);
  int32_t s0H = __SADD16(t0H,t1H);
  int32_t s1L = __SSUB16(t1L,t0L);
  int32_t s1H = __SSUB16(t1H,t0H);
  
  *((int32_t *)(z+4)) = __SADD16(*((int32_t *)z01),s1L);
  *((int32_t *)(z+6)) = __SADD16(*((int32_t *)(z01+2)),s1H);
  *((int32_t *)z) = __SSUB16(s0L,*((int32_t *)(z01+4)));
  *((int32_t *)(z+2)) = __SSUB16(s0H,*((int32_t *)(z01+6)));
  
}

#endif





#endif
