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
#include <vector>


/** Select Break Iterator
 *
 * @param opts_brkiter named list
 * @param _default default break iterator type
 * @return break iterator ID
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *                add param `_default`
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
int stri__opts_brkiter_select_iterator(SEXP opts_brkiter, const char* _default) {
   const char* type_opts[] = {"character", "line_break", "sentence", "word", NULL};
   const char* cur = _default;

   if (isNull(opts_brkiter)) {
      // use default settings
   }
   else if (Rf_isVectorList(opts_brkiter)) {
      R_len_t narg = LENGTH(opts_brkiter);
      SEXP names = Rf_getAttrib(opts_brkiter, R_NamesSymbol);
      if (names == R_NilValue || LENGTH(names) != narg)
         Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here
      // search for "locale" option
      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here
         const char* curname = CHAR(STRING_ELT(names, i));
         if (!strcmp(curname, "type")) {
            SEXP curval;
            PROTECT(curval = stri_prepare_arg_string_1(VECTOR_ELT(opts_brkiter, i), "type"));
            if (STRING_ELT(curval, i) == NA_STRING) {
               UNPROTECT(1);
               Rf_error(MSG__INCORRECT_MATCH_OPTION, "type");
            }
            cur = CHAR(STRING_ELT(curval, i));
            int brkiter_cur = stri__match_arg(cur, type_opts);
            UNPROTECT(1);
            if (brkiter_cur < 0)
               Rf_error(MSG__INCORRECT_MATCH_OPTION, "type"); // error() allowed here
            return brkiter_cur;
         }
      }
   }
   else {
      Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC);
   }

   // a BreakIterator must always be specified
   if (!cur)
      Rf_error(MSG__INCORRECT_MATCH_OPTION, "type"); // error() allowed here

   int brkiter_cur = stri__match_arg(cur, type_opts);
   if (brkiter_cur < 0)
      Rf_error(MSG__INCORRECT_MATCH_OPTION, "type"); // error() allowed here

//   0: // character
//   1: // line_break
//   2: // sentence
//   3: // word
   return brkiter_cur;
}


/** Get RuleBasedBreakIterator
 *
 * @param brkiter_cur break iterator ID;
 *        0:character, 1:line_break, 2:sentence, 3:word
 * @param qloc locale ID
 * @return RuleBasedBreakIterator
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 */
RuleBasedBreakIterator* stri__opts_brkiter_get_iterator(int brkiter_cur, const char* qloc) {
   UErrorCode status = U_ZERO_ERROR;
   RuleBasedBreakIterator* briter = NULL;
   Locale loc = Locale::createFromName(qloc);
   switch (brkiter_cur) {
      case 0: // character
         briter = (RuleBasedBreakIterator*)BreakIterator::createCharacterInstance(loc, status);
         break;

      case 1: // line_break
         briter = (RuleBasedBreakIterator*)BreakIterator::createLineInstance(loc, status);
         break;

      case 2: // sentence
         briter = (RuleBasedBreakIterator*)BreakIterator::createSentenceInstance(loc, status);
         break;

      case 3: // word
         briter = (RuleBasedBreakIterator*)BreakIterator::createWordInstance(loc, status);
         break;

//            case 4: // title
//               briter = (RuleBasedBreakIterator*)BreakIterator::createTitleInstance(loc, status);
//               break;
   }
   if (U_FAILURE(status))
      Rf_error(MSG__INCORRECT_MATCH_OPTION, "type"); // error() allowed here
   return briter;
}


/** Get UBreakIterator
 *
 * @param brkiter_cur break iterator ID;
 *        0:character, 1:line_break, 2:sentence, 3:word
 * @param qloc locale ID
 * @return UBreakIterator
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 */
UBreakIterator* stri__opts_brkiter_get_uiterator(int brkiter_cur, const char* qloc) {
   UErrorCode status = U_ZERO_ERROR;
   UBreakIterator* briter = NULL;
   switch (brkiter_cur) {
      case 0: // character [this is not documented]
         briter = ubrk_open(UBRK_CHARACTER, qloc, NULL, 0, &status);
         break;
      case 1: // line_break [this is not documented]
         briter = ubrk_open(UBRK_LINE, qloc, NULL, 0, &status);
         break;
      case 2: // sentence
         briter = ubrk_open(UBRK_SENTENCE, qloc, NULL, 0, &status);
         break;
      case 3: // word
         briter = ubrk_open(UBRK_WORD, qloc, NULL, 0, &status);
         break;
   }
   if (U_FAILURE(status))
      Rf_error(MSG__INCORRECT_MATCH_OPTION, "type"); // error() allowed here
   return briter;
}


