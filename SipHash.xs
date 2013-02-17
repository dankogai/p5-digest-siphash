/*
 * $Id: SipHash.xs,v 0.3 2013/02/17 14:48:20 dankogai Exp $
 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "csiphash.c"

static SV *
siphash_as_sv(SV *src, SV *seed) {
    uint64_t hash = le64toh(
        siphash24(SvPV_nolen(src), SvCUR(src), SvPV_nolen(seed))
    );
    return newSVpv((const char *)&hash, sizeof(uint64_t));
}

MODULE = Digest::SipHash  PACKAGE = Digest::SipHash

SV *
xs_siphash(src, seed)
SV *src;
SV *seed;
CODE:
    RETVAL = siphash_as_sv(src, seed);
OUTPUT:
    RETVAL
