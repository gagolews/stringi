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
#include "stri_container_bytesearch.h"
#include "stri_string8buf.h"
//#include "stri_interval.h"
#include <deque>
//#include <queue>
//#include <algorithm>
using namespace std;


/**
 * Replace all/first/last occurrences of a fixed pattern
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
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
 *          stri_replace_fixed now uses byte search only
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *          using String8buf::replaceAllAtPos, slightly faster
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri__replace_allfirstlast_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_fixed, int type)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed);
   PROTECT(str          = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern      = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(replacement  = stri_prepare_arg_string(replacement, "replacement"));
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerUTF8 replacement_cont(replacement, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   String8buf buf(0); // @TODO: calculate buf len a priori?

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);,
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(NULL, 0, CE_UTF8));)

      if (replacement_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t start;
      if (type >= 0) { // first or all
         pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());
         start = pattern_cont.findFirst();
      } else {
         pattern_cont.setupMatcherBack(i, str_cont.get(i).c_str(), str_cont.get(i).length());
         start = pattern_cont.findLast();
      }

      if (start == USEARCH_DONE) {
         SET_STRING_ELT(ret, i, str_cont.toR(i));
         continue;
      }

      R_len_t len = pattern_cont.getMatchedLength();
      R_len_t sumbytes = len;
      deque< pair<R_len_t, R_len_t> > occurrences;
      occurrences.push_back(pair<R_len_t, R_len_t>(start, start+len));

      if (type == 0) {
         while (USEARCH_DONE != pattern_cont.findNext()) { // all
            start = pattern_cont.getMatchedStart();
            len = pattern_cont.getMatchedLength();
            occurrences.push_back(pair<R_len_t, R_len_t>(start, start+len));
            sumbytes += len;
         }
      }

      R_len_t str_cur_n     = str_cont.get(i).length();
      R_len_t replacement_cur_n = replacement_cont.get(i).length();
      R_len_t buf_need =
         str_cur_n+replacement_cur_n*(R_len_t)occurrences.size()-sumbytes;
      buf.resize(buf_need, false/*destroy contents*/);

      R_len_t buf_used = buf.replaceAllAtPos(str_cont.get(i).c_str(), str_cur_n,
         replacement_cont.get(i).c_str(), replacement_cur_n,
         occurrences);

#ifndef NDEBUG
      if (buf_need != buf_used)
         throw StriException("!NDEBUG: stri__replace_allfirstlast_fixed: (buf_need != buf_used)");
#endif

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buf_used, CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


// Version 2, 2014-11-02, using String8::replaceAllAtPos, slower
//SEXP stri__replace_allfirstlast_fixed(SEXP str, SEXP pattern, SEXP replacement, int type)
//{
//   str          = stri_prepare_arg_string(str, "str");
//   pattern      = stri_prepare_arg_string(pattern, "pattern");
//   replacement  = stri_prepare_arg_string(replacement, "replacement");
//   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF8 str_cont(str, vectorize_length, false); // writable);
//   StriContainerUTF8 replacement_cont(replacement, vectorize_length);
//   StriContainerByteSearch pattern_cont(pattern, vectorize_length);
//
//   for (R_len_t i = pattern_cont.vectorize_init();
//         i != pattern_cont.vectorize_end();
//         i = pattern_cont.vectorize_next(i))
//   {
//      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
//         str_cont.setNA(i),
//         {/* zero-length string, just continue */})
//
//      if (replacement_cont.isNA(i)) {
//         str_cont.setNA(i);
//         continue;
//      }
//
//      R_len_t start;
//      if (type >= 0) { // first or all
//         pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());
//         start = pattern_cont.findFirst();
//      } else {
//         pattern_cont.setupMatcherBack(i, str_cont.get(i).c_str(), str_cont.get(i).length());
//         start = pattern_cont.findLast();
//      }
//
//      if (start == USEARCH_DONE) {
//         // nothing to do, no change, leave as-is
//         continue;
//      }
//
//      R_len_t len = pattern_cont.getMatchedLength();
//      R_len_t sumbytes = len;
//      deque< pair<R_len_t, R_len_t> > occurrences;
//      occurrences.push_back(pair<R_len_t, R_len_t>(start, start+len));
//
//      if (type == 0) {
//         while (USEARCH_DONE != pattern_cont.findNext()) { // all
//            start = pattern_cont.getMatchedStart();
//            len = pattern_cont.getMatchedLength();
//            occurrences.push_back(pair<R_len_t, R_len_t>(start, start+len));
//            sumbytes += len;
//         }
//      }
//
//      R_len_t str_cur_n     = str_cont.get(i).length();
//      R_len_t     replacement_cur_n = replacement_cont.get(i).length();
//      R_len_t buf_need =
//         str_cur_n+replacement_cur_n*(R_len_t)occurrences.size()-sumbytes;
//
//      str_cont.getWritable(i).replaceAllAtPos(buf_need,
//         replacement_cont.get(i).c_str(), replacement_cur_n,
//         occurrences);
//   }
//
//   STRI__UNPROTECT_ALL
//   return str_cont.toR();
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}


