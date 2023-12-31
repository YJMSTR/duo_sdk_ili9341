/*
 * memrchr - find last character in a memory zone.
 *
 * Copyright (c) 2020, Arm Limited.
 * SPDX-License-Identifier: MIT
 */

/* Assumptions:
 *
 * ARMv8-a, AArch64, Advanced SIMD.
 * MTE compatible.
 */

#include "asmdefs.h"

#define srcin		x0
#define chrin		w1
#define cntin		x2
#define result		x0

#define src		x3
#define cntrem		x4
#define synd		x5
#define shift		x6
#define	tmp		x7
#define wtmp		w7
#define end		x8
#define endm1		x9

#define vrepchr		v0
#define qdata		q1
#define vdata		v1
#define vhas_chr	v2
#define vrepmask	v3
#define vend		v4
#define dend		d4

/*
   Core algorithm:

   For each 16-byte chunk we calculate a 64-bit syndrome value with four bits
   per byte. For even bytes, bits 0-3 are set if the relevant byte matched the
   requested character or the byte is NUL. Bits 4-7 must be zero. Bits 4-7 are
   set likewise for odd bytes so that adjacent bytes can be merged. Since the
   bits in the syndrome reflect the order in which things occur in the original
   string, counting trailing zeros identifies exactly which byte matched.  */

ENTRY (__memrchr_aarch64)
	add	end, srcin, cntin
	sub	endm1, end, 1
	bic	src, endm1, 15
	cbz	cntin, L(nomatch)
	ld1	{vdata.16b}, [src]
	dup	vrepchr.16b, chrin
	mov	wtmp, 0xf00f
	dup	vrepmask.8h, wtmp
	cmeq	vhas_chr.16b, vdata.16b, vrepchr.16b
	neg	shift, end, lsl 2
	and	vhas_chr.16b, vhas_chr.16b, vrepmask.16b
	addp	vend.16b, vhas_chr.16b, vhas_chr.16b            /* 128->64 */
	fmov	synd, dend
	lsl	synd, synd, shift
	cbz	synd, L(start_loop)

	clz	synd, synd
	sub	result, endm1, synd, lsr 2
	cmp	cntin, synd, lsr 2
	csel	result, result, xzr, hi
	ret

L(start_loop):
	sub	tmp, end, src
	subs	cntrem, cntin, tmp
	b.ls	L(nomatch)

	/* Make sure that it won't overread by a 16-byte chunk */
	add	tmp, cntrem, 15
	tbnz	tmp, 4, L(loop32_2)

	.p2align 4
L(loop32):
	ldr	qdata, [src, -16]!
	cmeq	vhas_chr.16b, vdata.16b, vrepchr.16b
	umaxp	vend.16b, vhas_chr.16b, vhas_chr.16b		/* 128->64 */
	fmov	synd, dend
	cbnz	synd, L(end)

L(loop32_2):
	ldr	qdata, [src, -16]!
	subs	cntrem, cntrem, 32
	cmeq	vhas_chr.16b, vdata.16b, vrepchr.16b
	b.ls	L(end)
	umaxp	vend.16b, vhas_chr.16b, vhas_chr.16b		/* 128->64 */
	fmov	synd, dend
	cbz	synd, L(loop32)
L(end):
	and	vhas_chr.16b, vhas_chr.16b, vrepmask.16b
	addp	vend.16b, vhas_chr.16b, vhas_chr.16b		/* 128->64 */
	fmov	synd, dend

	add	tmp, src, 15
#ifdef __AARCH64EB__
	rbit	synd, synd
#endif
	clz	synd, synd
	sub	tmp, tmp, synd, lsr 2
	cmp	tmp, srcin
	csel	result, tmp, xzr, hs
	ret

L(nomatch):
	mov	result, 0
	ret

END (__memrchr_aarch64)