/** Get Break Iterator's locale
 *
 * @param opts_brkiter named list
 * @return locale ID, R_alloc'ed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 */
const char* stri__opts_brkiter_get_locale(SEXP opts_brkiter) {
   if (isNull(opts_brkiter)) {
      // use default locale
   }
   else if (Rf_isVectorList(opts_brkiter)) {
      R_len_t narg = LENGTH(opts_brkiter);
      SEXP names = Rf_getAttrib(opts_brkiter, R_NamesSymbol);
      if (names == R_NilValue || LENGTH(names) != narg)
         Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here

      // search for "locale" option
      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here
         const char* curname = CHAR(STRING_ELT(names, i));
         if (!strcmp(curname, "locale")) {
            return stri__prepare_arg_locale(VECTOR_ELT(opts_brkiter, i), "locale", true); /* this is R_alloc'ed */
         }
      }
   }
   else {
      Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here
   }

   // otherwise return default locale
   return stri__prepare_arg_locale(R_NilValue, "locale", true); /* this is R_alloc'ed */
}


/** Get Break Iterator's skip rule status
 *
 * @param opts_brkiter named list
 * @return vector of indices [even, odd) -- ids to skip
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 */
vector<int32_t> stri__opts_brkiter_get_skip_rule_status(SEXP opts_brkiter) {
   vector<int32_t> out;
   if (isNull(opts_brkiter))
      return out; // nothing to skip

   if (!Rf_isVectorList(opts_brkiter))
      Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here

   R_len_t narg = LENGTH(opts_brkiter);
   SEXP names = Rf_getAttrib(opts_brkiter, R_NamesSymbol);
   if (names == R_NilValue || LENGTH(names) != narg)
      Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here

   for (R_len_t i=0; i<narg; ++i) {
      if (STRING_ELT(names, i) == NA_STRING)
         Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here

      const char* curname = CHAR(STRING_ELT(names, i));
      if  (!strcmp(curname, "skip_word_none")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_none");
         if (val) { out.push_back(UBRK_WORD_NONE); out.push_back(UBRK_WORD_NONE_LIMIT); }
      } else if  (!strcmp(curname, "skip_word_number")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_number");
         if (val) { out.push_back(UBRK_WORD_NUMBER); out.push_back(UBRK_WORD_NUMBER_LIMIT); }
      } else if  (!strcmp(curname, "skip_word_letter")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_letter");
         if (val) { out.push_back(UBRK_WORD_LETTER); out.push_back(UBRK_WORD_LETTER_LIMIT); }
      } else if  (!strcmp(curname, "skip_word_kana")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_kana");
         if (val) { out.push_back(UBRK_WORD_KANA); out.push_back(UBRK_WORD_KANA_LIMIT); }
      } else if  (!strcmp(curname, "skip_word_ideo")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_ideo");
         if (val) { out.push_back(UBRK_WORD_IDEO); out.push_back(UBRK_WORD_IDEO_LIMIT); }
      } else if  (!strcmp(curname, "skip_line_soft")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_line_soft");
         if (val) { out.push_back(UBRK_LINE_SOFT); out.push_back(UBRK_LINE_SOFT_LIMIT); }
      } else if  (!strcmp(curname, "skip_line_hard")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_line_hard");
         if (val) { out.push_back(UBRK_LINE_HARD); out.push_back(UBRK_LINE_HARD_LIMIT); }
      } else if  (!strcmp(curname, "skip_sentence_term")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_sentence_term");
         if (val) { out.push_back(UBRK_SENTENCE_TERM); out.push_back(UBRK_SENTENCE_TERM_LIMIT); }
      } else if  (!strcmp(curname, "skip_sentence_sep")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_sentence_sep");
         if (val) { out.push_back(UBRK_SENTENCE_SEP); out.push_back(UBRK_SENTENCE_SEP_LIMIT); }
      } else {
         /* ignore */
      }
   }

   return out;
}


/** Should a boundary be ignored by a Break Iterator
 *
 * @param brkskip vector of indices [even, odd) -- ids to skip
 * @param rule current rule
 * @return logical value
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 */
bool stri__opts_brkiter_ignore_skip_status(const vector<int32_t>& brkskip, int32_t rule) {
   int n = (int)brkskip.size();
   for (int i=0; i<n; i += 2) {
      // n is even - that's sure

      if (rule >= brkskip[i] && rule < brkskip[i+1])
         return true;
   }

   return false; // don't ignore
}


