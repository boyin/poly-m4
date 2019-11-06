#ifndef _NUSS_
#define _NUSS_ 1
#include "cmsis.h"

#define q 4591
#define qm2p16 -300875776
#define q32inv 935519
#define qinv 15631

extern void gf_polymul_8x8_divR_negc(int *h, int *f, int *g);

#define load8(F,A,B,C,D) /* (A,B,C,D) = 8-poly at F         */		\
  __asm__ volatile ("ldr %0, [%4] \n\t"		/* load F01 */		\
		    "ldr %1, [%4, #4] \n\t"	/* load F23 */		\
		    "ldr %2, [%4, #8] \n\t"	/* load F45 */		\
		    "ldr %3, [%4, #12]"		/* load F67 */		\
		    : "=&r"((A)), "=&r"((B)), "=&r"((C)), "=&r"((D))	\
		    : "r"((F)), "m"(*(const int (*)[4]) (F))		\
		    ) 
#define load8a(F,A,B,C,D,E) /* as above except  (lvalue)F+=E  */	\
  __asm__ volatile  ("ldr %0, [%4], #4 \n\t"	/* load F01 */		\
		     "ldr %1, [%4], #4 \n\t"	/* load F23 */		\
		     "ldr %2, [%4], #4 \n\t"	/* load F45 */		\
		     "ldr %3, [%4], %6"		/* load F67 */		\
		     : "=&r"((A)), "=&r"((B)), "=&r"((C)), "=&r"((D)), "+r"((F))\
		     : "m"(*(const int (*)[4]) (F)),"X"((E)-12)		\
		     ) 

#define load8x(F,A,B,C,D) /* (A,B,C,D) = 8-poly at F / x mod(x^8+1) */	\
  __asm__ volatile ("ldrh %0, [%4, #14] \n\t"	/* load F7  */		\
                    "ldrsh %1, [%4] \n\t"	/* load F0  */		\
		    "sub %3, %0, %1, LSL #16\n\t"/* = F70x  */		\
		    "ldr %0, [%4, #2] \n\t"	/* load F12 */		\
		    "ldr %1, [%4, #6] \n\t"	/* load F34 */		\
		    "ldr %2, [%4, #10]"		/* load F56 */		\
		    : "=&r"((A)), "=&r"((B)), "=&r"((C)), "=&r"((D))	\
		    : "r"((F)), "m"(*(const int (*)[4]) (F))		\
		    ) 
#define load8xa(F,A,B,C,D,E) /* as above except  (lvalue)F+=E */	\
  __asm__ volatile ("ldrh %0, [%4, #14] \n\t"	/* load F7  */		\
                    "ldrsh %1, [%4], #2 \n\t"	/* load F0  */		\
		    "sub %3, %0, %1, LSL #16\n\t"/* = F70x  */		\
		    "ldr %0, [%4], #4 \n\t"	/* load F12 */		\
		    "ldr %1, [%4], #4 \n\t"	/* load F34 */		\
		    "ldr %2, [%4], %5"          /* load F56 */		\
		    : "=&r"((A)), "=&r"((B)), "=&r"((C)), "=&r"((D))	\
		    : "r"((F)), "X"(E-10), "m"(*(const int (*)[4]) (F))	\
		    ) 

//#define store8(F,A,B,C,D) /* store 8-poly (A,B,C,D) at F     */	\
  __asm__ volatile ("str %1, [%5] \n\t"		/* store F01 */		\
		    "str %2, [%5, #4] \n\t"	/* store F23 */		\
		    "str %3, [%5, #8] \n\t"	/* store F45 */		\
		    "str %4, [%5, #12]"		/* store F67 */		\
		    : "=m"(*(int (*)[4]) (F))				\
		    : "r"((A)), "r"((B)), "r"((C)), "r"((D)), "r"((F))	\
		    ) 

#define store8a(F,A,B,C,D,E) /* as above except  (lvalue)F+=E  */	\
  __asm__ volatile ("str %2, [%0], #4 \n\t"	/* store F01 */		\
		    "str %3, [%0], #4 \n\t"	/* store F23 */		\
		    "str %4, [%0], #4 \n\t"	/* store F45 */		\
		    "str %5, [%0], %6"	/* store F67 */			\
		    : "+r"((F)),  "=m"(*(int (*)[4]) (F))		\
		    : "r"((A)), "r"((B)), "r"((C)), "r"((D)), "X"((E)-12) \
		    ) 

