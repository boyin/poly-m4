.p2align 2,,3
.syntax unified
.text

.global gf_polymul_256x256
.type gf_polymul_256x256, %function
@ 256x256 Toom-4
@ void gf_polymul_256x256(uint32_t *h, uint32_t *c, uint32_t *f)
gf_polymul_256x256:
  push.w {r4-r12, lr}
  sub.w sp, sp, #4864
  vmov.w s0, r0
  mov.w r0, sp
  vmov.w s1, r2
  movw.w r2, #4591
  movw.w r3, #32768
  movw.w r4, #18015
  movt.w r4, #14
  add.w lr, r0, #128
gf_polymul_256x256_eval_input_c_body:
  ldr.w r8, [r1, #384]
  ldr.w r7, [r1, #128]
  ldr.w r6, [r1, #256]
  ldr.w r5, [r1], #4
  lsl.w r9, r7, #1
  lsl.w r10, r8, #3
  bfc.w r9, #16, #1
  bfc.w r10, #16, #3
  sadd16.w r9, r9, r10
  smlawb.w r10, r4, r9, r3
  smlawt.w r11, r4, r9, r3
  smulbt.w r10, r2, r10
  smulbt.w r11, r2, r11
  pkhbt.w r10, r10, r11, lsl #16
  ssub16.w r9, r9, r10
  lsl.w r10, r6, #2
  bfc.w r10, #16, #2
  sadd16.w r10, r10, r5
  sadd16.w r11, r10, r9
  ssub16.w r10, r10, r9
  smlawb.w r9, r4, r11, r3
  smlawt.w r12, r4, r11, r3
  smulbt.w r9, r2, r9
  smulbt.w r12, r2, r12
  pkhbt.w r9, r9, r12, lsl #16
  ssub16.w r11, r11, r9
  smlawb.w r9, r4, r10, r3
  smlawt.w r12, r4, r10, r3
  smulbt.w r9, r2, r9
  smulbt.w r12, r2, r12
  pkhbt.w r9, r9, r12, lsl #16
  ssub16.w r10, r10, r9
  lsl.w r9, r5, #3
  lsl.w r12, r6, #1
  bfc.w r9, #16, #3
  bfc.w r12, #16, #1
  sadd16.w r9, r9, r12
  sadd16.w r5, r5, r6
  smlawb.w r6, r4, r9, r3
  smlawt.w r12, r4, r9, r3
  smulbt.w r6, r2, r6
  smulbt.w r12, r2, r12
  pkhbt.w r6, r6, r12, lsl #16
  ssub16.w r9, r9, r6
  lsl.w r12, r7, #2
  bfc.w r12, #16, #2
  sadd16.w r12, r12, r8
  sadd16.w r7, r7, r8
  sadd16.w r9, r9, r12
  smlawb.w r6, r4, r9, r3
  smlawt.w r8, r4, r9, r3
  smulbt.w r6, r2, r6
  smulbt.w r8, r2, r8
  pkhbt.w r6, r6, r8, lsl #16
  ssub16.w r9, r9, r6
  ssub16.w r8, r5, r7
  sadd16.w r7, r5, r7
  smlawb.w r5, r4, r8, r3
  smlawt.w r6, r4, r8, r3
  smulbt.w r5, r2, r5
  smulbt.w r6, r2, r6
  pkhbt.w r5, r5, r6, lsl #16
  ssub16.w r8, r8, r5
  smlawb.w r5, r4, r7, r3
  smlawt.w r6, r4, r7, r3
  smulbt.w r5, r2, r5
  smulbt.w r6, r2, r6
  pkhbt.w r5, r5, r6, lsl #16
  ssub16.w r7, r7, r5
  str.w r10, [r0, #512]
  str.w r11, [r0, #384]
  str.w r8, [r0, #256]
  str.w r7, [r0, #128]
  str.w r9, [r0], #4
  cmp.w r0, lr
  bne.w gf_polymul_256x256_eval_input_c_body
  vmov.w r2, s1
  add.w r0, r0, #512
  vmov.w s1, r1
  mvn.w r1, #0x00010000
  mvn.w r3, #0x00030000
  mvn.w r4, #0x00070000
  add.w lr, r0, #128
gf_polymul_256x256_eval_input_f_body:
  ldr.w r8, [r2, #384]
  ldr.w r7, [r2, #128]
  ldr.w r6, [r2, #256]
  ldr.w r5, [r2], #4
  and.w r9, r1, r7, lsl #1
  and.w r10, r4, r8, lsl #3
  sadd16.w r9, r9, r10
  and.w r10, r3, r6, lsl #2
  sadd16.w r10, r10, r5
  sadd16.w r11, r10, r9
  ssub16.w r10, r10, r9
  and.w r9, r4, r5, lsl #3
  and.w r12, r1, r6, lsl #1
  sadd16.w r9, r9, r12
  sadd16.w r5, r5, r6
  and.w r12, r3, r7, lsl #2
  sadd16.w r12, r12, r8
  sadd16.w r7, r7, r8
  sadd16.w r9, r9, r12
  ssub16.w r8, r5, r7
  sadd16.w r7, r5, r7
  str.w r10, [r0, #512]
  str.w r11, [r0, #384]
  str.w r8, [r0, #256]
  str.w r7, [r0, #128]
  str.w r9, [r0], #4
  cmp.w r0, lr
  bne.w gf_polymul_256x256_eval_input_f_body
  vmov.w r1, s1
  add.w r0, r0, #512
  vmov.w r4, s0
  mov.w r5, r0
  sub.w r6, r1, #128
  sub.w r7, r2, #128
  mov.w r1, r6
  mov.w r2, r7
  bl.w gf_polymul_64x64
  add.w r0, r5, #1024
  sub.w r1, r5, #1280
  sub.w r2, r5, #640
  bl.w gf_polymul_64x64
  add.w r0, r5, #256
  sub.w r1, r5, #1152
  sub.w r2, r5, #512
  bl.w gf_polymul_64x64
  add.w r0, r5, #1280
  sub.w r1, r5, #1024
  sub.w r2, r5, #384
  bl.w gf_polymul_64x64
  add.w r0, r5, #512
  sub.w r1, r5, #896
  sub.w r2, r5, #256
  bl.w gf_polymul_64x64
  add.w r0, r5, #1536
  sub.w r1, r5, #768
  sub.w r2, r5, #128
  bl.w gf_polymul_64x64
  add.w r0, r5, #768
  add.w r1, r6, #384
  add.w r2, r7, #384
  bl.w gf_polymul_64x64
  vmov.w s0, r4
  mov.w r0, r5
  add.w lr, r0, #256
  movw.w r12, #18015
  movt.w r12, #14
  movw.w r11, #4591
  movw.w r10, #0xFFFE
  movt.w r10, #0xFA05
  vmov.w s1, r10
  movt.w r10, #0x08AB
  vmov.w s3, r10
  movw.w r10, #0x0878
  movt.w r10, #0x03FC
  vmov.w s2, r10
  movt.w r10, #0xFE02
  vmov.w s14, r10
  movw.w r10, #0x05FB
  movt.w r10, #0xFB83
  vmov.w s4, r10
  movt.w r10, #0x053B
  vmov.w s5, r10
  movw.w r10, #0x053B
  movt.w r10, #0x0004
  vmov.w s6, r10
  movw.w r10, #0xF70B
  movt.w r10, #0xF70A
  vmov.w s7, r10
  movw.w r10, #0x06F9
  movt.w r10, #0x00FF
  vmov.w s8, r10
  movw.w r10, #0x02FD
  movt.w r10, #0x047C
  vmov.w s10, r10
  movt.w r10, #0xFAC5
  vmov.w s11, r10
  movw.w r10, #0xFAC5
  movt.w r10, #0xFFFB
  vmov.w s12, r10
  movw.w r10, #0x08F7
  movt.w r10, #0x05FA
  vmov.w s13, r10
  movt.w r10, #0xF755
  vmov.w s15, r10
  add.w r1, r0, #1536
gf_polymul_256x256_interpol_output_body:
  ldr.w r10, [r0, #768]
  ldr.w r9, [r1]
  ldr.w r8, [r0, #512]
  ldr.w r7, [r0, #1280]
  ldr.w r6, [r0, #256]
  ldr.w r3, [r0, #1024]
  ldr.w r4, [r0], #4
  pkhbt.w r1, r4, r6, lsl #16
  pkhtb.w r2, r6, r4, asr #16
  pkhbt.w r4, r7, r8, lsl #16
  pkhtb.w r5, r8, r7, asr #16
  pkhbt.w r6, r9, r10, lsl #16
  pkhtb.w r7, r10, r9, asr #16
  vmov.w r10, s1
  smuad.w r8, r10, r1
  smuad.w r9, r10, r2
  mvn.w r10, #203
  smlabb.w r8, r10, r3, r8
  smlabt.w r9, r10, r3, r9
  vmov.w r10, s2
  smladx.w r8, r10, r4, r8
  smladx.w r9, r10, r5, r9
  vmov.w r10, s3
  smladx.w r8, r10, r6, r8
  smladx.w r9, r10, r7, r9
  smmulr.w r10, r12, r8
  mls.w r8, r11, r10, r8
  smmulr.w r10, r12, r9
  mls.w r9, r11, r10, r9
  pkhbt.w r8, r8, r9, lsl #16
  str.w r8, [r0, #1020]
  vmov.w r10, s4
  smuadx.w r8, r10, r1
  smuadx.w r9, r10, r2
  vmov.w r10, s5
  smlad.w r8, r10, r4, r8
  smlad.w r9, r10, r5, r9
  vmov.w r10, s6
  smlad.w r8, r10, r6, r8
  smlad.w r9, r10, r7, r9
  smmulr.w r10, r12, r8
  mls.w r8, r11, r10, r8
  smmulr.w r10, r12, r9
  mls.w r9, r11, r10, r9
  pkhbt.w r8, r8, r9, lsl #16
  str.w r8, [r0, #252]
  vmov.w r10, s7
  smuad.w r8, r10, r1
  smuad.w r9, r10, r2
  mov.w r10, #255
  smlabb.w r8, r10, r3, r8
  smlabt.w r9, r10, r3, r9
  vmov.w r10, s8
  smlad.w r8, r10, r4, r8
  smlad.w r9, r10, r5, r9
  movw.w r10, #0xF70B
  smlabt.w r8, r10, r6, r8
  smlabt.w r9, r10, r7, r9
  smmulr.w r10, r12, r8
  mls.w r8, r11, r10, r8
  smmulr.w r10, r12, r9
  mls.w r9, r11, r10, r9
  pkhbt.w r8, r8, r9, lsl #16
  str.w r8, [r0, #1276]
  vmov.w r10, s10
  smuadx.w r8, r10, r1
  smuadx.w r9, r10, r2
  vmov.w r10, s11
  smlad.w r8, r10, r4, r8
  smlad.w r9, r10, r5, r9
  vmov.w r10, s12
  smlad.w r8, r10, r6, r8
  smlad.w r9, r10, r7, r9
  smmulr.w r10, r12, r8
  mls.w r8, r11, r10, r8
  smmulr.w r10, r12, r9
  mls.w r9, r11, r10, r9
  pkhbt.w r8, r8, r9, lsl #16
  str.w r8, [r0, #508]
  vmov.w r10, s13
  smuad.w r8, r10, r1
  smuad.w r9, r10, r2
  mvn.w r10, #50
  smlabb.w r8, r10, r3, r8
  smlabt.w r9, r10, r3, r9
  vmov.w r10, s14
  smladx.w r8, r10, r4, r8
  smladx.w r9, r10, r5, r9
  vmov.w r10, s15
  smladx.w r8, r10, r6, r8
  smladx.w r9, r10, r7, r9
  smmulr.w r10, r12, r8
  mls.w r8, r11, r10, r8
  smmulr.w r10, r12, r9
  mls.w r9, r11, r10, r9
  pkhbt.w r8, r8, r9, lsl #16
  add.w r1, r0, #1536
  str.w r8, [r1, #-4]
  cmp.w r0, lr
  bne.w gf_polymul_256x256_interpol_output_body
  sub.w r1, r0, #256
  vmov.w r0, s0
  add.w lr, r0, #88
gf_polymul_256x256_copy_output_A:
  ldr.w r2, [r1], #4
  ldr.w r3, [r1], #4
  ldr.w r4, [r1], #4
  ldr.w r5, [r1], #4
  ldr.w r6, [r1], #4
  ldr.w r7, [r1], #4
  ldr.w r8, [r1], #4
  ldr.w r9, [r1], #4
  ldr.w r10, [r1], #4
  ldr.w r11, [r1], #4
  ldr.w r12, [r1], #4
  str.w r2, [r0], #4
  str.w r3, [r0], #4
  str.w r4, [r0], #4
  str.w r5, [r0], #4
  str.w r6, [r0], #4
  str.w r7, [r0], #4
  str.w r8, [r0], #4
  str.w r9, [r0], #4
  str.w r10, [r0], #4
  str.w r11, [r0], #4
  str.w r12, [r0], #4
  cmp.w r0, lr
  bne.w gf_polymul_256x256_copy_output_A
  ldr.w r2, [r1], #4
  ldr.w r3, [r1], #4
  ldr.w r4, [r1], #4
  ldr.w r5, [r1], #4
  ldr.w r6, [r1], #4
  ldr.w r7, [r1], #4
  ldr.w r8, [r1], #4
  ldr.w r9, [r1], #4
  ldr.w r10, [r1], #4
  ldr.w r11, [r1], #4
  str.w r2, [r0], #4
  str.w r3, [r0], #4
  str.w r4, [r0], #4
  str.w r5, [r0], #4
  str.w r6, [r0], #4
  str.w r7, [r0], #4
  str.w r8, [r0], #4
  str.w r9, [r0], #4
  str.w r10, [r0], #4
  str.w r11, [r0], #4
  add.w lr, r0, #760
gf_polymul_256x256_copy_output_B:
  ldr.w r7, [r1, #896]
  ldr.w r2, [r1], #4
  ldr.w r8, [r1, #896]
  ldr.w r3, [r1], #4
  ldr.w r9, [r1, #896]
  ldr.w r4, [r1], #4
  ldr.w r10, [r1, #896]
  ldr.w r5, [r1], #4
  ldr.w r11, [r1, #896]
  ldr.w r6, [r1], #4
  sadd16.w r2, r2, r7
  sadd16.w r3, r3, r8
  sadd16.w r4, r4, r9
  sadd16.w r5, r5, r10
  sadd16.w r6, r6, r11
  str.w r2, [r0], #4
  str.w r3, [r0], #4
  str.w r4, [r0], #4
  str.w r5, [r0], #4
  str.w r6, [r0], #4
  cmp.w r0, lr
  bne.w gf_polymul_256x256_copy_output_B
  ldr.w r4, [r1, #896]
  ldr.w r2, [r1], #4
  ldr.w r5, [r1, #896]
  ldr.w r3, [r1], #4
  sadd16.w r2, r2, r4
  sadd16.w r3, r3, r5
  str.w r2, [r0], #4
  str.w r3, [r0], #4
  add.w lr, r0, #88
gf_polymul_256x256_copy_output_C:
  ldr.w r2, [r1], #4
  ldr.w r3, [r1], #4
  ldr.w r4, [r1], #4
  ldr.w r5, [r1], #4
  ldr.w r6, [r1], #4
  ldr.w r7, [r1], #4
  ldr.w r8, [r1], #4
  ldr.w r9, [r1], #4
  ldr.w r10, [r1], #4
  ldr.w r11, [r1], #4
  ldr.w r12, [r1], #4
  str.w r2, [r0], #4
  str.w r3, [r0], #4
  str.w r4, [r0], #4
  str.w r5, [r0], #4
  str.w r6, [r0], #4
  str.w r7, [r0], #4
  str.w r8, [r0], #4
  str.w r9, [r0], #4
  str.w r10, [r0], #4
  str.w r11, [r0], #4
  str.w r12, [r0], #4
  cmp.w r0, lr
  bne.w gf_polymul_256x256_copy_output_C
  ldr.w r2, [r1], #4
  ldr.w r3, [r1], #4
  ldr.w r4, [r1], #4
  ldr.w r5, [r1], #4
  ldr.w r6, [r1], #4
  ldr.w r7, [r1], #4
  ldr.w r8, [r1], #4
  ldr.w r9, [r1], #4
  ldr.w r10, [r1], #4
  ldr.w r11, [r1], #4
  str.w r2, [r0], #4
  str.w r3, [r0], #4
  str.w r4, [r0], #4
  str.w r5, [r0], #4
  str.w r6, [r0], #4
  str.w r7, [r0], #4
  str.w r8, [r0], #4
  str.w r9, [r0], #4
  str.w r10, [r0], #4
  str.w r11, [r0], #4
  add.w sp, sp, #4864
  pop.w {r4-r12, pc}
