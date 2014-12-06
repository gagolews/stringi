/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
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
#include "stri_string8buf.h"
#include "stri_brkiter.h"
#include <unicode/ucasemap.h>


/**
 *  Convert case (TitleCase)
 *
 *
 *  @param str character vector
 *  @param opts_brkiter list
 *  @return character vector
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-03)
 *    separated from stri_trans_casemap;
 *    use StriUBreakIterator
 *
 */

SEXP stri_trans_totitle(SEXP str, SEXP opts_brkiter) {
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "word");
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument

// version 0.2-1 - Does not work with ICU 4.8 (but we require ICU >= 50)
   UCaseMap* ucasemap = NULL;

   STRI__ERROR_HANDLER_BEGIN(1)
   StriUBreakIterator brkiter(opts_brkiter2);

   UErrorCode status = U_ZERO_ERROR;
   ucasemap = ucasemap_open(brkiter.getLocale(), U_FOLD_CASE_DEFAULT, &status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   status = U_ZERO_ERROR;
   ucasemap_setBreakIterator(ucasemap, brkiter.getIterator(), &status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   brkiter.free(false);
   // ucasemap_setOptions(ucasemap, U_TITLECASE_NO_LOWERCASE, &status); // to do?
   // now briter is owned by ucasemap.
   // it will be released on ucasemap_close
   // (checked with ICU man & src code)

   R_len_t str_n = LENGTH(str);
   StriContainerUTF8 str_cont(str, str_n);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, str_n));


   // STEP 1.
   // Estimate the required buffer length
   // Notice: The resulting number of codepoints may be larger or smaller than
   // the number before casefolding
   R_len_t bufsize = str_cont.getMaxNumBytes();
   bufsize += 10; // a small margin
   String8buf buf(bufsize);

   // STEP 2.
   // Do case folding
   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t str_cur_n     = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      status = U_ZERO_ERROR;
      int buf_need = ucasemap_utf8ToTitle(ucasemap, buf.data(), buf.size(),
               (const char*)str_cur_s, str_cur_n, &status);

      if (U_FAILURE(status)) {
         buf.resize(buf_need, false/*destroy contents*/);
         status = U_ZERO_ERROR;
         buf_need = ucasemap_utf8ToTitle(ucasemap, buf.data(), buf.size(),
               (const char*)str_cur_s, str_cur_n, &status);

         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */}) // this shouldn't happen
                                             // we do have the buffer size required to complete this op
      }

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buf_need, CE_UTF8));
   }

   if (ucasemap) { ucasemap_close(ucasemap); ucasemap = NULL;}
   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({
      if (ucasemap) { ucasemap_close(ucasemap); ucasemap = NULL; }
   })
}