#define store8xa(F,A,B,C,D,E) /* store 8-poly(A,B,C,D)*x mod(x^8+1) at F */ \
  __asm__ volatile ("str %3, [%1, #2] \n\t"	/* store F23 */		\
		    "str %4, [%1, #6] \n\t"	/* store F45 */		\
		    "str %5, [%1, #10] \n\t"	/* store F67 */		\
		    "rsb %3, %2, #0\n\t"				\
		    "strh %3, [%1, #14] \n\t"	/* store -F0 */		\
		    "asr %2, %2, #16\n\t"				\
		    "strh %2, [%1], %6"	/* store F1  */			\
		    : "=m"(*(int (*)[4]) (F)), "+r"((F)),		\
		      "+r"((A)), "+r"((B))				\
		    :   "r"((C)), "r"((D)), "X"((E))			\
		    ) 


#define reduce8a(A,N) /* reduce N elements, 8|N */			\
  __asm__ volatile ("mov lr, %2 \n\t"					\
		    "mov r7, %3  \n\t"					\
		    "movt r7, %4 \n\t"					\
		    "mov r9, %5  \n\t"					\
		    "lsl r9, r9, #16 \n\t"				\
		    "mov r8, #32768\n\t"				\
		    "loop%=: \n\t"					\
		    "ldr r3, [%1] \n\t"					\
		    "ldr r4, [%1,#4] \n\t"				\
		    "ldr r5, [%1,#8] \n\t"				\
		    "ldr r6, [%1,#12] \n\t"				\
		    "smlawt r11, r7, r3, r8 \n\t"			\
		    "asr r11, #16 \n\t"					\
		    "mla r12, r11, r9, r3 \n\t"				\
		    "smlawb r11, r7, r3, r8 \n\t"			\
		    "smlatt r3, r11, r9, r3 \n\t"			\
		    "smlawt r10, r7, r4, r8 \n\t"			\
		    "asr r10, #16 \n\t"					\
		    "mla r11, r10, r9, r4 \n\t"				\
		    "smlawb r10, r7, r4, r8 \n\t"			\
		    "smlatt r4, r10, r9, r4 \n\t"			\
		    "pkhbt r3, r3, r12 \n\t"				\
		    "pkhbt r4, r4, r11 \n\t"				\
		    "smlawt r11, r7, r5, r8 \n\t"			\
		    "asr r11, #16 \n\t"					\
		    "mla r12, r11, r9, r5 \n\t"				\
		    "smlawb r11, r7, r5, r8 \n\t"			\
		    "smlatt r5, r11, r9, r5 \n\t"			\
		    "smlawt r10, r7, r6, r8 \n\t"			\
		    "asr r10, #16 \n\t"					\
		    "mla r11, r10, r9, r6 \n\t"				\
		    "smlawb r10, r7, r6, r8 \n\t"			\
		    "smlatt r6, r10, r9, r6 \n\t"			\
		    "pkhbt r5, r5, r12 \n\t"				\
		    "pkhbt r6, r6, r11 \n\t"				\
		    "str r3, [%1],#4 \n\t"				\
		    "str r4, [%1],#4 \n\t"				\
		    "str r5, [%1],#4 \n\t"				\
		    "str r6, [%1],#4 \n\t"				\
		    "subs lr, #16 \n\t"					\
		    "bne loop%= \n\t"					\
		    "sub %1, %2 \n\t"					\
		    :"+m" (*(const char (*)[]) A)			\
		    :"r"(A), "X"(N), "X"(q32inv % 65536),		\
		     "X"(q32inv / 65536), "X"(65536-q)			\
		    :"r3","r4","r5","r6","r7","r8","r9","r10","r11",	\
		     "r12","lr","cc"					\
		    )

