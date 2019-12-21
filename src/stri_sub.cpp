/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#include "stri_stringi.h"
#include "stri_container_utf8_indexable.h"
#include "stri_string8buf.h"
#include <stdexcept>

/***
 * used both in stri_sub and stri_sub_replacement
 *
 * @return number of objects PROTECTEd
 */
R_len_t stri__sub_prepare_from_to_length(SEXP& from, SEXP& to, SEXP& length,
   R_len_t& from_len, R_len_t& to_len, R_len_t& length_len,
   int*& from_tab, int*& to_tab, int*& length_tab)
{
   R_len_t sub_protected = 0;
   bool from_ismatrix = Rf_isMatrix(from);
   if (from_ismatrix) {
      SEXP t;
      PROTECT(t = Rf_getAttrib(from, R_DimSymbol));
      if (INTEGER(t)[1] == 1)
         from_ismatrix = false; /* it's a column vector */
      else if (INTEGER(t)[1] > 2) {
         /* error() is allowed here */
         UNPROTECT(1); // t
         Rf_error(MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS, "from", 2);
      }
      UNPROTECT(1); // t
   }

   sub_protected++;
   PROTECT(from = stri_prepare_arg_integer(from, "from"));
   /* may remove R_DimSymbol */

   if (from_ismatrix) {
      from_len      = LENGTH(from)/2;
      to_len        = from_len;
      from_tab      = INTEGER(from);
      to_tab        = from_tab+from_len;
      //PROTECT(to); /* fake - not to provoke stack imbalance */
      //PROTECT(length); /* fake - not to provoke stack imbalance */
   }
   else if (isNull(length)) {
      sub_protected++;
      PROTECT(to    = stri_prepare_arg_integer(to, "to"));
      from_len      = LENGTH(from);
      from_tab      = INTEGER(from);
      to_len        = LENGTH(to);
      to_tab        = INTEGER(to);
      //PROTECT(length); /* fake - not to provoke stack imbalance */
   }
   else {
      sub_protected++;
      PROTECT(length= stri_prepare_arg_integer(length, "length"));
      from_len      = LENGTH(from);
      from_tab      = INTEGER(from);
      length_len    = LENGTH(length);
      length_tab    = INTEGER(length);
      //PROTECT(to); /* fake - not to provoke stack imbalance */
   }
   return sub_protected;

   /* rchk reports that this function
    * [PB] has possible protection stack imbalance
    *
    * well, of course it does!! -> this is by design, UPROTECTing somewhere else.
    */
}


/***
 * used both in stri_sub and stri_sub_replacement
 */
inline void stri__sub_get_indices(StriContainerUTF8_indexable& str_cont, R_len_t& i,
                           R_len_t& cur_from,  R_len_t& cur_to,
                           R_len_t& cur_from2, R_len_t& cur_to2)
{
   if (cur_from >= 0) {
      cur_from--; /* 1-based -> 0-based index */
      cur_from2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_from);
   }
   else {
      cur_from  = -cur_from;
      cur_from2 = str_cont.UChar32_to_UTF8_index_back(i, cur_from);
   }
   if (cur_to >= 0) {
      ; /* do nothing with cur_to ; 1-based -> 0-based index */
        /* but +1 as we need the next one (bound) */
      cur_to2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_to);
   }
   else {
      cur_to  = -cur_to - 1;
      cur_to2 = str_cont.UChar32_to_UTF8_index_back(i, cur_to);
   }
}


