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
#include "stri_container_utf8_indexable.h"
#include <deque>
#include <utility>
#include <unicode/brkiter.h>


/** Locate or Split string by all BreakIterator boundaries
 *
 * @param str character vector
 * @param boundary single string, one of \code{character},
 * \code{line-break}, \code{sentence}, or \code{word}
 * @param locale identifier
 * @param split [internal]
 * @return character vector
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-27)
 *          return NA if no matches found
 */
SEXP stri__split_or_locate_boundaries(SEXP str, SEXP boundary, SEXP locale, bool split)
{
   str = stri_prepare_arg_string(str, "str");
   boundary = stri_prepare_arg_string(boundary, "boundary");
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true);
   Locale loc = Locale::createFromName(qloc);

   R_len_t str_length = LENGTH(str);
   R_len_t boundary_length = LENGTH(boundary);
   R_len_t vectorize_length = stri__recycling_rule(true, 2,
      str_length, boundary_length);

   const char* boundary_opts[] = {"character", "line_break",
      "sentence", "word", NULL};

   BreakIterator* briter = NULL;
   UText* str_text = NULL;
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8_indexable str_cont(str, vectorize_length);
   StriContainerUTF8 boundary_cont(boundary, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   int last_boundary = -1;
   for (R_len_t i = boundary_cont.vectorize_init();
         i != boundary_cont.vectorize_end();
         i = boundary_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || boundary_cont.isNA(i)) {
         if (split) {
            SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         }
         else {
            SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));
         }
         continue;
      }

      // get the boundary type and open BreakIterator (if needed)
      int boundary_cur = stri__match_arg(boundary_cont.get(i).c_str(), boundary_opts);
      if (boundary_cur < 0)
         throw StriException(MSG__INCORRECT_MATCH_OPTION, "boundary");

      if (last_boundary != boundary_cur) { // otherwise reuse BreakIterator
         if (briter) { delete briter; briter = NULL; }
         last_boundary = boundary_cur;
         UErrorCode status = U_ZERO_ERROR;
         switch (boundary_cur) {
            case 0: // character
               briter = BreakIterator::createCharacterInstance(loc, status);
               break;

            case 1: // line_break
               briter = BreakIterator::createLineInstance(loc, status);
               break;

            case 2: // sentence
               briter = BreakIterator::createSentenceInstance(loc, status);
               break;

            case 3: // word
               briter = BreakIterator::createWordInstance(loc, status);
               break;

//            case 4: // title
//               briter = (RuleBasedBreakIterator*)BreakIterator::createTitleInstance(loc, status);
//               break;
         }
         if (U_FAILURE(status))
            throw StriException(status); // briter will be deleted automagically
      }

      // get the current string
      UErrorCode status = U_ZERO_ERROR;
      const char* str_cur_s = str_cont.get(i).c_str();
      str_text = utext_openUTF8(str_text, str_cur_s, str_cont.get(i).length(), &status);
      if (U_FAILURE(status))
         throw StriException(status);
      briter->setText(str_text, status);
      if (U_FAILURE(status))
         throw StriException(status);

      deque< pair<R_len_t,R_len_t> > occurences; // this could be an R_len_t queue
      R_len_t match, last_match = briter->first();
      while ((match = briter->next()) != BreakIterator::DONE) {
         occurences.push_back(pair<R_len_t, R_len_t>(last_match, match));
         last_match = match;
      }

      R_len_t noccurences = (R_len_t)occurences.size();
      if (noccurences <= 0) {
         if (split) {
            SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         }
         else {
            SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));
         }
         continue;
      }

      if (split) {
         SEXP ans;
         STRI__PROTECT(ans = Rf_allocVector(STRSXP, noccurences));
         deque< pair<R_len_t,R_len_t> >::iterator iter = occurences.begin();
         for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
            SET_STRING_ELT(ans, j, Rf_mkCharLenCE(str_cur_s+(*iter).first,
               (*iter).second-(*iter).first, CE_UTF8));
         }
         SET_VECTOR_ELT(ret, i, ans);
         STRI__UNPROTECT(1);
      }
      else {
         SEXP ans;
         STRI__PROTECT(ans = Rf_allocMatrix(INTSXP, noccurences, 2));
         int* ans_tab = INTEGER(ans);
         deque< pair<R_len_t, R_len_t> >::iterator iter = occurences.begin();
         for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
            pair<R_len_t, R_len_t> cur_match = *iter;
            ans_tab[j]             = cur_match.first;
            ans_tab[j+noccurences] = cur_match.second;
         }

         // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
         str_cont.UTF8_to_UChar32_index(i, ans_tab,
               ans_tab+noccurences, noccurences,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
         SET_VECTOR_ELT(ret, i, ans);
         STRI__UNPROTECT(1);
      }
   }

   if (briter) { delete briter; briter = NULL; }
   if (str_text) { utext_close(str_text); str_text = NULL; }
   if (!split)
      stri__locate_set_dimnames_list(ret);
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (briter) { delete briter; briter = NULL; }
      if (str_text) { utext_close(str_text); str_text = NULL; }
   })
}


/** Locate all BreakIterator boundaries
 *
 * @param str character vector
 * @param boundary single string, one of \code{character},
 * \code{line-break}, \code{sentence}, or \code{word}
 * @param locale identifier
 * @return character vector
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-22)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-23)
 *          removed "title": For Unicode 4.0 and above title boundary
 *          iteration, please use Word Boundary iterator.
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *          use stri__split_or_locate_boundaries
 */
SEXP stri_locate_boundaries(SEXP str, SEXP boundary, SEXP locale)
{
   return stri__split_or_locate_boundaries(str, boundary, locale, false);
}


/** Split a string at BreakIterator boundaries
 *
 * @param str character vector
 * @param boundary single string, one of \code{character},
 * \code{line_break}, \code{sentence}, \code{word}
 * @param locale identifier
 * @return character vector
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-21)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-23)
 *          removed "title": For Unicode 4.0 and above title boundary
 *          iteration, please use Word Boundary iterator.
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *          use stri__split_or_locate_boundaries
 */
SEXP stri_split_boundaries(SEXP str, SEXP boundary, SEXP locale)
{
   return stri__split_or_locate_boundaries(str, boundary, locale, true);
}