#define tr88r(A,B) /* transpose, reduce 8x8  */				\
  __asm__ volatile ("mov lr, #8 \n\t"					\
		    "ldr r7, = %4 \n\t"					\
		    "ldr r9, = %5 \n\t"					\
		    "mov r8, #32768\n\t"				\
		    "loop%=: \n\t"					\
		    "ldr r4, [%1, #16] \n\t"				\
		    "ldr r5, [%1, #32] \n\t"				\
		    "ldr r6, [%1, #48] \n\t"				\
		    "ldr r3, [%1], #4 \n\t"				\
		    "smlawt r11, r7, r3, r8 \n\t"			\
		    "asr r11, #16 \n\t"					\
		    "mla r12, r11, r9, r3 \n\t"				\
		    "smlawb r11, r7, r3, r8 \n\t"			\
		    "smlatt r3, r11, r9, r3 \n\t"			\
		    "smlawt r10, r7, r4, r8 \n\t"			\
		    "asr r10, #16 \n\t"					\
		    "mla r11, r10, r9, r4 \n\t"				\
		    "smlawb r10, r7, r4, r8 \n\t"			\
		    "smlatt r4, r10, r9, r4 \n\t"			\
		    "pkhbt r3, r3, r4, LSL #16\n\t"			\
		    "pkhtb r4, r11, r12, ASR #16 \n\t"			\
		    "smlawt r11, r7, r5, r8 \n\t"			\
		    "asr r11, #16 \n\t"					\
		    "mla r12, r11, r9, r5 \n\t"				\
		    "smlawb r11, r7, r5, r8 \n\t"			\
		    "smlatt r5, r11, r9, r5 \n\t"			\
		    "smlawt r10, r7, r6, r8 \n\t"			\
		    "asr r10, #16 \n\t"					\
		    "mla r11, r10, r9, r6 \n\t"				\
		    "smlawb r10, r7, r6, r8 \n\t"			\
		    "smlatt r6, r10, r9, r6 \n\t"			\
		    "pkhbt r5, r5, r6, LSL #16 \n\t"			\
		    "pkhtb r6, r11, r12, ASR #16 \n\t"			\
		    "str r4, [%2, #16] \n\t"				\
		    "str r5, [%2, #4] \n\t"				\
		    "str r6, [%2, #20] \n\t"				\
		    "str r3, [%2], #32 \n\t"				\
		    "subs lr, #1 \n\t"					\
		    "beq end%= \n\t"					\
		    "tst lr, #3\n\t"					\
		    "itt eq \n\t"					\
		    "addeq %1, #48 \n\t"				\
		    "subeq %2, #120 \n\t"				\
		    "b loop%= \n\t"					\
		    "end%=: \n\t"					\
		    "sub %1, %1, #80 \n\t"				\
		    "sub %2, %2, #136 \n\t"				\
		    : "=m"(*(int (*)[64])(B))				\
		    : "r"((A)), "r"((B)), "m"(*(const int (*)[32])(A)), \
		      "X"(q32inv), "X"(qm2p16)				\
		    : "r3","r4","r5","r6","r7","r8","r9","r10","r11",	\
		      "r12","lr","cc"					\
		    )

#define tr88x(A,B) /* transpose 8x8 make extra copy */			\
  __asm__ volatile ("mov lr, #32 \n\t"					\
		    "loop%=: \n\t"					\
		    "ldr r9, [%1, #16] \n\t"				\
		    "ldr r10, [%1, #48] \n\t"				\
		    "ldr r11, [%1, #80] \n\t"				\
		    "ldr r12, [%1, #112] \n\t"				\
		    "ldr r5, [%1, #32] \n\t"				\
		    "ldr r6, [%1, #64] \n\t"				\
		    "ldr r7, [%1, #96] \n\t"				\
		    "ldr r4, [%1], #4 \n\t"				\
		    "pkhtb r8, r9, r4, ASR #16 \n\t"			\
		    "pkhbt r4, r4, r9, LSL #16 \n\t"			\
		    "pkhtb r9, r10, r5, ASR #16 \n\t"			\
		    "pkhbt r5, r5, r10, LSL #16 \n\t"			\
		    "pkhtb r10, r11, r6, ASR #16 \n\t"			\
		    "pkhbt r6, r6, r11, LSL #16 \n\t"			\
		    "pkhtb r11, r12, r7, ASR #16 \n\t"			\
		    "pkhbt r7, r7, r12, LSL #16 \n\t"			\
		    "str r11, [%2, #156] \n\t"				\
		    "str r11, [%2, #28] \n\t"				\
		    "str r10, [%2, #152] \n\t"				\
		    "str r10, [%2, #24] \n\t"				\
		    "str r9, [%2, #148] \n\t"				\
		    "str r9, [%2, #20] \n\t"				\
		    "str r8, [%2, #144] \n\t"				\
		    "str r8, [%2, #16] \n\t"				\
		    "str r7, [%2, #140] \n\t"				\
		    "str r7, [%2, #12] \n\t"				\
		    "str r6, [%2, #136] \n\t"				\
		    "str r6, [%2, #8] \n\t"				\
		    "str r5, [%2, #132] \n\t"				\
		    "str r5, [%2, #4] \n\t"				\
		    "str r4, [%2, #128] \n\t"				\
		    "str r4, [%2], #32 \n\t"				\
		    "subs lr, #8 \n\t"					\
		    "bne loop%= \n\t"					\
		    "sub %1, %1, #16 \n\t"				\
		    "sub %2, %2, #128\n\t"				\
		    : "=m"(*(int (*)[64])(B))			\
		    : "r"((A)), "r"((B)), "m"(*(const int (*)[32])(A))	\
		    : "r4","r5","r6","r7","r8","r9","r10","r11",	\
		      "r12","lr","cc"					\
		    )

