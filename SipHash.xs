/*
 * $Id: SipHash.xs,v 0.5 2013/03/05 06:52:11 dankogai Exp $
 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "csiphash.c"

static SV *
siphash_as_av(SV *src, SV *seed) {
    SV* retval;
    SV* sva[2];
    uint64_t hash = siphash24(SvPV_nolen(src), SvCUR(src), SvPV_nolen(seed));
    sva[0] = newSVuv(hash & 0xffffffff);
    sva[1] = newSVuv(hash >> 32);
    retval = newRV_noinc((SV *)av_make(2, sva));
    return retval;
}

MODULE = Digest::SipHash  PACKAGE = Digest::SipHash

UV
_xs_siphash64(src, seed)
SV *src;
SV *seed;
CODE:
    RETVAL = (UV)siphash24(SvPV_nolen(src), SvCUR(src), SvPV_nolen(seed));
OUTPUT:
    RETVAL

SV *
_xs_siphash_av(src, seed)
SV *src;
SV *seed;
CODE:
    RETVAL = siphash_as_av(src, seed);
OUTPUT:
    RETVAL
