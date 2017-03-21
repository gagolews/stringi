/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2017, Marek Gagolewski and other contributors.
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
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"
#include <unicode/ucol.h>
#include <vector>
#include <deque>
#include <algorithm>
#include <set>


// !!!! no longer used since stringi_0.2-3 !!!!
///** Compare 2 strings in UTF8, codepoint-wise [internal]
// *
// * Used by stri_order_codepoints and stri_cmp_codepoints
// *
// * @param str1 string in UTF8
// * @param str2 string in UTF8
// * @param n1 length of str1
// * @param n2 length of str2
// * @return -1, 0, or 1, like in strcmp
// *
// * @version 0.1-?? (Marek Gagolewski)
// *
// * @version 0.2-1 (Marek Gagolewski, 2014-03-19)
// *          BUGFIX: possibly incorrect results for strings of inequal number
// *                  of codepoints
// *
// * @version 0.2-1 (Marek Gagolewski, 2014-04-02)
// *          detect invalid UTF-8 byte stream
// */
//int stri__cmp_codepoints(const char* str1, R_len_t n1, const char* str2, R_len_t n2)
//{
//   // @NOTE: strangely, this is being outperformed by ucol_strcollUTF8
//   //        in some UTF-8 benchmarks...
//   int i1 = 0;
//   int i2 = 0;
//   UChar32 c1 = 0;
//   UChar32 c2 = 0;
//   while (c1 == c2 && i1 < n1 && i2 < n2) {
//      U8_NEXT(str1, i1, n1, c1);
//      U8_NEXT(str2, i2, n2, c2);
//      if (c1 < 0 || c2 < 0)
//         throw StriException(MSG__INVALID_UTF8);
//   }
//
//   if (c1 < c2)
//      return -1;
//   else if (c1 > c2)
//      return 1;
//
//   // reached here => first i1==i2 codepoints are the same
//   if (i1 < n1)      return  1;
//   else if (i2 < n2) return -1;
//   else              return  0;
//}


/* *************************************************************************
                                  STRI_CMP_CODEPOINTS
   ************************************************************************* */


/**
 * Compare elements in 2 character vectors, without collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param _negate [internal] integer; 0 or 1 (whether to negate the results)
 *
 * @return logical vector
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_cmp_codepoints(SEXP e1, SEXP e2, int _negate)
{
   // _negate is an internal arg, check manually, error() allowed here
   if (_negate < 0 || _negate > 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG);

   PROTECT(e1 = stri_prepare_arg_string(e1, "e1")); // prepare string argument
   PROTECT(e2 = stri_prepare_arg_string(e2, "e2")); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN(2)

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = 0; i < vectorize_length; ++i)
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      R_len_t     cur1_n = e1_cont.get(i).length();
      const char* cur1_s = e1_cont.get(i).c_str();
      R_len_t     cur2_n = e2_cont.get(i).length();
      const char* cur2_s = e2_cont.get(i).c_str();

      if (cur1_n != cur2_n) // different number of bytes => not equal
         ret_tab[i] = FALSE;
      else
         ret_tab[i] = (memcmp(cur1_s, cur2_s, cur1_n) == 0);

      if (_negate)
         ret_tab[i] = !ret_tab[i];
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({/* no-op on err */})
}


/**
 * Test if elements in 2 character vectors are equal, without collation
 *
 * @param e1 character vector
 * @param e2 character vector
 *
 * @return logical vector
 *
 * @version 0.6-1 (Marek Gagolewski, 2015-07-05)
 *    use stri_cmp_codepoints
 */
SEXP stri_cmp_eq(SEXP e1, SEXP e2) {
   return stri_cmp_codepoints(e1, e2, 0);
}


/**
 * Test if elements in 2 character vectors are non-equal, without collation
 *
 * @param e1 character vector
 * @param e2 character vector
 *
 * @return logical vector
 *
 * @version 0.6-1 (Marek Gagolewski, 2015-07-05)
 *    use stri_cmp_codepoints
 */
SEXP stri_cmp_neq(SEXP e1, SEXP e2) {
   return stri_cmp_codepoints(e1, e2, 1);
}