#define bct8_1(F,G,E)					\
  {							\
  int f01, f23, f45, f67;				\
  int g01, g23, g45, g67;				\
  int t01, t23, t45, t67;				\
							\
  load8((F), f01, f23, f45, f67);			\
  load8((G), t01, t23, t45, t67);			\
							\
  g01 = __SSUB16(f01,t01); g23 = __SSUB16(f23,t23);	\
  g45 = __SSUB16(f45,t45); g67 = __SSUB16(f67,t67);	\
  store8a(G, g01, g23, g45, g67, (E));			\
							\
  f01 = __SADD16(f01,t01); f23 = __SADD16(f23,t23);	\
  f45 = __SADD16(f45,t45); f67 = __SADD16(f67,t67);	\
  store8a(F, f01, f23, f45, f67, (E));			\
  }

#define bct8_y4(F,G,E)				\
  {						\
  int f01, f23, f45, f67;			\
  int g01, g23, g45, g67;			\
  int t01, t23, t45, t67;			\
						\
  load8(F, f01, f23, f45, f67);			\
  load8(G, t01, t23, t45, t67);			\
							\
  g01 = __SADD16(f01,t45); g23 = __SADD16(f23,t67);	\
  g45 = __SSUB16(f45,t01); g67 = __SSUB16(f67,t23);	\
  store8a(G, g01, g23, g45, g67, (E));			\
							\
  f01 = __SSUB16(f01,t45); f23 = __SSUB16(f23,t67);	\
  f45 = __SADD16(f45,t01); f67 = __SADD16(f67,t23);	\
  store8a(F, f01, f23, f45, f67, (E));			\
  }

#define bct8_y2(F,G,E)				\
  {						\
  int f01, f23, f45, f67;			\
  int g01, g23, g45, g67;			\
  int t01, t23, t45, t67;			\
						\
  load8(F, f01, f23, f45, f67);			\
  load8(G, t01, t23, t45, t67);			\
							\
  g01 = __SADD16(f01,t67); g23 = __SSUB16(f23,t01);	\
  g45 = __SSUB16(f45,t23); g67 = __SSUB16(f67,t45);	\
  store8a(G, g01, g23, g45, g67, (E));			\
							\
  f01 = __SSUB16(f01,t67); f23 = __SADD16(f23,t01);	\
  f45 = __SADD16(f45,t23); f67 = __SADD16(f67,t45);	\
  store8a(F, f01, f23, f45, f67, (E));			\
  }

#define bct8_y6(F,G,E)				\
  {						\
  int f01, f23, f45, f67;			\
  int g01, g23, g45, g67;			\
  int t01, t23, t45, t67;			\
						\
  load8(F, f01, f23, f45, f67);			\
  load8(G, t01, t23, t45, t67);			\
							\
  g01 = __SADD16(f01,t23); g23 = __SADD16(f23,t45);	\
  g45 = __SADD16(f45,t67); g67 = __SSUB16(f67,t01);	\
  store8a(G, g01, g23, g45, g67, (E));			\
							\
  f01 = __SSUB16(f01,t23); f23 = __SSUB16(f23,t45);	\
  f45 = __SSUB16(f45,t67); f67 = __SADD16(f67,t01);	\
  store8a(F, f01, f23, f45, f67, (E));			\
  }

//inline void bct8_y1(int *F, int*G) {
#define bct8_y1(F,G,E)					\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t12, t34, t56, t70x;				\
							\
    load8(F, f01, f23, f45, f67);			\
    load8x(G, t12, t34, t56, t70x);			\
							\
    g01 = __SADD16(f01,t70x); g23 = __SSUB16(f23,t12);	\
    g45 = __SSUB16(f45,t34); g67 = __SSUB16(f67,t56);	\
    store8a(G, g01, g23, g45, g67, (E));		\
							\
    f01 = __SSUB16(f01,t70x); f23 = __SADD16(f23,t12);	\
    f45 = __SADD16(f45,t34); f67 = __SADD16(f67,t56);	\
    store8a(F, f01, f23, f45, f67, (E));		\
  }

//inline void bct8_y5(int *F, int*G) {
#define bct8_y5(F,G,E)					\
  {							\
  int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t12, t34, t56, t70x;				\
							\
    load8(F, f01, f23, f45, f67);			\
    load8x(G, t12, t34, t56, t70x);			\
							\
    g01 = __SADD16(f01,t34); g23 = __SADD16(f23,t56);	\
    g45 = __SADD16(f45,t70x); g67 = __SSUB16(f67,t12);	\
    store8a(G, g01, g23, g45, g67, E);			\
							\
    f01 = __SSUB16(f01,t34); f23 = __SSUB16(f23,t56);	\
    f45 = __SSUB16(f45,t70x); f67 = __SADD16(f67,t12);	\
    store8a(F, f01, f23, f45, f67, E);			\
  }							\
  //inline void bct8_y3(int *F, int*G) {
