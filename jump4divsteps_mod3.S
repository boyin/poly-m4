
	.p2align	2,,3	
	.syntax		unified
	.text
	.global		jump4divsteps_mod3_1
	.type		jump4divsteps_mod3_1, %function
jump4divsteps_mod3_1:
	push	{r1,r4-r11,lr}
	ldr	r2, [r2] //f
	ldr	r3, [r3] //f
	mov	r4, #1	// u
	mov	r5, #0	// v
	mov	r6, #0	// r
	mov	r7, #1	// s
	ldr	r8, =0x03030303
jump4divsteps_ub3_1_0:	// start of turn 0
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
	pop	{r1}
	stm	r1!, {r2-r7}
	pop	{r4-r11,pc}

	.p2align	2,,3	
	.syntax		unified
	.text
	.global		jump4divsteps_mod3_2
	.type		jump4divsteps_mod3_2, %function
jump4divsteps_mod3_2:
	push	{r1,r4-r11,lr}
	ldr	r2, [r2] //f
	ldr	r3, [r3] //f
	mov	r4, #1	// u
	mov	r5, #0	// v
	mov	r6, #0	// r
	mov	r7, #1	// s
	ldr	r8, =0x03030303
jump4divsteps_ub3_2_0:	// start of turn 0
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
jump4divsteps_ub3_2_1:	// start of turn 1
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
	pop	{r1}
	stm	r1!, {r2-r7}
	pop	{r4-r11,pc}

	.p2align	2,,3	
	.syntax		unified
	.text
	.global		jump4divsteps_mod3_3
	.type		jump4divsteps_mod3_3, %function
jump4divsteps_mod3_3:
	push	{r1,r4-r11,lr}
	ldr	r2, [r2] //f
	ldr	r3, [r3] //f
	mov	r4, #1	// u
	mov	r5, #0	// v
	mov	r6, #0	// r
	mov	r7, #1	// s
	ldr	r8, =0x03030303
jump4divsteps_ub3_3_0:	// start of turn 0
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
jump4divsteps_ub3_3_1:	// start of turn 1
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
jump4divsteps_ub3_3_2:	// start of turn 2
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
	pop	{r1}
	stm	r1!, {r2-r7}
	pop	{r4-r11,pc}

	.p2align	2,,3	
	.syntax		unified
	.text
	.global		jump4divsteps_mod3
	.type		jump4divsteps_mod3, %function
jump4divsteps_mod3:
	push	{r1,r4-r11,lr}
	ldr	r2, [r2] //f
	ldr	r3, [r3] //f
	mov	r4, #1	// u
	mov	r5, #0	// v
	mov	r6, #0	// r
	mov	r7, #1	// s
	ldr	r8, =0x03030303
jump4divsteps_ub3_4_0:	// start of turn 0
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
jump4divsteps_ub3_4_1:	// start of turn 1
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
jump4divsteps_ub3_4_2:	// start of turn 2
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	lsl	r4, r4, #8	// u*=x
	lsl	r5, r5, #8	// v*=x
jump4divsteps_ub3_4_3:	// start of turn 3
	uxtb	r1, r3
	tst	r1, r0, ASR #31
	itttt	ne
	movne	r1, r4	// r4<->r6
	movne	r4, r6
	movne	r6, r1
	movne	r1, r5	// r5<->r7
	itttt	ne
	movne	r5, r7
	movne	r7, r1
	movne	r1, r2	// r2<->r3
	movne	r2, r3
	itt	ne
	movne	r3, r1
	negne	r0, r0
	sub	r1, r8, r2	// -f
	mul	r1, r3, r1	// T0 = -f0*g0
	sub	r0, r0, #1	// decrement minusdelta
	and	r1, r1, #0xff	// T0 = 0..4
	mla	r6, r1, r4, r6	// r+=T0*u, 0..10
	mla	r7, r1, r5, r7	// s+=T0*v, 0..10
	mla	r3, r1, r2, r3	// g+=T0*f
	and	r1, r8, r3, LSR #8
	bic	r3, r3, r8
	add	r3, r1, r3, LSR #10
	usub8	r1, r3, r8		// >= 3 ?
	sel	r3, r1, r3		// select
	bic	r1, r6, r8		// top 3b < 3
	and	r6, r6, r8		// bot 2b < 4
	add	r6, r6, r1, LSR #2	// range <=5
	usub8	r1, r6, r8		// >= 3 ?
	sel	r6, r1, r6		// select
	bic	r1, r7, r8		// top 3b < 3
	and	r7, r7, r8		// bot 2b < 4
	add	r7, r7, r1, LSR #2	// range <=5
	usub8	r1, r7, r8		// >= 3 ?
	sel	r7, r1, r7		// select
	pop	{r1}
	stm	r1!, {r2-r7}
	pop	{r4-r11,pc}
