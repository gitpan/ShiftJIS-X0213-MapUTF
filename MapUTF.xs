#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "fmsj0213.h"
#include "tosj0213.h"

#define PkgName "ShiftJIS::X0213::MapUTF"

#define Is_SJIS0213_SNG(i)   (0x00<=(i) && (i)<=0x7F || 0xA1<=(i) && (i)<=0xDF)
#define Is_SJIS0213_LED(i)   (0x81<=(i) && (i)<=0x9F || 0xE0<=(i) && (i)<=0xFC)
#define Is_SJIS0213_TRL(i)   (0x40<=(i) && (i)<=0x7E || 0x80<=(i) && (i)<=0xFC)

#define Is_SJIS0213_SBC(p)   (Is_SJIS0213_SNG(*(p)))
#define Is_SJIS0213_DBC(p)   (Is_SJIS0213_LED(*(p)) && Is_SJIS0213_TRL((p)[1]))
#define Is_SJIS0213_MBLEN(p) (Is_SJIS0213_DBC(p) ? 2 : 1)

#define VALID_UTF_MAX (0x10FFFF)

/* Perl 5.6.1 ? */
#ifndef uvuni_to_utf8
#define uvuni_to_utf8   uv_to_utf8
#endif /* uvuni_to_utf8 */

/* Perl 5.6.1 ? */
#ifndef utf8n_to_uvuni
#define utf8n_to_uvuni  utf8_to_uv
#endif /* utf8n_to_uvuni */

static void
sv_cat_retcvref (SV *dst, SV *cv, SV *sv)
{
    dSP;
    int count;
    SV* retsv;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv_2mortal(sv));
    PUTBACK;
    count = call_sv(cv, G_SCALAR);
    SPAGAIN;
    if (count != 1)
	croak("Panic in XS, " PkgName "\n");
    retsv = newSVsv(POPs);
    PUTBACK;
    FREETMPS;
    LEAVE;
    sv_catsv(dst,retsv);
    sv_2mortal(retsv);
}

MODULE = ShiftJIS::X0213::MapUTF	PACKAGE = ShiftJIS::X0213::MapUTF

void
sjis0213_to_unicode (arg1, arg2=0)
    SV* arg1
    SV* arg2
  PROTOTYPE: $;$
  PREINIT:
    SV *src, *dst, *cvref;
    STRLEN srclen, dstlen, mblen;
    U8 *s, *e, *p, *d, uni[UTF8_MAXLEN + 1];
    UV uv;
    U16 hi, lo;
    struct leading lb;
  PPCODE:
    cvref = NULL;
    if (items == 2)
	if (SvROK(arg1) && SvTYPE(SvRV(arg1)) == SVt_PVCV)
	    cvref = SvRV(arg1);
	else
	    croak(PkgName " 1st argument is not CODEREF");

    src = cvref ? arg2 : arg1;
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dstlen = srclen * MaxLenToUni + 1;

    dst = newSV(dstlen);
    (void)SvPOK_only(dst);
    SvUTF8_on(dst);

    if (cvref) {
	for (p = s; p < e; p += mblen) {
	    mblen = Is_SJIS0213_MBLEN(p);
	    lb = fmsjis0213_tbl[*p];
	    uv = (lb.tbl != NULL) ? lb.tbl[p[1]] : lb.sbc;
	    if (uv || !*p) {
		if (uv <= VALID_UTF_MAX) {
		    (void)uvuni_to_utf8(uni, uv);
		    sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
		} else {
		    hi = (U16)(uv >> 16);
		    lo = (U16)(uv & 0xFFFF);

		    (void)uvuni_to_utf8(uni, (UV)hi);
		    sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP((UV)hi));
		    (void)uvuni_to_utf8(uni, (UV)lo);
		    sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP((UV)lo));
		}
	    }
	    else
		sv_cat_retcvref(dst, cvref, newSVpvn((char*)p, mblen));
	}
    }
    else {
	d = (U8*)SvPVX(dst);
	for (p = s; p < e; p += mblen) {
	    mblen = Is_SJIS0213_MBLEN(p);
	    lb = fmsjis0213_tbl[*p];
	    uv = (lb.tbl != NULL) ? lb.tbl[p[1]] : lb.sbc;
	    if (uv || !*p)
		if (uv <= VALID_UTF_MAX) {
		    d = uvuni_to_utf8(d, (UV)uv);
		} else {
		    d = uvuni_to_utf8(d, (UV)(uv >> 16));
		    d = uvuni_to_utf8(d, (UV)(uv & 0xFFFF));
		}
	}
	*d = '\0';
	SvCUR_set(dst, d - (U8*)SvPVX(dst));
    }
    XPUSHs(sv_2mortal(dst));


