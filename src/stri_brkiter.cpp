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
#include "stri_brkiter.h"


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
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *     moved to the StriBrkIterOptions class
 */
void StriBrkIterOptions::setType(SEXP opts_brkiter, const char* _default) {
   const char* type_opts[] = {"character", "line_break", "sentence", "word", NULL};
   int brkiter_cur = stri__match_arg(_default, type_opts);

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
            brkiter_cur = stri__match_arg(CHAR(STRING_ELT(curval, i)), type_opts);
            UNPROTECT(1);
            break;
         }
      }
   }
   else {
      Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC);
   }

   switch (brkiter_cur) {
      case 0: // character
         this->type = UBRK_CHARACTER;
         break;
      case 1: // line_break
         this->type = UBRK_LINE;
         break;
      case 2: // sentence
         this->type = UBRK_SENTENCE;
         break;
      case 3: // word
         this->type = UBRK_WORD;
         break;
      default:
         Rf_error(MSG__INCORRECT_MATCH_OPTION, "type"); // error() allowed here
         break;
   }
}


/** Get Break Iterator's locale
 *
 * @param opts_brkiter named list
 * @return locale ID, R_alloc'ed
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *     moved to the StriBrkIterOptions class
 */
void StriBrkIterOptions::setLocale(SEXP opts_brkiter) {
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
            this->locale = stri__prepare_arg_locale(VECTOR_ELT(opts_brkiter, i), "locale", true); /* this is R_alloc'ed */
            return;
         }
      }
   }
   else {
      Rf_error(MSG__INCORRECT_BRKITER_OPTION_SPEC); // error() allowed here
   }

   // otherwise return default locale
   this->locale = stri__prepare_arg_locale(R_NilValue, "locale", true); /* this is R_alloc'ed */
}


/** Get Break Iterator's skip rule status
 *
 * @param opts_brkiter named list
 * @return vector of indices [even, odd) -- ids to skip
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *     moved to the StriBrkIterOptions class
 */
void StriBrkIterOptions::setSkipRuleStatus(SEXP opts_brkiter) {
   if (isNull(opts_brkiter)) {
      return; // leave as-is (empty)
   }

   R_len_t tmp_size = 0;
   int32_t tmp_rules[32];

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
         if (val) { tmp_rules[tmp_size++] = UBRK_WORD_NONE; tmp_rules[tmp_size++] = UBRK_WORD_NONE_LIMIT; }
      } else if  (!strcmp(curname, "skip_word_number")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_number");
         if (val) { tmp_rules[tmp_size++] = UBRK_WORD_NUMBER; tmp_rules[tmp_size++] = UBRK_WORD_NUMBER_LIMIT; }
      } else if  (!strcmp(curname, "skip_word_letter")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_letter");
         if (val) { tmp_rules[tmp_size++] = UBRK_WORD_LETTER; tmp_rules[tmp_size++] = UBRK_WORD_LETTER_LIMIT; }
      } else if  (!strcmp(curname, "skip_word_kana")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_kana");
         if (val) { tmp_rules[tmp_size++] = UBRK_WORD_KANA; tmp_rules[tmp_size++] = UBRK_WORD_KANA_LIMIT; }
      } else if  (!strcmp(curname, "skip_word_ideo")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_word_ideo");
         if (val) { tmp_rules[tmp_size++] = UBRK_WORD_IDEO; tmp_rules[tmp_size++] = UBRK_WORD_IDEO_LIMIT; }
      } else if  (!strcmp(curname, "skip_line_soft")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_line_soft");
         if (val) { tmp_rules[tmp_size++] = UBRK_LINE_SOFT; tmp_rules[tmp_size++] = UBRK_LINE_SOFT_LIMIT; }
      } else if  (!strcmp(curname, "skip_line_hard")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_line_hard");
         if (val) { tmp_rules[tmp_size++] = UBRK_LINE_HARD; tmp_rules[tmp_size++] = UBRK_LINE_HARD_LIMIT; }
      } else if  (!strcmp(curname, "skip_sentence_term")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_sentence_term");
         if (val) { tmp_rules[tmp_size++] = UBRK_SENTENCE_TERM; tmp_rules[tmp_size++] = UBRK_SENTENCE_TERM_LIMIT; }
      } else if  (!strcmp(curname, "skip_sentence_sep")) {
         bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_brkiter, i), "skip_sentence_sep");
         if (val) { tmp_rules[tmp_size++] = UBRK_SENTENCE_SEP; tmp_rules[tmp_size++] = UBRK_SENTENCE_SEP_LIMIT; }
      } else {
         /* ignore */
      }
   }

   if (tmp_size <= 0)
      return;

   skip_size  = tmp_size;
   skip_rules = (int32_t*)R_alloc((size_t)tmp_size, (int)sizeof(int32_t));
   for (R_len_t i=0; i<tmp_size; ++i)
      skip_rules[i] = tmp_rules[i];
}