#define bct8_y3(F,G,E)					\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t12, t34, t56, t70x;				\
    							\
    load8(F, f01, f23, f45, f67);			\
    load8x(G, t12, t34, t56, t70x);			\
    							\
    g01 = __SADD16(f01,t56); g23 = __SADD16(f23,t70x);	\
    g45 = __SSUB16(f45,t12); g67 = __SSUB16(f67,t34);	\
  							\
    store8a(G, g01, g23, g45, g67, E);			\
							\
    f01 = __SSUB16(f01,t56); f23 = __SSUB16(f23,t70x);	\
    f45 = __SADD16(f45,t12); f67 = __SADD16(f67,t34);	\
    store8a(F, f01, f23, f45, f67, E);			\
  }

//inline void bct8_y7(int *F, int*G) {
#define bct8_y7(F,G,E)					\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t12, t34, t56, t70x;				\
							\
    load8(F, f01, f23, f45, f67);			\
    load8x(G, t12, t34, t56, t70x);			\
    							\
    g01 = __SADD16(f01,t12); g23 = __SADD16(f23,t34);	\
    g45 = __SADD16(f45,t56); g67 = __SADD16(f67,t70x);	\
    store8a(G, g01, g23, g45, g67, E);			\
    							\
    f01 = __SSUB16(f01,t12); f23 = __SSUB16(f23,t34);	\
    f45 = __SSUB16(f45,t56); f67 = __SSUB16(f67,t70x);	\
    store8a(F, f01, f23, f45, f67, E);			\
  }

#define bgs8_y12(F, G, E)				\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t01, t23, t45, t67;				\
							\
    load8(F, t01, t23, t45, t67);			\
    load8(G, g01, g23, g45, g67);			\
							\
  f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
  f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
  store8a(F, f01, f23, f45, f67, (E));			\
							\
  g01 = __SSUB16(g01,t01); g23 = __SSUB16(g23,t23);	\
  g45 = __SSUB16(t45,g45); g67 = __SSUB16(t67,g67);	\
  store8a(G, g45, g67, g01, g23, (E));			\
  }							

#define bgs8_y14(F, G, E)                               \
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t01, t23, t45, t67;				\
							\
    load8(F, t01, t23, t45, t67);			\
    load8(G, g01, g23, g45, g67);			\
							\
    f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
    f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
    store8a(F, f01, f23, f45, f67, (E));		\
							\
    g01 = __SSUB16(g01,t01); g23 = __SSUB16(t23,g23);	\
    g45 = __SSUB16(t45,g45); g67 = __SSUB16(t67,g67);	\
    store8a(G, g23, g45, g67, g01, (E));		\
  }							

#define bgs8_y10(F, G, E)				\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t01, t23, t45, t67;				\
							\
    load8(F, t01, t23, t45, t67);			\
    load8(G, g01, g23, g45, g67);			\
							\
    f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
    f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
    store8a(F, f01, f23, f45, f67, (E));		\
							\
    g01 = __SSUB16(g01,t01); g23 = __SSUB16(g23,t23);	\
    g45 = __SSUB16(g45,t45); g67 = __SSUB16(t67,g67);	\
    store8a(G, g67, g01, g23, g45, (E));		\
  }							




//inline void bgs8_y15 (int *F, int *G) {
#define bgs8_y15(F, G, E)				\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t01, t23, t45, t67;				\
							\
    load8(F, t01, t23, t45, t67);			\
    load8(G, g01, g23, g45, g67);			\
    							\
    f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
    f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
    store8a(F, f01, f23, f45, f67, E);			\
    							\
    g01 = __SSUB16(t01,g01); g23 = __SSUB16(t23,g23);	\
    g45 = __SSUB16(t45,g45); g67 = __SSUB16(t67,g67);	\
    store8xa(G, g01, g23, g45, g67, E);			\
  }

//inline void bgs8_y11(int *F, int*G) {
#define bgs8_y11(F, G, E)			\
  {						\
    int f01, f23, f45, f67;			\
    int g01, g23, g45, g67;			\
    int t01, t23, t45, t67;			\
    						\
    load8(F, t01, t23, t45, t67);		\
    load8(G, g01, g23, g45, g67);			\
    							\
    f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
    f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
    store8a(F, f01, f23, f45, f67, E);			\
    							\
    g01 = __SSUB16(g01,t01); g23 = __SSUB16(g23,t23);	\
    g45 = __SSUB16(t45,g45); g67 = __SSUB16(t67,g67);	\
    store8xa(G, g45, g67, g01, g23, E);			\
  }