void
sjis0213_to_utf16le (arg1, arg2=0)
    SV* arg1
    SV* arg2
  PROTOTYPE: $;$
  ALIAS:
    sjis0213_to_utf16be = 1
  PREINIT:
    SV *src, *dst, *cvref;
    STRLEN srclen, dstlen, mblen;
    U8 *s, *e, *p, *d, ucs[5];
    UV uv;
    U16 hi, lo;
    struct leading lb;
  PPCODE:
    cvref = NULL;
    if (items == 2)
	if (SvROK(arg1) && SvTYPE(SvRV(arg1)) == SVt_PVCV)
	    cvref = SvRV(arg1);
	else
	    croak(PkgName " 1st argument is not CODEREF");

    src = cvref ? arg2 : arg1;
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dstlen = srclen * MaxLenToU16 + 1;

    dst = newSV(dstlen);
    (void)SvPOK_only(dst);

    if (cvref) {
	for (p = s; p < e; p += mblen) {
	    mblen = Is_SJIS0213_MBLEN(p);
	    lb = fmsjis0213_tbl[*p];
	    uv = (lb.tbl != NULL) ? lb.tbl[p[1]] : lb.sbc;
	    if (uv || !*p) {
		if (uv <= 0xFFFF) {
		    ucs[1-ix] = (U8)(uv >> 8);
		    ucs[ix]   = (U8)(uv & 0xff);
		    sv_catpvn(dst, (char*)ucs, 2);
		}
		else if (uv <= 0xFFFFFFFF) {
		    if (uv <= VALID_UTF_MAX) {
			uv -= 0x10000;
			hi = (U16)(0xD800 | (uv >> 10));
			lo = (U16)(0xDC00 | (uv & 0x3FF));
		    } else {
			hi = (U16)(uv >> 16);
			lo = (U16)(uv & 0xFFFF);
		    }
		    ucs[1-ix] = (U8)(hi >> 8);
		    ucs[ix]   = (U8)(hi & 0xff);
		    ucs[3-ix] = (U8)(lo >> 8);
		    ucs[2+ix] = (U8)(lo & 0xff);
		    sv_catpvn(dst, (char*)ucs, 4);
		}
	    }
	    else
		sv_cat_retcvref(dst, cvref, newSVpvn((char*)p, mblen));
	}
    }
    else {
	d = (U8*)SvPVX(dst);
	for (p = s; p < e; p += mblen) {
	    mblen = Is_SJIS0213_MBLEN(p);
	    lb = fmsjis0213_tbl[*p];
	    uv = (lb.tbl != NULL) ? lb.tbl[p[1]] : lb.sbc;
	    if (uv || !*p) {
		if (uv <= 0xFFFF) {
		    if (ix) /* BE */
			*d++ = (U8)(uv >> 8);
		    *d++ = (U8)(uv & 0xff);
		    if (!ix) /* LE */
			*d++ = (U8)(uv >> 8);
		}
		else if (uv <= 0xFFFFFFFF) {
		    if (uv <= VALID_UTF_MAX) {
			uv -= 0x10000;
			hi = (U16)(0xD800 | (uv >> 10));
			lo = (U16)(0xDC00 | (uv & 0x3FF));
		    } else {
			hi = (U16)(uv >> 16);
			lo = (U16)(uv & 0xFFFF);
		    }

		    if (ix) /* BE */
			*d++ = (U8)(hi >> 8);
		    *d++ = (U8)(hi & 0xff);
		    if (!ix) /* LE */
			*d++ = (U8)(hi >> 8);

		    if (ix) /* BE */
			*d++ = (U8)(lo >> 8);
		    *d++ = (U8)(lo & 0xff);
		    if (!ix) /* LE */
			*d++ = (U8)(lo >> 8);
		}
	    }
	}
	*d = '\0';
	SvCUR_set(dst, d - (U8*)SvPVX(dst));
    }
    XPUSHs(sv_2mortal(dst));


