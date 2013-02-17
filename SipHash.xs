/*
 * $Id: SipHash.xs,v 0.1 2013/02/17 07:53:54 dankogai Exp dankogai $
 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "csiphash.c"

SV *
siphash_as_aref(SV *src, SV *key) {
    SV*      sva[2];
    uint64_t hash = siphash24(SvPV_nolen(src), SvCUR(src), SvPV_nolen(key));
    sva[0] = sv_2mortal(newSVuv(hash >> 32));
    sva[1] = sv_2mortal(newSVuv(hash & 0xffffffff));
    return newRV_noinc((SV *)av_make(2, sva));
}

MODULE = Digest::SipHash  PACKAGE = Digest::SipHash

SV *
xs_siphash(src, key)
SV *src;
SV *key;
CODE:
    RETVAL = siphash_as_aref(src, key);
OUTPUT:
    RETVAL