/**
 * Get substring
 *
 *
 * @param str character vector
 * @param from integer vector (possibly with negative indices)
 * @param to integer vector (possibly with negative indices) or NULL
 * @param length integer vector or NULL
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *          stri_sub
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF8 and stri__UChar32_to_UTF8_index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          use StriContainerUTF8's UChar32-to-UTF8 index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          Use StriContainerUTF8_indexable
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 *          Use stri__sub_prepare_from_to_length()
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.5-9003 (Marek Gagolewski, 2015-08-05)
 *    Bugfix #183: floating point exception when to or length is an empty vector
 */
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));

   R_len_t str_len       = LENGTH(str);
   R_len_t from_len      = 0;
   R_len_t to_len        = 0;
   R_len_t length_len    = 0;
   int* from_tab         = 0;
   int* to_tab           = 0;
   int* length_tab       = 0;

   R_len_t sub_protected =  1+  /* how many objects to PROTECT on ret? */
      stri__sub_prepare_from_to_length(from, to, length,
      from_len, to_len, length_len, from_tab, to_tab, length_tab);

   R_len_t vectorize_len = stri__recycling_rule(true, 3,
      str_len, from_len, (to_len>length_len)?to_len:length_len);

   if (vectorize_len <= 0) {
      UNPROTECT(sub_protected);
      return Rf_allocVector(STRSXP, 0);
   }

   STRI__ERROR_HANDLER_BEGIN(sub_protected)
   StriContainerUTF8_indexable str_cont(str, vectorize_len);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_len));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_len];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_len]:length_tab[i % length_len];
      if (str_cont.isNA(i) || cur_from == NA_INTEGER || cur_to == NA_INTEGER) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      if (length_tab) {
         if (cur_to <= 0) {
            SET_STRING_ELT(ret, i, R_BlankString);
            continue;
         }
         cur_to = cur_from + cur_to - 1;
         if (cur_from < 0 && cur_to >= 0) cur_to = -1;
      }

      const char* str_cur_s = str_cont.get(i).c_str();

      R_len_t cur_from2; // UTF-8 byte indices
      R_len_t cur_to2;   // UTF-8 byte indices

      stri__sub_get_indices(str_cont, i, cur_from, cur_to, cur_from2, cur_to2);

      if (cur_to2 > cur_from2) { // just copy
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cur_s+cur_from2, cur_to2-cur_from2, CE_UTF8));
      }
      else {
         // maybe a warning here?
         SET_STRING_ELT(ret, i, Rf_mkCharLen(NULL, 0));
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Substring replacement function
 *
 *
 * @param str character vector
 * @param from integer vector (possibly with negative indices)
 * @param to integer vector (possibly with negative indices) or NULL
 * @param length integer vector or NULL
 * @param omit_na logical scalar
 * @param value character vector replacement
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF8 and stri__UChar32_to_UTF8_index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          use StriContainerUTF8's UChar32-to-UTF8 index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          Use StriContainerUTF8_indexable
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 *          Use stri__sub_prepare_from_to_length()
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.5-9003 (Marek Gagolewski, 2015-08-05)
 *    Bugfix #183: floating point exception when to or length is an empty vector
 *
 * @version 1.0-2 (Marek Gagolewski, 2016-01-31)
 *    FR #199: new arg: `omit_na`
 *    FR #207: allow insertions
 *
 *
 * @version 1.4.3 (Marek Gagolewski, 2019-03-12)
 *    #346: na_omit for `value`
 */
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to, SEXP length, SEXP omit_na, SEXP value)
{
   PROTECT(str   = stri_prepare_arg_string(str, "str"));
   PROTECT(value = stri_prepare_arg_string(value, "value"));
   bool omit_na_1 = stri__prepare_arg_logical_1_notNA(omit_na, "omit_na");

   R_len_t value_len     = LENGTH(value);
   R_len_t str_len       = LENGTH(str);
   R_len_t from_len      = 0; // see below
   R_len_t to_len        = 0; // see below
   R_len_t length_len    = 0; // see below
   int* from_tab         = 0; // see below
   int* to_tab           = 0; // see below
   int* length_tab       = 0; // see below

   R_len_t sub_protected =  2+ /* how many objects to PROTECT on ret? */
      stri__sub_prepare_from_to_length(from, to, length,
      from_len, to_len, length_len, from_tab, to_tab, length_tab);

   R_len_t vectorize_len = stri__recycling_rule(true, 4,
      str_len, value_len, from_len, (to_len>length_len)?to_len:length_len);

   if (vectorize_len <= 0) {
      UNPROTECT(sub_protected);
      return Rf_allocVector(STRSXP, 0);
   }

   STRI__ERROR_HANDLER_BEGIN(sub_protected)
   StriContainerUTF8_indexable str_cont(str, vectorize_len);
   StriContainerUTF8 value_cont(value, vectorize_len);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_len));
   String8buf buf(0); // @TODO: estimate bufsize a priori

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_len];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_len]:length_tab[i % length_len];

      if (str_cont.isNA(i)) {
          SET_STRING_ELT(ret, i, NA_STRING);
          continue;
      }
      if (cur_from == NA_INTEGER || cur_to == NA_INTEGER || value_cont.isNA(i)) {
         if (omit_na_1) {
            SET_STRING_ELT(ret, i, str_cont.toR(i));
         }
         else {
            SET_STRING_ELT(ret, i, NA_STRING);
         }
         continue;
      }

      if (length_tab) {
         if (cur_to <= 0) {
            // SET_STRING_ELT(ret, i, R_BlankString);
            // continue;
            cur_to = 0;
         }
         else {
            cur_to = cur_from + cur_to - 1;
            if (cur_from < 0 && cur_to >= 0) cur_to = -1;
         }
      }

      const char* str_cur_s   = str_cont.get(i).c_str();
      R_len_t str_cur_n       = str_cont.get(i).length();
      const char* value_cur_s = value_cont.get(i).c_str();
      R_len_t value_cur_n     = value_cont.get(i).length();

      R_len_t cur_from2; // UTF-8 byte indices
      R_len_t cur_to2;   // UTF-8 byte indices

      stri__sub_get_indices(str_cont, i, cur_from, cur_to, cur_from2, cur_to2);
      if (cur_to2 < cur_from2) cur_to2 = cur_from2;

      R_len_t buflen = str_cur_n-(cur_to2-cur_from2)+value_cur_n;
      buf.resize(buflen, false/*destroy contents*/);
      if (cur_from2 > 0)
         memcpy(buf.data(), str_cur_s, (size_t)cur_from2);
      if (value_cur_n > 0)
         memcpy(buf.data()+cur_from2, value_cur_s, (size_t)value_cur_n);
      if (str_cur_n-cur_to2 > 0)
         memcpy(buf.data()+cur_from2+value_cur_n, str_cur_s+cur_to2, (size_t)str_cur_n-cur_to2);
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buflen, CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}