void
unicode_to_sjis0213 (arg1, arg2=0)
    SV* arg1
    SV* arg2
  PROTOTYPE: $;$
  PREINIT:
    SV *src, *dst, *cvref;
    STRLEN srclen, dstlen, retlen;
    U8 *s, *e, *p, *d, mbc[3];
    U16 j, *tbl_row, **tbl_plain;
    UV uv, uv2;
  PPCODE:
    cvref = NULL;
    if (items == 2)
	if (SvROK(arg1) && SvTYPE(SvRV(arg1)) == SVt_PVCV)
	    cvref = SvRV(arg1);
	else
	    croak(PkgName " 1st argument is not CODEREF");

    src = cvref ? arg2 : arg1;
    if (!SvUTF8(src)) {
	src = sv_mortalcopy(src);
	sv_utf8_upgrade(src);
    }

    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dstlen = srclen * MaxLenFmUni + 1;

    dst = newSV(dstlen);
    (void)SvPOK_only(dst);

    if (cvref) {
	for (p = s; p < e;) {
	    uv = utf8n_to_uvuni(p, e - p, &retlen, 0);
	    p += retlen;

	    j = 0;
	    if (isbase (uv) && p < e) {
		uv2 = utf8n_to_uvuni(p, e - p, &retlen, 0);
		j = (U16)getcomposite(uv, uv2);
		if (j)
		    p += retlen;
	    }
	    if (!j) {
	        tbl_plain = uv < VALID_UTF_MAX ?
		    tosjis0213_tbl[uv >> 16] : NULL;
		tbl_row = tbl_plain ? tbl_plain[(uv >> 8) & 0xff] : NULL;
		j = tbl_row ? tbl_row[uv & 0xff] : 0;
	    }

	    if (j || !uv) {
		if (j >= 256) {
		    mbc[0] = (U8)(j >> 8);
		    mbc[1] = (U8)(j & 0xff);
		    sv_catpvn(dst, (char*)mbc, 2);
		}
		else {
		    mbc[0] = (U8)(j & 0xff);
		    sv_catpvn(dst, (char*)mbc, 1);
		}
	    }
	    else
		sv_cat_retcvref(dst, cvref, newSVuv(uv));
	}
    }
    else {
	d = (U8*)SvPVX(dst);
	for (p = s; p < e;) {
	    uv = utf8n_to_uvuni(p, e - p, &retlen, 0);
	    p += retlen;

	    j = 0;
	    if (isbase (uv) && p < e) {
		uv2 = utf8n_to_uvuni(p, e - p, &retlen, 0);
		j = (U16)getcomposite(uv, uv2);
		if (j)
		    p += retlen;
	    }
	    if (!j) {
	        tbl_plain = uv < VALID_UTF_MAX ?
		    tosjis0213_tbl[uv >> 16] : NULL;
		tbl_row = tbl_plain ? tbl_plain[(uv >> 8) & 0xff] : NULL;
		j = tbl_row ? tbl_row[uv & 0xff] : 0;
	    }

	    if (j || !uv) {
		if (j >= 256)
		    *d++ = (U8)(j >> 8);
		*d++ = (U8)(j & 0xff);
	    }
	}
	*d = '\0';
	SvCUR_set(dst, d - (U8*)SvPVX(dst));
    }
    XPUSHs(sv_2mortal(dst));