//inline void bgs8_y13(int *F, int*G) {
#define bgs8_y13(F, G, E)				\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t01, t23, t45, t67;				\
							\
    load8(F, t01, t23, t45, t67);			\
    load8(G, g01, g23, g45, g67);			\
							\
    f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
    f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
    store8a(F, f01, f23, f45, f67, E);			\
							\
    g01 = __SSUB16(g01,t01); g23 = __SSUB16(t23,g23);	\
    g45 = __SSUB16(t45,g45); g67 = __SSUB16(t67,g67);	\
    store8xa(G, g23, g45, g67, g01, E);			\
  }

//inline void bgs8_y9(int *F, int*G) {

#define bgs8_y9(F, G, E)				\
  {							\
    int f01, f23, f45, f67;				\
    int g01, g23, g45, g67;				\
    int t01, t23, t45, t67;				\
							\
    load8(F, t01, t23, t45, t67);			\
    load8(G, g01, g23, g45, g67);			\
							\
    f01 = __SADD16(t01,g01); f23 = __SADD16(t23,g23);	\
    f45 = __SADD16(t45,g45); f67 = __SADD16(t67,g67);	\
    store8a(F, f01, f23, f45, f67, E);			\
							\
    g01 = __SSUB16(g01,t01); g23 = __SSUB16(g23,t23);	\
    g45 = __SSUB16(g45,t45); g67 = __SSUB16(t67,g67);	\
    store8xa(G, g67, g01, g23, g45, E);			\
  }

//inline void add_y(int *F, int *G) {
#define add8_y(F,G,E)						\
  {								\
    int f01, f23, f45, f67;					\
    int g01, g23, g45, g67;					\
    								\
    load8(F, f01, f23, f45, f67);				\
    load8xa(G, g01, g23, g45, g67, E);				\
    								\
    f01 = __SSUB16(f01,g67); f23 = __SADD16(f23,g01);		\
    f45 = __SADD16(f45,g23); f67 = __SADD16(f67,g45);		\
    								\
    store8a(F, f01, f23, f45, f67, E);				\
  }

#define bct8_1_add8_y(F,G,E)					\
  {								\
    int f01, f23, f45, f67;					\
    int t01, t23, t45, t67;					\
    int g12, g34, g56, g70x;					\
								\
    load8((F), f01, f23, f45, f67);				\
    load8a((G), t01, t23, t45, t67, (E));			\
								\
    g12 = __SSUB16(f01,t01); g34 = __SSUB16(f23,t23);		\
    g56 = __SSUB16(f45,t45); g70x = __SSUB16(f67,t67);		\
    								\
    f01 = __SADD16(f01,t01); f23 = __SADD16(f23,t23);		\
    f45 = __SADD16(f45,t45); f67 = __SADD16(f67,t67);		\
    								\
    int g01, g23, g45, g67;						\
    int g43, g0x7;							\
    __asm__ volatile ("ror %0, %2, #16 \n\t"				\
		      "ror %1, %3, #16 \n\t"				\
		      :"=r"(g43),"=r"(g0x7)				\
		      :"r"(g34),"r"(g70x)				\
		      );						\
    __asm__ volatile ("pkhtb %1, %6, %5, ASR #16 \n\t"			\
		      "pkhbt %2, %6, %7, LSL #16 \n\t"			\
		      "pkhtb %3, %4, %7, ASR #16 \n\t"			\
		      "neg %4, %4 \n\t"					\
		      "pkhbt %0, %4, %5, LSL #16 \n\t"			\
		      :"=r"(g01),"=r"(g23),"=r"(g45),"=r"(g67),"+r"(g0x7) \
		      :"r"(g12),"r"(g43),"r"(g56)			\
		      );						\
    f01 = __SADD16(f01,g01); f23 = __SADD16(f23,g23);			\
    f45 = __SADD16(f45,g45); f67 = __SADD16(f67,g67);			\
    store8a(F, f01, f23, f45, f67, (E));				\
  }

void fft64(int *A, int *B) {
  int *F, *G, i;
 layer0:// transpose and layer 0
  tr88x(A,B);
 layer1: // layer 1
  F = B; G = B + 16;
  for (i=4; i>0; i--) {bct8_1(F,G,16);}
  F += 16; G += 16;
  for (i=4; i>0; i--) {bct8_y4(F,G,16);}
 layer2:// layer 2;
  F = B; G = B + 8;
  bct8_1(F,G,16);  bct8_1(F,G,48);
  bct8_y4(F,G,16);  bct8_y4(F,G,48); 
  bct8_y2(F,G,16);  bct8_y2(F,G,48); 
  bct8_y6(F,G,16);  bct8_y6(F,G,-208);
 layer3:// layer 3; F = B;
  G = B + 4;
  bct8_1(F,G,32); bct8_y4(F,G,32); bct8_y2(F,G,32); bct8_y6(F,G,32); 
  bct8_y1(F,G,32); bct8_y5(F,G,32); bct8_y3(F,G,32); bct8_y7(F,G,-224);
  // reduce
  F = B; reduce8a(F,256);
}