/**
 * Replace all occurrences of a fixed pattern; vectorize_all=FALSE
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @return character vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *                Complete rewrite; faster
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri__replace_all_fixed_no_vectorize_all(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_fixed)
{ // version gamma:
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
   if (pattern_n % replacement_n != 0)
      Rf_warning(MSG__WARN_RECYCLING_RULE);

   if (pattern_n == 1) { // this will be much faster:
      SEXP ret;
      PROTECT(ret = stri__replace_allfirstlast_fixed(str, pattern, replacement, opts_fixed, 0));
      UNPROTECT(4);
      return ret;
   }

   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed);

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF8 str_cont(str, str_n, false); // writable
   StriContainerUTF8 replacement_cont(replacement, pattern_n);
   StriContainerByteSearch pattern_cont(pattern, pattern_n, pattern_flags);

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

      for (R_len_t j = 0; j<str_n; ++j) {
         if (str_cont.isNA(j)) continue;

         pattern_cont.setupMatcherFwd(i, str_cont.get(j).c_str(), str_cont.get(j).length());
         R_len_t start = pattern_cont.findFirst();
         if (start == USEARCH_DONE)  continue;  // nothing to do now

         R_len_t len = pattern_cont.getMatchedLength();
         R_len_t sumbytes = len;
         deque< pair<R_len_t, R_len_t> > occurrences;
         occurrences.push_back(pair<R_len_t, R_len_t>(start, start+len));

         while (USEARCH_DONE != pattern_cont.findNext()) { // all
            start = pattern_cont.getMatchedStart();
            len = pattern_cont.getMatchedLength();
            occurrences.push_back(pair<R_len_t, R_len_t>(start, start+len));
            sumbytes += len;
         }

         R_len_t str_cur_n     = str_cont.get(j).length();
         R_len_t replacement_cur_n = replacement_cont.get(i).length();
         R_len_t buf_need =
            str_cur_n+replacement_cur_n*(R_len_t)occurrences.size()-sumbytes;

         str_cont.getWritable(j).replaceAllAtPos(buf_need,
            replacement_cont.get(i).c_str(), replacement_cur_n,
            occurrences);
      }
   }

   STRI__UNPROTECT_ALL
   return str_cont.toR();
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}

// stri__replace_all_fixed_no_vectorize_all
//{  // version beta: for-loop like, 2014-11-01
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
//      str = stri__replace_allfirstlast_fixed(str, pattern_cur, replacement_cur, 0);
//      UNPROTECT(1);
//      PROTECT(str);
//   }
//
//   UNPROTECT(5);
//   return str;
//}
// stri__replace_all_fixed_no_vectorize_all
// Version alpha: benchmarks: 32 ms vs 35 ms for the loop-version
// Not worth fighting for..... :/, 2014-11-01
//SEXP stri__replace_all_fixed_no_vectorize_all(SEXP str, SEXP pattern, SEXP replacement)
//{
//   str          = stri_prepare_arg_string(str, "str");
//   pattern      = stri_prepare_arg_string(pattern, "pattern");
//   replacement  = stri_prepare_arg_string(replacement, "replacement");
//
//   R_len_t str_n = LENGTH(str);
//   R_len_t pattern_n = LENGTH(pattern);
//   R_len_t replacement_n = LENGTH(replacement);
//   if (pattern_n < replacement_n || pattern_n <= 0 || replacement_n <= 0)
//      Rf_error(MSG__WARN_RECYCLING_RULE2);
//   if (pattern_n % replacement_n != 0)
//      Rf_warning(MSG__WARN_RECYCLING_RULE);
//
//   // if str_n is 0, then return an empty vector
//   if (str_n <= 0)
//      return stri__vector_empty_strings(0);
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF8 str_cont(str, str_n);
//   StriContainerUTF8 replacement_cont(replacement, pattern_n);
//   StriContainerByteSearch pattern_cont(pattern, pattern_n);
//
//   // if any of the patterns is missing, then return an NA vector
//   // if a pattern is empty, throw an error
//   for (R_len_t i=0; i<pattern_n; ++i) {
//      if (pattern_cont.isNA(i))
//         return stri__vector_NA_strings(str_n);
//      if (pattern_cont.get(i).length() <= 0)
//         throw StriException(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
//   }
//
//   vector< deque< StriInterval<R_len_t> > > queues(str_n); // matches
//
//   vector<bool> which_NA(str_n, false); // which str[i] will be NA
//   for (R_len_t j=0; j<str_n; ++j)
//      if (str_cont.isNA(j))
//         which_NA[j] = true;
//
//   // get indices at which we have a pattern match
//   // for each pattern, for each search string
//
//   // THIS IS THE SLOWEST FOR LOOP IN THIS FUNCTION
//   for (R_len_t i = 0; i < pattern_n; ++i)
//   {
//      // current pattern is not NA and is not empty
//
//      for (R_len_t j=0; j<str_n; ++j) {
//         if (which_NA[j] || str_cont.get(j).length() <= 0)
//            continue; // there's nothing interesting to play with here
//
//         R_len_t match_idx;
//         pattern_cont.setupMatcherFwd(i, str_cont.get(j).c_str(), str_cont.get(j).length());
//         match_idx = pattern_cont.findFirst();
//         if (match_idx == USEARCH_DONE) continue; // no match at all
//
//         // otherwise, there is >= 1 match
//         if (replacement_cont.isNA(i)) {
//            which_NA[j] = true; // this string will be missing in result
//            // it may have overlapping patterns BTW, but we won't check for that
//            continue; // the same pattern, next string
//         }
//         do {
//            queues[j].push_back(StriInterval<R_len_t>(match_idx, match_idx+pattern_cont.getMatchedLength(), i));
//            match_idx = pattern_cont.findNext();
//         }
//         while (match_idx != USEARCH_DONE);
//      }
//   }
//
//   // check if there are overlapping patterns,
//   // determine max buf size
//   R_len_t bufsize = 0;
//   for (R_len_t i=0; i<str_n; ++i) {
//      if (which_NA[i] || str_cont.get(i).length() <= 0 || !queues[i].size())
//         continue; // nothing interesting
//
//      // sort the i-th queue w.r.t. lower interval bound:
//      sort(queues[i].begin(), queues[i].end());
//
//      R_len_t bufsize_cur = str_cont.get(i).length();
//      deque< StriInterval<R_len_t> >::iterator iter = queues[i].begin();
//
//      StriInterval<R_len_t> last_int = *(iter++);
//      bufsize_cur = bufsize_cur - pattern_cont.get(last_int.data).length()
//                                + replacement_cont.get(last_int.data).length();
//      for (; iter != queues[i].end(); ++iter) {
//         StriInterval<R_len_t> cur_int = *iter;
//         if (cur_int.a < last_int.b)
//            throw StriException(MSG__OVERLAPPING_PATTERN_UNSUPPORTED);
//         bufsize_cur = bufsize_cur - pattern_cont.get(cur_int.data).length()
//                                   + replacement_cont.get(cur_int.data).length();
//         last_int = cur_int;
//      }
//
//      if (bufsize < bufsize_cur) bufsize = bufsize_cur;
//   }
//
//   // construct the resulting vector
//   SEXP ret;
//   STRI__PROTECT(ret = Rf_allocVector(STRSXP, str_n));
//   String8buf buf(bufsize);
//   for (R_len_t i=0; i<str_n; ++i) {
//      if (which_NA[i]) {
//         SET_STRING_ELT(ret, i, NA_STRING);
//         continue;
//      }
//      else if (str_cont.get(i).length() <= 0 || !queues[i].size()) {
//         // copy as-is
//         SET_STRING_ELT(ret, i, str_cont.toR(i));
//         continue;
//      }
//
//      // all right, at least one match - replace, captain!
//      R_len_t bufused = 0;
//      char* curbuf = buf.data();
//      const char* str_cur_s = str_cont.get(i).c_str();
//      R_len_t str_cur_n = str_cont.get(i).length();
//
//      R_len_t last_b = 0;
//      for (deque< StriInterval<R_len_t> >::iterator iter = queues[i].begin();
//               iter != queues[i].end(); ++iter) {
//         StriInterval<R_len_t> cur_int = *iter;
//         memcpy(curbuf+bufused, str_cur_s+last_b, cur_int.a-last_b);
//         bufused += (cur_int.a-last_b);
//         memcpy(curbuf+bufused, replacement_cont.get(cur_int.data).c_str(),
//            replacement_cont.get(cur_int.data).length());
//         bufused += replacement_cont.get(cur_int.data).length();
//         last_b = cur_int.b;
//      }
//
//      // the remainder
//      memcpy(curbuf+bufused, str_cur_s+last_b, str_cur_n-last_b);
//      bufused += (str_cur_n-last_b);
//      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), bufused, CE_UTF8));
//   }
//
//   STRI__UNPROTECT_ALL
//   return ret;
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}


/**
 * Replace all occurrences of a fixed pattern
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @param vectorize_all single logical value
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_replace_fixed now uses byte search only
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *          vectorize_all argument added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_replace_all_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP vectorize_all, SEXP opts_fixed)
{
   if (stri__prepare_arg_logical_1_notNA(vectorize_all, "vectorize_all"))
      return stri__replace_allfirstlast_fixed(str, pattern, replacement, opts_fixed, 0);
   else
      return stri__replace_all_fixed_no_vectorize_all(str, pattern, replacement, opts_fixed);
}


/**
 * Replace last occurrence of a fixed pattern
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_replace_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_replace_last_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_fixed)
{
   return stri__replace_allfirstlast_fixed(str, pattern, replacement, opts_fixed, -1);
}


/**
 * Replace first occurrence of a fixed pattern
 *
 * @param str character vector
 * @param pattern character vector
 * @param replacement character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-26)
 *          use stri__replace_allfirstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_replace_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_replace_first_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_fixed)
{
   return stri__replace_allfirstlast_fixed(str, pattern, replacement, opts_fixed, 1);
}