/**
 *  Convert case (TitleCase, lowercase, etc.)
 *
 *
 *  @param str character vector
 *  @param type internal code of case conversion type
 *  @param locale single string identifying
 *         the locale ("" or NULL for default locale)
 *  @return character vector
 *
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF16
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-11-19)
 *          use UCaseMap + StriContainerUTF8
 *          **THIS DOES NOT WORK WITH ICU 4.8**, we have to revert the changes
 *          ** BTW, since stringi_0.1-25 we require ICU>=50 **
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-18)
 *          use UCaseMap + StriContainerUTF8
 *          (this is much faster for UTF-8 and slightly faster for 8bit enc)
 *          Estimates minimal buffer size.
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-24)
 *          Use a custom BreakIterator with stri_trans_totitle
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-03)
 *    use StriUBreakIterator
*/
SEXP stri_trans_casemap(SEXP str, SEXP type, SEXP locale)
{
   if (!Rf_isInteger(type) || LENGTH(type) != 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually
   int _type = INTEGER(type)[0];
   if (_type < 1 || _type > 2) Rf_error(MSG__INCORRECT_INTERNAL_ARG);

   const char* qloc = stri__prepare_arg_locale(locale, "locale", true); /* this is R_alloc'ed */
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument

// version 0.2-1 - Does not work with ICU 4.8 (but we require ICU >= 50)
   UCaseMap* ucasemap = NULL;

   STRI__ERROR_HANDLER_BEGIN(1)
   UErrorCode status = U_ZERO_ERROR;
   ucasemap = ucasemap_open(qloc, U_FOLD_CASE_DEFAULT, &status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   R_len_t str_n = LENGTH(str);
   StriContainerUTF8 str_cont(str, str_n);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, str_n));


   // STEP 1.
   // Estimate the required buffer length
   // Notice: The resulting number of codepoints may be larger or smaller than
   // the number before casefolding
   R_len_t bufsize = str_cont.getMaxNumBytes();
   bufsize += 10; // a small margin
   String8buf buf(bufsize);

   // STEP 2.
   // Do case folding
   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t str_cur_n     = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      status = U_ZERO_ERROR;
      int buf_need;
      if (_type == 1) buf_need = ucasemap_utf8ToLower(ucasemap,
         buf.data(), buf.size(), (const char*)str_cur_s, str_cur_n, &status);
      else buf_need = ucasemap_utf8ToUpper(ucasemap,
         buf.data(), buf.size(), (const char*)str_cur_s, str_cur_n, &status);

      if (U_FAILURE(status)) { /* retry */
         buf.resize(buf_need, false/*destroy contents*/);
         status = U_ZERO_ERROR;
         if (_type == 1) buf_need = ucasemap_utf8ToLower(ucasemap,
            buf.data(), buf.size(), (const char*)str_cur_s, str_cur_n, &status);
         else buf_need = ucasemap_utf8ToUpper(ucasemap,
            buf.data(), buf.size(), (const char*)str_cur_s, str_cur_n, &status);

         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */}) // this shouldn't happen
                                             // we do have the buffer size required to complete this op
      }

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buf_need, CE_UTF8));
   }

   if (ucasemap) { ucasemap_close(ucasemap); ucasemap = NULL;}
   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({
      if (ucasemap) { ucasemap_close(ucasemap); ucasemap = NULL; }
   })
}


// v0.1-?? - UTF-16 - WORKS WITH ICU 4.8
// (this is much slower for UTF-8 and slightly slower for 8bit enc)
// Slower than v0.2-1
////    BreakIterator* briter = NULL;
//
//   STRI__ERROR_HANDLER_BEGIN
//
//   if (!Rf_isInteger(type) || LENGTH(type) != 1)
//      throw StriException(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually
//   int _type = INTEGER(type)[0];
//
//
//   Locale loc = Locale::createFromName(qloc); // this will be freed automatically
//   StriContainerUTF16 str_cont(str, LENGTH(str), false); // writable, no recycle
//
////    if (_type == 6) {
////       UErrorCode status = U_ZERO_ERROR;
////       briter = BreakIterator::createWordInstance(loc, status);
////       STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
////    }
//
//   for (R_len_t i = str_cont.vectorize_init();
//         i != str_cont.vectorize_end();
//         i = str_cont.vectorize_next(i))
//   {
//      if (!str_cont.isNA(i)) {
//         switch (_type) {
//            case 1:
//               str_cont.getWritable(i).toLower(loc);
//               break;
//            case 2:
//               str_cont.getWritable(i).toUpper(loc);
//               break;
//            case 3:
//               str_cont.getWritable(i).toTitle(NULL, loc); // use default ICU's BreakIterator
//               break;
//            case 4:
//               str_cont.getWritable(i).foldCase(U_FOLD_CASE_DEFAULT);
//               break;
//            case 5:
//               str_cont.getWritable(i).foldCase(U_FOLD_CASE_EXCLUDE_SPECIAL_I);
//               break;
////             case 6:
////                str_cont.getWritable(i).toTitle(briter, loc); // how to get it working properly with English text???
////                                                                 I guess ICU doesn't support language-sensitive title casing at all...
////                break;
//            default:
//               throw StriException("stri_trans_case: incorrect case conversion type");
//         }
//      }
//   }
//
////    if (briter) { delete briter; briter = NULL; }
//   SEXP ret;
//   PROTECT(ret = str_cont.toR());
//   UNPROTECT(1);
//   return ret;
//   STRI__ERROR_HANDLER_END(/*noop*/;
////       if (briter) delete briter;
//   )