void unfft64(int *A, int *B) {
  int i, *F, *G;
  // layer 3
  F = B; G = B + 4;
  bct8_1(F,G,32);  bgs8_y12(F,G,32);  bgs8_y14(F,G,32);  bgs8_y10(F,G,32);
  bgs8_y15(F,G,32);  bgs8_y11(F,G,32);  bgs8_y13(F,G,32);  bgs8_y9(F,G,-224); 
  // layer 2; F = B;
  G = B + 8;
  bct8_1(F,G,16);  bct8_1(F,G,48);
  bgs8_y12(F,G,16);  bgs8_y12(F,G,48); 
  bgs8_y14(F,G,16);  bgs8_y14(F,G,48); 
  bgs8_y10(F,G,16);  bgs8_y10(F,G,-208);
  // layer 1;  F = B;
  G = B + 16;
  for (i=4; i>0; i--) { bct8_1(F,G,16); }
  F = B + 32; G = F + 16;
  for (i=4; i>0; i--) { bgs8_y12(F,G,16); }
  // reduce
  F = B; reduce8a(F,256);
  // layer 0, collect;
  F = B; G = B + 32;
  for (i=8; i>0; i--) {
    //bct8_1(F,G,16); }
    //bct8_1_add8_y(F,G,16);
    bct8_1(F,G,0);
    add8_y(F,G,16);
  }
    // collect
    //F = B; G = B + 32;
    //for (i=8; i>0; i--) { add8_y(F,G,16);}
  
  // transpose, reduce, and store
  tr88r(B,A);
}

