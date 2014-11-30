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
#include "stri_container_usearch.h"
#include "stri_string8buf.h"
#include <deque>
using namespace std;


/**
 * Replace all/first/last occurrences of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          StriException friendly & Use StriContainers
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-07-10)
 *          BUGFIX: wrong behavior on empty str
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri__replace_allfirstlast_coll (opts_collator == NA not allowed)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__replace_allfirstlast_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator, int type)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(replacement = stri_prepare_arg_string(replacement, "replacement"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));

   UCollator* collator = NULL;
   collator = stri__ucol_open(opts_collator);

   STRI__ERROR_HANDLER_BEGIN(3)
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));
   StriContainerUTF16 str_cont(str, vectorize_length, false); // writable
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont
   StriContainerUTF16 replacement_cont(replacement, vectorize_length);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         str_cont.setNA(i);,
         /*just skip on empty str*/;)

      if (replacement_cont.isNA(i)) {
         str_cont.setNA(i);
         continue;
      }

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);

      UErrorCode status = U_ZERO_ERROR;
      R_len_t remUChars = 0;
      deque< pair<R_len_t, R_len_t> > occurrences;

      if (type >= 0) { // first or all
         int start = (int)usearch_first(matcher, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         if (start == USEARCH_DONE) // no match
            continue; // no change in str_cont[i] at all

         while (start != USEARCH_DONE) {
            R_len_t mlen = usearch_getMatchedLength(matcher);
            remUChars += mlen;
            occurrences.push_back(pair<R_len_t, R_len_t>(start, start+mlen));
            if (type > 0) break; // break if first and not all
            start = usearch_next(matcher, &status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         }
      }
      else { // if last
         int start = (int)usearch_last(matcher, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         if (start == USEARCH_DONE) // no match
            continue; // no change in str_cont[i] at all
         R_len_t mlen = usearch_getMatchedLength(matcher);
         remUChars += mlen;
         occurrences.push_back(pair<R_len_t, R_len_t>(start, start+mlen));
      }

      R_len_t replacement_cur_n = replacement_cont.get(i).length();
      R_len_t noccurrences = (R_len_t)occurrences.size();
      UnicodeString ans(str_cont.get(i).length()-remUChars+noccurrences*replacement_cur_n, (UChar)0xfffd, 0);
      R_len_t jlast = 0;
      R_len_t anslast = 0;
      deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
      for (; iter != occurrences.end(); ++iter) {
         pair<R_len_t, R_len_t> match = *iter;
         ans.replace(anslast, match.first-jlast, str_cont.get(i), jlast, match.first-jlast);
         anslast += match.first-jlast;
         jlast = match.second;
         ans.replace(anslast, replacement_cur_n, replacement_cont.get(i));
         anslast += replacement_cur_n;
      }
      ans.replace(anslast, str_cont.get(i).length()-jlast, str_cont.get(i), jlast, str_cont.get(i).length()-jlast);
      str_cont.getWritable(i) = ans;
   }

   if (collator) { ucol_close(collator); collator=NULL; }
   STRI__UNPROTECT_ALL
   return str_cont.toR();
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}


/**
 * Replace all occurrences of a coll pattern; vectorize_all=FALSE
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator a named list
 * @return character vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-06)
 *    Added missing ucol_close
 */
SEXP stri__replace_all_coll_no_vectorize_all(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator)
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
   R_len_t pattern_n = LENGTH(pattern);
   R_len_t replacement_n = LENGTH(replacement);
   if (pattern_n < replacement_n || pattern_n <= 0 || replacement_n <= 0) {
      UNPROTECT(3);
      Rf_error(MSG__WARN_RECYCLING_RULE2);
   }
   if (pattern_n % replacement_n != 0) {
      Rf_warning(MSG__WARN_RECYCLING_RULE);
   }

   if (pattern_n == 1) {// this will be much faster:
      SEXP ret;
      PROTECT(ret = stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, 0));
      UNPROTECT(4);
      return ret;
   }

   UCollator* collator = NULL;
   collator = stri__ucol_open(opts_collator);

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF16 str_cont(str, str_n, false); // writable
   StriContainerUStringSearch pattern_cont(pattern, pattern_n, collator);  // collator is not owned by pattern_cont
   StriContainerUTF16 replacement_cont(replacement, pattern_n);

   for (R_len_t i = 0; i<pattern_n; ++i)
   {
      if (pattern_cont.isNA(i) || replacement_cont.isNA(i)) {
         if (collator) { ucol_close(collator); collator=NULL; }
         STRI__UNPROTECT_ALL
         return stri__vector_NA_strings(str_n);
      }
      else if (pattern_cont.get(i).length() <= 0) {
         if (collator) { ucol_close(collator); collator=NULL; }
         Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
         STRI__UNPROTECT_ALL
         return stri__vector_NA_strings(str_n);
      }

      for (R_len_t j = 0; j<str_n; ++j) {
         if (str_cont.isNA(j) || str_cont.get(j).length() <= 0) continue;

         UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(j));
         usearch_reset(matcher);
         UErrorCode status = U_ZERO_ERROR;
         R_len_t remUChars = 0;
         deque< pair<R_len_t, R_len_t> > occurrences;

         int start = (int)usearch_first(matcher, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         if (start == USEARCH_DONE) // no match
            continue; // no change in str_cont[j] at all

         while (start != USEARCH_DONE) {
            R_len_t mlen = usearch_getMatchedLength(matcher);
            remUChars += mlen;
            occurrences.push_back(pair<R_len_t, R_len_t>(start, start+mlen));
            start = usearch_next(matcher, &status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         }

         R_len_t replacement_cur_n = replacement_cont.get(i).length();
         R_len_t noccurrences = (R_len_t)occurrences.size();
         UnicodeString ans(str_cont.get(j).length()-remUChars+noccurrences*replacement_cur_n, (UChar)0xfffd, 0);
         R_len_t jlast = 0;
         R_len_t anslast = 0;
         deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
         for (; iter != occurrences.end(); ++iter) {
            pair<R_len_t, R_len_t> match = *iter;
            ans.replace(anslast, match.first-jlast, str_cont.get(j), jlast, match.first-jlast);
            anslast += match.first-jlast;
            jlast = match.second;
            ans.replace(anslast, replacement_cur_n, replacement_cont.get(i));
            anslast += replacement_cur_n;
         }
         ans.replace(anslast, str_cont.get(j).length()-jlast, str_cont.get(j), jlast, str_cont.get(j).length()-jlast);
         str_cont.getWritable(j) = ans;
      }
   }

   if (collator) { ucol_close(collator); collator=NULL; }
   STRI__UNPROTECT_ALL
   return str_cont.toR();
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}


/**
 * Replace all occurrences of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri_replace_all_coll (opts_collator == NA not allowed)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *          vectorize_all arg added
 */
SEXP stri_replace_all_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP vectorize_all, SEXP opts_collator)
{
   if (stri__prepare_arg_logical_1_notNA(vectorize_all, "vectorize_all"))
      return stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, 0);
   else
      return stri__replace_all_coll_no_vectorize_all(str, pattern, replacement, opts_collator);
}


/**
 * Replace last occurrence of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri_replace_last_coll (opts_collator == NA not allowed)
 */
SEXP stri_replace_last_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator)
{
   return stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, -1);
}


/**
 * Replace first occurrence of a fixed pattern [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param opts_collator list
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          new fun: stri_replace_first_coll (opts_collator == NA not allowed)
 */
SEXP stri_replace_first_coll(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_collator)
{
   return stri__replace_allfirstlast_coll(str, pattern, replacement, opts_collator, 1);
}
