/*
 * $Id: SipHash.xs,v 0.2 2013/02/17 10:30:45 dankogai Exp dankogai $
 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "csiphash.c"

static SV *
siphash_as_sv(SV *src, SV *key) {
    uint64_t hash = le64toh(
        siphash24(SvPV_nolen(src), SvCUR(src), SvPV_nolen(key))
    );
    return newSVpv((const char *)&hash, sizeof(uint64_t));
}

MODULE = Digest::SipHash  PACKAGE = Digest::SipHash

SV *
xs_siphash(src, key)
SV *src;
SV *key;
CODE:
    RETVAL = siphash_as_sv(src, key);
OUTPUT:
    RETVAL
