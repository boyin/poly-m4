#include <stdio.h>
#include <stdlib.h>
//#include "polymul_16x16.h"
//#include "cmsis.h"

#define WARMCACHE 0
#define NUMTESTS  10
#define QQ 4591


//extern unsigned long long cpucycles(void);
//extern __m256i montproduct(__m256i x,__m256i y);

//void qsort(void *base, size_t nitems, size_t size, int (*compar)(const void *, const void*));
//int cmpfunc (const void * a, const void * b) {
//   return ( *(int*)a - *(int*)b );
//}

//extern void montmult_16x16(__m256i * zl, __m256i *zh , __m256i x , __m256i y);
//extern int jump16divsteps (int delta, __m256i *fi, __m256i *gi, __m256i *uvqr);
//int times[NUMTESTS];

void rand16 (short *b) {
  int i;
  for (i=0; i<16; i++) {
    b[i] = rand() % QQ;
    if (b[i] > QQ/2) b[i]-=QQ;
  }
}

void print8 (int *b) {
  int i,y;
  y = b[0];
  printf("((%d)+(%d)*x",(int)(short) y, (y>>16));
  for (i=1; i<4; i++) {
    y = b[i];
    printf("+(%d)*x^%d+(%d)*x^%d",(int)(short)y,2*i,(y>>16),2*i+1);
  }
  printf(")");
}

// void print8 (short *b) {
//   int i;
//   printf("((%d)+(%d)*x",b[0],b[1]);
//   for (i=2; i<8; i++) {
//     printf("+(%d)*x^%d",b[i],i);
//   }
//   printf(")");
// }
  

int main (void) {
  int i, delta;
  int ff[16], gg[16], hh[32];
  short *f = (short *)ff;
  short *g = (short *)gg;
  short *h = (short *)hh;
  //unsigned long long cycles, time1, time2;
  //int c,j;
  
  //cycles = 0;
  for (i=0; i< NUMTESTS + WARMCACHE ; i++) { 

    rand16(f); rand16(f+16);
    rand16(g); rand16(g+16);
  
    printf("f=GF4591x(");
    print8(ff);
    printf("+\nx^8*");
    print8(ff+4);
    printf("+\nx^16*");
    print8(ff+8);
    printf("+\nx^24*");
    print8(ff+12);
    printf(")\ng=GF4591x(");
    print8(gg);
    printf("+\nx^8*");
    print8(gg+4);
    printf("+\nx^16*");
    print8(gg+8);
    printf("+\nx^24*");
    print8(gg+12);
    printf(")\n");
    
    //time1  = cpucycles();
    gf_polymul_32x32_divR(hh,ff,gg);
    //time2  = cpucycles();
    printf("h = GF4591x(");
    print8(hh);
    printf("+\nx^8*");
    print8(hh+4);
    printf("+\nx^16*");
    print8(hh+8);
    printf("+\nx^24*");
    print8(hh+12);
    printf("+\nx^32*");
    print8(hh+16);
    printf("+\nx^40*");
    print8(hh+20);
    printf("+\nx^48*");
    print8(hh+24);
    printf("+\nx^56*");
    print8(hh+28);
    printf(")\n");
    
    if (i>= WARMCACHE) {
      //cycles += (time2 - time1);
      //printf("%lld ",time2-time1);
      //times[i-WARMCACHE] = time2-time1;
    }
  }
  //printf("%lld cycles ",(cycles)/NUMTESTS);
  //qsort(times, NUMTESTS, sizeof(int), cmpfunc);
  //printf("%d cycles median\n",times[NUMTESTS/2]);
  //printf("fails %d\n",fail);
  return(0);
}