/**
 *
 * @ version 0.4-1 (Marek Gagolewski, 2014-12-03)
 */
void StriRuleBasedBreakIterator::setupMatcher(const char* _searchStr, R_len_t _searchLen)
{
   if (!rbiterator) open();

   this->searchStr = _searchStr;
   this->searchLen = _searchLen;
   this->searchPos = BreakIterator::DONE;

   UErrorCode status = U_ZERO_ERROR;
   this->searchText = utext_openUTF8(this->searchText,
      _searchStr, _searchLen, &status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   status = U_ZERO_ERROR;
   this->rbiterator->setText(this->searchText, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
}


/** Should a boundary be ignored by a Break Iterator
 *
 * @param brkskip vector of indices [even, odd) -- ids to skip
 * @param rule current rule
 * @return logical value
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *
 * @version 0.4-1 (Marek Gagolews, 2014-12-03)
 *    moved to StriRuleBasedBreakIterator
 */
bool StriRuleBasedBreakIterator::ignoreBoundary() {
#ifndef NDEBUG
   if (!rbiterator || !searchText)
      throw StriException("!NDEBUG: StriRuleBasedBreakIterator::ignoreBoundary()");
#endif

   if (skip_size <= 0) return false;

   int rule = rbiterator->getRuleStatus();
   for (int i=0; i<skip_size; i += 2) {
      // skip_size is even - that's sure
      if (rule >= skip_rules[i] && rule < skip_rules[i+1])
         return true;
   }

   return false; // don't ignore
}


/**
 *
 * @ version 0.4-1 (Marek Gagolewski, 2014-12-03)
 */
void StriRuleBasedBreakIterator::first()
{
#ifndef NDBEGUG
   if (!rbiterator)
      throw StriException("!NDEBUG: StriRuleBasedBreakIterator::first");
#endif

   this->searchPos = rbiterator->first(); // ICU man: "The offset of the beginning of the text, zero."

#ifndef NDBEGUG
   if (this->searchPos != 0)
      throw StriException("!NDEBUG: StriRuleBasedBreakIterator::first");
#endif
}


/**
 *
 * @ version 0.4-1 (Marek Gagolewski, 2014-12-03)
 */
bool StriRuleBasedBreakIterator::next()
{
   while ((this->searchPos = rbiterator->next()) != BreakIterator::DONE) {
      if (!ignoreBoundary())
         return true;
   }
   return false;
}


/**
 *
 * @ version 0.4-1 (Marek Gagolewski, 2014-12-03)
 */
bool StriRuleBasedBreakIterator::next(std::pair<R_len_t, R_len_t>& bdr)
{
   R_len_t lastPos = searchPos;
   while ((searchPos = rbiterator->next()) != BreakIterator::DONE) {
      if (!ignoreBoundary()) {
         bdr.first  = lastPos;
         bdr.second = searchPos;
         return true;
      }

      lastPos = searchPos;
   }
   return false;
}


/**
 *
 * @ version 0.4-1 (Marek Gagolewski, 2014-12-05)
 */
void StriRuleBasedBreakIterator::last()
{
#ifndef NDBEGUG
   if (!rbiterator)
      throw StriException("!NDEBUG: StriRuleBasedBreakIterator::last");
   if (searchLen <= 0)
      throw StriException("!NDEBUG: StriRuleBasedBreakIterator::last");
#endif

   rbiterator->first();
   this->searchPos = rbiterator->last(); // ICU man: "The text's past-the-end offset. "

#ifndef NDBEGUG
   if (this->searchPos > this->searchLen)
      throw StriException("!NDEBUG: StriRuleBasedBreakIterator::last");
#endif
}


/**
 *
 * @ version 0.4-1 (Marek Gagolewski, 2014-12-05)
 */
bool StriRuleBasedBreakIterator::previous(std::pair<R_len_t, R_len_t>& bdr)
{
   do {
      if (!ignoreBoundary()) {
         bdr.second  = searchPos;
         searchPos = rbiterator->previous();
         if (searchPos == BreakIterator::DONE) return false;
         bdr.first = searchPos;
         return true;
      }
      searchPos = rbiterator->previous();
   }
   while (searchPos != BreakIterator::DONE);
   return false;
}