/**
 * Extract multiple substrings
 *
 *
 * @param str character vector
 * @param from list
 * @param to list
 * @param length list
 * @return list of character vectors
 *
 * @version 1.3.2 (Marek Gagolewski, 2019-02-21)
 *    #30: new function
 */
SEXP stri_sub_all(SEXP str, SEXP from, SEXP to, SEXP length)
{
   PROTECT(str    = stri_prepare_arg_string(str, "str"));
   PROTECT(from   = stri_prepare_arg_list(from, "from"));
   PROTECT(to     = stri_prepare_arg_list(to, "to"));
   PROTECT(length = stri_prepare_arg_list(length, "length"));

   R_len_t str_len       = LENGTH(str);
   R_len_t from_len      = LENGTH(from);
   // R_len_t to_len        = LENGTH(to);
   // R_len_t length_len    = LENGTH(length);


   R_len_t vectorize_len;
   if (!isNull(to))
      vectorize_len = stri__recycling_rule(true, 3,
         str_len, from_len, LENGTH(to));
   else if (!isNull(length))
      vectorize_len = stri__recycling_rule(true, 3,
        str_len, from_len, LENGTH(length));
   else
      vectorize_len = stri__recycling_rule(true, 2, str_len, from_len);

   if (vectorize_len <= 0) {
      UNPROTECT(4);
      return Rf_allocVector(VECSXP, 0);
   }


  // no STRI__ERROR_HANDLER_BEGIN  block ---- stri_sub can longjmp with Rf_error...

   SEXP ret, str_tmp, tmp;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_len)); //5
   PROTECT(str_tmp = Rf_allocVector(STRSXP, 1));         //6

   for (R_len_t i = 0; i<vectorize_len; ++i)
   {
      PROTECT(tmp = STRING_ELT(str, i%str_len));
      SET_STRING_ELT(str_tmp, 0, tmp);
      UNPROTECT(1); //tmp

      if (!isNull(to)) {
         PROTECT(tmp = stri_sub(str_tmp,
              VECTOR_ELT(from, i%from_len), VECTOR_ELT(to, i%LENGTH(to)), R_NilValue));
      }
      else if (!isNull(length)) {
         PROTECT(tmp = stri_sub(str_tmp,
              VECTOR_ELT(from, i%from_len), R_NilValue, VECTOR_ELT(length, i%LENGTH(length))));
      }
      else {
         PROTECT(tmp = stri_sub(str_tmp,
              VECTOR_ELT(from, i%from_len), R_NilValue, R_NilValue));
      }

      SET_VECTOR_ELT(ret, i, tmp);
      UNPROTECT(1); //tmp
   }

   UNPROTECT(6);
   return ret;
}