/** Locate or Split string by all BreakIterator boundaries
 *
 * @param str character vector
 * @param opts_brkiter identifier
 * @param split [internal]
 * @return character vector
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-27)
 *          return NA if no matches found
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *          use opts_brkiter
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__split_or_locate_boundaries(SEXP str, SEXP opts_brkiter, bool split)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   const char* qloc = stri__opts_brkiter_get_locale(opts_brkiter); /* this is R_alloc'ed */
   vector<int32_t> brkskip = stri__opts_brkiter_get_skip_rule_status(opts_brkiter);
   int brkiter_cur = stri__opts_brkiter_select_iterator(opts_brkiter, "line_break");
   RuleBasedBreakIterator* briter = stri__opts_brkiter_get_iterator(brkiter_cur, qloc);
   UText* str_text = NULL;

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, str_length));

   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         if (split) {
            SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         }
         else {
            SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));
         }
         continue;
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

      deque< pair<R_len_t,R_len_t> > occurrences; // this could be an R_len_t queue
      R_len_t match, last_match = briter->first();
      while ((match = briter->next()) != BreakIterator::DONE) {
         int rule = briter->getRuleStatus();
         if (!stri__opts_brkiter_ignore_skip_status(brkskip, rule))
            occurrences.push_back(pair<R_len_t, R_len_t>(last_match, match));
         last_match = match;
      }

      R_len_t noccurrences = (R_len_t)occurrences.size();
      if (noccurrences <= 0) {
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
         STRI__PROTECT(ans = Rf_allocVector(STRSXP, noccurrences));
         deque< pair<R_len_t,R_len_t> >::iterator iter = occurrences.begin();
         for (R_len_t j = 0; iter != occurrences.end(); ++iter, ++j) {
            SET_STRING_ELT(ans, j, Rf_mkCharLenCE(str_cur_s+(*iter).first,
               (*iter).second-(*iter).first, CE_UTF8));
         }
         SET_VECTOR_ELT(ret, i, ans);
         STRI__UNPROTECT(1);
      }
      else {
         SEXP ans;
         STRI__PROTECT(ans = Rf_allocMatrix(INTSXP, noccurrences, 2));
         int* ans_tab = INTEGER(ans);
         deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
         for (R_len_t j = 0; iter != occurrences.end(); ++iter, ++j) {
            pair<R_len_t, R_len_t> cur_match = *iter;
            ans_tab[j]             = cur_match.first;
            ans_tab[j+noccurrences] = cur_match.second;
         }

         // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
         str_cont.UTF8_to_UChar32_index(i, ans_tab,
               ans_tab+noccurrences, noccurrences,
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
 * @param opts_brkiter named list
 * @return list
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-22)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-23)
 *          removed "title": For Unicode 4.0 and above title boundary
 *          iteration, please use Word Boundary iterator.
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *          use stri__split_or_locate_boundaries
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *          use opts_brkiter
 */
SEXP stri_locate_boundaries(SEXP str, SEXP opts_brkiter)
{
   return stri__split_or_locate_boundaries(str, opts_brkiter, false);
}


/** Split a string at BreakIterator boundaries
 *
 * @param str character vector
 * @param opts_brkiter named list
 * @return list
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-21)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-23)
 *          removed "title": For Unicode 4.0 and above title boundary
 *          iteration, please use Word Boundary iterator.
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *          use stri__split_or_locate_boundaries
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *          use opts_brkiter
 */
SEXP stri_split_boundaries(SEXP str, SEXP opts_brkiter)
{
   return stri__split_or_locate_boundaries(str, opts_brkiter, true);
}


/** Count the number of BreakIterator boundaries
 *
 * @param str character vector
 * @param opts_brkiter identifier
 * @return character vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_count_boundaries(SEXP str, SEXP opts_brkiter)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   const char* qloc = stri__opts_brkiter_get_locale(opts_brkiter); /* this is R_alloc'ed */
   vector<int32_t> brkskip = stri__opts_brkiter_get_skip_rule_status(opts_brkiter);
   int brkiter_cur = stri__opts_brkiter_select_iterator(opts_brkiter, "line_break");
   RuleBasedBreakIterator* briter = stri__opts_brkiter_get_iterator(brkiter_cur, qloc);
   UText* str_text = NULL;

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_length));

   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         INTEGER(ret)[i] = NA_INTEGER;
         continue;
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

      int cur_count = 0;
      deque< pair<R_len_t,R_len_t> > occurrences; // this could be an R_len_t queue
      R_len_t match = briter->first();
      while ((match = briter->next()) != BreakIterator::DONE) {
         int rule = briter->getRuleStatus();
         if (!stri__opts_brkiter_ignore_skip_status(brkskip, rule))
            cur_count++;
      }

      INTEGER(ret)[i] = cur_count;
   }

   if (briter) { delete briter; briter = NULL; }
   if (str_text) { utext_close(str_text); str_text = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (briter) { delete briter; briter = NULL; }
      if (str_text) { utext_close(str_text); str_text = NULL; }
   })
}
