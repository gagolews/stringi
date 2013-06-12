/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
 * 
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
 */
 
#include "stringi.h"


/** 
 * Detect if a pattern occurs in a string
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 * @version 0.1 (Marcin Bujarski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16
 * @version 0.3 (Marek Gagolewski) - use StriContainerUTF16's vectorization
 */
SEXP stri_detect_regex(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   // this will work for nmax == 0:
   
   SEXP ret;
   PROTECT(ret = allocVector(LGLSXP, nmax));
 
   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
 
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(ss, pp, LOGICAL(ret)[i] = NA_LOGICAL, LOGICAL(ret)[i] = FALSE)
      
      RegexMatcher *matcher = pp->vectorize_getMatcher(i); // will be deleted automatically
      matcher->reset(ss->get(i));
      LOGICAL(ret)[i] = (int)matcher->find();
   }
   
   delete ss;
   delete pp;
   UNPROTECT(1);
   return ret;
}


// Another version (MG)
// No conversion to UTF-16, using UText
// This is slower than the StriContainerUTF16 + C++ API for regex
// Well... we've tried. :)
//
//SEXP stri_detect_regex(SEXP str, SEXP pattern)
//{
//   str = stri_prepare_arg_string(str, "str");
//   pattern = stri_prepare_arg_string(pattern, "pattern");
//   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
//   // this will work for nmax == 0:
//   
//   SEXP ret;
//   PROTECT(ret = allocVector(LGLSXP, nmax));
// 
//   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
//   StriContainerUTF8* pp = new StriContainerUTF8(pattern, nmax);
// 
//   UText *uts = NULL;
//   UText *utp = NULL;
//   const String8* last_s = NULL;
//   const String8* last_p = NULL;
//   URegularExpression* matcher = NULL;
//   UErrorCode err = U_ZERO_ERROR;
//   
//   for (R_len_t i = pp->vectorize_init();
//         i != pp->vectorize_end();
//         i = pp->vectorize_next(i))
//   {
//      if (pp->isNA(i) || ss->isNA(i)) {
//         LOGICAL(ret)[i] = NA_LOGICAL;
//      }
//      else {
//         const String8* cur_s = &(ss->get(i));
//         const String8* cur_p = &(pp->get(i));
//         
//         if (last_p != cur_p) {
//            last_p = cur_p;
//            if (matcher) uregex_close(matcher);
//            utp = utext_openUTF8(utp, last_p->c_str(), last_p->length(), &err);
//            matcher = uregex_openUText(utp, 0, NULL, &err);
//            if (U_FAILURE(err))
//               error(MSG__REGEXP_FAILED);
//         }
//         
//         if (last_s != cur_s) {
//            last_s = cur_s;
//            uts = utext_openUTF8(uts, last_s->c_str(), last_s->length(), &err);
//         }
//         
//         uregex_setUText(matcher, uts, &err);
//         uregex_reset(matcher, 0, &err);
//         int found = (int)uregex_find(matcher, -1, &err);
//         LOGICAL(ret)[i] = found;
//         if (U_FAILURE(err))
//            error(MSG__REGEXP_FAILED);
//      }
//   }
//   
//   if (matcher) uregex_close(matcher);
//   if (uts) utext_close(uts);
//   if (utp) utext_close(utp);
//   delete ss;
//   delete pp;
//   UNPROTECT(1);
//   return ret;
//}

