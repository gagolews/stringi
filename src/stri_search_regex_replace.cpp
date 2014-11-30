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
#include "stri_container_utf16.h"
#include "stri_container_regex.h"


/**
 * Replace occurrences of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF16's vectorization
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-21)
 *          use StriContainerRegexPattern + more general
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-07-10)
 *          BUGFIX: wrong behavior on empty str
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__replace_allfirstlast_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex, int type)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(replacement = stri_prepare_arg_string(replacement, "replacement"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   STRI__ERROR_HANDLER_BEGIN(3)
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));
   StriContainerUTF16 str_cont(str, vectorize_length, false); // writable
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);
   StriContainerUTF16 replacement_cont(replacement, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);,
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE((const char*)NULL, 0, CE_UTF8));)

      if (replacement_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      matcher->reset(str_cont.get(i));

      UErrorCode status = U_ZERO_ERROR;
      if (type == 0) { // all
         str_cont.set(i, matcher->replaceAll(replacement_cont.get(i), status));
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
      else if (type == 1) { // first
         str_cont.set(i, matcher->replaceFirst(replacement_cont.get(i), status));
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
      else if (type == -1) { // end
         int start = -1;
         int end = -1;
         while (matcher->find()) { // find last match
            start = matcher->start(status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            end = matcher->end(status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         }
         if (start >= 0) {
            matcher->find(start, status); // go back
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            UnicodeString out;
            matcher->appendReplacement(out, replacement_cont.get(i), status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            out.append(str_cont.get(i), end, str_cont.get(i).length()-end);
            str_cont.set(i, out);
         }
      }
      else {
         throw StriException(MSG__INTERNAL_ERROR);
      }

      SET_STRING_ELT(ret, i, str_cont.toR(i));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Replace all occurrences of a regex pattern; vectorize_all=FALSE
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_regex a named list
 * @return character vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *          Second version, 3x faster, 2 for loops + replaceAll
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__replace_all_regex_no_vectorize_all(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex)
{ // version beta
   PROTECT(str          = stri_prepare_arg_string(str, "str"));

   // if str_n is 0, then return an empty vector
   R_len_t str_n = LENGTH(str);
   if (str_n <= 0) {
      UNPROTECT(1);
      return stri__vector_empty_strings(0);
   }

   PROTECT(pattern      = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(replacement  = stri_prepare_arg_string(replacement, "replacement"));
   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   R_len_t pattern_n = LENGTH(pattern);
   R_len_t replacement_n = LENGTH(replacement);
   if (pattern_n < replacement_n || pattern_n <= 0 || replacement_n <= 0) {
      UNPROTECT(3);
      Rf_error(MSG__WARN_RECYCLING_RULE2);
   }
   else if (pattern_n % replacement_n != 0)
      Rf_warning(MSG__WARN_RECYCLING_RULE);

   if (pattern_n == 1) {// this will be much faster:
      SEXP ret;
      PROTECT(ret = stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, 0));
      UNPROTECT(4);
      return ret;
   }

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF16 str_cont(str, str_n, false); // writable
   StriContainerRegexPattern pattern_cont(pattern, pattern_n, pattern_flags);
   StriContainerUTF16 replacement_cont(replacement, pattern_n);

   for (R_len_t i = 0; i<pattern_n; ++i)
   {
      if (pattern_cont.isNA(i) || replacement_cont.isNA(i)) {
         STRI__UNPROTECT_ALL
         return stri__vector_NA_strings(str_n);
      }
      else if (pattern_cont.get(i).length() <= 0) {
         Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
         STRI__UNPROTECT_ALL
         return stri__vector_NA_strings(str_n);
      }

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically

      for (R_len_t j = 0; j<str_n; ++j) {
         if (str_cont.isNA(j)) continue;

         matcher->reset(str_cont.get(j));

         UErrorCode status = U_ZERO_ERROR;
         str_cont.set(j, matcher->replaceAll(replacement_cont.get(i), status));
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
   }

   STRI__UNPROTECT_ALL
   return str_cont.toR();
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


// version alpha == to slow == too many toutf16 conversions
//{
//   PROTECT(pattern      = stri_prepare_arg_string(pattern, "pattern"));
//   PROTECT(replacement  = stri_prepare_arg_string(replacement, "replacement"));
//
//   R_len_t pattern_n = LENGTH(pattern);
//   R_len_t replacement_n = LENGTH(replacement);
//   if (pattern_n < replacement_n || pattern_n <= 0 || replacement_n <= 0)
//      Rf_error(MSG__WARN_RECYCLING_RULE2);
//   if (pattern_n % replacement_n != 0)
//      Rf_warning(MSG__WARN_RECYCLING_RULE);
//
//   // no str_error_handlers needed here
//   SEXP pattern_cur, replacement_cur;
//   PROTECT(pattern_cur = Rf_allocVector(STRSXP, 1));
//   PROTECT(replacement_cur = Rf_allocVector(STRSXP, 1));
//
//   PROTECT(str);
//   for (R_len_t i=0; i<pattern_n; ++i) {
//      SET_STRING_ELT(pattern_cur, 0, STRING_ELT(pattern, i));
//      SET_STRING_ELT(replacement_cur, 0, STRING_ELT(replacement, i%replacement_n));
//      str = stri__replace_allfirstlast_regex(str, pattern_cur, replacement_cur, opts_regex, 0);
//      UNPROTECT(1);
//      PROTECT(str);
//   }
//
//   UNPROTECT(5);
//   return str;
//}


/**
 * Replace all occurrences of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-21)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *          vectorize_all argument added
 */
SEXP stri_replace_all_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP vectorize_all, SEXP opts_regex)
{
   if (stri__prepare_arg_logical_1_notNA(vectorize_all, "vectorize_all"))
      return stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, 0);
   else
      return stri__replace_all_regex_no_vectorize_all(str, pattern, replacement, opts_regex);
}


/**
 * Replace first occurrence of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-21)
 */
SEXP stri_replace_first_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex)
{
   return stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, 1);
}


/**
 * Replace last occurrence of a regex pattern
 *
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @param replacement replacements
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-21)
 */
SEXP stri_replace_last_regex(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_regex)
{
   return stri__replace_allfirstlast_regex(str, pattern, replacement, opts_regex, -1);
}