void
utf16le_to_sjis0213 (arg1, arg2=0)
    SV* arg1
    SV* arg2
  PROTOTYPE: $;$
  ALIAS:
    utf16be_to_sjis0213 = 1
  PREINIT:
    SV *src, *dst, *cvref;
    STRLEN srclen, dstlen;
    U8 *s, *e, *p, *d, row, cell, mbc[3];
    U16 j, *tbl_row, **tbl_plain;
    UV uv, uv2, luv;
  PPCODE:
    cvref = NULL;
    if (items == 2)
	if (SvROK(arg1) && SvTYPE(SvRV(arg1)) == SVt_PVCV)
	    cvref = SvRV(arg1);
	else
	    croak(PkgName " 1st argument is not CODEREF");

    src = cvref ? arg2 : arg1;
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dstlen = srclen * MaxLenFmU16 + 1;

    dst = newSV(dstlen);
    (void)SvPOK_only(dst);

    if (cvref) {
	for (p = s; p < e;) {
	    if (p + 1 == e) /* odd byte */
		break;

	    row  = ix ? p[0] : p[1];
	    cell = ix ? p[1] : p[0];
	    uv = (UV)((row << 8) | cell);
	    p += 2;

	    if (0xD800 <= uv && uv <= 0xDBFF && (1 < e - p)) {
		row  = ix ? p[0] : p[1];
		cell = ix ? p[1] : p[0];
		luv  = (row << 8) | cell;
		if (0xDC00 <= luv && luv <= 0xDFFF) {
		    uv = 0x10000 + ((uv-0xD800) * 0x400) + (luv-0xDC00);
		    p += 2;
		}
	    }

	    j = 0;
	    if (isbase(uv) && (1 < e - p)) {
		row  = ix ? p[0] : p[1];
		cell = ix ? p[1] : p[0];
		uv2 = (UV)((row << 8) | cell);
		j = (U16)getcomposite(uv, uv2);
		if (j)
		    p += 2;
	    }
	    if (!j) {
	        tbl_plain = uv < VALID_UTF_MAX ?
		    tosjis0213_tbl[uv >> 16] : NULL;
		tbl_row = tbl_plain ? tbl_plain[(uv >> 8) & 0xff] : NULL;
		j = tbl_row ? tbl_row[uv & 0xff] : 0;
	    }

	    if (j || !uv) {
		if (j >= 256) {
		    mbc[0] = (U8)(j >> 8);
		    mbc[1] = (U8)(j & 0xff);
		    sv_catpvn(dst, (char*)mbc, 2);
		}
		else {
		    mbc[0] = (U8)(j & 0xff);
		    sv_catpvn(dst, (char*)mbc, 1);
		}
	    }
	    else
		sv_cat_retcvref(dst, cvref, newSVuv(uv));
	}
    } else {
	d = (U8*)SvPVX(dst);

	for (p = s; p < e;) {
	    if (p + 1 == e) /* odd byte */
		break;

	    row  = ix ? p[0] : p[1];
	    cell = ix ? p[1] : p[0];
	    uv = (UV)((row << 8) | cell);
	    p += 2;

	    if (0xD800 <= uv && uv <= 0xDBFF && (1 < e - p)) {
		row  = ix ? p[0] : p[1];
		cell = ix ? p[1] : p[0];
		luv = (row << 8) | cell;
		if (0xDC00 <= luv && luv <= 0xDFFF) {
		    uv = 0x10000 + ((uv-0xD800) * 0x400) + (luv-0xDC00);
		    p += 2;
		}
	    }

	    j = 0;
	    if (isbase(uv) && (1 < e - p)) {
		row  = ix ? p[0] : p[1];
		cell = ix ? p[1] : p[0];
		uv2 = (UV)((row << 8) | cell);
		j = (U16)getcomposite(uv, uv2);
		if (j)
		    p += 2;
	    }
	    if (!j) {
	        tbl_plain = uv < VALID_UTF_MAX ?
		    tosjis0213_tbl[uv >> 16] : NULL;
		tbl_row = tbl_plain ? tbl_plain[(uv >> 8) & 0xff] : NULL;
		j = tbl_row ? tbl_row[uv & 0xff] : 0;
	    }

	    if (j || !uv) {
		if (j >= 256)
		    *d++ = (U8)(j >> 8);
		*d++ = (U8)(j & 0xff);
	    }
	}
	*d = '\0';
	SvCUR_set(dst, d - (U8*)SvPVX(dst));
    }
    XPUSHs(sv_2mortal(dst));