/** internal function - replace multiple substrings in a single string
 * can raise Rf_error
 *
 *  @version 1.3.2 (Marek Gagolewski, 2019-02-23)
 *
 * @version 1.4.3 (Marek Gagolewski, 2019-03-12)
 *    #346: na_omit for `value`
 *
 * @version 1.4.4 (Marek Gagolewski, 2019-03-13)-
 *    #348: UBSAN runtime error: null pointer passed as argument 1,
 *     which is declared to never be null
 */
SEXP stri__sub_replacement_all_single(SEXP curs,
    SEXP from, SEXP to, SEXP length, bool omit_na_1, SEXP value)
{
    // curs is a CHARSXP in UTF-8

    PROTECT(value = stri_enc_toutf8(value,
        Rf_ScalarLogical(FALSE), Rf_ScalarLogical(FALSE)));
    R_len_t value_len     = LENGTH(value);

    R_len_t from_len      = 0; // see below
    R_len_t to_len        = 0; // see below
    R_len_t length_len    = 0; // see below
    int* from_tab         = 0; // see below
    int* to_tab           = 0; // see below
    int* length_tab       = 0; // see below

    R_len_t sub_protected = 1+ /* how many objects to PROTECT on ret? */
        stri__sub_prepare_from_to_length(from, to, length,
        from_len, to_len, length_len, from_tab, to_tab, length_tab);

    R_len_t vectorize_len = stri__recycling_rule(true, 2, // does not care about value_len
      from_len, (to_len>length_len)?to_len:length_len);

    if (vectorize_len <= 0) { // "nothing" is being replaced -> return the input as-is
        UNPROTECT(sub_protected);
        return curs;
    }
    if (value_len <= 0) { // things are supposed to be replaced with "nothing"...
        UNPROTECT(sub_protected);
        Rf_warning(MSG__REPLACEMENT_ZERO);
        return NA_STRING;
    }

    if (vectorize_len % value_len != 0)
        Rf_warning(MSG__WARN_RECYCLING_RULE2);


    const char* curs_s = CHAR(curs); // already in UTF-8
    R_len_t curs_n = LENGTH(curs);

    // first check for NAs....
    if (!omit_na_1) {
       for (R_len_t i=0; i<vectorize_len; ++i) {
           R_len_t cur_from     = from_tab[i % from_len];
           R_len_t cur_to       = (to_tab)?to_tab[i % to_len]:length_tab[i % length_len];
           if (cur_from == NA_INTEGER || cur_to == NA_INTEGER) {
               UNPROTECT(sub_protected);
               if (omit_na_1) return curs;
               else return NA_STRING;
           }
       }

       for (R_len_t i=0; i<vectorize_len; ++i) {
           if (STRING_ELT(value, i%value_len) == NA_STRING) {
               UNPROTECT(sub_protected);
               return NA_STRING;
           }
       }
    }

    // get the number of code points in curs, if required (for negative indexes)
    R_len_t curs_m = -1;
    if (IS_ASCII(curs)) curs_m = curs_n;
    else { // is UTF-8
        curs_m = 0;    // code points count
        R_len_t j = 0; // byte pos
        while (j < curs_n) {
            U8_FWD_1_UNSAFE(curs_s, j);
            ++curs_m;
        }
    }

    STRI__ERROR_HANDLER_BEGIN(sub_protected)
    std::vector<char> buf; // convenience >> speed

    R_len_t last_pos = 0;
    R_len_t byte_pos = 0;
    for (R_len_t i=0; i<vectorize_len; ++i) {
        R_len_t cur_from     = from_tab[i % from_len];
        R_len_t cur_to       = (to_tab)?to_tab[i % to_len]:length_tab[i % length_len];

        if (cur_from == NA_INTEGER || cur_to == NA_INTEGER || STRING_ELT(value, i%value_len) == NA_STRING) {
           // omit_na is true
           continue;
        }

        if (cur_from < 0) cur_from = curs_m+cur_from+1;
        if (cur_from <= 0) cur_from = 1;
        cur_from--; // 1-based -> 0-based index
        if (cur_from >= curs_m) cur_from = curs_m;

        // cur_from is in [0, curs_m]

        if (length_tab) {
            if (cur_to < 0) cur_to = 0;
            cur_to = cur_from+cur_to;
        }
        else {
            if (cur_to < 0)  cur_to = curs_m+cur_to+1;
            if (cur_to < cur_from) cur_to = cur_from; // insertion
        }
        if (cur_to >= curs_m) cur_to = curs_m;

        // the chunk to replace is at code points [cur_from, cur_to)

        // Rprintf("orig [%d,%d) repl [%d,%d)\n", last_pos, cur_from, cur_from, cur_to);

        if (last_pos > cur_from)
            throw StriException(MSG__OVERLAPPING_OR_UNSORTED_INDEXES);

        // first, copy [last_pos, cur_from)
        R_len_t byte_pos_last = byte_pos;
        while (last_pos < cur_from) {
            U8_FWD_1_UNSAFE(curs_s, byte_pos);
            ++last_pos;
        }

        if (byte_pos-byte_pos_last > 0) {
           R_len_t buf_size = buf.size();
           buf.resize(buf_size+byte_pos-byte_pos_last);
           if (!buf.data() || !curs_s)
              throw StriException(MSG__MEM_ALLOC_ERROR);
           memcpy(buf.data()+buf_size, curs_s+byte_pos_last, byte_pos-byte_pos_last);
        }

        // then, copy the corresponding replacement string
        SEXP value_cur = STRING_ELT(value, i%value_len);
        const char* value_s = CHAR(value_cur);
        R_len_t value_n = LENGTH(value_cur);
        if (value_n > 0) {
           R_len_t buf_size = buf.size();
           buf.resize(buf_size+value_n);
           if (!buf.data() || !value_s)
              throw StriException(MSG__MEM_ALLOC_ERROR);
           memcpy(buf.data()+buf_size, value_s, value_n);
        }


        // lastly, update last_pos
        // ---> last_pos = cur_to;
        while (last_pos < cur_to) {
            U8_FWD_1_UNSAFE(curs_s, byte_pos);
            ++last_pos;
        }
    }

    // finally, copy [last_pos, curs_m)
    if (curs_n-byte_pos > 0) {
       R_len_t buf_size = buf.size();
       buf.resize(buf_size+curs_n-byte_pos);
       if (!buf.data() || !curs_s)
          throw StriException(MSG__MEM_ALLOC_ERROR);
       memcpy(buf.data()+buf_size, curs_s+byte_pos, curs_n-byte_pos);
    }

    SEXP ret;
    STRI__PROTECT(ret = Rf_mkCharLenCE(buf.data(), buf.size(), CE_UTF8));
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Replace multiple substrings
 *
 *
 * @param str character vector
 * @param from integer vector (possibly with negative indices)
 * @param to integer vector (possibly with negative indices) or NULL
 * @param length integer vector or NULL
 * @param omit_na logical scalar
 * @param value character vector replacement
 * @return character vector
 *
 * @version 1.3.2 (Marek Gagolewski, 2019-02-22)
 *    #30: new function
 *
 *
 * @version 1.4.3 (Marek Gagolewski, 2019-03-12)
 *    #346: na_omit for `value`
 */
SEXP stri_sub_replacement_all(SEXP str, SEXP from, SEXP to, SEXP length, SEXP omit_na, SEXP value)
{
   //PROTECT(str    = stri_prepare_arg_string(str, "str"));
   PROTECT(str = stri_enc_toutf8(str, Rf_ScalarLogical(FALSE), Rf_ScalarLogical(FALSE)));
   PROTECT(from   = stri_prepare_arg_list(from, "from"));
   PROTECT(to     = stri_prepare_arg_list(to, "to"));
   PROTECT(length = stri_prepare_arg_list(length, "length"));
   PROTECT(value  = stri_prepare_arg_list(value, "value"));
   bool omit_na_1 = stri__prepare_arg_logical_1_notNA(omit_na, "omit_na");

   R_len_t str_len       = LENGTH(str);
   R_len_t from_len      = LENGTH(from);
   R_len_t value_len     = LENGTH(value);


   R_len_t vectorize_len;
   if (!isNull(to))
      vectorize_len = stri__recycling_rule(true, 4,
         str_len, from_len, value_len, LENGTH(to));
   else if (!isNull(length))
      vectorize_len = stri__recycling_rule(true, 4,
        str_len, from_len, value_len, LENGTH(length));
   else
      vectorize_len = stri__recycling_rule(true, 3, str_len, from_len, value_len);

   if (vectorize_len <= 0) {
      UNPROTECT(5);
      return Rf_allocVector(STRSXP, 0);
   }

 // no STRI__ERROR_HANDLER_BEGIN  block ---- below we can longjmp with Rf_error...

   SEXP ret, curs, tmp;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_len)); // 6
   for (R_len_t i = 0; i<vectorize_len; ++i)
   {
      curs = STRING_ELT(str, i%str_len);
      if (curs == NA_STRING) {
          SET_STRING_ELT(ret, i, NA_STRING);
          continue;
      }

      if (!isNull(to)) {
         PROTECT(tmp = stri__sub_replacement_all_single(curs,
              VECTOR_ELT(from, i%from_len),
              VECTOR_ELT(to, i%LENGTH(to)), R_NilValue,
              omit_na_1, VECTOR_ELT(value, i%value_len)));
      }
      else if (!isNull(length)) {
         PROTECT(tmp = stri__sub_replacement_all_single(curs,
              VECTOR_ELT(from, i%from_len),
              R_NilValue, VECTOR_ELT(length, i%LENGTH(length)),
              omit_na_1, VECTOR_ELT(value, i%value_len)));
      }
      else {
         PROTECT(tmp = stri__sub_replacement_all_single(curs,
              VECTOR_ELT(from, i%from_len),
              R_NilValue, R_NilValue,
              omit_na_1, VECTOR_ELT(value, i%value_len)));
      }

      SET_STRING_ELT(ret, i, tmp);
      UNPROTECT(1); //tmp
   }

   UNPROTECT(6);
   return ret;
}