#define polymul_8x8_divR_negc_shift(H,F,G)				\
  __asm__ volatile ("ldr	r5, [%2, #4]	/* f23 */ \n\t"		\
		    "ldr	r6, [%2, #8]	/* f45 */ \n\t"		\
		    "ldr	r7, [%2, #12]	/* f67 */ \n\t"		\
		    "ldr	r4, [%2], #16	/* f01 */ \n\t"		\
		    "ldr	r9, [%3, #4]	/* g23 */ \n\t"		\
		    "ldr	r10, [%3, #8]	/* g45 */ \n\t"		\
		    "ldr	r11, [%3, #12]	/* g67 */ \n\t"		\
		    "vmov	s4, r3 \n\t"				\
		    "vmov	s6, r8 \n\t"				\
		    "ldr	r8, [%3], #16	/* g01 */ \n\t"		\
		    "smuadx	r14, r4, r8 \n\t"			\
		    "smuadx	r3, r5, r11 \n\t"			\
		    "smladx	r3, r6, r10, r3 \n\t"			\
		    "smladx	r3, r7, r9, r3 \n\t"			\
		    "sub	r14, r14, r3 \n\t"			\
		    "smuadx	r12, r4, r9 \n\t"			\
		    "smladx	r12, r5, r8, r12 \n\t"			\
		    "smuadx	r3, r6, r11 \n\t"			\
		    "smladx	r3, r7, r10, r3 \n\t"			\
		    "sub	r12, r12, r3 \n\t"			\
		    "vmov	s1, r14 \n\t"				\
		    "vmov	s3, r12 \n\t"				\
		    "smuadx	r14, r4, r10 \n\t"			\
		    "smladx	r14, r5, r9, r14 \n\t"			\
		    "smladx	r14, r6, r8, r14 \n\t"			\
		    "smuadx	r3, r7, r11 \n\t"			\
		    "sub	r14, r14, r3  \n\t"			\
		    "smuadx	r12, r4, r11 \n\t"			\
		    "smladx	r12, r5, r10, r12 \n\t"			\
		    "smladx	r12, r6, r9, r12 \n\t"			\
		    "smladx	r12, r7, r8, r12 \n\t"			\
		    "vmov	s5, r14	 \n\t"				\
		    "vmov	s7, r12 \n\t"				\
		    "pkhbt	r3, r4, r7 /* f07 */ \n\t"		\
		    "pkhbt	r4, r5, r4 /* f21 */ \n\t"		\
		    "pkhbt	r5, r6, r5 /* f43 */ \n\t"		\
		    "pkhbt	r6, r7, r6 /* f65 */ \n\t"		\
		    "smusd	r7, r3, r8 /* f0g0 - f7g1  */ \n\t"	\
		    "smuad	r14, r4, r11 \n\t"			\
		    "smlad	r14, r5, r10, r14 \n\t"			\
		    "smlad	r14, r6, r9, r14 \n\t"			\
		    "sub	r14, r7, r14 	/* h0 */ \n\t"		\
		    "smusd	r7, r3, r9	/* f0g2 - f7g3 */ \n\t"	\
		    "smlad	r7, r4, r8, r7	/*+f2g0 + f1g1 */ \n\t"	\
		    "smuad	r12, r6, r10 \n\t"			\
		    "smlad	r12, r5, r11, r12 \n\t"			\
		    "sub	r12, r7, r12	/* h2 */ \n\t"		\
		    "vmov	s0, r14 \n\t"				\
		    "vmov	s2, r12 \n\t"				\
		    "smusd	r7, r3, r10	/* f0g4 - f7g5 */ \n\t"	\
		    "smlad	r7, r4, r9, r7 \n\t"			\
		    "smlad	r7, r5, r8, r7 \n\t"			\
		    "smuad	r14, r6, r11 \n\t"			\
		    "sub	r14, r7, r14	/* h4 */ \n\t"		\
		    "smusd	r12, r3, r11	/* f0g6 - f7g7 */ \n\t" \
		    "smlad	r12, r4, r10, r12 \n\t"			\
		    "smlad	r12, r5, r9, r12 \n\t"			\
		    "smlad	r12, r6, r8, r12	/* h6  */ \n\t" \
		    "movw	r3, %5 \n\t"				\
		    "movw	r4, %4 \n\t"				\
		    "vmov	r5, s5 \n\t"				\
		    "vmov	r6, s7 \n\t"				\
		    "vmov	r7, s0 \n\t"				\
		    "vmov	r8, s1 \n\t"				\
		    "vmov	r9, s2 \n\t"				\
		    "vmov	r10, s3 \n\t"				\
		    "smulbb	r11, r14, r3 \n\t"			\
		    "smlabb	r14, r4, r11, r14 \n\t"			\
		    "smulbb	r11, r5, r3 \n\t"			\
		    "smlabb	r5, r4, r11, r5 \n\t"			\
		    "pkhtb	r14, r5, r14, ASR #16 \n\t" /* h45 */ 	\
		    "smulbb	r11, r12, r3 \n\t"			\
		    "smlabb	r12, r4, r11, r12 \n\t"			\
		    "smulbb	r11, r6, r3 \n\t"			\
		    "smlabb	r6, r4, r11, r6 \n\t"			\
		    "pkhtb	r12, r6, r12, ASR #16 \n\t" /* h67 */ 	\
		    "smulbb	r11, r9, r3 \n\t"			\
		    "smlabb	r9, r4, r11, r9 \n\t"			\
		    "smulbb	r11, r10, r3 \n\t"			\
		    "smlabb	r10, r4, r11, r10 \n\t"			\
		    "pkhtb	r9, r10, r9, ASR #16 \n\t" /* h23 */ 	\
                    "smulbb	r11, r7, r3 \n\t"			\
		    "smlabb	r7, r4, r11, r7 \n\t"			\
		    "smulbb	r11, r8, r3 \n\t"			\
		    "smlabb	r8, r4, r11, r8 \n\t"			\
		    "pkhtb	r7, r8, r7, ASR #16 \n\t" /* h01 */ 	\
		    "vmov	r8, s6 \n\t"				\
		    "vmov	r3, s4 \n\t"				\
		    "str	r9, [%1, #4] \n\t"			\
		    "str	r14, [%1, #8] \n\t"			\
		    "str	r12, [%1, #12] \n\t"			\
		    "str	r7, [%1], #16 \n\t"			\
		    : "=m"(*(int (*)[4])(H)),"+r"(H),"+r"(F),"+r"(G)	\
		    : "X"(q),"X"(65536-qinv),				\
		      "m"(*(int (*)[4])(F)),"m"(*(int (*)[4])(G))	\
		    : "r4","r5","r6","r7","r9","r10","r11",		\
		      "r12","lr","cc"					\
		    )



void gf_polymul_8x8_divR_negc (int *h, int *f, int *g) {
  int *fff=f, *ggg=g, *hhh=h;
  polymul_8x8_divR_negc_shift(hhh,fff,ggg);
}

void gf_polymul_64x64_div4096_negc (int *h, int f[32], int g[32]) {
  int ff[64], gg[64], hh[64], i;
  int *fff=ff, *ggg=gg, *hhh=hh;
  
  fft64(f, ff);
  fft64(g, gg);
  for (i=15; i>=0; i--) {
    polymul_8x8_divR_negc_shift(hhh,fff,ggg);}
  unfft64(h, hh);
}


#endif
