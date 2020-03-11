#ifndef __bred_int
#define __bred_int

// return the barrett reduction of C
// Q is modulus, QI = -round(2^32/Q)
__attribute__(( always_inline )) static inline int bred(int C, int Q, int QI) { 
  int result;								
  __asm__ volatile ("smmulr %0, %1, %2 \n\t"	/* round(C/Q) */	\
		    "mla %0, %0, %3, %1"				\
		    : "=&r"(result)					\
		    : "r"(C), "r" (QI), "r"(Q)				\
		    );
  return(result);
  }									
    
// return the barrett reduction of 16-bit parts of AB in C 
// Q is modulus, QI = -round(2^32/Q), pos is bb, bt, tb, or tt 
#define bmul(C, A, B, Q, QI, pos)				\
  {								\
  int scratch;							\
  __asm__ volatile ("smul" #pos " %0, %2, %3 \n\t"              \ 
"smmulr %1, %0, %4 \n\t"					\
"mla %0, %1, %5, %0"						\
: "=&r"((C)), "=&r"(scratch)					\
  : "r"((A)), "r"((B)), "r"((QI)), "r"((Q))			\
  );								\
}

// both top and bottom of C are reduced
// Q is modulus, QI = -round(2^32/Q)
#define bred_16x2(C, Q, QI)					\
  {								\
  int scratch;							\
  __asm__ volatile ( "smlawt	%1, %2, %0, %4\n\t"		\
		     "smultb	%1, %1, %3 \n\t"		\
		     "add	%0, %0, %1, LSL #16\n\t"	\
		     "smlawb	%1, %2, %0, %4\n\t"		\
		     "smlatb	%1, %1, %3, %0\n\t"		\
		     "pkhbt	%0, %1, %0"			\
		     : "+r"((C)), "=&r" (scratch)		\
		     : "r"((QI)), "r"((Q)), "r"(32768)		\
		     );						\
  }								\

// A and B are reduced and made into 32-bit with A bottom 
// Q is modulus, QI = -round(2^32/Q)
#define bred_32x2(C, A, B, Q, QI)				\
  {								\
  int scratch;							\
  __asm__ volatile ( "smmulr	%0, %2, %4\n\t"			\
		     "mla	%0, %0, %5, %2\n\t"		\
		     "smmulr	%1, %3, %4\n\t"			\
		     "mla	%1, %1, %5, %3\n\t"		\
		     "pkhbt	%0, %0, %1, LSL #16"		\
		     : "=&r"((C)), "=&r" (scratch)		\
		     : "r"((A)), "r"((B)), "r"((QI)), "r"((Q))	\
		     );						\
  }								\


#endif