/* *************************************************************************
                                  STRI_CMP_LOGICAL
   ************************************************************************* */


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 * @param type [internal] vector of length 2,
 * type[0]: 0 for ==, -1 for < and 1 for >,
 * type[1]: 0 or 1 (whether to negate the results)
 *
 * @return logical vector
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-19)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *          opts_collator == NA no longer allowed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__cmp_logical(SEXP e1, SEXP e2, SEXP opts_collator, int _type, int _negate)
{
   // we'll perform a collator-based cmp
   // type is an internal arg, check manually, error() allowed here
   if (_type > 1 || _type < -1 || _negate < 0 || _negate > 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG);

   PROTECT(e1 = stri_prepare_arg_string(e1, "e1")); // prepare string argument
   PROTECT(e2 = stri_prepare_arg_string(e2, "e2")); // prepare string argument

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* col = NULL;
   col = stri__ucol_open(opts_collator);

   STRI__ERROR_HANDLER_BEGIN(2)

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = 0; i < vectorize_length; ++i)
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      R_len_t     cur1_n = e1_cont.get(i).length();
      const char* cur1_s = e1_cont.get(i).c_str();
      R_len_t     cur2_n = e2_cont.get(i).length();
      const char* cur2_s = e2_cont.get(i).c_str();

      // with collation
      UErrorCode status = U_ZERO_ERROR;
      ret_tab[i] = (_type == (int)ucol_strcollUTF8(col,
         cur1_s, cur1_n, cur2_s, cur2_n, &status
      ));
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      if (_negate)
         ret_tab[i] = !ret_tab[i];
   }

   if (col) {
      ucol_close(col);
      col = NULL;
   }
   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({
      if (col) { ucol_close(col); col = NULL; }
   })
}


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return logical vector
 *
 * @version 0.6-1  (Marek Gagolewski, 2015-07-05)
 *    use stri__cmp_logical
 */
SEXP stri_cmp_equiv(SEXP e1, SEXP e2, SEXP opts_collator) {
   return stri__cmp_logical(e1, e2, opts_collator, 0, 0);
}


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return logical vector
 *
 * @version 0.6-1  (Marek Gagolewski, 2015-07-05)
 *    use stri__cmp_logical
 */
SEXP stri_cmp_nequiv(SEXP e1, SEXP e2, SEXP opts_collator) {
   return stri__cmp_logical(e1, e2, opts_collator, 0, 1);
}


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return logical vector
 *
 * @version 0.6-1  (Marek Gagolewski, 2015-07-05)
 *    use stri__cmp_logical
 */
SEXP stri_cmp_lt(SEXP e1, SEXP e2, SEXP opts_collator) {
   return stri__cmp_logical(e1, e2, opts_collator, -1, 0);
}


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return logical vector
 *
 * @version 0.6-1  (Marek Gagolewski, 2015-07-05)
 *    use stri__cmp_logical
 */
SEXP stri_cmp_gt(SEXP e1, SEXP e2, SEXP opts_collator) {
   return stri__cmp_logical(e1, e2, opts_collator, 1, 0);
}


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return logical vector
 *
 * @version 0.6-1  (Marek Gagolewski, 2015-07-05)
 *    use stri__cmp_logical
 */
SEXP stri_cmp_le(SEXP e1, SEXP e2, SEXP opts_collator) {
   return stri__cmp_logical(e1, e2, opts_collator, 1, 1);
}


/**
 * Compare elements in 2 character vectors, with collation [INTERNAL]
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return logical vector
 *
 * @version 0.6-1  (Marek Gagolewski, 2015-07-05)
 *    use stri__cmp_logical
 */
SEXP stri_cmp_ge(SEXP e1, SEXP e2, SEXP opts_collator) {
   return stri__cmp_logical(e1, e2, opts_collator, -1, 1);
}


/* *************************************************************************
                                  STRI_CMP
   ************************************************************************* */

/**
 * Compare character vectors, possibly with collation
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param opts_collator passed to stri__ucol_open()
 *
 * @return integer vector, like strcmp in C
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException friendly
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-27)
 *          moved to UTF16, as ucol_strcollUTF8 is DRAFT
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-16)
 *          using ucol_strcollUTF8 again, as we now require ICU >= 50
 *          [4x speedup utf8, 2x slowdown 8bit]
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-19)
 *          one function for cmp with and without collation
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-07)
 *          opts_collator == NA no longer allowed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_cmp(SEXP e1, SEXP e2, SEXP opts_collator)
{
   PROTECT(e1 = stri_prepare_arg_string(e1, "e1"));
   PROTECT(e2 = stri_prepare_arg_string(e2, "e2"));

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* col = NULL;
   col = stri__ucol_open(opts_collator);

   STRI__ERROR_HANDLER_BEGIN(2)

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);


   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));
   int* ret_int = INTEGER(ret);

   for (R_len_t i = 0; i < vectorize_length; ++i)
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_int[i] = NA_INTEGER;
         continue;
      }

      R_len_t     cur1_n = e1_cont.get(i).length();
      const char* cur1_s = e1_cont.get(i).c_str();
      R_len_t     cur2_n = e2_cont.get(i).length();
      const char* cur2_s = e2_cont.get(i).c_str();

      // cmp with collation
      UErrorCode status = U_ZERO_ERROR;
      ret_int[i] = (int)ucol_strcollUTF8(col,
         cur1_s, cur1_n, cur2_s, cur2_n, &status
      );
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   }

   if (col) {
      ucol_close(col);
      col = NULL;
   }
   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({
      if (col) { ucol_close(col); col = NULL; }
   })
}
