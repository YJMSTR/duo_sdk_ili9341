/*
 * strlen - calculate the length of a string.
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
#define result		x0

#define src		x1
#define	synd		x2
#define tmp		x3
#define wtmp		w3
#define shift		x4

#define data		q0
#define vdata		v0
#define vhas_nul	v1
#define vrepmask	v2
#define vend		v3
#define dend		d3

/* Core algorithm:

   For each 16-byte chunk we calculate a 64-bit syndrome value with four bits
   per byte. For even bytes, bits 0-3 are set if the relevant byte matched the
   requested character or the byte is NUL. Bits 4-7 must be zero. Bits 4-7 are
   set likewise for odd bytes so that adjacent bytes can be merged. Since the
   bits in the syndrome reflect the order in which things occur in the original
   string, counting trailing zeros identifies exactly which byte matched.  */

ENTRY (__strlen_aarch64_mte)
	bic	src, srcin, 15
	mov	wtmp, 0xf00f
	ld1	{vdata.16b}, [src]
	dup	vrepmask.8h, wtmp
	cmeq	vhas_nul.16b, vdata.16b, 0
	lsl	shift, srcin, 2
	and	vhas_nul.16b, vhas_nul.16b, vrepmask.16b
	addp	vend.16b, vhas_nul.16b, vhas_nul.16b		/* 128->64 */
	fmov	synd, dend
	lsr	synd, synd, shift
	cbz	synd, L(loop)

	rbit	synd, synd
	clz	result, synd
	lsr	result, result, 2
	ret

	.p2align 5
L(loop):
	ldr	data, [src, 16]!
	cmeq	vhas_nul.16b, vdata.16b, 0
	umaxp	vend.16b, vhas_nul.16b, vhas_nul.16b
	fmov	synd, dend
	cbz	synd, L(loop)

	and	vhas_nul.16b, vhas_nul.16b, vrepmask.16b
	addp	vend.16b, vhas_nul.16b, vhas_nul.16b		/* 128->64 */
	sub	result, src, srcin
	fmov	synd, dend
#ifndef __AARCH64EB__
	rbit	synd, synd
#endif
	clz	tmp, synd
	add	result, result, tmp, lsr 2
	ret

END (__strlen_aarch64_mte)

